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

package net.othrayte.util.async;

#if neko
import neko.vm.Mutex;
#elseif cpp
import cpp.vm.Mutex;
#end

class SyncPipe<T> {
	private var data:T;
	private var lock:Mutex;

	public function new() {
		lock = new Mutex();
		lock.acquire();
	}

	public function receive(data:T) {
		this.data = data;
		lock.release();
	}

	public function need():T {
		lock.acquire();
		trace(data);
		return data;
	}
}