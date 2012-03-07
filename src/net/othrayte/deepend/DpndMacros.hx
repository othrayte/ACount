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

import haxe.macro.Expr;
import haxe.macro.Context;

typedef RelExpr = {name:String, expr:ExprDef};

class DpndMacros {
    public static function macroBuild() {
        //trace("Started building");
        var regCalls:Array<String> = new Array();
        var reg:Function;
        var unregCalls:Array<String> = new Array();
        var unreg:Function;
        var relCalls:Array<String> = new Array();
        var rel:Function;
        var fields = Context.getBuildFields();
        var constructor;
        for(f in fields) {
            if (f.name == "new") {
                switch(f.kind) {
                    case FFun(func):
                        constructor = func;
                        continue;
                    default:
                        continue;
                }
            }
            var dpndVar:Bool = true;
            var eqCB = "";
            for (m in f.meta) {
                if (m.name == ":eq") {
                    switch(f.kind) {
                    case FVar(t, _):
                        f.kind = FProp("default", "null", t);
                        var lock = false;
                        if (m.params.length==0)
                            Context.error("Equation needs an expression", f.pos);
                        if (m.params.length==1)
                            Context.error("Equation needs something to depend on, else it will never execute", f.pos);
                        var eq = m.params.shift();
                        for(p in m.params) {
                            var names:Array<String> = new Array();
                            var e:Expr = p;
                            do {
                                switch(e.expr) {
                                case EConst(c):
                                    switch(c) {
                                    case CIdent(name):
                                        names.push(name);
                                        if (names.length==1) {
                                            // direct relation
                                            relCalls.push("DpndServer.relate("+name+"_ref, "+f.name+"_ref)");
                                        } else {
                                            // indirect
                                            relCalls.push("DpndServer.indirectRelate(this, ['"+names.join("','")+"'], "+f.name+"_ref)");
                                        }
                                        e = null;
                                    default:
                                        e = null;
                                    }
                                case EField(expr, name):
                                    names.push(name);
                                    e = expr;
                                default:
                                    e = null;
                                }
                            } while(e!=null);
                        }
                        eqCB = "calc_"+f.name;
                        // Add call back function
                        //  <- eq;
                        eq.expr = EBinop(OpAssign, {expr: EConst(CIdent(f.name)), pos: eq.pos},{expr: eq.expr, pos: eq.pos});
                        var func:Function = {expr: eq, ret: TPath({sub:null, name:"Void", pack:[], params:[] }), params:[], args:[]};
                        fields.push({name: eqCB, meta : [], kind : FFun(func), doc : null, access : [APublic], pos : f.pos});
                        
                        // Setup reg and unreg
                        regCalls.push(""+f.name+"_ref = DpndServer.dependable("+eqCB+")");
                        unregCalls.push("DpndServer.notDependable("+f.name+"_ref)");
                        
                        // Add ref var
                        fields.push({name: f.name+"_ref", meta: [], kind: FProp("default", "null", TPath({ sub:null, name:"Int", pack:[], params:[] })), doc : null, access : [APublic], pos : f.pos });
                        
                        dpndVar = false;
                    default:
                        Context.error("Invalid equation field type", f.pos);
                    }
                    break;
                } else if (m.name == ":const") {
                    dpndVar = false;
                }
            }
            switch(f.kind) {
                case FVar(t, _):
                    if (dpndVar) {
                        var p = Context.getLocalClass().get().pos;
                        
                        // Add ref var
                        fields.push({name: f.name+"_ref", meta: [], kind: FProp("default", "null", TPath({ sub:null, name:"Int", pack:[], params:[] })), doc : null, access : [APublic], pos : p });

                        // Setter
                        var expr = {expr: EBlock([
                            Context.parse(""+f.name+" = v", p),
                            Context.parse("DpndServer.changed("+f.name+"_ref)", p),
                            Context.parse("trace(\"Setting "+f.name+": \"+"+f.name+")", p),
                            Context.parse("return "+f.name, p)
                            ]), pos: p};
                        var func:Function = {expr: expr, ret: t, params:[], args:[{ name : "v", opt : false, type : t, value : null }]};
                        fields.push({name: "set_"+f.name, meta: [], kind: FFun(func), doc: null, access: [APrivate], pos: p});

                        // Make property
                        f.kind = FProp("default", "set_"+f.name, t);

                        // Setup reg and unreg
                        regCalls.push(""+f.name+"_ref = DpndServer.dependable("+eqCB+")");
                        unregCalls.push("DpndServer.notDependable("+f.name+"_ref)");
                    }
                default:
                    continue;
            }
        }
        // Reg function
        var p = Context.getLocalClass().get().pos;
        var expr = {expr: EBlock(Lambda.array(Lambda.map(regCalls, function (call) {return Context.parse(call, p);}))), pos: p};
        var func:Function = {expr: expr, ret: TPath({ sub:null, name:"Void", pack:[], params:[] }), params:[], args:[]};
        fields.push({name: "reg", meta: [], kind: FFun(func), doc: null, access: [APrivate], pos: p});

        // Unreg function
        p = Context.getLocalClass().get().pos;
        expr = {expr: EBlock(Lambda.array(Lambda.map(unregCalls, function (call) {return Context.parse(call, p);}))), pos: p};
        func = {expr: expr, ret: TPath({ sub:null, name:"Void", pack:[], params:[] }), params:[], args:[]};
        fields.push({name: "unreg", meta: [], kind: FFun(func), doc: null, access: [APrivate], pos: p});

        // Rel function
        p = Context.getLocalClass().get().pos;
        expr = {expr: EBlock(Lambda.array(Lambda.map(relCalls, function (call) {return Context.parse(call, p);}))), pos: p};
        func = {expr: expr, ret: TPath({ sub:null, name:"Void", pack:[], params:[] }), params:[], args:[]};
        fields.push({name: "rel", meta: [], kind: FFun(func), doc: null, access: [APrivate], pos: p});
        
        // Modify the constructor
        constructor.expr.expr = EBlock([
            Context.parse("reg()", constructor.expr.pos),
            {expr: constructor.expr.expr, pos: constructor.expr.pos},
            Context.parse("rel()", constructor.expr.pos)
        ]);

        return fields;
    }

}
