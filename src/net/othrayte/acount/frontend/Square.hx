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

class Square extends GuiElement {
    private var timer:Timer;

    public function new(width:Float, height:Float) {
        super();
        this.width = width;
        this.height = height;
        timer = new Timer(cast 1000/60);
    }

    @:ex(x,y,width,height,timer.time) private function redraw(_:Int) {
        sprite.graphics.clear();
        sprite.graphics.beginFill(0xff9900);
        sprite.graphics.drawRect(x,y,width,(Math.sin(timer.time)*height+height)/2);
        sprite.graphics.endFill();
    }

}