//
//  testPartTwo.swift
//  SimpleDomainModelTests
//
//  Created by Kelley Lu Chen on 10/19/17.
//  Copyright © 2017 Ted Neward. All rights reserved.
//

import XCTest
import SimpleDomainModel

class testPartTwo: XCTestCase {

    let tenUSD = Money(amount: 10, currency: "USD")
    let twelveUSD = Money(amount: 12, currency: "USD")
    let fiveGBP = Money(amount: 5, currency: "GBP")
    let fifteenEUR = Money(amount: 15, currency: "EUR")
    let fifteenCAN = Money(amount: 15, currency: "CAN")
    
    func testMoneyDesc() {
        XCTAssert(tenUSD.description == "USD10")
        XCTAssert(fifteenCAN.description == "CAN15")
    }
    
    func testJobDesc() {
        let job = Job(title: "TA", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.description == "The job title is TA paid 15.0 per hour")
    }
    
    

    func testPersonDesc() {
        let kelley = Person(firstName: "Kelley", lastName: "Chen", age: 20)
        XCTAssert(kelley.description == "Kelley, Chen age: 20")
    }

    func testProtocolAddUSDToUSD() {
        XCTAssert(tenUSD.amount == 10 && tenUSD.currency == "USD")
        XCTAssert(twelveUSD.amount == 12 && twelveUSD.currency == "USD")
        
        let result = tenUSD.add(twelveUSD) // --> 25GBP
        XCTAssert(result.amount == 22 && result.currency == "USD")
    }
    
    func testProtocolAddUSDtoElse () {
        let result = tenUSD.add(fifteenCAN)
        XCTAssert(result.amount == 27 && result.currency == "CAN")
    }
    
    func testProtocolSubtractUSDToUSD () {
        let result = tenUSD.subtract(twelveUSD)
        XCTAssert(result.amount == 2 && result.currency == "USD")
    }
    
    func testProtocolSubtractUSDToElse () {
        let fiveCAN = Money(amount: 5, currency: "CAN")

        let result = fiveCAN.subtract(fifteenEUR)
        XCTAssert(result.amount == 9 && result.currency == "EUR")
    }
}
