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
