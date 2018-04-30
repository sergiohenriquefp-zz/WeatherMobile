//
//  BaseTest.swift
//  WeatherMobileTests
//
//  Created by Sergio Freire on 29/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest
@testable import WeatherMobile

class BaseTest: XCTestCase {

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
}
