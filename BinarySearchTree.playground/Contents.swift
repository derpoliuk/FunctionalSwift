//: Playground - noun: a place where people can play

import UIKit

indirect enum BinarySearchTree<Element: Comparable> {
    case Leaf
    case Node(BinarySearchTree<Element>, Element, BinarySearchTree<Element>)
}

let leaf: BinarySearchTree<Int> = .Leaf
let five: BinarySearchTree<Int> = .Node(leaf, 5, leaf)

extension BinarySearchTree {
    init() {
        self = .Leaf
    }
    init(_ value: Element) {
        self = .Node(.Leaf, value, .Leaf)
    }
}

extension BinarySearchTree {
    var count: Int {
        switch self {
        case .Leaf:
            return 0
        case let .Node(left, _, right):
            return 1 + left.count + right.count
        }
    }
}

extension BinarySearchTree {
    var elements: [Element] {
        switch self {
        case .Leaf:
            return []
        case let .Node(left, x, right):
            return left.elements + [x] + right.elements
        }
    }
}

extension BinarySearchTree {
    var isEmpy: Bool {
        if case .Leaf = self {
            return true
        }
        return false
    }
}

extension Sequence {
    func all(_ predicate: (Self.Iterator.Element) -> Bool) -> Bool {
        for x in self where !predicate(x) {
            return false
        }
        return true
    }
}

extension BinarySearchTree where Element: Comparable {
    var isBST: Bool {
        switch self {
        case .Leaf:
            return true
        case let .Node(left, x, right):
            return left.elements.all { y in y < x }
                && right.elements.all { y in y < x }
                && left.isBST
                && right.isBST
        }
    }
}

extension BinarySearchTree {
    func contains(_ x: Element) -> Bool {
        switch self {
        case .Leaf:
            return false
        case let .Node(_, y, _) where x == y:
            return true
        case let .Node(left, y, _) where x < y:
            return left.contains(x)
        case let .Node(_, y, right) where x > y:
            return right.contains(x)
        default:
            fatalError("The impossible occured")
        }
    }
}

extension BinarySearchTree {
    mutating func insert(_ x: Element) {
        switch self {
        case .Leaf:
            self = BinarySearchTree(x)
        case .Node(var left, let y, var right):
            if x < y { left.insert(x) }
            if x > y { right.insert(x) }
            self = .Node(left, y, right)
        }
    }
}

let tree: BinarySearchTree<Int> = BinarySearchTree()
var copied = tree
copied.insert(5)
(tree.elements, copied.elements)


func autocomplete(_ history: [String], textEntered: String) -> [String] {
    return history.filter { $0.hasPrefix(textEntered) }
}

struct Trie<Element: Hashable> {
    let isElement: Bool
    let children: [Character: Trie<Element>]
}

extension Trie {
    init() {
        isElement = false
        children = [:]
    }
}

extension Trie {
    var elements: [[Element]] {
        var result: [[Element]] = isElement ? [[]] : []
        for (key, value) in children {
            result += value.elements.map { [key] + $0 }
        }
        return result
    }
}