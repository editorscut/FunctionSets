// Support code for http://editorscut.com/Blog/2018/01/16-Sets.html


typealias IntSet = (Int) -> Bool

let emptySet: IntSet = {(_) in return false}
let universalSet : IntSet = {(_) in return true}


func rangeSet(from lower: Int, to upper: Int) -> IntSet {
    return { x in
        (x >= lower) && (x <= upper)
    }
}


let twoThreeFour = rangeSet(from: 2, to: 4)
twoThreeFour(0)
twoThreeFour(2)
twoThreeFour(3)

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


let twoThroughFive = union(of: twoThreeFour, and: threeFourFive)
twoThroughFive(1)
twoThroughFive(2)
twoThroughFive(3)
twoThroughFive(4)
twoThroughFive(5)
twoThroughFive(6)

let threeAndFour = intersection(of: twoThreeFour, and: threeFourFive)
threeAndFour(1)
threeAndFour(2)
threeAndFour(3)
threeAndFour(4)
threeAndFour(5)


