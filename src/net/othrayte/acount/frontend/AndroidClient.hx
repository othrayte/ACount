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

import haxe.remoting.HttpAsyncConnection;

import net.othrayte.acount.core.ConstAccount;
import net.othrayte.acount.core.ConstEntity;
import net.othrayte.acount.core.ConstTag;
import net.othrayte.acount.core.ConstUnPaidEntry;

import net.othrayte.util.async.SyncPipe;

import net.othrayte.acount.frontend.Gui;

class ServerProxy extends haxe.remoting.AsyncProxy<net.othrayte.acount.backend.Server> { }

class AndroidClient {
	static var url:String;
	static var cnx:HttpAsyncConnection;
	static var proxy:ServerProxy;

	public static function main() {
		try {
			trace("ACount starting ...");
			new AndroidClient();
			trace("ACount stopping!");
		} catch (e:Dynamic) {
			trace(e);
		}
	}

	public function new() {
		Gui.load();

		//url = "http://192.168.1.5/acount/index.php";
		//cnx = HttpAsyncConnection.urlConnect(url);
		//proxy = new ServerProxy(cnx.Server);
		
		//proxy.llGetAccounts(showAccounts);
	}

	function showAccounts(accounts:List<ConstAccount>) {
		for (account in accounts) trace(account);
	}

}