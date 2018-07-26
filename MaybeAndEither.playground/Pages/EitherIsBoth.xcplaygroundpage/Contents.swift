extension String: Error{}

enum Result<Value> {
    case failure(Error)
    case success(Value)
}

extension Result {
    func map<Output>(_ f: @escaping (Value) -> Output)
        -> Result<Output> {
            switch self {
            case .failure(let errorMessage):
                return .failure(errorMessage)
            case .success(let value):
                return .success(f(value))
            }
    }
}

func <^><A, B>(a: Result<A>,
               f: @escaping (A) -> B) -> Result<B> {
    return a.map(f)
}


extension Result {
    func flatMap<Output>(_ f: @escaping (Value) -> Result<Output> ) -> Result<Output> {
        switch self {
        case .failure(let errorMessage):
            return .failure(errorMessage)
        case .success(let value):
            return f(value)
        }
    }
}

func >=><A, B>(a: Result<A>,
               f: @escaping (A) -> Result<B>) -> Result<B> {
    return a.flatMap(f)
}

func echoEvenOrFail(_ input: Int) -> Result<Int> {
    guard input.isEven else { return .failure("\(input) is odd")}
    return .success(input)
}

echoEvenOrFail(2)
echoEvenOrFail(3)

func halve(_ input: Int) -> Int {
    return input/2
}

echoEvenOrFail(2).map(halve)
echoEvenOrFail(3).map(halve)

let numberDictionary = [1: "one", 2: "two", 3: "three"]

func valueInNumberDictionary(for key: Int) -> Result<String> {
    guard numberDictionary.keys.contains(key) else
        {return .failure("Dictionary has no key: \(key)")}
    return .success(numberDictionary[key]!)
}


echoEvenOrFail(2).flatMap(valueInNumberDictionary)
echoEvenOrFail(3).flatMap(valueInNumberDictionary)
echoEvenOrFail(4).flatMap(valueInNumberDictionary)
