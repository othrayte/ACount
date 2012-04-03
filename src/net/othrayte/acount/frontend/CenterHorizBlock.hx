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

class CenterHorizBlock extends ParentElement {

    public function new(subElement:GuiElement) {
        super(subElement);

    }

    @:ex(child.width,parent.width,parent.height) private function update(_:Int) {
        trace("Update recenter");
        trace(x+", "+y+", "+height+", "+width);
        trace(((parent!=null)?parent.width:-1)+", "+((child!=null)?child.width:-1)+", "+((parent!=null)?parent.height:-1));
        width = (child!=null)?child.width:0;
        x = (parent!=null)?(parent.width-width)/2:0;
        y = 0;
        height = (parent!=null)?parent.height:0;
        trace(x+", "+y+", "+height+", "+width);
    }

}