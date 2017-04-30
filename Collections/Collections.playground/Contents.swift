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

// Iteration using forEach

for element in [1, 2, 3] {
    print(element)
}

[1, 2, 3].forEach { element in
    print(element)
}

extension Array where Element: Equatable {
    func index(of element: Element) -> Int? {
        for idx in self.indices where self[idx] == element {
            return idx
        }
        return nil
    }
}


// Array Types

// Slices

let slice = Array(fibs[1..<fibs.endIndex])
type(of: slice)

// Dictionaries

enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

let defaultSettings: [String: Setting] = [
        "Airplane Mode": .bool(true),
        "Name": .text("My iPhone")
]

defaultSettings["Name"]

// Mutation

var localizedSettings = defaultSettings
localizedSettings["Name"] = .text("Mein iPhone")
localizedSettings["Do Not Disturb"] = .bool(true)

let oldName = localizedSettings.updateValue(.text("ll mio iPhone"), forKey: "Name")
localizedSettings["Name"]
oldName

// Some Useful Dictionary Extensions

extension Dictionary {
    mutating func merge<S>(_ other: S) where S: Sequence, S.Iterator.Element == (key: Key, value: Value) {
        for (k, v) in other {
            self[k] = v
        }
    }
}

var settings = defaultSettings
let overridenSettings: [String: Setting] = ["Name": .text("Jane's iPhone")]
settings.merge(overridenSettings)
settings

extension Dictionary {
    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: Key, value: Value) {
        self = [:]
        self.merge(sequence)
    }
}

let defaultAlarms = (1..<5).map { (key: "Alarm \($0)", value: false) }
let alarmsDictionary = Dictionary(defaultAlarms)

extension Dictionary {
    func mapValues<NewValue>(transform: (Value) -> NewValue) -> [Key: NewValue] {
        return Dictionary<Key, NewValue>(map { (key, value) in
            return (key, transform(value))
        })
    }
}


let settingsAsStrings = settings.mapValues { setting -> String in
    switch setting {
    case .text(let text):
        return text
    case .int(let number):
        return String(number)
    case .bool(let value):
        return String(value)
    }
}

settingsAsStrings

// Hashable Requirement

struct Person {
    
    var name: String
    var zipCode: Int
    var birthday: Date
}

extension Person: Equatable {
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name
        && lhs.zipCode == rhs.zipCode
        && lhs.birthday == rhs.birthday
    }
}

extension Person: Hashable {
    var hashValue: Int {
        return name.hashValue ^ zipCode.hashValue ^ birthday.hashValue
    }
}

// Sets

let naturals: Set = [1, 2, 3, 2]
naturals
naturals.contains(3)
naturals.contains(0)

// Set Algebra

let iPods: Set = ["iPod touch", "iPod nano", "iPod mini", "iPod shuffle", "iPod Classic"]
let discontinuediPods: Set = ["iPod mini", "iPod Classic"]
let currentiPods = iPods.subtracting(discontinuediPods)

let touchScreen: Set = ["iPhone", "iPad", "iPod touch", "iPod nano"]
let iPodsWithTouch = iPods.intersection(touchScreen)

var discontinued: Set = ["iBook", "Powerbook", "Power Mac"]
discontinued.formUnion(discontinuediPods)

// Index Sets and Character Sets

var indices = IndexSet()
indices.insert(integersIn: 1..<5)
indices.insert(integersIn: 11..<15)
let evenIndices = indices.filter { $0 % 2 == 0 }

// Using Sets Inside Closures

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter {
            if seen.contains($0) {
                return false
            } else {
                seen.insert($0)
                return true
            }
        }
    }
}

[1, 2, 3, 12, 1, 3, 4, 5, 6, 4, 6].unique()

// Ranges

let singleDigitNumbers = 0..<10

let lowerCaseLetters = Character("a")...Character("z")





























