// **************************************
// Inheritance
// **************************************

class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    var storedProperty = "This is a stored property"
    var computedProperty: String {
        set {
            storedProperty = newValue
        }
        get {
            return storedProperty
        }
    }

    func makeNoise() {
    }
}

// Subclasses can add their own properties, methods, subscripts
class Bicycle: Vehicle {
    var hasBasket = false
}

// If subclass wants to provide their own version of a property, method, or subscript, add `override` modifier
class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}

let train = Train()
train.makeNoise()

//: 1. Any inherited property can be overridden.
class Car: Vehicle {
    var gear = 1

    //: A read-only can be overwritten to become a read-write property, but not vice versa.
    //: i.e. an inherited read-write property cannot be presented as a read-only property.
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: \(car.description)")

class AutomaticCar: Car {
    var maxGear = 7
    var maxSpeed: Double {
        get {
            return Double(maxGear) * 20.0
        }
    }
    //: Observers can be added as you override.
    //: However, you can't provide both custom setter and observer.
    //: Use custom setter as observer if need arises.
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 20.0) + 1
        }
    }
    //: A stored property can be a overridden to become a computed property, but not vice versa.
    //: i.e. a computed property cannot be overwritten as a stored property.
    override var storedProperty: String {
        set {
            super.storedProperty = newValue
        }
        get {
            return super.storedProperty+", which is now a computed property"
        }
    }
}

let automatic = AutomaticCar()
print(automatic.maxSpeed)
print(automatic.storedProperty)

//: 2. Prevent override by marking a method, property, or subscript as "final".
