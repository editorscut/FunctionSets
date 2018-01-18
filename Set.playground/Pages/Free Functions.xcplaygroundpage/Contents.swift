// Support code for http://editorscut.com/Blog/2018/01/18-SetsFreeFunction.html


typealias IntSet = (Int) -> Bool

let emptySet: IntSet = {(_) in return false}
let universalSet : IntSet = {(_) in return true}

func contents(of set: IntSet,
                from lowerBound: Int = 0,
                to upperBound: Int = 10) -> String {
    return [Int](lowerBound...upperBound).filter{x in set(x)}.description
}


func rangeSet(from lower: Int, to upper: Int) -> IntSet {
    return { x in
        (x >= lower) && (x <= upper)
    }
}

func setFrom(elements: Int...) -> IntSet {
    return {x in
        elements.contains(x)
    }
}

let twoThreeFour = rangeSet(from: 2, to: 4)
let threeFourFive = rangeSet(from: 3, to: 5)



func union(of firstSet: @escaping IntSet,
           and secondSet: @escaping IntSet) -> IntSet {
    return { x in
        (firstSet(x) || secondSet(x))
    }
}

func intersection(of firstSet: @escaping IntSet,
                  and secondSet: @escaping IntSet) -> IntSet {
    return { x in
        (firstSet(x) && secondSet(x))
    }
}

func complement(of set: @escaping IntSet) -> IntSet {
    return {x in !set(x)}
}

func difference(of baseSet: @escaping IntSet, minus setToBeRemoved: @escaping IntSet) -> IntSet {
    return intersection(of: baseSet, and: complement(of: setToBeRemoved))
}

func symmetricDifference(of setOne: @escaping IntSet, and setTwo: @escaping IntSet) -> IntSet {
    let unionSet = union(of: setOne, and: setTwo)
    let intersectionSet = intersection(of: setOne, and: setTwo)
    return difference(of: unionSet, minus: intersectionSet)
}

func add(_ element: Int, to set: @escaping IntSet) -> IntSet {
    return {x in
        set(x) || x == element
    }
}

func remove(_ element: Int, from set: @escaping IntSet) -> IntSet {
    return { x in
        set(x) && x != element
    }
}



let twoThroughFive = union(of: twoThreeFour, and: threeFourFive)
let threeAndFour = intersection(of: twoThreeFour, and: threeFourFive)
contents(of: emptySet)
contents(of: universalSet)
contents(of: twoThreeFour)
contents(of: complement(of: twoThreeFour))

contents(of: difference(of: twoThroughFive, minus: threeAndFour))
contents(of: symmetricDifference(of: twoThreeFour, and: threeFourFive))

let addSeven = add(7, to: twoThreeFour)
let removeSeven = remove(7, from: addSeven)
let addSevenAgain = add(7, to: removeSeven)

contents(of: addSeven)
contents(of: removeSeven)
contents(of: addSevenAgain)

let primes = setFrom(elements: 2, 3, 5, 7)
contents(of: primes)

contents(of: union(of: primes, and: twoThreeFour))

