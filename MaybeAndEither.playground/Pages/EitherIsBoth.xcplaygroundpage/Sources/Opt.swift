public struct Opt<Wrapped> {
    private let backingList: List<Wrapped>
}

extension Opt {
    public init(_ value: Wrapped) {
        self.init(backingList: List(value))
    }
    
    public init() {
        self.init(backingList: List())
    }
    
    public var value: Wrapped {
        return backingList.head
    }
    
    public var isNil: Bool {
        return backingList.isEmpty
    }
}

extension Opt: CustomStringConvertible where Wrapped: CustomStringConvertible {
    public var description: String {
        if isNil {return "nil"}
        else {return "Opt(" + backingList.head.description + ")"}
        
    }
}


extension Opt {
    public func map<Output>(_ f: @escaping (Wrapped) -> Output)
        -> Opt<Output> {
            return Opt<Output>(backingList: backingList.map(f))
    }
}

public func <^><A, B>(a: Opt<A>,
               f: @escaping (A) -> B) -> Opt<B> {
    return a.map(f)
}

extension Opt {
    public func flatMap<Output>(_ f: @escaping (Wrapped) -> Opt<Output> ) -> Opt<Output> {
        return Opt<Output>(backingList: backingList.flatMap{x in f(x).backingList})
    }
}

public func >=><A, B>(a: Opt<A>,
               f: @escaping (A) -> Opt<B>) -> Opt<B> {
    return a.flatMap(f)
}
