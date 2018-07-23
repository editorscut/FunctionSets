enum Opt<Wrapped> {
    case none
    case some(Wrapped)
}

extension Opt {
    init(_ value: Wrapped) {
        self = Opt.some(value)
    }
    
    init() {
        self = Opt<Wrapped>.none
    }
    
    var value: Wrapped {
        if case .some(let value) = self {return value}
        else {fatalError("Tried to unwrap nil")}
    }
    
    var isNil: Bool {
        if case .none = self {return true}
        else {return false}
    }
}

extension Opt: CustomStringConvertible where Wrapped: CustomStringConvertible {
    var description: String {
        if isNil {return "nil"}
        else {return "Opt(" + value.description + ")"}
        
    }
}

Opt(5)
Opt<Int>()

extension Opt {
    func map<Output>(_ f: @escaping (Wrapped) -> Output)
        -> Opt<Output> {
            guard case .some(let value) = self else {return .none}
            return .some(f(value))
    }
}

func <^><A, B>(a: Opt<A>,
               f: @escaping (A) -> B) -> Opt<B> {
    return a.map(f)
}

extension Opt {
    func flatMap<Output>(_ f: @escaping (Wrapped) -> Opt<Output> ) -> Opt<Output> {
        guard case .some(let value) = self else {return .none}
        return f(value)
    }
}

func >=><A, B>(a: Opt<A>,
               f: @escaping (A) -> Opt<B>) -> Opt<B> {
    return a.flatMap(f)
}

extension Opt {
    func filter(_ f: (Wrapped) -> Bool) -> Opt {
        switch self {
        case .some(let value):
            if f(value) {return self}
            fallthrough
        default:
            return .none
        }
    }
}

extension Opt {
    func getOrElse(_ defaultValue: Wrapped) -> Wrapped {
        switch self {
        case .some(let value):
            return value
        default:
            return defaultValue
        }
    }
}

func ??<A>(opt: Opt<A>, defaultValue: A) -> A {
    return opt.getOrElse(defaultValue)
}


func echoEvenOrNil(_ input: Int) -> Opt<Int> {
    guard input.isEven else { return Opt()}
    return Opt(input)
}

echoEvenOrNil(2)
echoEvenOrNil(3)

let contentsDivisibleBy3 = {x in x % 3 == 0}

echoEvenOrNil(2).filter(contentsDivisibleBy3)
echoEvenOrNil(3).filter(contentsDivisibleBy3)
echoEvenOrNil(12).filter(contentsDivisibleBy3)

func halve(_ input: Int) -> Int {
    return input/2
}



echoEvenOrNil(2).map(halve)
echoEvenOrNil(3).map(halve)

echoEvenOrNil(2) <^>  halve

2 |> echoEvenOrNil <^> halve
3 |> echoEvenOrNil <^> halve

let numberDictionary = [1: "one", 2: "two", 3: "three"]

func valueInNumberDictionary(for key: Int) -> Opt<String> {
    guard numberDictionary.keys.contains(key) else {return Opt()}
    return Opt(numberDictionary[key]!)
}

echoEvenOrNil(2).flatMap(valueInNumberDictionary)
echoEvenOrNil(3).flatMap(valueInNumberDictionary)
echoEvenOrNil(4).flatMap(valueInNumberDictionary)


2 |> echoEvenOrNil >=> valueInNumberDictionary
3 |> echoEvenOrNil >=> valueInNumberDictionary
4 |> echoEvenOrNil >=> valueInNumberDictionary

echoEvenOrNil(3).getOrElse(-1)
echoEvenOrNil(2).getOrElse(-1)


echoEvenOrNil(3) ?? -1
echoEvenOrNil(2) ?? -1
