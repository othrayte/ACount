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

package net.othrayte.acount.core;

import sys.db.Types;

class UnPaidEntry extends sys.db.Object {
	public var id: SUId;
	@:relation(entityId) public var entity: Entity;
	public var amount: SInt;
	public var description: SSmallText;
	public var dateIncurred: SDateTime;

	public function new(entity:Entity, amount:Int, description:String, dateIncurred:Date) {
		super();
		this.entity = entity;
		this.amount = amount;
		this.description = description;
		this.dateIncurred = dateIncurred;
	}

	public function pay(transaction: Transaction) {
		var relations = UnPaidTagRelation.manager.search($unPaidEntryId == id);
		var tags = relations.map(function (x) {return x.tag;});
		var relation:UnPaidTagRelation;
		while ((relation = relations.pop()) != null) relation.delete();
		delete();
		var newEntry = new PaidEntry(transaction, amount, description, dateIncurred);
		transaction.account.balance += amount;
		transaction.account.update();
		newEntry.insert();
		tags.map(function (x) {newEntry.assign(x);});
	}

	public function assign(tag:Tag) {
		var assignment = new UnPaidTagRelation(this, tag);
		assignment.unPaidEntry = this;
		assignment.insert();
	}

	public function const() {
		var unPaidEntry = new ConstUnPaidEntry(entity.const(), amount, description, dateIncurred);
		unPaidEntry.id = id;
		return unPaidEntry;
	}
}