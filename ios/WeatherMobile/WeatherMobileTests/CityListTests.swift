//
//  CityListTests.swift
//  WeatherMobileTests
//
//  Created by Sergio Freire on 26/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest
@testable import WeatherMobile

class CityListViewMock : NSObject, CityListProtocol{
    var setUserCitiesCalled = false
    var setEmptyCitiesCalled = false
    
    func setUserCities(_ cities: [CityObject]){
        setUserCitiesCalled = true
    }
    
    func setEmptyCities() {
        setEmptyCitiesCalled = true
    }
    
}

class CityListTests: XCTestCase {
    
    let cityObj1 = CityObject(id:"1", city:"Campinas", temperature:"26", minTemperature:"20", maxTemperature:"30", humidity:"30%", weatherCondition:"Clear")
    let cityObj2 = CityObject(id:"2", city:"Sao Paulo", temperature:"22", minTemperature:"18", maxTemperature:"24", humidity:"30%", weatherCondition:"Clear")
    let cityObj3 = CityObject(id:"3", city:"Rio de Janeiro", temperature:"30", minTemperature:"26", maxTemperature:"34", humidity:"60%", weatherCondition:"Clear")
    let cityViewMock = CityListViewMock()
    let presenterUnderTest = CityListPresenter()
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        presenterUnderTest.attachView(cityViewMock)
        //Clear saved cities
        presenterUnderTest.saveUserCities([])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //Persisting
    func testSaveCity(){
        
        presenterUnderTest.attachView(cityViewMock)
        presenterUnderTest.saveUserCity(cityObj1)
        let cities = presenterUnderTest.getSavedUserCities()
        
        XCTAssertTrue(cities[0].city == cityObj1.city)
    }
    
    func testDeleteCity(){
        
        presenterUnderTest.attachView(cityViewMock)
        presenterUnderTest.saveUserCity(cityObj1)
        presenterUnderTest.saveUserCity(cityObj2)
        let citiesOnlyAdding = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(citiesOnlyAdding.count == 2)
        
        presenterUnderTest.deleteUserCity(cityObj1)
        let citiesDeleted = presenterUnderTest.getSavedUserCities()
        
        XCTAssertTrue(citiesDeleted[0].city == cityObj2.city)
        XCTAssertTrue(citiesDeleted.count == 1)
    }
    
    func testLoadEmptyCities(){
        XCTFail()
    }
    
    func testLoadCities(){
        XCTFail()
    }
    
    //Sorting
    func testSortCitiesByName(){
        presenterUnderTest.attachView(cityViewMock)
        presenterUnderTest.saveUserCity(cityObj3)
        presenterUnderTest.saveUserCity(cityObj2)
        presenterUnderTest.saveUserCity(cityObj1)
        //not sorted
        let cities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(cities.count == 3)
        
        XCTAssertTrue(cities[0].city == cityObj3.city)
        
        presenterUnderTest.sortUserCities(0)
        let citiesSorted = presenterUnderTest.getSortedSavedUserCities()
        
        //Campinas was the last, become the first
        XCTAssertTrue(citiesSorted[0].city == cityObj1.city)
    }
    
    func testSortCitiesByHighestTemperature(){
        
        presenterUnderTest.attachView(cityViewMock)
        presenterUnderTest.saveUserCity(cityObj1)
        presenterUnderTest.saveUserCity(cityObj2)
        presenterUnderTest.saveUserCity(cityObj3)
        
        //not sorted
        let cities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(cities.count == 3)
        
        XCTAssertTrue(cities[0].city == cityObj1.city)
        
        presenterUnderTest.sortUserCities(1)
        let citiesSorted = presenterUnderTest.getSortedSavedUserCities()
        
        //Rio de Janeiro has the higher temperature
        XCTAssertTrue(citiesSorted[0].city == cityObj3.city)
    }
    
    func testSortCitiesByLowestTemperature(){
        presenterUnderTest.attachView(cityViewMock)
        presenterUnderTest.saveUserCity(cityObj1)
        presenterUnderTest.saveUserCity(cityObj2)
        presenterUnderTest.saveUserCity(cityObj3)
        
        //not sorted
        let cities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(cities.count == 3)
        
        XCTAssertTrue(cities[0].city == cityObj1.city)
        
        presenterUnderTest.sortUserCities(2)
        let citiesSorted = presenterUnderTest.getSortedSavedUserCities()
        
        //Sao Paulo has the lowest temperature
        XCTAssertTrue(citiesSorted[0].city == cityObj2.city)
    }
    
    //Empty Screen
    func testShowingEmptyScreen(){
        XCTFail()
    }
}
