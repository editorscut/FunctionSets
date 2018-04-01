// Support code for http://editorscut.com/Blog/2018/01/22-SetsStructs.html


struct IntSet {
    let contains: (Int) -> Bool
}

extension IntSet {
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

extension IntSet: CustomStringConvertible {
    var description: String {
        return [Int](0 ... 10).filter{x in contains(x)}.description
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

let evens = IntSet(){x in
    x % 2 == 0
}

evens
evens.contains(4)
evens.contains(3)

let twoThreeFour = IntSet(withRangeFrom: 2, to: 4)
let primes = IntSet(2, 3, 5, 7)
    

let emptySet = IntSet()
emptySet
let universalSet = IntSet(contains: {(_) in return true})
universalSet





let threeFourFive = IntSet(3, 4, 5)

twoThreeFour.union(threeFourFive)
twoThreeFour.intersection(threeFourFive)
twoThreeFour.complement
twoThreeFour.minus(threeFourFive)
twoThreeFour.symmetricDifference(with: threeFourFive)

let addSeven = twoThreeFour.add(7)
let removeSeven = addSeven.remove(7)
let addSevenAgain = removeSeven.add(7)



