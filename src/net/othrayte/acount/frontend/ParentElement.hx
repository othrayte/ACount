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

class ParentElement extends GuiElement {
    @:dpdbl public var child(getChild,setChild):GuiElement;
    private var _child:GuiElement;

    public function new(child) {
    	super();
    	this.child = child;
    }

    public function getChild() {
    	return _child;
    }
    public function setChild(element:GuiElement) {
    	trace("SetChild:"+element+" on "+this);
        if (element != null) {
            if (_child != null) {
                sprite.removeChild(_child.get());
                _child.unSetParent();
            }
            _child = element;
            element.setParent(this);
            sprite.addChild(_child.get());
        } else {
        	unSetChild();
        }
        return element;
    }

    private function unSetChild() {
        if (_child != null) {
            sprite.removeChild(_child.get());
            _child.unSetParent();
            _child = null;
        }
    }
}


