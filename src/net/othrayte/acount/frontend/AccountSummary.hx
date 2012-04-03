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

import net.othrayte.acount.core.ConstAccount;

class AccountSummary extends GuiElement {
    private var account:ConstAccount;
    private var hDetails:HorizDetails;

    public function new(account:ConstAccount) {
        super();
        trace("AccountSummary");
        this.account = account;
        hDetails = new HorizDetails();
        sprite.addChild(hDetails.get());
        hDetails.append(new Title(account.name));
        hDetails.append(new Amount(account.balance));
        trace("AccountSummary - end");
    }

    @:ex(hDetails.width) private function _width(_:Int) {
        width = (hDetails!=null)?hDetails.width:0;
        trace(width);
    }

    @:ex(hDetails.height) private function _height(_:Int) {
        height = (hDetails!=null)?hDetails.height:0;
        trace(height);
    }

}