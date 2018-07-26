public indirect enum List<A> {
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
    
    public init(_ xs: A...){
        self.init(xs)
    }
}

extension List: CustomStringConvertible  {
    public var description: String {
        switch self {
        case .empty:
            return "( )"
        case let .cons(head, tail):
            return "(\(head)" + tail.description + ")"
        }
    }
    
    public var isEmpty: Bool {
        guard case .empty = self else {return false}
        return true
    }
}
extension List: Equatable where A: Equatable {
    public static func == (lhs: List, rhs: List) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case(.empty, .cons), (.cons, .empty): return false
        case(.cons(let headL, let tailL), .cons(let headR, let tailR)):
            return headL == headR && tailL == tailR
        }
    }
}

extension List {
    public var head: A {
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
    public func map<B>(_ f: @escaping (A) -> B) -> List<B> {
        return foldR(List<B>.empty){(element, mappedList) in
            List<B>.cons(head: f(element), tail: mappedList)}
    }
    func filter(_ f: @escaping (A) -> Bool) -> List {
        return foldR(List.empty){(element, filteredList) in
            f(element) ? List.cons(head: element, tail: filteredList) : filteredList}
    }
    
}

extension List {
    func append(_ otherList: List) -> List {
        return foldR(otherList){(a,b) in List.cons(head: a, tail: b)}
    }
    
    func join<B>() -> List<B> where A == List<B> {
        return foldR(List<B>.empty, {(a,b) in a.append(b)})
    }
    
    public func flatMap<B>(_ f: @escaping (A) -> List<B> ) -> List<B> {
        return map(f).join()
    }
    
    init(pure a: A) {
        self = List.cons(head: a, tail: List.empty)
    }
    
    func mapAlt<B>(_ f: @escaping (A) -> B) -> List<B> {
        return flatMap{a in List<B>(pure:(f(a)))}
    }
    
    func apply<B>(_ fs: List<(A) -> B>) -> List<B> {
        return fs.foldR(List<B>.empty){
            let f = $0
            return $1.append(self.foldR(List<B>.empty){
                List<B>.cons(head: f($0), tail: $1)
            })
        }
    }
}
