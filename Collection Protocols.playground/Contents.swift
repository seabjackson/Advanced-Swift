//: Playground - noun: a place where people can play

import UIKit

// Collection Protocol

// Sequences

protocol Sequence {
    associatedtype Iterator: IteratorProtocol
    
    func makeIterator() -> Iterator
}

// Iterators

protocol IteratorProtocol {
    associatedtype Element
    
    mutating func next() -> Element?
}

//struct FibsIterator: IteratorProtocol {
//    var state = (0, 1)
//    
//    mutating func next() -> Int? {
//        let upcomingNumber = state.0
//        state = (state.1, state.0 + state.0)
//        return upcomingNumber
//    }
//}

// Conformance to Sequence

struct PrefixIterator: IteratorProtocol {

    let string: String
    var offset: String.Index
    
    init(string: String) {
        self.string = string
        offset = string.startIndex
    }
    
    mutating func next() -> String? {
        guard offset < string.endIndex else { return nil }
        offset = string.index(after: offset)
        return string[string.startIndex..<offset]
    }
}


struct PrefixSequence: Sequence {
    
    let string: String
    
    func makeIterator() -> PrefixIterator  {
        return PrefixIterator(string: string)
    }
}

// Iterators and Value Semantics

let seq = stride(from: 0, to: 10, by: 1)
var i1 = seq.makeIterator()
i1.next()
i1.next()
var i2 = i1
i1.next()
i1.next()
i2.next()
var i3 = AnyIterator(i1)
var i4 = i3
i3.next()
i4.enumerated()
i3.next()
i3.next()

// Function Based Iterators and Sequences

func fibsIterator() -> AnyIterator<Int> {
    var state = (0, 1)
    return AnyIterator {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}

let fibsSequnce = AnySequence(fibsIterator)
Array(fibsSequnce.prefix(10))

let randomNumbers = sequence(first: 100) { (previous: UInt32) in
    let newValue = arc4random_uniform(previous)
    guard newValue > 0 else {
        return nil
    }
    return newValue
}
Array(randomNumbers)

// Infinite Sequences

// Unstable Sequences

// Collections

// Designing a Protocol for Queues

// A type that can enqueue and dequeue elements

protocol Queue {
    
    // the type of elements held in self
    associatedtype Element
    
    // enqueue element to self
    mutating func enqueue(_ newElement: Element)
    
    // dequeue an element from self
    mutating func dequeue() -> Element?
}

// A Queue Implementation

struct FIFOQueue<Element>: Queue {
    fileprivate var left: [Element] = []
    fileprivate var right: [Element] = []
    
    // add an element to the back of the queue
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }
    
    // removes front of the queue
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
    
}

// Conforming to Collection

extension FIFOQueue: Collection {
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return left.count + right.count }
    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    public subscript(position: Int) -> Element {
        precondition((0..<endIndex).contains(position), "Index out of bounds")
        if position < left.endIndex {
            return left[left.count - position - 1]
        } else {
            return right[position - left.count]
        }
    }
}

var q = FIFOQueue<String>()
for x in ["1", "2", "foo", "3"] {
    q.enqueue(x)
}

for s in q {
    print(s, terminator: " ")
}


var a = Array(q)
a.append(contentsOf: q[2...3])

q.map { $0.uppercased() }
q.flatMap { Int($0) }
q.filter { $0.characters.count > 1 }
q.sorted()
q.joined(separator: "|")

q.isEmpty
q.count
q.first







































