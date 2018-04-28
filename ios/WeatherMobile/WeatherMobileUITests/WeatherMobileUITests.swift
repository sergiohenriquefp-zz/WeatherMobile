//
//  WeatherMobileUITests.swift
//  WeatherMobileUITests
//
//  Created by Sergio Freire on 25/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest
@testable import WeatherMobile

class WeatherMobileUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    let cityObj1 = CityObject(id:"1", city:"Campinas", temperature:"26", minTemperature:"20", maxTemperature:"30", humidity:"30%", weatherCondition:"Clear")
    let cityObj2 = CityObject(id:"2", city:"Sao Paulo", temperature:"22", minTemperature:"18", maxTemperature:"24", humidity:"30%", weatherCondition:"Clear")
    let cityObj3 = CityObject(id:"3", city:"Rio de Janeiro", temperature:"30", minTemperature:"26", maxTemperature:"34", humidity:"60%", weatherCondition:"Clear")
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        sleep(2)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSwipeToDelete(){
        let cities = [cityObj1]
        UserDefaults.standard.set(try? PropertyListEncoder().encode(cities), forKey:"userCitiesList")
        
        let tablesQuery = app.tables.cells
        tablesQuery.element(boundBy: 0).swipeLeft()
        tablesQuery.element(boundBy: 0).buttons["Delete"].tap()
        
    }
}
