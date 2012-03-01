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

class ConstUnPaidEntry {
	public var id: Null<Int>;
	public var entity: ConstEntity;
	public var amount: Int;
	public var description: String;
	public var dateIncurred: Date;

	public function new(entity:ConstEntity, amount:Int, description:String, dateIncurred:Date) {
		this.entity = entity;
		this.amount = amount;
		this.description = description;
		this.dateIncurred = dateIncurred;
	}

	#if php
	public function reanimate() {
		if (id == null) {
			var unPaidEntry = new UnPaidEntry(entity.reanimate(), amount, description, dateIncurred);
			unPaidEntry.insert();
			return unPaidEntry;
		} else {
			return UnPaidEntry.manager.get(id);
		}
	}
	#end
}