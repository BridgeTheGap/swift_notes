//: Playground - noun: a place where people can play

import UIKit

var number: Int = 3 {
didSet {
    print("Number has been changed from \(oldValue) to \(number)")
}
}

var alwaysBigger: Int {
get {
    return ++number
}
}

number = 5
print("Printing alwaysBigger \(alwaysBigger)")