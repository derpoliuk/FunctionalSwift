//: Playground - noun: a place where people can play

import UIKit

protocol Smaller {
    func smaller() -> Self?
}

extension Int: Smaller {
    func smaller() -> Int? {
        return self == 0 ? nil : self / 2
    }
}

extension CGFloat: Smaller {
    func smaller() -> CGFloat? {
        return nil
    }
}

extension CGSize: Smaller {
    func smaller() -> CGSize? {
        return nil
    }
}

extension String: Smaller {
    func smaller() -> String? {
        return isEmpty ? nil : String(characters.dropFirst())
    }
}

extension Character: Smaller {
    func smaller() -> Character? {
        return nil
    }
}

protocol Arbitrary: Smaller {
    static func arbitrary() -> Self
}

extension Int: Arbitrary {
    static func arbitrary() -> Int {
        return Int(arc4random())
    }
}

extension Int {
    static func random(from: Int, to: Int) -> Int {
        return from + (Int(arc4random()) % (to - from))
    }
}

extension Character: Arbitrary {
    static func arbitrary() -> Character {
        return Character(UnicodeScalar(Int.random(from: 65, to: 90))!)
    }
}

func tabulate<A>(times: Int, transform: (Int) -> A) -> [A] {
    return (0..<times).map(transform)
}

extension String: Arbitrary {
    static func arbitrary() -> String {
        let randomLength = Int.random(from: 0, to: 40)
        let randomCharacters = tabulate(times: randomLength) { _ in
            Character.arbitrary()
        }
        return String(randomCharacters)
    }
}

extension CGFloat: Arbitrary {
    static func arbitrary() -> CGFloat {
        return (CGFloat(Float(arc4random()) / Float(UINT32_MAX)) - 0.5) * 1000
    }
}

extension CGSize {
    var area: CGFloat {
        return width * height
    }
}

extension CGSize: Arbitrary {
    static func arbitrary() -> CGSize {
        return CGSize(width: CGFloat.arbitrary(), height: CGFloat.arbitrary())
    }
}

func iterateWhile<A>(condition: (A) -> Bool, initial: A, next: (A) -> A?) -> A {
    if let x = next(initial), condition(x) {
        return iterateWhile(condition: condition, initial: x, next: next)
    }
    return initial
}

let numberOfIterations = 10

func check1<A: Arbitrary>(message: String, property: (A) -> Bool) -> () {
    for _ in 0..<numberOfIterations {
        let value = A.arbitrary()
        guard property(value) else {
            print("\"\(message)\" doesn't hold: \(value)")
            return
        }
    }
    print("\"\(message)\" passed \(numberOfIterations) tests")
}

func check2<A: Arbitrary>(message: String, property: (A) -> Bool) -> () {
    for _ in 0..<numberOfIterations {
        let value = A.arbitrary()
        guard property(value) else {
            let smallerValue = iterateWhile(condition: { !property($0) }, initial: value) {
                $0.smaller()
            }
            print("\"\(message)\" doesn't hold: \(smallerValue)")
            return
        }
    }
    print("\"\(message)\" passed \(numberOfIterations) tests")
}

//check1(message: "Area should be at least 0") { (size: CGSize) in size.area >= 0 }
//check1(message: "Every string starts with Hello") { (s: String) in
//    s.hasPrefix("Hello")
//}

