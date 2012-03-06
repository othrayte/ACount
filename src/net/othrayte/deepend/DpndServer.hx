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

class DpndServer {
    static var maxIdx = 0;
    static var callbacks:IntHash<Null<Void->Void>> = new IntHash();

    static public function dependable(?cb:Void->Void) {
        callbacks.set(maxIdx, cb);
        trace("(*.*)");
        return maxIdx++;
    }
    static public function notDependable(ref:Int) {
        
    }
    static public function relate(refDependable:Int, refDependee:Int) {
        trace("(*^*)");        
    }
    static public function indirectRelate(origin:Dynamic, route:Array<String>, refRependee:Int) {
        trace("(*_*)");
    }
    static public function unRelate(refDependable:Int, refDependee:Int) {
        
    }
    static public function changed(ref:Int) {
        
    }
}
