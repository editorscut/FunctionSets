struct Opt<Wrapped> {
    private let backingList: List<Wrapped>
}

extension Opt {
    init(_ value: Wrapped) {
        self.init(backingList: List(value))
    }
    
    init() {
        self.init(backingList: List())
    }
    
    var value: Wrapped {
        return backingList.head
    }
    
    var isNil: Bool {
        return backingList.isEmpty
    }
}

extension Opt: CustomStringConvertible where Wrapped: CustomStringConvertible {
    var description: String {
        if isNil {return "nil"}
        else {return "Opt(" + backingList.head.description + ")"}
        
    }
}

Opt(5)
Opt<Int>()

extension Opt {
    func map<Output>(_ f: @escaping (Wrapped) -> Output)
                           -> Opt<Output> {
        return Opt<Output>(backingList: backingList.map(f))
    }
}

func <^><A, B>(a: Opt<A>,
               f: @escaping (A) -> B) -> Opt<B> {
    return a.map(f)
}

extension Opt {
    public func flatMap<Output>(_ f: @escaping (Wrapped) -> Opt<Output> ) -> Opt<Output> {
        return Opt<Output>(backingList: backingList.flatMap{x in f(x).backingList})
    }
}

func >=><A, B>(a: Opt<A>,
                      f: @escaping (A) -> Opt<B>) -> Opt<B> {
    return a.flatMap(f)
}

func echoEvenOrNil(_ input: Int) -> Opt<Int> {
    guard input.isEven else { return Opt()}
    return Opt(input)
}

echoEvenOrNil(2)
echoEvenOrNil(3)

func halve(_ input: Int) -> Int {
    return input/2
}

func halveEvenOrNil(_ input: Opt<Int>) -> Opt<Int> {
    if input.isNil {return Opt()}
    else {
        
        return Opt(halve(input.value))}
}

halveEvenOrNil(echoEvenOrNil(2))
halveEvenOrNil(echoEvenOrNil(3))

2 |> echoEvenOrNil |> halveEvenOrNil
3 |> echoEvenOrNil |> halveEvenOrNil


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

valueInNumberDictionary(for: 2)
valueInNumberDictionary(for: 3)
valueInNumberDictionary(for: 4)

echoEvenOrNil(2).map(valueInNumberDictionary)
echoEvenOrNil(3).map(valueInNumberDictionary)
echoEvenOrNil(4).map(valueInNumberDictionary)

echoEvenOrNil(2).flatMap(valueInNumberDictionary)
echoEvenOrNil(3).flatMap(valueInNumberDictionary)
echoEvenOrNil(4).flatMap(valueInNumberDictionary)


2 |> echoEvenOrNil >=> valueInNumberDictionary
3 |> echoEvenOrNil >=> valueInNumberDictionary
4 |> echoEvenOrNil >=> valueInNumberDictionary
