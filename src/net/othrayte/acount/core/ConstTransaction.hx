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

import net.othrayte.acount.core.Util;

class ConstTransaction {
	public var id: Int;
	public var time: Date;
	public var amount: Int;
	public var account: ConstAccount;
	public var entity: ConstEntity;
	public var description: String;

	public function new(time: Date, amount: Int, account: ConstAccount, entity: ConstEntity, description:String) {
		this.time = time;
		this.amount = amount;
		this.account = account;
		this.entity = entity;
		this.description = description;
	}

	#if php
	public function reanimate() {
		if (id == null) {
			var transaction = new Transaction(time, amount, account.reanimate(), entity.reanimate(), description);
			transaction.insert();
			return transaction;
		} else {
			return Transaction.manager.get(id);
		}
	}
	#end

	public function toString() {
		return ""+time+": "+Util.amountStr(amount)+" "+entity.name+" -> "+account.name+" \""+description+"\""+account;
	}
}