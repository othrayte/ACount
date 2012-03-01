/*
    Copyright © 2012, othrayte (Adrian Cowan)
    
    This file is part of ACount.

    ACount is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    ACount is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
*/

package net.othrayte.acount.frontend;

import haxe.remoting.HttpAsyncConnection;

import net.othrayte.acount.core.ConstAccount;
import net.othrayte.acount.core.ConstEntity;
import net.othrayte.acount.core.ConstTag;
import net.othrayte.acount.core.ConstUnPaidEntry;

import net.othrayte.util.async.SyncPipe;


class ServerProxy extends haxe.remoting.AsyncProxy<net.othrayte.acount.backend.Server> { }

using StringTools;

class NekoClient {
	static var url:String;
	static var cnx:HttpAsyncConnection;
	static var proxy:ServerProxy;

	static function main() {
		new NekoClient();
	}

	public function new() {
		url = "localhost/acount/index.php";
		cnx = HttpAsyncConnection.urlConnect(url);
		proxy = new ServerProxy(cnx.Server);
		
		while (mainMenu()) {}
	}

	public function mainMenu() {
		neko.Lib.print(
"
  1: Check funds 
  2: Pay bill
  3: Bill received
  4: Spent money
  5: Confirm spending

  6: Low level options

  :"
		);
		var n = neko.io.File.stdin().readLine();
		switch (n) {
			case "1": proxy.llGetAccounts(showAccounts);
			case "2": proxy.llRecordTransaction(-askAmount('amount'), askDate('time payed'), askString('payment description'), chooseMultiple("bills", proxy.llGetLiabilities), askAccount('account'));
			case "3": proxy.llRecordLiability(askAmount('amount'), askDate('time received'), askString('bill description'), chooseOne('bill sender (creditor)', proxy.llGetEntities), chooseMultiple('tags', proxy.llGetTags));
			case "4": spendMoney();
			case "5": proxy.llRecordTransaction(-askAmount('amount'), askDate('time transferred'), askString('transaction description'), chooseMultiple('unconfirmed spending', proxy.llGetLiabilities), askAccount('account'));
			case "6": llMenu();
			default: return false;
		}
		return true;
	}

	public function spendMoney() {
		var amount:Int = askAmount('amount');
		var time:Date = askDate('time spent');
		var desc:String = askString('spending description');
		var seller:ConstEntity = chooseOne("the seller", proxy.llGetEntities);
		var tags:List<ConstTag> = chooseMultiple("tags", proxy.llGetTags);
		var account:ConstAccount = chooseOne("the account the payment is from", proxy.llGetAccounts);
		var liability:SyncPipe<ConstUnPaidEntry> = new SyncPipe();
		proxy.llRecordLiability(amount, time, desc, seller, tags, liability.receive);
		var liabilities = new List();
		liabilities.add(liability.need());
		proxy.llRecordTransaction(amount, time, "", liabilities, account);
	}


	public function llMenu() {
		neko.Lib.print(
"
  1: Define Entity
  2: Define Tag
  3: Open Account
  4: Record Liability
  5: Record Receivable
  6: Record Transaction
  7: Get Current Balance
  8: Get Effective Balance
  9: Get Liabilities
 10: Get Receivables

  :"
		);
		var n = neko.io.File.stdin().readLine();
		switch (n) {
			case "1": proxy.llDefineEntity(askString('name'), askString('description'));
			case "2": proxy.llDefineTag(askString('name'), askString('description'));
			case "3": proxy.llOpenAccount(askString('name'), askString('description'), askAmount('initial balance'));
			case "4": proxy.llRecordLiability(askAmount('amount'), askDate('time'), askString('description'), chooseOne('creditor', proxy.llGetEntities), chooseMultiple('tags', proxy.llGetTags));
			case "5": proxy.llRecordReceivable(askAmount('amount'), askDate('time'), askString('description'), chooseOne('debtor', proxy.llGetEntities), chooseMultiple('tags', proxy.llGetTags));
			case "6": proxy.llRecordTransaction(askAmount('amount'), askDate('time'), askString('description'), chooseMultiple('unpaid entry', proxy.llGetUnPaidEntries), askAccount('account'));
			case "7": proxy.llGetCurrentBalance(showCurrentBalance);
			case "8": proxy.llGetEffectiveBalance(showEffectiveBalance);
			case "9": proxy.llGetLiabilities(showLiabilities);
			case "10": proxy.llGetReceivables(showReceivables);
			default: return false;
		}
		return true;
	}

	function askString(name:String):String {
		neko.Lib.print(name+"? ");
		return neko.io.File.stdin().readLine();
	}

	function askAmount(name:String):Int {
		var amount:Int = 0;
		while (true) {
			neko.Lib.print(name+"? $");
			var responce = neko.io.File.stdin().readLine();
			var bits = responce.split('.');
			if (bits.length > 2) continue;
			var higher = Std.parseInt(bits[0]);
			if (higher == null) continue;
			amount = higher*100;
			if (bits.length < 2) break;
			var lower = Std.parseInt(bits[1]);
			if (lower == null) continue;
			amount += (higher<0)?-lower:lower;
			break;
		}
		return amount;
	}

	function askDate(name:String):Date {
		var date:Date = Date.now();
		while (true) {
			neko.Lib.print(name+"? [YYYY-MM-DD hh:mm:ss] ");
			var responce = neko.io.File.stdin().readLine();
			date = Date.fromString(responce);
			//if (date.getTime() > (Date.now().getTime()+365*24*60*60*1000)) continue;
			if (date.getTime() < new Date(1990, 0, 0, 0, 0, 0).getTime()) continue;
			break;
		}
		return date;
	}

	function askEntity(name:String) {
		var entity:Int = 0;
		while (true) {
			neko.Lib.print(name+"? ");
			entity = Std.parseInt(neko.io.File.stdin().readLine());
			if (entity != null) break;
		}
		return entity;
	}

	function askAccount(name:String) {
		var account:ConstAccount;
		var accounts:SyncPipe<List<ConstAccount>> = new SyncPipe();
		proxy.llGetAccounts(accounts.receive);
		var options = new Array();
		var idx:Null<Int> = 0;
		for (account in accounts.need()) {
			options[idx] = account;
			idx++;
		}
		while (true) {
			neko.Lib.println("Which account");
			for (idx in 0 ... options.length) {
				neko.Lib.println(" "+idx+":\t"+options[idx]);
			}
			neko.Lib.print("  ? ");
			idx = Std.parseInt(neko.io.File.stdin().readLine());
			if (idx != null && idx>=0 && idx<options.length) break;
		}
		return options[idx];
	}

	function askTag(name:String) {
		var tag:Int = 0;
		while (true) {
			neko.Lib.print(name+"? ");
			tag = Std.parseInt(neko.io.File.stdin().readLine());
			if (tag != null) break;
		}
		return tag;
	}

	function askUnPaidEntry(name:String) {
		var unPaidEntry:Int = 0;
		while (true) {
			neko.Lib.print(name+"? ");
			unPaidEntry = Std.parseInt(neko.io.File.stdin().readLine());
			if (unPaidEntry != null) break;
		}
		return unPaidEntry;
	}

	function askPaidEntry(name:String) {
		var paidEntry:Int = 0;
		while (true) {
			neko.Lib.print(name+"? ");
			paidEntry = Std.parseInt(neko.io.File.stdin().readLine());
			if (paidEntry != null) break;
		}
		return paidEntry;
	}

	function askList<T>(f:String->T, name:String):List<T> {
		var list:List<T> = new List();
		while (true) {
			list.push(f(name));
			neko.Lib.print("another? ");
			if (neko.io.File.stdin().readLine().ltrim().charAt(0).toUpperCase()!='Y') break;
		}
		return list;
	}

	function chooseMultiple<T>(msg:String, getOptions:(List<T>->Void)->Void):List<T> {
		var choices:List<T> = new List();
		var all:SyncPipe<List<T>> = new SyncPipe();
		getOptions(all.receive);
		var options = new Array();
		var idx:Null<Int> = 0;
		for (option in all.need()) {
			options[idx] = option;
			idx++;
		}
		neko.Lib.println("Please select multiple "+msg);
		for (idx in 0 ... options.length) {
			neko.Lib.println(" "+idx+":\t"+options[idx]);
		}
		neko.Lib.println(" <Enter>: Finished");
		while (true) {
			neko.Lib.print(" ?: ");
			var line = neko.io.File.stdin().readLine();
			if (line == "") break;
			idx = Std.parseInt(line);
			if (idx == null || idx<0 || idx>=options.length) continue;
			choices.add(options[idx]);
		}
		return choices;
	}

	function chooseOne<T>(msg:String, getOptions:(List<T>->Void)->Void):T {
		var choice:T;
		var all:SyncPipe<List<T>> = new SyncPipe();
		getOptions(all.receive);
		var options = new Array();
		var idx:Null<Int> = 0;
		for (option in all.need()) {
			options[idx] = option;
			idx++;
		}
		neko.Lib.println("Please select "+msg);
		for (idx in 0 ... options.length) {
			neko.Lib.println(" "+idx+":\t"+options[idx]);
		}
		while (true) {
			neko.Lib.print(" ?: ");
			var line = neko.io.File.stdin().readLine();
			idx = Std.parseInt(line);
			if (idx == null || idx<0 || idx>=options.length) continue;
			break;
		}
		return options[idx];
	}

	function showCurrentBalance(balance:Int) {
		neko.Lib.print("The current balance is $"+balance/100);
	}

	function showEffectiveBalance(balance:Int) {
		neko.Lib.print("The current effective balance is $"+balance/100);
	}

	function showLiabilities(liabilities:List<ConstUnPaidEntry>) {
		for (liability in liabilities) neko.Lib.println(liability);
	}

	function showReceivables(receivables:List<ConstUnPaidEntry>) {
		for (receivable in receivables) neko.Lib.println(receivable);
	}

	function showAccounts(accounts:List<ConstAccount>) {
		for (account in accounts) neko.Lib.println(account);
	}
	
	/*
	public function defineEntity(name:String, description:String) {
		acount.defineEntity(name, description);
	}

	public function defineTag(name:String, description:String) {
		acount.defineTag(name, description);
	}

	public function openAccount(name:String, description:String, initialBalance:Int) {
		acount.openAccount(name, description, initialBalance);
	}

	public function recordLiability(amount:Int, date:Date, description:String, creditor:Entity, tags:List<Tag> = null) {
		acount.recordLiability(amount, date, description, creditor, tags);
	}

	public function recordReceivable(amount:Int, date:Date, description:String, debtor:Entity, tags:List<Tag> = null) {
		acount.recordReceivable(amount, date, description, debtor, tags);
	}

	public function recordTransaction(amount:Int, date:Date, description:String, unPaidEntries:List<Int>, account:Account) {
		acount.recordTransaction(amount, date, description, unPaidEntries, account);
	}

	public function getCurrentBalance():Int {
		return acount.getCurrentBalance();
	}

	public function getEffectiveBalance():Int {
		return acount.getEffectiveBalance();
	}

	public function getLiabilities():List<UnPaidEntry> {
		return acount.getLiabilities();
	}

	public function getReceivables():List<UnPaidEntry> {
		return acount.getReceivables();
	}

	static function display(result:Int) {
		trace ("The server calculated 3 + 5 to equal: " + result);
	}*/
}