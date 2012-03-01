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

package net.othrayte.acount.backend;

#if php
import net.othrayte.acount.ACount;
import net.othrayte.acount.core.Account;
import net.othrayte.acount.core.Entity;
import net.othrayte.acount.core.PaidEntry;
import net.othrayte.acount.core.PaidTagRelation;
import net.othrayte.acount.core.Tag;
import net.othrayte.acount.core.Transaction;
import net.othrayte.acount.core.UnPaidEntry;
import net.othrayte.acount.core.UnPaidTagRelation;
#end
import net.othrayte.acount.core.ConstAccount;
import net.othrayte.acount.core.ConstEntity;
import net.othrayte.acount.core.ConstPaidEntry;
import net.othrayte.acount.core.ConstTag;
import net.othrayte.acount.core.ConstTransaction;
import net.othrayte.acount.core.ConstUnPaidEntry;

class Server {
	static function main() {
		var context = new haxe.remoting.Context();
		var server = new Server();
		context.addObject("Server", server);
		server.go(context);
	}

	private var loginOkay:Bool;
	private var username:String;
	private var acount:ACount;

	public function new() {	
	}
	
	#if php
	public function go(context) {
		acount = new ACount();
		try {
			haxe.remoting.HttpConnection.handleRequest(context);
		} catch (e:Dynamic) {
			acount.done(false);
			throw e;
		}
		acount.done();	
	}
	#end

	public function llDefineEntity(name:String, description:String):ConstEntity {
		return acount.defineEntity(name, description).const();
	}

	public function llDefineTag(name:String, description:String):ConstTag {
		return acount.defineTag(name, description).const();
	}

	public function llOpenAccount(name:String, description:String, initialBalance:Int):ConstAccount {
		return acount.openAccount(name, description, initialBalance).const();
	}

	public function llRecordLiability(amount:Int, date:Date, description:String, creditor:ConstEntity, tags:List<ConstTag> = null):ConstUnPaidEntry {
		return acount.recordLiability(amount, date, description, creditor.reanimate(), tags.map(function (x) {return x.reanimate();})).const();
	}

	public function llRecordReceivable(amount:Int, date:Date, description:String, debtor:ConstEntity, tags:List<ConstTag> = null):ConstUnPaidEntry {
		return acount.recordReceivable(amount, date, description, debtor.reanimate(), tags.map(function (x) {return x.reanimate();})).const();
	}

	public function llRecordTransaction(amount:Int, date:Date, description:String, unPaidEntries:List<ConstUnPaidEntry>, account:ConstAccount):ConstTransaction {
		return acount.recordTransaction(amount, date, description, unPaidEntries.map(function (x) {return x.reanimate();}), account.reanimate()).const();
	}

	public function llGetAccounts():List<ConstAccount> {
		return acount.getAccounts().map(function (x) {return x.const();});
	}

	public function llGetCurrentBalance():Int {
		return acount.getCurrentBalance();
	}

	public function llGetEffectiveBalance():Int {
		return acount.getEffectiveBalance();
	}

	public function llGetUnPaidEntries():List<ConstUnPaidEntry> {
		return acount.getUnPaidEntries().map(function (x) {return x.const();});
	}

	public function llGetPaidEntries():List<ConstPaidEntry> {
		return acount.getPaidEntries().map(function (x) {return x.const();});
	}

	public function llGetLiabilities():List<ConstUnPaidEntry> {
		return acount.getLiabilities().map(function (x) {return x.const();});
	}

	public function llGetReceivables():List<ConstUnPaidEntry> {
		return acount.getReceivables().map(function (x) {return x.const();});
	}

	public function llGetEntities():List<ConstEntity> {
		return acount.getEntities().map(function (x) {return x.const();});
	}

	public function llGetTags():List<ConstTag> {
		return acount.getTags().map(function (x) {return x.const();});
	}
} 