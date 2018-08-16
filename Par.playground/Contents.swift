let ints = Array(1...10)





func sum1(_ ints: [Int]) -> Int {
    return ints.reduce(0, +)
}

sum1(ints)

func sum2(_ ints: [Int]) -> Int {
    let splitPoint = ints.count/2
    switch splitPoint {
    case 0:
        return ints[0]
    case 1:
        return ints[0] + sum2(Array(ints[splitPoint...]))
    default:
        return sum2(Array(ints[...(splitPoint-1)])) + sum2(Array(ints[splitPoint...]))
    }
}

sum2(ints)
