//: Playground - noun: a place where people can play

import UIKit
//
//let arr = [1, 2, 3, 4]
//let addTwo: (Int, Int) -> Int = { x, y in x + y }
//let reducedArr = arr.reduce(10, addTwo)
//let another = arr.reduce(10) { x, y in x + y }

struct City {
    let name: String
    let population: Int
}

let paris = City(name: "Paris", population: 2241)
let madrid = City(name: "Madrid", population: 4102)
let amsterdam = City(name: "Amsterdam", population: 801)
let berlin = City(name: "Berlin", population: 3562)

let cities = [paris, madrid, amsterdam, berlin]

extension City {
    func byScalingPopulation() -> City {
        return City(name: name, population: population * 1000)
    }
}

let result = cities.filter { $0.population > 1000 }
    .map { $0.byScalingPopulation() }
    .reduce("City: Population") { result, c in
        return result + "\n" + "\(c.name):\(c.population)"
    }
result
