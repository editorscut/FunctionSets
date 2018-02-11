// Support code for http://editorscut.com/Blog/2018/02/11-List.html


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


