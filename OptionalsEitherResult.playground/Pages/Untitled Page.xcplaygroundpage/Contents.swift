//enum Opt<Wrapped> {
//    case some(Wrapped)
//    case none
//}
//
//func echoEvenOrNil(_ input: Int) -> Opt<Int> {
//    guard input % 2 == 0 else {return .none}
//    return .some(input)
//}
//
//extension Opt: CustomStringConvertible where Wrapped: CustomStringConvertible {
//    var description: String {
//        switch self {
//        case .none: return "nil"
//        case .some(let value): return value.description
//        }
//    }
//}
//
//echoEvenOrNil(2)
//echoEvenOrNil(3)
