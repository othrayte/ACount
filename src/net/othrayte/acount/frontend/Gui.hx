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
        var square = new Square();
        addChild(square.get());

        square.x = 0;
        square.y = 0;
        square.width = 200;
        square.height = 300;
        DpndServer.start(60);

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