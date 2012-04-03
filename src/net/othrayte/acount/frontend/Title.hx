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

import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;

class Title extends GuiElement {
    var tf:TextField;
    var title:String;

    public function new(title:String) {
        super();
        this.title = title;
        tf = new TextField();
        tf.text = title;
        tf.autoSize = TextFieldAutoSize.LEFT;
        var format = new TextFormat();
        format.bold = true;
        format.size = 25;
        format.color = 0xffffff;
        tf.setTextFormat(format);
        height = tf.height;
        width = tf.width;
        trace(width);
        sprite.addChild(tf);
    }

}