//: 1. Stored type properties are lazily initialized on their first access.

//: 2. Stored type properties are guaranteed to be initialized only once, even when accessed by multiple threads simultaneously.
class SingletonClass {
    static let sharedClass = SingletonClass()
}

//: 3. Stored type properties need a default value, since the type doesn't have an initializer to assign a value to that type property

//: 4. Enum, struct, classes can all have a type property, defined with the prefix "static". In case of classes, computed properties can be overridden by prefixing the property with "class".

//: ** Example **
enum CrudeRace {
    case White, Black, Asian
}

class Person {
    static var totalPopulation = 0
    static var populationByRace: [CrudeRace: Int] = [.White: 0, .Black: 0, .Asian: 0]
    
    class var totalAsians: Int {
        set {
            populationByRace[.Asian]! += newValue
        }
        get {
            return populationByRace[.Asian]!
        }
    }
    
    let race: CrudeRace
    
    init(race: CrudeRace) {
        self.race = race
        ++Person.totalPopulation
        Person.populationByRace[race]! += 1
        print("A new life. Now \(Person.totalPopulation) living on earth")
    }
    
    deinit {
        --Person.totalPopulation
        print("The end of a life. Now \(Person.totalPopulation) remains")
    }
}

var a: Person? = Person.init(race: .Asian)
var b: Person? = Person.init(race: .Asian)
var c: Person? = Person.init(race: .Black)
var d: Person? = Person.init(race: .White)

print(Person.totalAsians)

a = nil

//: ** Question **
//: 1. What is the difference between a computed property and a function?
//: 2. Why can't lazy properties have observers?
