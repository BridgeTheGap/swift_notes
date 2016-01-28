class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
    }
}

class Bicycle: Vehicle {
    var hasBasket = false
}

class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}


let tandem = Tandem()
tandem.hasBasket = true

class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}


let train = Train()
train.makeNoise()

//: 1. Any inherited property can be overridden. However, an inherited read-write property cannot be presented as a read-only property.

class Car: Vehicle {
    var gear = 1
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
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 20.0) + 1
        }
    }
}

let automatic = AutomaticCar()
print(automatic.maxSpeed)

//: 2. Prevent override by marking a method, property, or subscript as "final".
