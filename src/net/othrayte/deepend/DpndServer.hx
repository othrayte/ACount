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

import haxe.FastList;
import haxe.Timer;

class DpndServer {
    static var maxIdx = 0;
    static var callbacks:IntHash<Null<Void->Void>> = new IntHash();
    static var relations:IntHash<IntHash<Int>> = new IntHash();
    static private var pending:IntHash<IntHash<Int>> = new IntHash();
    static private var solist:Solist = new Solist();
    static private var timer:Timer;

    static public function start(rps:Int) {
        timer = new Timer(cast 1000/rps);
        timer.run = refresh;
    }

    static public function refresh() {
        var list:Array<Int> = createRefreshList();
        pending = new IntHash();
        solist = new Solist();

        for (ref in list) {
            trace("R> "+ref);
            var cb = callbacks.get(ref);
            if (cb != null)
                cb();
        }   
    }

    static private function createRefreshList() {
        var lists:Array<Array<Int>> = new Array();
        var pos:Array<Int> = new Array();
        var out:Array<Int> = new Array();
        var output:FastList<FastList<Int>> = solist.output();
        //trace(output);
        solist.empty();
        // list list with all the things that need to be refreshed
        for (order in output) {
            var tmp:Array<Int> = new Array();
            for (indv in order) {
                tmp.push(indv);
            }
            lists.push(tmp);
        }

        // sort list
        for (list in lists) {
            for (i in 0 ... list.length - 1) { // -1 because the last one is already last
                pos[list[i]] = i+1;
                var secured:Bool = false;
                var loopDetectD:Int = 0;
                var loopDetectN:Int = 0;
                var count:Int = 0;
                while (!secured) {
                    var befores:IntHash<Int> = pending.get(list[i]);
                    secured = true;
                    for (j in befores.keys()) {
                        if (pos[j] == 0) pos[j] = findInArray(list, j) + 1;
                        if (pos[j] - 1 > i) {
                            list.insert(pos[j]-1+1, list[i]);
                            list.remove(list[i]);
                            for (k in i ... pos[j]-1+1) pos[list[k]] = k+1;
                            if (loopDetectD == pos[j]-1 - i) {
                                loopDetectN++;
                            } else if (loopDetectD < pos[j]-1 - i) {
                                loopDetectN = 0;
                                loopDetectD = pos[j]-1 - i;
                            }
                            if (loopDetectN == loopDetectD /*&& loopDetectN != 0*/) {
                                trace("Small (Regular) Loop found, ignoring, this may cause updates to happen in an indeterminate order");
                            }
                            secured = false;
                            break;
                        }
                    }
                    count++;
                }
            }
            for (indv in list) {
                out.push(indv);
            }
        }
        return out;
    }
    static private function lodge(refDependable:Int, refDependee:Int) {
        if (refDependable == refDependee) trace("inbreading");
        trace("Dive! "+solist);
        solist.add(refDependable, refDependee);      
        trace(solist.output());
        // If dependee not in pending set
        if (!pending.exists(refDependee)) {
            // Add after to after list
            var temp = new IntHash();
            temp.set(refDependable, null);
            pending.set(refDependee, temp);
        } else { // Else (dependee is in pending set)
            // If dependable isn't already in the set
            if (!pending.get(refDependee).exists(refDependable)) {
                // add to schedule
                pending.get(refDependee).set(refDependable, null);
            }
        }
    }

    static public function dependable(?cb:Void->Void) {
        callbacks.set(maxIdx, cb);
        return maxIdx++;
    }
    static public function notDependable(ref:Int) {
        callbacks.remove(ref);
    }
    static public function relate(refDependable:Int, refDependee:Int) {
        trace("Relating "+refDependable+" to "+refDependee);
        if (!relations.exists(refDependable)) {
            var hash = new IntHash();
            hash.set(refDependee, 1);
            relations.set(refDependable, hash);
        } else {
            var hash = relations.get(refDependable);
            if (!hash.exists(refDependee)) {
                hash.set(refDependee, 1);
            } else {
                hash.set(refDependee, hash.get(refDependee)+1);
            }
        }
        trace(relations);
    }
    static public function indirectRelate(origin:Dynamic, route:Array<String>, refDependee:Int) {
        trace("(*_*)");
    }
    static public function unRelate(refDependable:Int, refDependee:Int) {
        if (relations.exists(refDependable)) {
            var hash = relations.get(refDependable);
            if (hash.exists(refDependee)) {
                if (hash.get(refDependee)>1) {
                    hash.set(refDependee,hash.get(refDependee)-1);
                } else {
                    hash.remove(refDependee);
                }
            }
            if (!hash.keys().hasNext()) {
                relations.remove(refDependable);
            }
        }
    }
    static public function changed(ref:Int) {
        var forwards = [ref];
        var lockOut = new IntHash();
        do {
            trace(forwards);
            var r = forwards.shift();
            trace(r);
            if (lockOut.exists(r)) continue;
            lockOut.set(r, null);
            trace(relations);
            if (relations.exists(r)) {
                for (key in relations.get(r).keys()) {
                    trace(key);
                    lodge(r, key);
                    forwards.push(key);
                }
            }
        } while (forwards.length>0);
        trace(lockOut);
    }

    static private function findInArray<T>(array:Array<T>, thing:T) {
        var out:Int = -1;
        var index:Int;
        for (index in 0 ... array.length) {
            if (array[index] == thing) {
                return index;
            }
        }
        return out;
    }
}
