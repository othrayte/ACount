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

package net.othrayte.acount;

import net.othrayte.acount.core.Account;
import net.othrayte.acount.core.Entity;
import net.othrayte.acount.core.PaidEntry;
import net.othrayte.acount.core.PaidTagRelation;
import net.othrayte.acount.core.Tag;
import net.othrayte.acount.core.Transaction;
import net.othrayte.acount.core.UnPaidEntry;
import net.othrayte.acount.core.UnPaidTagRelation;

class ACount {
	private var cnx : sys.db.Connection;

	public function new() {
		// initialize the connection
		var useMysql = false;
		cnx = sys.db.Mysql.connect({ 
			host : "localhost",
			port : 3306,
			database : "acount",
			user : "acount",
			pass : "pbFXMUUfnyn9sEZS",
			socket : null
		});
		sys.db.Manager.cnx = cnx;
		//createTables();
		sys.db.Manager.initialize();
		cnx.startTransaction();
	}

	function createTables() {
		sys.db.TableCreate.create(Account.manager);
		sys.db.TableCreate.create(Entity.manager);
		sys.db.TableCreate.create(Tag.manager);
		sys.db.TableCreate.create(UnPaidEntry.manager);
		sys.db.TableCreate.create(UnPaidTagRelation.manager);
		sys.db.TableCreate.create(PaidEntry.manager);
		sys.db.TableCreate.create(PaidTagRelation.manager);
		sys.db.TableCreate.create(Transaction.manager);
	}

	public function done(successful:Bool=true) {
		successful?cnx.commit():cnx.rollback();
		sys.db.Manager.cleanup();
		cnx.close();
	}

	public function defineEntity(name:String, description:String) {
		var entity = new Entity(name, description);
		entity.insert();
		return entity;
	}

	public function defineTag(name:String, description:String) {
		var tag = new Tag(name, description);
		tag.insert();
		return tag;
	}

	public function openAccount(name:String, description:String, initialBalance:Int) {
		var account = new Account(name, description, initialBalance);
		account.insert();
		return account;
	}

	public function recordLiability(amount:Int, date:Date, description:String, creditor:Entity, tags:List<Tag> = null) {
		var entry = new UnPaidEntry(creditor, -amount, description, date);
		trace(entry.id);
		trace(entry.insert());
		trace(entry.id);
		if (tags != null){
			while (!tags.isEmpty()) {
				var tag = tags.pop();
				entry.assign(tag);
				while (tags.remove(tag)) {} // Remove any duplicates
			}
		}
		return entry;
	}

	public function recordReceivable(amount:Int, date:Date, description:String, debtor:Entity, tags:List<Tag> = null) {
		var entry = new UnPaidEntry(debtor, amount, description, date);
		entry.insert();
		if (tags != null){
			while (!tags.isEmpty()) {
				var tag = tags.pop();
				entry.assign(tag);
				while (tags.remove(tag)) {} // Remove any duplicates
			}
		}
		return entry;
	}

	public function recordTransaction(amount:Int, date:Date, description:String, unPaidEntries:List<UnPaidEntry>, account:Account) {
		var totalAmount:Int = 0;
		var commonEntity:Entity = null;
		var entries:List<UnPaidEntry> = new List();
		for (entry in unPaidEntries) {
			totalAmount += entry.amount;
			entries.push(entry);
			if (commonEntity == null) continue;
			if (entry.entity != commonEntity) throw "Unmatched entities";
		}
		if (amount != totalAmount) throw "amounts do not balance";

		var transaction = new Transaction(date, amount, account, commonEntity, description);
		transaction.insert();
		for (entry in entries) {
			entry.pay(transaction);
		}
		return transaction;
	}

	public function getAccounts():List<Account> {
		return Account.manager.all();
	}

	public function getCurrentBalance():Int {
		var accounts:List<Account> = Account.manager.all();
		var balance:Int = 0;
		for (account in accounts) {
			balance += account.balance;
		}
		return balance;
	}

	public function getEffectiveBalance():Int {
		var unPaidEntries:List<UnPaidEntry> = UnPaidEntry.manager.all();
		var balance:Int = getCurrentBalance();
		for (entry in unPaidEntries) {
			balance += entry.amount;
		}
		return balance;
	}

	public function getUnPaidEntries():List<UnPaidEntry> {
		return UnPaidEntry.manager.all();
	}

	public function getPaidEntries():List<PaidEntry> {
		return PaidEntry.manager.all();
	}

	public function getLiabilities():List<UnPaidEntry> {
		return UnPaidEntry.manager.search($amount < 0);
	}

	public function getReceivables():List<UnPaidEntry> {
		return UnPaidEntry.manager.search($amount > 0);
	}

	public function getEntities():List<Entity> {
		return Entity.manager.all();
	}

	public function getTags():List<Tag> {
		return Tag.manager.all();
	}
}