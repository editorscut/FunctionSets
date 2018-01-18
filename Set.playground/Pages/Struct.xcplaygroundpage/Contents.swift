//: Playground - noun: a place where people can play


struct IntSet {
    let contains: (Int) -> Bool
    
    init(contains: @escaping (Int) -> Bool) {
        self.contains = contains
    }
    
    init(withRangeFrom lower: Int, to upper: Int) {
        contains = {x in
            (x >= lower) && (x <= upper)
        }
    }
    
    init(_ elements: Int ...) {
        contains = {x in
            elements.contains(x)
        }
    }
}

extension IntSet {
    func union(_ otherSet: IntSet) -> IntSet {
        return IntSet{ x in
            (self.contains(x) || otherSet.contains(x))
        }
    }
    
    func intersection(_ otherSet: IntSet) -> IntSet {
        return IntSet{ x in
            (self.contains(x) && otherSet.contains(x))
        }
    }
    var complement:  IntSet {
        return IntSet{x in !self.contains(x)}
    }
    
    func minus(_ setToBeRemoved:  IntSet) -> IntSet {
        return self.intersection(setToBeRemoved.complement)
    }
    
    func symmetricDifference(with otherSet: IntSet) -> IntSet {
        return self.union(otherSet).minus(self.intersection(otherSet))
    }
    
    func add(_ element: Int) -> IntSet {
        return IntSet{x in
            self.contains(x) || x == element
        }
    }
    
    func remove(_ element: Int) -> IntSet {
        return IntSet{ x in
            self.contains(x) && x != element
        }
    }
}

extension IntSet: CustomStringConvertible {
    var description: String {
        return [Int](0 ... 10).filter{x in contains(x)}.description
    }
}


let emptySet = IntSet()
emptySet
let universalSet = IntSet(contains: {(_) in return true})
universalSet

let twoThreeFour = IntSet(withRangeFrom: 2, to: 4)
let threeFourFive = IntSet(3, 4, 5)

twoThreeFour.union(threeFourFive)
twoThreeFour.intersection(threeFourFive)
twoThreeFour.complement
twoThreeFour.minus(threeFourFive)
twoThreeFour.symmetricDifference(with: threeFourFive)

let addSeven = twoThreeFour.add(7)
let removeSeven = addSeven.remove(7)
let addSevenAgain = removeSeven.add(7)


