//: Extensions in Swift has a much broader scope than its counterpart in ObjC
//: Extensions in Swift can:
//:     - Add computed properties
//:     - Provide new initializers
//:     - Define subscripts
//:     - Make an existing type conform to a protocol
//: * Extensions can add new functionality but can't override existing ones.

//: 1. Computed properties
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}

let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
let threeFeet = 3.ft
print("Three feet is \(threeFeet) meters")

//: 2. Initializers
struct Size {
    var width = 0.0, height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
}

extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

//: 3. Methods
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0 ..< self {
            task()
        }
    }
}

3.repetitions({ print("Hello!") })
3.repetitions { print("Goodbye!") }

extension Int {
    mutating func square() { self = self * self }
}

var someInt = 3
someInt.square()
print(someInt)

//: 4. Subscripts

extension Int {
    subscript(digitIndex: Int) -> Int {
        var digitIndex = digitIndex
        var decimalBase = 1
        while digitIndex > 0 {
            decimalBase *= 10
            digitIndex -= 1
        }
        return (self / decimalBase) % 10
    }
}

print(746381295[0])
print(746381295[1])
print(746381295[2])
print(746381295[8])

print(746381295[9])

//: 5. Nested types
extension Int {
    enum Kind { case Negative, Zero, Positive }
    var kind: Kind {
        switch self {
        case 0: return .Zero
        case let x where x > 0: return .Positive
        default: return .Negative
        }
    }
}

func printIntegerKinds(numbers: [Int]) {
    for n in numbers {
        switch n.kind {
        case .Negative: print("- ", terminator: "")
        case .Zero:     print("0 ", terminator: "")
        case .Positive: print("+ ", terminator: "")
        }
    }
    print("")
}

printIntegerKinds([3, 9, -27, 0, -6, 0, 7])

//: If a type already has all the specifications of a protocol,
//: the type can conform to a protocol through empty implementation
