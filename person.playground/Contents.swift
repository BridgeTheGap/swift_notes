import UIKit

extension NSDateComponents {
    convenience init(year: Int, month: Int, day: Int) {
        self.init()
        
        self.year = year
        self.month = month
        self.day = day
    }
}

extension NSDate {
    class func date(year: Int, month: Int, day: Int) -> Self {
        return dateHelper(year, month: month, day: day)
    }
    private class func dateHelper<T>(year:Int, month: Int, day: Int) -> T {
        let cal = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        return cal!.dateFromComponents(NSDateComponents.init(year: year, month: month, day: day)) as! T
    }
}


enum Gender {
    case Male
    case Female
}

class Person {
    static var numberOfPeople: Int = 0
    var parents: [Person]?
    var name: String
    let gender: Gender?
    let birthday: NSDate
    var age: Int {
        get {
            let cal = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
            ++totalCount
            return cal!.components(.Year, fromDate: birthday, toDate: NSDate(), options: .WrapComponents).year
        }
    }
    var hairColor: UIColor = UIColor.blackColor() {
        willSet {
            print("\(name) is going to dye \(pronoun) hair.")
        }
        didSet {
            print("\(name) dyed \(pronoun) hair.")
        }
    }
    var totalCount: Int = 0 {
        didSet {
            let times = totalCount == 1 ? "time" : "times"
            print("People have asked \(name)'s age \(totalCount) \(times)")
        }
    }
    var pronoun: String {
        get {
            return gender! == .Male ? "his" : "her"
        }
    }
    
    init(gender: Gender, name: String, birthday: NSDate) {
        ++Person.numberOfPeople
        self.name = name
        self.birthday = birthday
        self.gender = gender
        self.parents = []
        
        print("\(self.name) is born.")
        print(Person.getPopulation())
    }
    
    class func getPopulation() -> String {
        let person = numberOfPeople == 1 ? "person" : "people"
        return "There are \(numberOfPeople) \(person) in this world."
    }
    
    func dyeHair(color: UIColor) {
        hairColor = color
    }
    
    func askBirthday() -> String {
        return "My birthday is \(birthday)"
    }
    
    func procreate(other: Person, name: String, birthday: NSDate) -> Person {
        let randomNumber = rand()%2
        let gender: Gender = randomNumber == 0 ? .Male : .Female
        let child = Person.init(gender: gender, name: name, birthday: birthday)
        child.parents = [self, other]
        
        return child
    }
    
    func getParentsName() -> [String] {
        if let p = parents {
            return [p[0].name, p[1].name]
        } else {
            return []
        }
    }
}

class Asian: Person {
    override init(gender: Gender, name: String, birthday: NSDate) {
        super.init(gender: gender, name: name, birthday: birthday)
        hairColor = UIColor.blackColor()
    }
}

let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
let dateComponents = NSDateComponents.init(year: 1985, month: 11, day: 8)
let birthday = calendar?.dateFromComponents(dateComponents)
let person_A = Person(gender:.Male, name: "Josh", birthday: birthday!)

print("\(person_A.name) is \(person_A.age) years old.")
print("\(person_A.age)")

person_A.dyeHair(UIColor.brownColor())

let asian_A = Asian(gender: .Female, name: "Minji", birthday: NSDate.date(1987, month: 11, day: 4))
print(asian_A.askBirthday())

let asian_B = Asian(gender: .Male, name: "Minsu", birthday: NSDate.date(1985, month: 11, day: 8))
let asian_C = asian_A.procreate(asian_B, name: "Suji", birthday: NSDate.date(2015, month: 9, day: 8))

let cParents = asian_C.getParentsName()
print("\(asian_C.name)'s parents are \(cParents.first!) and \(cParents.last!)")
