import Foundation

//: 1. Unlike ObjC, sub-properties of a structure property can be set directly,
//:    without having to set the entire property to a new value.
//:    (e.g. in ObjC, the frame property of a view had to be changed entirely.)
struct Resolution {
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

let someVideoMode = VideoMode()
someVideoMode.resolution.width = 1280


//: CASE 1
typealias ClassClosure = ClassRange -> ClassRange

class ClassRange {
    var firstValue: Int
    var length: Int
    var clones: [ClassRange]
    
    init(firstValue: Int, length: Int) {
        self.firstValue = firstValue
        self.length = length
        clones = []
    }
    
    func clone() -> (clone: ClassRange, closure: ClassClosure) {
        let addClone: ClassClosure = { closure in
            self.clones.append(closure)
            return self
        }
        return (self, addClone)
    }
    
    func resetFirstValue() {
        firstValue = 0
    }
    
    func printClass() {
        print("\(self)(firstValue: \(self.firstValue), length: \(self.length), clones: \(self.clones)")
    }
}

let cRange = ClassRange(firstValue: 2, length: 2)
var cTuples = cRange.clone()
cRange.firstValue = 4

let clonedCRange = cTuples.clone
clonedCRange.firstValue = 6

cTuples.closure(clonedCRange).printClass()

print("range: ", terminator:"")
cRange.printClass()
cRange.resetFirstValue()

cRange.clones.first!.printClass()

print("range: ", terminator:"")
clonedCRange.printClass()
print("clonedClassRange: ", terminator:"")
clonedCRange.printClass()

if cRange === cRange.clones.first! {
    print("!! cRange and instance in cRange clones are the same")
}
if cRange === clonedCRange {
    print("!! cRange and clonedCRange are the same")
}

print("*******************")

typealias MutatingClosure = StructRange -> StructRange

struct StructRange {
    var firstValue: Int
    var length: Int
    var clones: [StructRange]
    
    init(firstValue: Int, length: Int) {
        self.firstValue = firstValue
        self.length = length
        clones = []
    }
    
    mutating func clone() -> (clone: StructRange, closure: MutatingClosure) {
        let addClone: MutatingClosure = { inputRange in
            self.clones.append(inputRange)
            return self
        }
        return (self, addClone)
    }
    
    mutating func resetFirstValue() {
        firstValue = 0
    }
    
    mutating func mutator() -> ()->() {
        return {
            self.firstValue = 0
        }
    }
    
    mutating func appender(object: StructRange) {
        self.clones.append(object)
    }
}

var sRange = StructRange(firstValue: 2, length: 2)
var tuples = sRange.clone()
sRange.firstValue = 4

var clonedSRange = tuples.clone
clonedSRange.firstValue = 6

print(tuples.closure(clonedSRange))

print("sRange: \(sRange)")
sRange.resetFirstValue()

print("sRange: \(sRange)")
print("clonedSRange: \(clonedSRange)")


// Summary:
//
// Since classes are reference types, and clone() doesn't return a copy,
// all three variables refer to the same instance.
//
// However, the struct displays an interesting behavior, which is
// when mutating self, it preserves the change, but when passed inside a closure,
// a copy of self resides in the closure, and as a result,
// any mutation within the closure is lost.

//: Case 2
enum CarClass {
    case Economy, Family, Sedan, Luxury, Sports, OffRoader, Commercial
}

struct Struct {
    let car: Car
    var number: Int
}

class Car {
    let seats: Int
    let classification: CarClass
    var passengers: Int
    
    init(seats: Int = 5, classification: CarClass = .Sedan, passengers: Int = 4) {
        self.seats = seats
        self.classification = classification
        self.passengers = passengers
    }
}

let someStruct = Struct(car: Car(), number: 5)
someStruct.car.passengers = 5

// When a structure's property is a reference type,
// it is allowed to mutate the reference type property even when the instance is a constant.


//: USAGE
// Structs are used when the internal values are not likely to change much

struct Point {
    var x = 0.0, y = 0.0
}

struct Size {
    var width = 0.0, height = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width/2)
            let centerY = origin.y + (size.height/2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width/2)
            origin.y = newCenter.y - (size.height/2)
        }
    }
}

var square = Rect(origin: Point(x: 0.0, y: 0.0), size: Size(width: 10.0, height: 10.0))
var initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")


struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width/2)
            let centerY = origin.y + (size.height/2)
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width/2)
            origin.y = newValue.y - (size.height/2)
        }
    }
}





