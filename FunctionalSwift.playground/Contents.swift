//: Playground - noun: a place where people can play

import UIKit

typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
}

extension Position {
    func inRange(_ range: Distance) -> Bool {
        return sqrt(x * x + y * y) <= range
    }
}

extension Position {
    func minus(_ p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    var length: Double {
        return sqrt(x * x + y * y)
    }
}

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}

extension Ship {
    func canEngage(ship: Ship) -> Bool {
        let dx = ship.position.x - position.x
        let dy = ship.position.y - position.y
        let shipDistance = sqrt(dx * dx + dy * dy)
        return shipDistance <= firingRange
    }
}

extension Ship {
    func canSafelyEngage(ship: Ship) -> Bool {
        let dx = ship.position.x - position.x
        let dy = ship.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange
            && targetDistance > unsafeRange
    }
}

extension Ship {
    func canSafelyEngage1(ship: Ship, friendly: Ship) -> Bool {
        let dx = ship.position.x - position.x
        let dy = ship.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        let friendlyDx = friendly.position.x - ship.position.x
        let friendlyDy = friendly.position.y - ship.position.y
        let friendlyDistance = sqrt(friendlyDx * friendlyDx + friendlyDy * friendlyDy)
        return targetDistance <= firingRange
            && targetDistance > unsafeRange
            && friendlyDistance > unsafeRange
    }
}

extension Ship {
    func canSafelyEngage2(ship: Ship, friendly: Ship) -> Bool {
        let targetDistance = ship.position.minus(position).length
        let friendlyDistance = friendly.position.minus(position).length
        return targetDistance <= firingRange
            && targetDistance > unsafeRange
            && friendlyDistance > unsafeRange
    }
}

typealias Region = (Position) -> Bool

func circle(radius: Distance) -> Region {
    return { point in point.length <= radius }
}

func circle(radius: Distance, center: Position) -> Region {
    return { point in point.minus(center).length <= radius }
}

func shift(region: @escaping Region, offset: Position) -> Region {
    return { point in region(point.minus(offset)) }
}

func invert(region: @escaping Region) -> Region {
    return { point in !region(point) }
}

func intersection(_ region1: @escaping Region, _ region2: @escaping Region) -> Region {
    return { point in region1(point) && region2(point) }
}

func union(_ region1: @escaping Region, _ region2: @escaping Region) -> Region {
    return { point in region1(point) || region2(point) }
}

func difference(region: @escaping Region, minus: @escaping Region) -> Region {
    return intersection(region, invert(minus))
}
