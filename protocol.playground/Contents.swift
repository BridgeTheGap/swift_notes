import Foundation

protocol ExampleProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "Simple class"
    func adjust() {
        simpleDescription = "Simple " + simpleDescription
    }
}

struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "Simple structure"
    mutating func adjust() {
        simpleDescription += "YUP"
    }
}

enum SimpleEnum: ExampleProtocol {
    case First
    case Second
    var simpleDescription: String {
        return "Simple enumeration"
    }
    mutating func adjust() {
        self = SimpleEnum.Second
    }
}

var a = SimpleEnum.First
print(a)
print(a.simpleDescription)
a.adjust()
print(a, a.simpleDescription)


enum TriStateSwitch {
    case Off, Low, High
    mutating func next() {
        switch self {
        case Off:
            self = Low
        case Low:
            self = High
        case High:
            self = Off
        }
    }
}

var aSwitch = TriStateSwitch.Low
aSwitch.next()
aSwitch.next()


