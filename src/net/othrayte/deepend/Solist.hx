/*
    Copyright © 2012, othrayte (Adrian Cowan)

    This file is part of Deepend.

    Deepend is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Deepend is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
*/

package net.othrayte.deepend;

import haxe.FastList;
import haxe.Timer;

/**
 * Split Ordered Linked bInary Search Tree
 */
class Solist {
	private var treeHead:SolistNode;
	private var orderListHeads:Array<SolistNode>;
	private var orderListTails:Array<SolistNode>;
	
	public function add(before:Int, after:Int) {
		if (before == after) return;
		var beforeNode:SolistNode = new SolistNode(before);
		var afterNode:SolistNode = new SolistNode(after);
		var result1:SolistNode = findOrAddToTree(beforeNode);
		var result2:SolistNode = findOrAddToTree(afterNode);
		if (result1 != null && result2 == null) { // 10
			afterNode.next = result1.next;
			if (afterNode.next != null) {
				afterNode.next.prev = afterNode;
			} else {
				orderListTails[result1.stream] = afterNode;
			}
			result1.next = afterNode;
			afterNode.prev = result1;
			afterNode.stream = result1.stream;
			afterNode.use = true;
		} else if (result1 != null && result2 != null) { // 12-11
			if (result1.stream == result2.stream) { // 11
				if (!inOrder(result1, result2)) {
					if (result2.prev != null) {
						result2.prev.next = result2.next;
					} else {
						orderListHeads[result2.stream] = result2.next; 
					}
					if (result2.next != null) {
						result2.next.prev = result2.prev;
					} else {
						trace("HUH?!");
					}
					result2.next = result1.next;
					if (result1.next != null) {
						result1.next.prev = result2;
					} else {
						orderListTails[result1.stream] = result2;
					}
					result1.next = result2;
					result2.prev = result1;
				}
			} else { // 12
				orderListTails[result1.stream].next = orderListHeads[result2.stream];
				orderListHeads[result2.stream].prev = orderListTails[result1.stream];
				orderListTails[result1.stream] = orderListTails[result2.stream];
				var c:SolistNode = orderListHeads[result2.stream];
				orderListHeads[result2.stream] = null;
				orderListTails[result2.stream] = null;
				while (c != null) {
					c.stream = result1.stream;
					c = c.next;
				}
			}
			result2.use = true;
		} else if (result1 == null && result2 != null) { // 01
			beforeNode.next = result2;
			if (result2.prev != null) {
				result2.prev.next = beforeNode;
			} else {
				orderListHeads[result2.stream] = beforeNode;
			}
			beforeNode.prev = result2.prev;
			result2.prev = beforeNode;
			beforeNode.stream = result2.stream;	
			beforeNode.use = false;	
			result2.use = true;		
		} else { // 00
			orderListHeads.push(beforeNode);
			orderListTails.push(afterNode);
			beforeNode.stream = orderListHeads.length-1;
			afterNode.stream = orderListHeads.length-1;
			beforeNode.next = afterNode;
			afterNode.prev = beforeNode;
			beforeNode.use = false;
			afterNode.use = true;
		}
	}
	public function output() {
		var output:FastList<FastList<Int>>;
		output = new FastList<FastList<Int>>();
		for (node in orderListTails) {
			if (node != null) {
				var tmp:FastList<Int> = new FastList<Int>();
				while (node != null) {
					if (node.use) tmp.add(node.v);
					node = node.prev;
				}
				output.add(tmp);
			}
		}
		return output;
	}
	public function empty() {
		orderListHeads = new Array();
		orderListTails = new Array();
		treeHead = null;
	}
	
	private function findOrAddToTree(node:SolistNode) {
		if (treeHead == null) {
			treeHead = node;
		} else {
			var cNode:SolistNode = treeHead;
			while (cNode.v != node.v) {
				if (node.v > cNode.v) {
					if (cNode.r != null) {
						cNode = cNode.r;
					} else {
						cNode.r = node;
						node.parent = cNode;
						return null;
					}
				} else if (node.v < cNode.v) {
					if (cNode.l != null) {
						cNode = cNode.l;
					} else {
						cNode.l = node;
						node.parent = cNode;
						return null;
					}
				} else {
					return cNode;
				}
			}
			return cNode;
		}
		return null;
	}
	
	private function inOrder(beforeNode:SolistNode, afterNode:SolistNode) {
		while (beforeNode.next != null) {
			if (beforeNode.next == afterNode) return true;
			beforeNode = beforeNode.next;
		}
		return false;
	}
	
	public function new() {
		orderListHeads = new Array();
		orderListTails = new Array();
	}	
}

class SolistNode {
	public var v:Int;
	public var use:Bool;
	public var parent:SolistNode;
	public var l:SolistNode;
	public var r:SolistNode;
	public var prev:SolistNode;
	public var next:SolistNode;
	public var stream:Int;
	
	public function new(val:Int) {
		v = val;
		parent = null;
		l = null;
		r = null;
		next = null;
		prev = null;
	}

	public function toString() {
		return "SolistNode: "+v;
	}
}