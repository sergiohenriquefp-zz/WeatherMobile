//
//  BaseUITest.swift
//  WeatherMobileUITests
//
//  Created by Sergio Freire on 29/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest

class BaseUITest: XCTestCase {
        
    //Campinas
    func getMockedCity1() -> City?{
        return getMockedCity(filename: "city1")
    }
    
    //Sao Paulo
    func getMockedCity2() -> City?{
        return getMockedCity(filename: "city2")
    }
    
    //Rio de Janeiro
    func getMockedCity3() -> City?{
        return getMockedCity(filename: "city3")
    }
    
    func getMockedCity(filename fileName: String) -> City?{
        
        if let parsedCity = self.loadJson(filename: fileName){
            return parsedCity
        }
        
        return nil
    }
    
    func getJsonData(filename fileName: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        if let url = testBundle.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch {
            }
        }
        return nil
    }
    
    func loadJson(filename fileName: String) -> City? {
        
        if let data = getJsonData(filename: fileName){
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(City.self, from: data)
                return jsonData
            } catch {
            }
        }
        
        return nil
    }
    
    //Tests Utils
    func waitElement(element: XCUIElement) {
        if element.waitForExistence(timeout: 10.0){
            
        }
    }
    
    func waitPickerAndSwipeElement(picker:XCUIElement, element: XCUIElement) {
        if picker.waitForExistence(timeout: 10.0){
            element.swipeDown()
        }
    }
    
    func waitElementAndSwipeLeft(element: XCUIElement) {
        if element.waitForExistence(timeout: 10.0){
            element.swipeLeft()
        }
    }
    
    func waitElementAndSwipeUp(element: XCUIElement) {
        if element.waitForExistence(timeout: 10.0){
            element.swipeUp()
        }
    }
    
    func waitElementAndSwipeDown(element: XCUIElement) {
        if element.waitForExistence(timeout: 10.0){
            element.swipeDown()
        }
    }
    
    func waitAndTapElement(element: XCUIElement) {
        
        if element.waitForExistence(timeout: 10.0){
            element.tap()
        }
    }
    
    func waitTapAndTypeElement(element: XCUIElement, text: String){
        
        if element.waitForExistence(timeout: 10.0){
            element.tap()
            element.typeText(text)
        }
        
    }
}
