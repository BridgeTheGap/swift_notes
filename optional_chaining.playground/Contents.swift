// ***************************
// Optional Chaining
// ***************************

//: ** Case study 1 **
class Person {
    var residence: Residence?
}

class Residence {
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address?
}

class Room {
    let name: String
    init(name: String) { self.name = name }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        print("-buildingIdentifier called")
        if buildingName != nil { return buildingName }
        else if buildingNumber != nil && street != nil {
            return "\(buildingNumber) \(street)"
        } else { return nil }
    }
}

let john = Person()
//: Comment/uncomment the following block of code to check optional chaining behavior

//let johnsHouse = Residence()
//johnsHouse.rooms.append(Room(name: "Living room"))
//johnsHouse.rooms.append(Room(name: "Kitchen"))
//john.residence = johnsHouse

let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Rd."

//: This line of code does nothing, since `john.residence` is nil

john.residence?.address = someAddress

if let roomCount = john.residence?.numberOfRooms {
    print("\(roomCount) room(s)")
} else {
    print("no rooms")
}

//: If func is called, it will print to the console
func createAddress() -> Address {
    print("createAdress() called")
    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Rd."
    return someAddress
}

//: The rhs is not evaluated at all, since nothing is printing
//: This is expected since `john.residence` is nil

john.residence?.address = createAddress()

//: The Swift equivalent to -respondsToSelector: is optional chaining function calls
if john.residence?.printNumberOfRooms() != nil {
    print("Success calling printNumberOfRooms()")
} else {
    print("Could not call printNumberOfRooms()")
}

//: Function call actually returns a value of () (a.k.a Void)
if let c = john.residence?.printNumberOfRooms() {
    print("Result of calling printNumberOfRooms(): \(c)")
}

//: The same is true for property setters, like so:
if (john.residence?.address = someAddress) != nil {
    print("Success setting address")
} else {
    print("Could not set address")
}

//: Likewise, setting a property returns a value of Void
if let c = john.residence?.address = someAddress {
    print("Result of setting address: \(c)")
}

//: Question mark for optional chaining comes before the subscript
if let firstRoomName = john.residence?[0].name {
    print("The first room is \(firstRoomName)")
} else {
    print("No first room name")
}

//: Multiple optional chaining doesn't require extra levels of unwrapping
if let street = john.residence?.address?.street {
    print("John lives on \(street)")
} else {
    print("Could not get street")
}

//: The following block of code won't pass through the first if check,
//: if an element in the optional chaining returned nil.
if let prefix = john.residence?.address?.buildingIdentifier()?.hasPrefix("the") {
    if prefix {
        print("The Building ID begins with \"the\"")
    } else {
        print("The Building ID doesn't begin with \"the\"")
    }
} else {
    print("Nil was returned somewhere in the optional chaining")
}

//: ** Case study 2 **
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
print(testScores["Dave"]?[0] = 91)     // 86 -> 91, returns Void
print(testScores["Bev"]?[0]++)         // 79++, returns 79
print(testScores["Brian"]?[0] = 72)    // This does not trigger a compiler error, returns nil
print(testScores)