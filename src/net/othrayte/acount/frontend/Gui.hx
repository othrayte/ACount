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


import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.Assets;
import nme.Lib;

import net.othrayte.deepend.Test;

class Gui extends nme.display.Sprite {
    var d:Test;

    public function new() {
        super();
        width = Lib.stage.stageWidth;
        height = Lib.stage.stageHeight;
        var button = new Sprite();
        button.graphics.beginFill(0);
        button.graphics.drawRect(0,0,100,100);
        button.graphics.endFill();
        addChild(button);
        
        d = new Test();
    }

    public static function load() {
        nme.Lib.stage.addChild(new Gui());
    }
}