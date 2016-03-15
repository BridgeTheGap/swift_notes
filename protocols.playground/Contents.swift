//: Protocol

protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case Off, On
    mutating func toggle() {
        switch self {
        case Off: self = On
        case On: self = Off
        }
    }
}

var lightSwitch = OnOffSwitch.Off
lightSwitch.toggle()

//: 1. [Initialization] Protocols can even require initializers like so
protocol SomeProtocol {
    init(someParameter: Int)
}

protocol AnotherProtocol {
    init()
    func printMethod()
}

//: Required initializers can be implemented as either a designated initializer
//: or a convenience initializer. In either case, the initializer should be marked
//: with the keyword "required"

class SomeClass {
    init() {}
}

class SomeSubClass: SomeClass, AnotherProtocol {
    required override init() {}
    func printMethod() { print("This is \(self) we got here!") }
}

//: 2. [Types] Protocols are fully-fledged types.

class YetAnotherClass: AnotherProtocol {
    required init() {}
    func printMethod() { print("This is \(self) we got here!") }
}

//: Two different types can be added to an array because they both
//: conform to AnotherProtocol

var someArray = [AnotherProtocol]()
someArray.append(SomeSubClass())
someArray.append(YetAnotherClass())

//: All objects in this array are guaranteed to have printMethod(),
//: since they all conform to "AnotherProtocol"
for obj in someArray { obj.printMethod() }

//: 3. [Extension + Protocol] An existing type can conform to a protocol through extension.
protocol TextRepresentable {
    var textualDescription: String { get }
}

extension YetAnotherClass: TextRepresentable {
    var textualDescription: String { return "A class named \(self)" }
}

extension SomeSubClass: TextRepresentable {
    var textualDescription: String { return "A class named \(self)" }
}

for obj in someArray {
    // YetAnotherClass conforms to TextRepresentable, so it supports
    // property named textualDescription
    if let yac = obj as? YetAnotherClass {
        print(yac.textualDescription)
    }
    // SomeSubClass and YetAnotherClass both conform to TextRepresentable
    if let tr = obj as? TextRepresentable { print(tr.textualDescription) }
}

//: If for some reason, the type conforms to a protocol, but doesn't adopt it,
//: it can be done through extension like so:
struct Hamster {
    var name: String
    var textualDescription: String { return "A hamster named \(name)" }
}

extension Hamster: TextRepresentable {}

//: 4. [Protocol Inheritance] A protocol can inherit another protocol, much like
//:    class inheritance. A type that conforms to the child protocol must
//:    meet the requirements of its parents also.

protocol PrettyTextRespresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}

//: The following class needs both "textualDescription" AND "prettyTextualDescription"
class StillAnotherClass: PrettyTextRespresentable {
    var textualDescription: String { return "This is \(self)" }
    var prettyTextualDescription: String { return textualDescription+" />_<)/" }
}

//: 5. [Class-Only]
protocol ClassOnly: class, SomeProtocol {}

//: 6. [Protocol Composition] When a parameter is required to conform to multiple protocols at once,
//:    use the protocol composition like so:
protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct Person: Named, Aged {
    var name: String
    var age: Int
}

func wishHappyBirthday(celebrator: protocol<Named, Aged>) {
    print("Happy birthday \(celebrator.name) - you're \(celebrator.age)")
}

wishHappyBirthday(Person(name: "Malcolm", age: 21))

//: 7. [Typecasting] Typecasting works much like that of classes.
struct Dog: Named, Aged {
    var name: String
    var age: Int
}

struct Country: Named {
    var name: String
}

var anotherArray = [Any]()
anotherArray.append(Country(name: "Korea"))
anotherArray.append(Person(name: "Josh", age: 30))
anotherArray.append(Dog(name: "Max", age: 2))

//: 8. [Protocol Extensions] By extending protocols, you can prescribe the behavior
//:    of the protocol instead of leaving it to individual implementation.
extension Named {
    func introduce() -> String { return "Hi, my name is \(name)." }
}

for obj in anotherArray {
    if obj is Named { print("\(obj) has a name") }
    else            { print("\(obj) doesn't have a name") }
    if let aged = obj as? Aged { print(aged.age) }
    else            { print("\(obj) doesn't have an age") }
    if let named = obj as? Named { print(named.introduce()) }
}

//: 9. [Constraints] Protocol extensions can specified about their scope
//:    through the use of where keyword like so:

extension CollectionType where Generator.Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "["+itemsAsText.joinWithSeparator(", ")+"]"
    }
}

let hamsters = [Hamster(name: "Steve"), Hamster(name: "Maurice"), Hamster(name: "Murray"), Hamster(name: "Morgan")]
print(hamsters.textualDescription)