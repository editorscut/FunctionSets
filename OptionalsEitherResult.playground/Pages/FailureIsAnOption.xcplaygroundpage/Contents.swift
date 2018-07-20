//func echoEvensOnly(_ input: Int) -> Int {
//    if input is even {return input}
//    else {something has gone wrong}
//}

extension Int {
    var isEven: Bool {
        return self % 2 == 0 ? true : false
    }
}

extension String: Error{}

func echoEvenOrThrow(_ input: Int) throws -> Int {
    guard input.isEven else { throw "\(input) is odd"}
    return input
}

do {
    try echoEvenOrThrow(2)
} catch  {
    print("error:", error)
}

do {
    try echoEvenOrThrow(3)
} catch  {
    print("error:", error)
}

try? echoEvenOrThrow(2)
try? echoEvenOrThrow(3)

func echoEvenOrNil(_ input: Int) -> Int? {
    guard input.isEven else {return nil}
    return Optional(input)
}

echoEvenOrNil(2)
echoEvenOrNil(3)

enum Result<Value> {
    case failure(Error)
    case success(Value)
}

func echoEvenResults(_ input: Int) -> Result<Int> {
    guard input.isEven else {return Result.failure("\(input) is odd")}
    return Result.success(input)
}

echoEvenResults(2)
echoEvenResults(3)
