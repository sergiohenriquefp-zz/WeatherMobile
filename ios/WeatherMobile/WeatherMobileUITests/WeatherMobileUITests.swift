//
//  WeatherMobileUITests.swift
//  WeatherMobileUITests
//
//  Created by Sergio Freire on 25/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest

class WeatherMobileUITests: BaseUITest {
    
    var app: XCUIApplication!
    
    var cityObj1: City?
    var cityObj2: City?
    var cityObj3: City?
    
    override func setUp() {
        super.setUp()
        
        cityObj1 = self.getMockedCity1()
        cityObj2 = self.getMockedCity2()
        cityObj3 = self.getMockedCity3()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func addCityWithName(name:String){
        self.waitAndTapElement(element: app.buttons["btn_add_city"])
        self.waitTapAndTypeElement(element: app.searchFields.firstMatch, text:name)
        self.waitAndTapElement(element: app.tables.cells.firstMatch)
    }
    
    func swipeToDeleteCell(element: XCUIElement) {
        self.waitElement(element: element)
        self.waitElementAndSwipeLeft(element: element)
        self.waitAndTapElement(element: element.buttons["Delete"])
    }
    
    func testAddCity(){
        self.addCityWithName(name: (cityObj1?.name)!)
        self.addCityWithName(name: (cityObj2?.name)!)
        self.addCityWithName(name: (cityObj3?.name)!)
    }
    
    func testSwipeToDelete(){
        
        let firstTableCell = app.tables.firstMatch.cells.firstMatch
        if firstTableCell.waitForExistence(timeout: 10.0){
            swipeToDeleteCell(element: firstTableCell)
        }
        else{
            self.addCityWithName(name: (cityObj1?.name)!)
            swipeToDeleteCell(element: firstTableCell)
        }
    }
    
    func testChangeSorting(){
        self.waitAndTapElement(element: app.buttons["High"])
        self.waitAndTapElement(element: app.buttons["Low"])
        self.waitAndTapElement(element: app.buttons["City"])
    }
    
    func testWasAddingCityButGiveUp(){
        self.waitAndTapElement(element: app.buttons["btn_add_city"])
        self.waitAndTapElement(element: app.buttons["btn_back"])
    }
}
