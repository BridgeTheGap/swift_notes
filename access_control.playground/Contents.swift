// ==============
// Access Control
// ==============

import UIKit

//: 1. The default access level is internal

//: 2. Accessors can have more restriction for setters by using the `private(set)` keyword

struct TrackedString {
    // `numberOfEdits` can only be modified within the source file
    // However, this property can be set upon initialization if no custom initializers are declared
    private(set) var numberOfEdits = 0
    var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
    
    // By declaring a custom initializer, default member-wise initializers can be made unavailable
    init() {}
}
