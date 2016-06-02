
//: [GENERICS]

//: 1. Generic functions
func swapTwoValues<T>(inout a: T, inout b: T) {
    let tempA = a
    a = b
    b = tempA
}

var intA = 3
var intB = 42
swapTwoValues(&intA, b: &intB)
print(intA, intB)

var stringA = "hello"
var stringB = "world"
swapTwoValues(&stringA, b: &stringB)
print(stringA, stringB)

//: 2. Type Parameter
//: Type parameters are written immediately after the function's name, like so: <T>

//: 3. Generic Types

struct Stack<Element> {
    var items = [Element]()
    mutating func push(item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

//: 4. When extending generic types, you don't proved a type parameter list
//:    as part of the extension definition, but use the original type definition.

extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count-1]
    }
}

//: 5. Type Constraint Syntax
class SomeClass {}
protocol SomeProtocol {}
struct SomeStruct {}
enum SomeEnum {}

//: Structures cannot be used in this case
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
    
}

//: Generic type should conform to a Equatable in order to make use of `==` operator.
func findIndex<T: Equatable>(array: [T], _ valueToFind: T) -> Int? {
    for (index, value) in array.enumerate() {
        if value == valueToFind { return index }
    }
    return nil
}

//: 6. Associated Types
//: A protocol can provide a placeholder name to a type that is used as part of the protocol.
//: When adopting a protocol, the associated types should be specified.
//: (Basically, associated types are similar in that they are placeholders
//: for the protocol. Since protocols are guidelines, it's not possible to declare
//: generic protocols, hence the usage of associatedtypes)

protocol Container {
    associatedtype ItemType
    mutating func append(item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}

//: Implementing for specific type goes like so:

struct IntStack: Container {
    typealias ItemType = Int    // This line can be omitted.
    var items = [Int]()
    mutating func push(item: Int) { items.append(item) }
    mutating func pop() -> Int { return items.removeLast() }
    mutating func append(item: Int) { self.push(item) }
    var count: Int { return items.count }
    subscript(i: Int) -> Int { return items[i] }
}

//: Since the associatedtype can be inferred, protocols can be conformed to
//: as long as the implementation conforms to the protocol with any one type.
//: This allows the protocol to be conformed by generic types
//: Implementing for generic type is also available by omitting typealias:

extension Stack: Container {
    mutating func append(item: Element) { self.push(item) }
    var count: Int { return items.count }
    subscript(i: Int) -> Element { return items[i] }
}

//: 7. Associated Type Requirements via where clause
//: Requirements for associated types are defined as part of a type parameter list.
//: In the where clause, the associated type can either by required to
//: conform to a protocol or be of a specific type.

//: The `where` clause should be placed immediately after the list of type paramters,
//: followed by constraints (e.g. Element: Comparable)
//: or equality relationships (e.g. Element == String).

func allItemsMatch<C1: Container, C2: Container where C1.ItemType == C2.ItemType, C1.ItemType: Equatable>(someContainer: C1, _ anotherContainer: C2) -> Bool {
    if someContainer.count != anotherContainer.count { return false }
    
    for i in 0 ..< someContainer.count {
        if someContainer[i] != anotherContainer[i] { return false }
    }
    
    return true
}


