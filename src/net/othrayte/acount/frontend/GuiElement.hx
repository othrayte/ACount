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
    along with ACount.  If not, see <http://www.gnu.org/licenses/>.
*/

package net.othrayte.acount.frontend;

import nme.display.Sprite;

import net.othrayte.deepend.Dpnd;
import net.othrayte.deepend.DpndServer;

class GuiElement implements Dpnd {
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;
    public var parent:GuiElement;
    private var sprite:Sprite;

    public function new() {
        x = 0;
        y = 0;
        width = 10;
        height = 10;
        sprite = new Sprite();
    }

    public function get() {
        return sprite;
    }  

    private function setParent(element:GuiElement) {
        parent = element;
    } 

    private function unSetParent() {
        parent = null;
    }

    @:ex(x, y, width, height) private function realign(_:Int) {
        sprite.x = x;
        sprite.y = y;
    }

}