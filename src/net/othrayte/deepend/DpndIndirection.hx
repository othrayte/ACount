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
    along with Deepend.  If not, see <http://www.gnu.org/licenses/>.
*/

package net.othrayte.deepend;


class DpndIndirection {
    var route:Array<String>;
    var refs:Array<Int>;
    var cbRefs:Array<Int>;
    var objs:Array<Dynamic>;
    var idx:Int;
    var refDependee:Int;

    public function new(origin:Dynamic, route:Array<String>, refDependee:Int #if debug, name:String #end) {
        this.route = route;
        this.refDependee = refDependee;
        idx = 0;

        refs = new Array();
        cbRefs = new Array();
        objs = new Array();
        objs[0] = origin;

        for (element in route) {
            if (cbRefs.length<route.length-1) {
                trace(element);
                cbRefs.push(DpndServer.dependable(trigger #if debug, name+="["+element+"]" #end));
                if (cbRefs.length>1) DpndServer.relate(cbRefs[cbRefs.length-2], cbRefs[cbRefs.length-1]);
            }
        }

        cbRefs.push(refDependee);

        recheck(0);
    }

    public function trigger(ref:Int) {
        for (i in 0 ... cbRefs.length) {
            if (cbRefs[i] == ref) {
                if (i <= idx) {
                    recheck(i);
                }
                break;
            }
        }
    }

    private function recheck(i:Int) {
        //trace("rc-"+i);
        if (objs[i]!=null) {
            if (i == route.length) {
                idx = i-1;
            } else {
                //trace(route[i]);
                if (refs[i]==0) {
                    if (Reflect.hasField(objs[i], route[i]+"_ref"))
                        refs[i] = Reflect.field(objs[i], route[i]+"_ref");
                    if (refs[i]!=0) DpndServer.relate(refs[i], cbRefs[i]);
                }
                var newObj = Reflect.field(objs[i], route[i]);
                if (newObj == null) {
                    // unrel higher ups
                    deicide(i+1);
                    // set idx here
                    idx = i;
                } else {
                    if (newObj != objs[i+1]) {
                        if (objs[i+1]!=null) {
                            // unrel higher ups
                            deicide(i+1);
                        }
                    }
                    // set this
                    objs[i+1] = newObj;
                    // check next up
                    recheck(i+1);
                }
            }
        }
    }

    private inline function deicide(i:Int) {
        for (j in i ... idx) {
            if (j != route.length) {
                objs[j+1] = null;
                if (refs[j]!=0) DpndServer.unRelate(refs[j], cbRefs[j]);
                refs[j] = 0;
            }
        }
    }
}
