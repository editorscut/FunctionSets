import Foundation

extension Int {
    public var isEven: Bool {
        return self % 2 == 0 ? true : false
    }
}

precedencegroup Apply {
    associativity: left
}

precedencegroup Compose {
    higherThan: Apply
    associativity: right
}

infix operator |>: Apply
infix operator >>> : Compose
infix operator <^>: Apply
infix operator >=>: Apply

public func |><A, B>(x: A, f: (A) -> B) -> B {
    return f(x)
}

public func >>><A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return {x in g(f(x))}
}


