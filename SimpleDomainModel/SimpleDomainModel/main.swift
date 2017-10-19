//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

protocol CostumStringConvertible {
    var description: String { get }
}

protocol Mathematics {
    func add (_: Money) -> Money
    func subtract(_: Money) -> Money
}

extension Double {
    var USD: Money {
        return Money(amount: Int(self), currency: "USD")
    }
    
    var EUR: Money {
        return Money(amount: Int(self), currency: "EUR")
    }
    
    var GBP: Money {
        return Money(amount: Int(self), currency: "GBP")
    }
    
    var CAN: Money {
        return Money(amount: Int(self), currency: "CAN")
    }
}

////////////////////////////////////
// Money
//
public struct Money: CustomStringConvertible, Mathematics {
    public var amount : Int
    public var currency : String
    
    public var description: String {
        get {
            return currency + String(amount)
        }
    }
    
    public func convert(_ to: String) -> Money {
        var convertedAmt: Int?
        let convertedCurr: String? = to
        if (to == "GBP") {
            if (self.currency == "USD") {
                convertedAmt = (self.amount * 50) / 100
            } else if (self.currency == "EUR") {
                convertedAmt = (self.amount * 33) / 100
            } else if (self.currency == "CAN") {
                convertedAmt = (self.amount * 40) / 100
            } else {
                convertedAmt = nil
            }
        } else if (to == "EUR") {
            if (self.currency == "USD") {
                convertedAmt = (self.amount * 150) / 100
            } else if (self.currency == "GBP") {
                convertedAmt = (self.amount * 300) / 100
            } else if (self.currency == "CAN") {
                convertedAmt = (self.amount * 120) / 100
            } else {
                convertedAmt = nil
            }
        } else if (to == "USD"){
            if (self.currency == "GBP") {
                convertedAmt = (self.amount * 200) / 100
            } else if (self.currency == "EUR") {
                convertedAmt = (self.amount * 67) / 100
            } else if (self.currency == "CAN") {
                convertedAmt = (self.amount * 80) / 100
            } else {
                convertedAmt = nil
            }
        } else if (to == "CAN"){
            if (self.currency == "USD") {
                convertedAmt = (self.amount * 125) / 100
            } else if (self.currency == "EUR") {
                convertedAmt = (self.amount * 83) / 100
            } else if (self.currency == "GBP") {
                convertedAmt = (self.amount * 225) / 100
            } else {
                convertedAmt = nil
            }
        }
        if (convertedAmt == nil || convertedCurr == nil) {
            return Money(amount: 0, currency: "")
        } else {
            return Money(amount: convertedAmt!, currency: convertedCurr!)
        }
    }
    
    public func add(_ to: Money) -> Money {
        var added: Int
        if (self.currency != to.currency) {
            let converted = self.convert(to.currency)
            added = converted.amount + to.amount
        } else {
            added = self.amount + to.amount
        }
        return Money(amount: added, currency: to.currency)
    }
    
    public func subtract(_ from: Money) -> Money {
        var subtracted: Int
        if (self.currency != from.currency) {
            let converted = self.convert(from.currency)
            subtracted = from.amount - converted.amount
        } else {
            subtracted = from.amount - self.amount
        }
        return Money(amount: subtracted, currency: from.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job: CustomStringConvertible{
    fileprivate var title : String
    fileprivate var type : JobType
    
    public var description: String {
        get {
            var res = "The job title is \(title)"
            switch type {
            case .Hourly(let amt):
                res += " paid \(amt) per hour"
            case .Salary (let amt):
                res += " paid \(amt) per year"
            }
            return res
        }
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let hourSal):
            return Int(Double(hours) * hourSal)
        case .Salary(let yearSal):
            return yearSal
        }
    }
    
    open func raise(_ amt : Double) {
        switch self.type {
        case .Hourly(let hourSal):
            self.type = JobType.Hourly(hourSal + amt)
        case .Salary(let yearSal):
            self.type = JobType.Salary(Int(amt) + yearSal)
        }
    }
}


////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    public var description: String {
        get {
            return "\(firstName), \(lastName) age: \(age)"
        }
    }
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            return _job
        }
        set(value) {
            if (age >= 16) {
                self._job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            return _spouse
        }
        set(value) {
            if (self.age >= 18) {
                self._spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public var description: String {
        get {
            var result = "Members:"
            if (members.count > 1) {
                for person in members {
                    result += "\(person) "
                }
            } else {
                return "No family members"
            }
            return result
        }
    }
    public init(spouse1: Person, spouse2: Person) {
        if (spouse1.spouse == nil && spouse2.spouse == nil && spouse1.age >= 18 && spouse2.age >= 18) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
    }
    
    open func haveChild(_ child: Person) -> Bool {
        var canHave = false
        for person in members {
            if (person.age >= 21) {
                canHave = true
                break
            }
        }
        if (canHave) {
            members.append(child)
        }
        return canHave
    }
    
    open func householdIncome() -> Int {
        var total = 0
        for human in members {
            if (human.job != nil) {
                total += (human.job?.calculateIncome(2000))!
            }
        }
        return total
    }
}






