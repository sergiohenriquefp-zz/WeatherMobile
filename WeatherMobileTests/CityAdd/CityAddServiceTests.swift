//
//  CityAddServiceTests.swift
//  WeatherMobileTests
//
//  Created by Sergio Freire on 29/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest
import Alamofire
@testable import WeatherMobile

class CityAddServiceMock: CityAddService {
    fileprivate let cities: [City]
    fileprivate let text: String
    init(cities:[City], text:String) {
        self.cities = cities
        self.text = text
    }
    override func searchCity(_ text:String, callBack:@escaping ([City], String) -> Void){
        callBack(cities,text)
    }
    
}

class CityAddServiceTests: BaseTest {
    
    var cityObj1: City?
    
    var emptyCitiesServiceMock : CityAddService?
    
    var towCitiesServiceMock : CityAddService?
    
    var vcCityList: CityListView!
    var vcCityAdd: CityAddView!
    
    override func setUp() {
        super.setUp()
        
        //load mocked city
        cityObj1 = self.getMockedCity1()
        //load service mock
        emptyCitiesServiceMock = CityAddServiceMock(cities:[City](), text:"")
        towCitiesServiceMock = CityAddServiceMock(cities:[cityObj1!],text:"Campinas")
        
        //Clear saved cities
        UserDefaults.standard.set(nil, forKey:"userCitiesList")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //Test if the parseServiceCity function is parsing correctly the city1.json file
    func testParseCity(){
        let citiesServiceMock = CityAddServiceMock(cities:[City](), text:"")
        if let data = getJsonData(filename: "city1"){
            if let cityParsed = citiesServiceMock.parseServiceCity(data){
                XCTAssertTrue(cityParsed.name == "Campinas")
            }
            else{
                XCTFail()
            }
        }
        else{
            XCTFail()
        }
    }
    
    //Test if the parseServiceCity function is parsing correctly the city_empty.json file by rejecting the data
    func testParseWrongData(){
        let citiesServiceMock = CityAddServiceMock(cities:[City](), text:"")
        if let data = getJsonData(filename: "city_empty"){
            if let _ = citiesServiceMock.parseServiceCity(data){
                XCTFail()
            }
        }
    }
    
    //Test if the parseResponseServiceCity function is rejecting responses with status different of 200
    func testParseWrongResponseStatus(){
        let citiesServiceMock = CityAddServiceMock(cities:[City](), text:"")
        
        let text = "newyork"
        let apiKey = Bundle.main.infoDictionary!["WeatherAPI"] as! String
        let textEscaped = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(textEscaped)&appid=\(apiKey)"
        let expectation = self.expectation(description: "request should fail with 400")
        
        Alamofire.request(urlString).responseJSON { response in
            
            if let _ = citiesServiceMock.parseResponseServiceCity(response){
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
