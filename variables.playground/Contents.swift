//: 1. Variables can also have observers
var number: Int = 3 {
didSet {
    print("Number has been changed from \(oldValue) to \(number)")
}
}

//: 2. It is possible to have a computed variable
var alwaysBigger: Int {
get {
    return number+1
}
}

number = 5
print("Printing alwaysBigger \(alwaysBigger)")