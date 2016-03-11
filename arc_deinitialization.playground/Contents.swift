// *******************************
// ARC and deinit
// *******************************

//: 1. Avoid strong reference cycles by using `weak` or `unowned`
//:     a. Use `weak` when the reference will become nil at some point
//:     b. Use `unowned` when the reference will never become nil

class Person {
    let name: String
    var apartment: Apartment?
    
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    convenience init() { self.init(name: "No name") }
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Person?
var unit4A: Apartment?

john = Person()
unit4A = Apartment(unit: "4A")

john?.apartment = unit4A
unit4A?.tenant = john

john = nil
unit4A = nil

//: 2. Unowned example

//: Use when the reference will never become nil (can be deinitialized)
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

var jane: Customer?
jane = Customer(name: "Jane Appleseed")
jane!.card = CreditCard(number: 1234_5678_9012_3456, customer: jane!)
jane = nil

//: 3. In a co-dependent state, where two objects won't be destroyed,
//: using optionals results in extra unwrapping process.
//: Since two objects are dependent on each other for initialization,
//: however, one of the objects needs to be assigned nil at init time.
//: This problem can be solved by using implicitly unwrapped optionals.

class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

//: Avoid reference cycles using `unowned` modifier.

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

//: 4. Closures

class HTMLElement {
    let name: String
    let text: String?
    lazy var asHTML: () -> String = {
        //: Capture list
//        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }

    //: Providing an initial value in an initializer is, in effect,
    //: similar to implementing another initializer without that value
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

var heading: HTMLElement? = HTMLElement(name: "h1")
let defaultText = "some default text"

//: In this case, a strong reference cycle isn't made, since the original
//: closure property that would otherwise form a reference cycle has been
//: replaced by the next stub of code.

heading!.asHTML = { "<\(heading!.name)>\(heading!.text ?? defaultText)</\(heading!.name)>" }
print(heading!.asHTML())
heading = nil

//: The following case maintains the original closure property,
//: which does form a strong reference cycle

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
paragraph = nil