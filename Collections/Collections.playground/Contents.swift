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

// Transforming Arrays

// MAP

// square an array of integers
var squared: [Int] = []
for fib in fibs {
    squared.append(fib * fib)
}
squared

let squares = fibs.map { fib in fib * fib }
squares

extension Array {
    func map<T>(_ transform: (Element) -> T) -> [T] {
        var result: [T] = []
        result.reserveCapacity(count)
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}

// Parameterizing Behavior with Functions

let names = ["Paula", "Elena", "Zoe"]

var lastNameEndingINA: String?
for name in names.reversed() where name.hasSuffix("a") {
    lastNameEndingINA = name
    break
}
lastNameEndingINA

extension Sequence {
    func last(where predicate: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for element in reversed() where predicate(element) {
            return element
        }
        return nil
    }
}

let match = names.last { $0.hasSuffix("a") }
match

// Mutation and Stateful Closures

extension Array {
    func accumulate<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map { next in
            running = nextPartialResult(running, next)
            return running
        }
    }
}
[1, 2, 3, 4].accumulate(0, +)

// Filter

(1..<10).map { $0 * $0 }.filter { $0 % 2 == 0 }

extension Array {
    func filter(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where isIncluded(x) {
            result.append(x)
        }
        return result
    }
}

extension Sequence {
    public func all(matching predicate: (Iterator.Element) -> Bool) -> Bool {
        // every element matches a predicate if no element doesn't match it:
        return !contains { !predicate($0) }
    }
}

// Reduce

var total = 0

for num in fibs {
    total = total + num
}
total

let sum = fibs.reduce(0, +)

print(fibs.reduce("") { str, num in str + "\(num) " })

extension Array {
    func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> Result {
        var result = initialResult
        for x in self {
            result = nextPartialResult(result, x)
        }
        return result
    }
}

extension Array {
    func map2<T>(_ transform: (Element) -> T) -> [T] {
        return reduce([]) {
            $0 + [transform($1)]
        }
    }
}


// A Flattening Map

extension Array {
    func flatMap<T>(_ transform: (Element) -> [T]) -> [T] {
        var result: [T] = []
        for x in self {
            result.append(contentsOf: transform(x))
        }
        return result
    }
}


let suits = ["♠", "♥", "♣", "♦"]
let ranks = ["J","Q","K","A"]

let result = suits.flatMap { suit in
    ranks.map { rank in
        (suit, rank)
    }
}
result











