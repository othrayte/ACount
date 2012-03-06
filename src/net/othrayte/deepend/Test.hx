/*
    Copyright © 2012, othrayte (Adrian Cowan)

    This file is part of Deepend.

    Deepend is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Deepend is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
*/

package net.othrayte.deepend;

class Test implements Dpnd {
	@:const var a:Int;
	var myInt:Int;
	var child:Test;
	@:eq(child!=null?child.myInt:0, child.a.b.c.myInt) var myInt2:Int;
	@:eq(child!=null?child.myInt+myInt2:0, child.myInt, myInt2) var myInt3:Int;

	public function new() {
		trace("Hello World");
	}
}

class Test2 {
	var a:Int;
	var myInt(default,set_myInt):Int;
	var myInt_ref(default,null):Int;
	var child(default,set_child):Test2;
	var child_ref(default,null):Int;
	var myInt2(default,null):Int;
	var myInt2_ref(default,null):Int;
	var myInt3(default,null):Int;
	var myInt3_ref(default,null):Int;
	public function new() {
		reg();
		trace("Hello World");
		rel();
	}

	private function reg() {
		myInt_ref = DpndServer.dependable();
		child_ref = DpndServer.dependable();
		myInt2_ref = DpndServer.dependable(calc_myInt2);
		myInt3_ref = DpndServer.dependable(calc_myInt3);
	}

	private function unreg() {
		DpndServer.notDependable(myInt_ref);
		DpndServer.notDependable(child_ref);
		DpndServer.notDependable(myInt2_ref);
		DpndServer.notDependable(myInt3_ref);
	}

	private function rel() {
		DpndServer.indirectRelate(this, ['child','a','b','c','myInt'], myInt2_ref);
		DpndServer.indirectRelate(this, ['child','myInt'], myInt2_ref);
		DpndServer.relate(myInt2_ref, myInt3_ref);
	}

	private function calc_myInt2() {
		myInt2 = child.myInt;
	}

	private function calc_myInt3() {
		myInt2 = child.myInt+2;
	}

	private function set_myInt(v:Int) {
		myInt = v;
		DpndServer.changed(myInt_ref);
		return myInt;
	}

	private function set_child(v:Test2) {
		child = v;
		DpndServer.changed(child_ref);
		return child;
	}
}