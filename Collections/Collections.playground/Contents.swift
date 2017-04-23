//: Playground - noun: a place where people can play

import Cocoa

/******************************************************************
 *
 * ADVANCED SWIFT
 *
 *
 *****************************************************************/

// Arrays and Mutability

// The Fibonacci numbers
let fibs = [0, 1, 1, 2, 3, 5]
var mutableFibs = [0, 1, 1, 2, 3, 5]

mutableFibs.append(8)
mutableFibs.append(contentsOf: [13, 21])
mutableFibs

var x = [1, 2, 3]
var y = x
y.append(4)
y
x

let a = NSMutableArray(array: [1, 2, 3])

// I don't want to be able to mutaye b
let b: NSArray = a
a.insert(4, at: 3)
b

let c = NSMutableArray(array: [1, 2, 3])

// I don't want to be able to mutate d
let d = c.copy() as! NSArray
c.insert(4, at: 3)
c
d






















