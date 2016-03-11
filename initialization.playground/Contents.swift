// *************************************
// Initialization
// *************************************

//: 1. Structures
//: Structs get a default init and a memberwise init by default if it has default values for all properties
struct Point {
    var x = 0.0, y = 0.0
}

struct Size {
    var width = 0.0, height = 0.0
}

struct Rect {
    var origin = Point(), size = Size()
}

//: This behavior will be overridden if you implement a custom initializer
//: To keep the default inits, use extension
extension Rect {
    init(center: Point, size: Size) {
        origin.x = center.x - size.width/2.0
        origin.y = center.y - size.height/2.0
        self.size = size
    }
}

print(Rect())
print(Rect(origin: Point(x: 1, y: 1), size: Size(width: 1, height: 1)))
print(Rect(center: Point(x: 0.5, y: 0.5), size: Size(width: 1, height: 1)))

//: Default values include optionals and implicitly unwrapped optionals
//: Optionals will initialize to nil
struct SimpleStruct {
    var string: String?
    var int: Int!
    
    // : The following line will cause compiler error, but only for default init
    // : Memberwise init will work as long as a value for double is provided
    //    var double: Double
}

print(SimpleStruct())
print(SimpleStruct(string: "This is a string", int: 80))

//: 2. Class
//: Classes are also provided with a default initializer if default values are set for all properties
class SimpleClass {
    var string: String?
    var int: Int?
}

let s = SimpleClass()
print(s.int, s.string)

//: 2-1. Designated init
//: A subclass can only call the designated init of its superclass
//: Convenience inits should eventually call the designated init for its class

//: 2-2. Two-phase init
//: a. A class should have all its properities initialized before calling `super.init()`.
//: b. Assign values to inherited properties after calling `super.init()`.
//:    Inherited properties will be assigned their default values at their level of init.
//:    Any values assigned prior will be overwritten at the superclass level.
//: c. Convenience inits should assign value after calling the designated init at their level.
//:    Any values assigned prior will be overwritten during initialization.
//:    (This is usually not a problem since values should be passed to the designated inits as parameters.)
//: d. Until the first phase of initialization is finished, no instance methods or properties can be accessed.
//:    (For obvious reasons: the instance hasn't been initialized yet)

//: Case study 1
class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}

//: Since all properties are assigned a value, Vehicle automatically can use the default init
let v = Vehicle()

class Bicycle: Vehicle {
    //: init() has the same parameters as the designated init of its superclass.
    //: Mark the initializer with `override` modifier.
    override init() {
        //: numberOfWheels is an inherited property.
        //: Must call super.init() before custom setting
        super.init()
        numberOfWheels = 2
    }
}

let b = Bicycle()
print("Bicycle: \(b.description)")

//: Case study 2
class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    //: Since Food's designated init is overridden, RecipeIngrdient inherits Food's convenience initializers as well
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

//: Although this was never a part of RecipeIngredient's implementation,
//: as per rule, this initializer is inherited. (Look at line 116)
let mysteryItem = RecipeIngredient()

class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}

var breakfastList = [
    ShoppingListItem(),
    ShoppingListItem(name: "Bacon"),
    ShoppingListItem(name: "Eggs", quantity: 6),
]
breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}

//: Case study 3
//: Within the initializer, once all properties are assigned a value,
//: the instance finishes Phase 1 initialization.
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        //: The following line displays a compiler error,
        //: since self.name hasn't been given an initial value.
        //: (Still Phase 1)
        // print(self)
        self.name = name
        //: However, after self.name has been given an initial value, self can be used.
        //: (Now Phase 2)
        print(self)
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}

var c = Country(name: "Korea", capitalName: "Seoul")
print(c.capitalCity.name, c.name)

//: 3. Failable initializers
struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty { return nil }
        self.species = species
    }
}

let emptyString = ""
let noString: String? = nil

//: For classes, you can fail only after initializing has been done.
class Product {
    var name: String!
    init?(name: String) {
        self.name = name
        if name.isEmpty { return nil }
    }
}

//: 4. Overriding failable initializers
//: You can override a failable initializer with a non-failable init but not vice versa.
class Document {
    var name: String?
    init() {}
    init?(name: String) {
        self.name = name
        if name.isEmpty { return nil }
    }
}

class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        name = "[Untitled]"
    }
    override init(name: String) {
        if name.isEmpty {
            super.init(name: "[Untitled]")!
        } else {
            super.init(name: name)!
        }
    }
}

let d = AutomaticallyNamedDocument(name: "")
