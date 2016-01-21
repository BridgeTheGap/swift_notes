import UIKit

// ** Parameters **

//: 1. Default Parameters
//: Like Python, Swift functions can also have default parameters
func someFunction(defaultParameter: Int = 42) {
    print(defaultParameter)
}

//: 2. Variadic Parameters
//: Variadic parameters are converted to an array within its implementation
func arithmeticMean(count: Int, numbers: Double...) -> Double {
    print(numbers)
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}

//: 3. Variable Parameters
//: Function parameters are constants by default.
//: This behavior can be modified through prefixing the parameter name with "var"
//: This gives a new modifiable copy of the parameter's value.
//: The variable parameter value will not presist beyond the function's scope.

func alignRight(var string: String, totalLength: Int, pad: Character) -> String {
    let amountToPad = totalLength - string.characters.count
    if amountToPad < 1 {
        return string
    }
    let padString = String(pad)
    for _ in 1...amountToPad {
        string = padString + string
    }
    return string
}

let originalString = "hello"
let paddedString = alignRight(originalString, totalLength: 10, pad: "-")

//: 4. In-Out parameters
//: Declare the parameter as an inout parameter to make the modified value persist
//: beyond the scope of the function call.

func swapper(inout a: Int, inout _ b: Int) {
    let tempA = a
    a = b
    b = tempA
}

var x = 1
var y = 42
swapper(&x, &y)
print(x, y)
