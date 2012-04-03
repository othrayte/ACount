/*
    Copyright © 2012, othrayte (Adrian Cowan)
    
    This file is part of net.othrayte.util .
    It is modified from the original made by the Caffeine-hx project, any
    modifications fall under this license and the original license below is
    acknowledged for all original parts.

    net.othrayte.util is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    net.othrayte.util is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with net.othrayte.util.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
* Copyright (c) 2009, The Caffeine-hx project contributors
* All rights reserved.
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* - Redistributions of source code must retain the above copyright
* notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
* notice, this list of conditions and the following disclaimer in the
* documentation and/or other materials provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY THE CAFFEINE-HX PROJECT CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE CAFFEINE-HX PROJECT CONTRIBUTORS
* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
* THE POSSIBILITY OF SUCH DAMAGE.
*/

package net.othrayte.util.async;

/**
A mutex which works on all platforms. Not thread safe for platforms that
do not support threads in the first place (flash, js)
@author Russell Weir
**/

#if neko
typedef Mutex = neko.vm.Mutex;
#elseif cpp
typedef Mutex = cpp.vm.Mutex;
#else

class Mutex {
	var m:Dynamic;
	
	public function new() {
		m = mutex_create();
	}

	/**
	Wait until a mutex can be aquired
	**/
	public function acquire() {
		mutex_acquire(m);
	}

	/**
	Attempt to acquire a mutex
	@returns true if mutext was successfully acquired, false otherwise
	**/
	public function tryAcquire() : Bool {
		return mutex_try(m);
	}

	/**
	Releases an acquired mutex.
	**/
	public function release() {
		mutex_release(m);
	}

	static function mutex_create() : Dynamic {
		return { acquired : false };
	}

	static function mutex_acquire(m : Dynamic) {
		while(m.acquired) {}
		m.acquired = true;
	}

	static function mutex_try(m : Dynamic) : Bool {
		if(m.acquired)
		return false;
		return m.acquired = true;
	}

	static function mutex_release(m : Dynamic) : Void {
		if(m.acquired)
		m.acquired = false;
	}
}
#end
