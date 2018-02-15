// Support code for http://editorscut.com/Blog/2018/02/15-BuildingOnOurFoundation.html


indirect enum List<A> {
    case empty
    case cons(head: A, tail: List)
}

extension List {
    private init(_ xs: [A]) {
        if xs.isEmpty {self = List.empty}
        else {
            var xs = xs
            let first = xs.removeFirst()
            self = List.cons(head: first, tail: List(xs))
        }
    }
    
    init(_ xs: A...){
        self.init(xs)
    }
}

extension List: CustomStringConvertible  {
    var description: String {
        switch self {
        case .empty:
            return "( )"
        case let .cons(head, tail):
            return "(\(head)" + tail.description + ")"
        }
    }
}
extension List: Equatable where A: Equatable {
    static func == (lhs: List, rhs: List) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case(.empty, .cons), (.cons, .empty): return false
        case(.cons(let headL, let tailL), .cons(let headR, let tailR)):
            return headL == headR && tailL == tailR
        }
    }
}

extension List {
    var head: A {
        guard case .cons(let head, _) = self  else {
            fatalError("The list is empty.")
        }
        return head
    }
    var tail: List {
        guard case .cons(_, let tail) = self else {
            fatalError("The list is empty.")
        }
        return tail
    }
    func element(number n: Int) -> A {
        guard n > 0 else {return head}
        return tail.element(number: n - 1)
    }
    func append(_ element: A) -> List {
        return List.cons(head: element, tail: self)
    }
}

extension List {
    func foldLeft<B>(_ initialValue: B, _ f: @escaping(B, A) -> B) -> B {
        guard case let .cons(head, tail) = self else {return initialValue}
        return tail.foldLeft(f(initialValue, head), f)
    }
    func foldRight<B>(_ initialValue: B, _ f: @escaping(A, B) -> B) -> B {
        guard case let .cons(head, tail) = self else {return initialValue}
        return f(head, tail.foldRight(initialValue, f))
    }
    func reversed() -> List {
        return foldLeft(List.empty){ (reversedList, element) in
            List.cons(head: element, tail: reversedList)
        }
    }
    func foldR<B>(_ initialValue: B, _ f: @escaping(A, B) -> B) -> B {
        return reversed().foldLeft(initialValue){(b,a) in f(a,b)}
    }
    func map<B>(_ f: @escaping (A) -> B) -> List<B> {
        return foldR(List<B>.empty){(element, mappedList) in
            List<B>.cons(head: f(element), tail: mappedList)}
    }
    func filter(_ f: @escaping (A) -> Bool) -> List {
        return foldR(List.empty){(element, filteredList) in
            f(element) ? List.cons(head: element, tail: filteredList) : filteredList}
    }
}

let emptyList = List<Int>.empty

let six = List.cons(head: 6, tail: emptyList)

let twoThreeFour
    = List.cons(head: 2,
                tail: List.cons(head: 3,
                                tail: List.cons(head: 4,
                                                tail: emptyList)))
let fiveSixSeven = List(5,6,7)
let anotherEmptyList = List<Int>()

[5,6,7][0]
[5,6,7][2]

fiveSixSeven.head
fiveSixSeven.element(number: 0)
fiveSixSeven.element(number: 1)
fiveSixSeven.element(number: 2)

fiveSixSeven.foldLeft(0, +)
fiveSixSeven.foldLeft(0){(accumulator, element) in
    accumulator + element
}
fiveSixSeven.foldLeft(emptyList){(accumulator, element)
    in accumulator.append(element + 1)
}

fiveSixSeven.foldRight(0, +)
fiveSixSeven.foldRight(0){(element, accumulator) in
    accumulator + element
}
fiveSixSeven.foldRight(emptyList){(element, accumulator)
    in accumulator.append(element + 1)
}

twoThreeFour.reversed()
emptyList.reversed()

twoThreeFour == twoThreeFour.reversed()
twoThreeFour == twoThreeFour.reversed().reversed()
emptyList == emptyList.reversed()

fiveSixSeven.foldR(emptyList){(element, accumulator)
    in accumulator.append(element + 1)
}
let sixSevenEight = fiveSixSeven.map{x in x + 1}
sixSevenEight

let evens = sixSevenEight.filter{x in x % 2 == 0}
evens

let sixSeven = sixSevenEight.filter{x in x <= 7}
sixSeven 
