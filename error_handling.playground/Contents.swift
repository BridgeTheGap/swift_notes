import UIKit

enum VendingMachineError: ErrorType {
    case InvalidSelection
    case InsufficientFunds(coinsNeeded: Int)
    case OutOfStock
}

//: Example of exception throwing
//throw VendingMachineError.InsufficientFunds(coinsNeeded: 5)

//: 1. [Propagating errors using throwing functions]
//:    Error handling is done in the scope where the function is called.
//:    At the point where the error throwing function is called,
//:    the error could either be handled directly through a do-catch statement,
//:    or it could be propagated up yet again.

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0
    func dispenseSnack(snack: String) {
        print("Dispensing \(snack)")
    }
    
    func vend(itemNamed name: String) throws {
        // Ensuring preconditions are met
        // Early exception throwing before computing data
        guard var item = inventory[name] else {
            throw VendingMachineError.InvalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.OutOfStock
        }
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.InsufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        item.count -= 1
        inventory[name] = item
        dispenseSnack(name)
    }
}

let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]

//: buyFavoriteSnack(_:vendingMachine:) is an example of a propagating function.
//: Within the function itself, there is now throwing function, but since
//: vend(itemNamed:) throws an error, it should be marked with "throws"
//: and calling vend(itemNamed:) requires a try keyword
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
}

//: 2. [Handling errors using do-catch]
//:    This is one way to handle errors directly.
//:    If an error is thrown inside the do clause, the error will be matched
//:    against the catch clauses.
//:    If the error has no matching cases, it will propagagte
//:    to the surrounding scope.

var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8

do {
    try buyFavoriteSnack("Alice", vendingMachine: vendingMachine)
} catch VendingMachineError.InvalidSelection {
    print("Invalid selection.")
} catch VendingMachineError.OutOfStock {
    print("Out of stock.")
} catch VendingMachineError.InsufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
}


//: 3. Converting errors to optional values

func someThrowingFunction(n: Int) throws -> Int {
    return n
}

//: By using try?, x is assigned nil if an error is thrown.
//: Otherwise, x will be assigned a value.
//: y is just a more descriptive version of what happens to x.
//: Since x and y both have the possibility of being assigned nil,
//: the value assigned to x and y will be an optional type.

let x = try? someThrowingFunction(3)

let y: Int?
do {
    y = try someThrowingFunction(3)
} catch {
    y = nil
}

//: The "try?" keyword allows for a concise error handling like so:
func fetchInt() -> Int? {
    if let i = try? someThrowingFunction(3) { return i }
    if let i = try? someThrowingFunction(5) { return i }
    return nil
}

//: 4. Disabling error propagation
//:    When calling a function that throws, but it is ensured at compile time,
//:    that no error will be thrown, "try!" keyword will allow the function
//:    to run without any error handling.
let someInt = try! someThrowingFunction(5)

//: 5. Defer
//:    The code enclosed within the defer keyword is executed just before
//:    code execution these the current scope, where it is leaving by
//:    error throwing or by reaching the end of code block.
//:    This is particularly useful when a code needs a corresponding function,
//:    such as NSNotificationCenter removing an observer.

func processFile(filename: String) throws {
    func exists(fileName: String) -> Bool {
        // Some way to ensure file name is present
        return true
    }
    
    func open(fileName: String) -> AnyObject { return 1 }
    func close(file: AnyObject) { }
    func someFunction() throws -> Int? { return 1 }
    
    if exists(filename) {
        let file = open(filename)
        defer {
            close(file)
        }
        while let _ = try someFunction() {
            // Work with the file
        }
        // Close(file) is called here at the end of the scope.
    }
}
