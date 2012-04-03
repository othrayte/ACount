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

import net.othrayte.deepend.DpndServer;

class HorizElements extends GuiElement {
    private var elements:Array<GuiElement>;
    private var refsWidth:Array<Int>;
    private var refsHeight:Array<Int>;
    private var heights:Array<Float>;

    public function new() {
        super();
        elements = new Array();
        refsWidth = new Array();
        refsHeight = new Array();
        heights = new Array();
    }

    public function append(element:GuiElement) {
        element.setParent(this);
        refsWidth.push(DpndServer.dependable(updateWidth));
        refsHeight.push(DpndServer.dependable(updateHeight));
        elements.push(element);
        sprite.addChild(element.get());
        DpndServer.relate(elements[refsWidth.length-1].width_ref, refsWidth[refsWidth.length-1]);
        DpndServer.relate(elements[refsHeight.length-1].height_ref, refsHeight[refsHeight.length-1]);
    }

    public function prepend(element:GuiElement) {
        element.setParent(this);
        refsWidth.unshift(DpndServer.dependable(updateWidth));
        refsHeight.unshift(DpndServer.dependable(updateHeight));
        elements.unshift(element);
        DpndServer.relate(elements[0].width_ref, refsWidth[0]);
        DpndServer.relate(elements[0].height_ref, refsHeight[0]);
    }

    public function pop() {
        DpndServer.unRelate(elements[0].width_ref, refsWidth[0]);
        DpndServer.unRelate(elements[0].height_ref, refsHeight[0]);
        var element = elements.shift();
        DpndServer.notDependable(refsWidth.shift());
        DpndServer.notDependable(refsHeight.shift());
        element.unSetParent();
        return element;
    }

    public function drop() {
        DpndServer.unRelate(elements[refsWidth.length-1].width_ref, refsWidth[refsWidth.length-1]);
        DpndServer.unRelate(elements[refsHeight.length-1].height_ref, refsHeight[refsHeight.length-1]);
        var element = elements.pop();
        DpndServer.notDependable(refsWidth.pop());
        DpndServer.notDependable(refsHeight.pop());
        element.unSetParent();
        return element;
    }

    public function insert(element:GuiElement, idx:Int) {
        element.setParent(this);
        refsWidth.insert(idx, DpndServer.dependable(updateWidth));
        refsWidth.insert(idx, DpndServer.dependable(updateHeight));
        elements.insert(idx, element);
        DpndServer.relate(elements[idx].width_ref, refsWidth[idx]);
        DpndServer.relate(elements[idx].height_ref, refsHeight[idx]);
    }

    public function remove(element:GuiElement) {
        var idx:Int = 0;
        for (idx in 0...elements.length)
            if (elements[idx] == element) break;
        DpndServer.unRelate(elements[idx].width_ref, refsWidth[idx]);
        DpndServer.unRelate(elements[idx].height_ref, refsHeight[idx]);
        DpndServer.notDependable(refsWidth.splice(idx,1)[0]);
        DpndServer.notDependable(refsHeight.splice(idx,1)[0]);
        var elementR = elements.splice(idx,1)[0];
        elementR.unSetParent();
        return elementR;
    }

    private function updateWidth(ref:Int) {
        var idx:Int = 0;
        for (idx in 0...elements.length)
            if (refsWidth[idx] == ref) break;
        while (idx<elements.length-1) {
            elements[idx+1].x = elements[idx].x+elements[idx].width;
            idx++;
        }
        width = elements[idx].x+elements[idx].width;
    }

    private function updateHeight(ref:Int) {
        var idx:Int = 0;
        for (idx in 0...elements.length)
            if (refsHeight[idx] == ref) break;
        var oldHeight = height;
        if (height < elements[idx].height) {
            height = elements[idx].height;
        } else if (height == heights[idx]) {
            var cMaxHeight:Float = 0;
            for (h in heights)
                if (cMaxHeight < h)
                    cMaxHeight = h;
            if (cMaxHeight != height)
                height = cMaxHeight;
        }
        heights[idx] = elements[idx].height;
        if (oldHeight != height)
            for (element in elements)
                element.y = (height-element.height)/2;
    }
}