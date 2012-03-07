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

package net.othrayte.acount.frontend;


import haxe.Timer;

import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.Assets;
import nme.Lib;

import net.othrayte.deepend.Test;
import net.othrayte.deepend.Solist;
import net.othrayte.deepend.DpndServer;

class Gui extends nme.display.Sprite {

    public function new() {
        super();

        Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownStageEvent);
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpStageEvent);

        width = Lib.stage.stageWidth;
        height = Lib.stage.stageHeight;
        var button = new Sprite();
        button.graphics.beginFill(0);
        button.graphics.drawRect(0,0,100,100);
        button.graphics.endFill();
        addChild(button);

        var d = new Test();
        var e = new Test();
        e.myInt = 2;
        d.child = e;
        d.myInt = 4;
        trace(d.myInt2);
        trace(d.myInt3);
        DpndServer.start(10);
        DpndServer.refresh();
        trace(d.myInt2);
        trace(d.myInt3);

    }

    public static function load() {
        nme.Lib.stage.addChild(new Gui());
    }

    public function onKeyDownStageEvent(event:KeyboardEvent):Void {
        trace("Keydown: " + event.keyCode);
        //event.stopImmediatePropagation();
        //event.stopPropagation();
    }

    public function onKeyUpStageEvent(event:KeyboardEvent):Void {
        trace("Keyup: " + event.keyCode);
        //event.stopImmediatePropagation();
        //event.stopPropagation();
    }
}