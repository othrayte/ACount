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

import net.othrayte.deepend.Dpnd;
import net.othrayte.deepend.DpndServer;

class Square implements Dpnd {
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;
    private var sprite:Sprite;
    private var timer:Timer;

    public function new() {
        sprite = new Sprite();
        timer = new Timer(cast 1000/60);
    }

    public function get() {
        return sprite;
    }

    @:ex(x,y,width,height,timer.time) private function redraw(_:Int) {
        //trace("drawing "+Math.sin(timer.time)*height);
        sprite.graphics.clear();
        sprite.graphics.beginFill(0xff9900);
        sprite.graphics.drawRect(x,y,width,(Math.sin(timer.time)*height+height)/2);
        sprite.graphics.endFill();
    }

}