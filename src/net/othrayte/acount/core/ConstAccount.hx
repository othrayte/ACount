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

class ConstAccount {
	public var id: Null<Int>;
	public var name: String;
	public var description: String;
	public var balance: Int;

	public function new(name: String, description:String, balance:Int) {
		this.name = name;
		this.description = description;
		this.balance = balance;
	}

	#if php
	public function reanimate() {
		if (id == null) {
			var account = new Account(name, description, balance);
			account.insert();
			return account;
		} else {
			return Account.manager.get(id);
		}
	}
	#end

	public function toString() {
		return ""+name+" ("+Util.amountStr(balance)+") - "+description;
	}
}