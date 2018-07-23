extension String: Error{}

func echoEvenOrThrow(_ input: Int) throws -> Int {
    guard input.isEven else { throw "\(input) is odd"}
    return input
}

func echoEvenOrNil(_ input: Int) -> Opt<Int> {
    guard input.isEven else { return Opt()}
    return Opt(input)
}


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
