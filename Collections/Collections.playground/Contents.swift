//: Playground - noun: a place where people can play

import Cocoa


// Arrays and Mutability

let fibs = [0, 1, 1, 2, 3, 5]

var mutableFibs = [0, 1, 1, 2, 3, 5]

mutableFibs.append(8)
mutableFibs.appendContentsOf([13, 21])

// note in Swift that arrays are passed by value

var x = [1, 2, 3]

var y = x
y.append(4)

let a = NSMutableArray(array: [1, 2, 3])

// I don't want to be able to mutate b
let b: NSArray = a.copy() as! NSArray

a.insertObject(4, atIndex: 3)
b // still is [1, 2, 3]

// TRANSFORMING ARRAYS

//  Map
var squared: [Int] = []
for fib in fibs {
    squared.append(fib * fib)
}

let squares = fibs.map { fib in fib * fib }
squared
squares

extension Array {
    // Element is a generic placeholder for whatever type the array contains
    func map<U>(transform: Element -> U) -> [U]  {
        var result: [U] = []
        result.reserveCapacity(self.count)
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}


// Mutation and Stateful Closures
extension Array {
    func accumulate<U>(initial: U, combine: (U, Element) -> U) -> [U] {
        var running = initial
        return self.map { next in
            running = combine(running, next)
            return running
        }
    }
}

[1, 2, 3, 4].accumulate(0, combine: +)

// Filter
fibs.filter { $0 % 2 == 0 }

// Find all squares under 100 that are even
print("\((1..<10).map {$0 * $0 }.filter {$0 % 2 == 0 })")




