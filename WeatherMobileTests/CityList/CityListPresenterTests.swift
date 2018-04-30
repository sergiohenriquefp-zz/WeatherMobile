//
//  CityListPresenterTests.swift
//  WeatherMobileTests
//
//  Created by Sergio Freire on 29/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest
@testable import WeatherMobile

class CityListViewMock : NSObject, CityListProtocol{
    var setUserCitiesCalled = false
    var setEmptyCitiesCalled = false
    
    func setUserCities(_ cities: [City]){
        setUserCitiesCalled = true
    }
    
    func setEmptyCities() {
        setEmptyCitiesCalled = true
    }
}


class CityListPresenterTests: BaseTest {
    
    var cityObj1: City?
    var cityObj2: City?
    var cityObj3: City?
    let cityListViewMock = CityListViewMock()
    let presenterUnderTest = CityListPresenter()
    
    
    override func setUp() {
        super.setUp()
        
        //Cities used to test
        cityObj1 = self.getMockedCity1()
        cityObj2 = self.getMockedCity2()
        cityObj3 = self.getMockedCity3()
        //
        presenterUnderTest.attachView(cityListViewMock)
        //Clear saved cities
        UserDefaults.standard.set(nil, forKey:"userCitiesList")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        presenterUnderTest.detachView()
    }
    
    //Test the logic if the presenter is telling the view to show empty view
    func testShouldSetEmptyCities(){
        
        presenterUnderTest.getUserCities()
    
        XCTAssertTrue(cityListViewMock.setEmptyCitiesCalled)
    }
    
    //Test the logic if the presenter is telling the view to show the list of cities
    func testShouldSetCities(){
        
        presenterUnderTest.saveUserCity(cityObj1!)
        presenterUnderTest.getUserCities()
        
        XCTAssertTrue(cityListViewMock.setUserCitiesCalled)
    }
    
    //Test the logic to Add and remove cities by verifying at every action the saved user cities list
    func testShouldAddAndRemoveCities(){
        
        presenterUnderTest.addUserCity(cityObj1!)
        let addCities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(addCities.count == 1)
        
        presenterUnderTest.removeUserCity(cityObj1!)
        let updatedCities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(updatedCities.count == 0)
    }
    
    //Persisting
    
    //Test if the function to persist the added city it's really persisting
    func testSaveCity(){
        
        presenterUnderTest.saveUserCity(cityObj1!)
        let cities = presenterUnderTest.getSavedUserCities()
        
        XCTAssertTrue(cities[0].name == cityObj1!.name)
    }
    
    //Test if the function to persist the added city is verifyinf if the city was already added
    func testSaveSameCityTwice(){
        
        presenterUnderTest.saveUserCity(cityObj1!)
        let cities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(cities.count == 1)
        
        presenterUnderTest.saveUserCity(cityObj1!)
        let updatedCities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(updatedCities.count == 1)
    }
    
    //Test if the function to persist the deleted city it's really persisting the deleted city, decreasing the count of the list.
    func testDeleteCity(){
        
        presenterUnderTest.saveUserCity(cityObj1!)
        presenterUnderTest.saveUserCity(cityObj2!)
        let citiesOnlyAdding = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(citiesOnlyAdding.count == 2)
        
        presenterUnderTest.deleteUserCity(cityObj1!)
        let citiesDeleted = presenterUnderTest.getSavedUserCities()
        
        XCTAssertTrue(citiesDeleted[0].name == cityObj2!.name)
        XCTAssertTrue(citiesDeleted.count == 1)
    }
    //Test if the function to persist is working when we have never initalized the list persisted.
    func testGetFromCitiesFirstTime(){
        UserDefaults.standard.set(nil, forKey:"userCitiesList")
        presenterUnderTest.saveUserCity(cityObj1!)
        let cities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(cities[0].name == cityObj1!.name)
    }
    
    //Sorting
    //Test sorting 3 cities with different names
    //Before - 3 cities on the list with the reverse alphabetical order
    //After - 3 cities sorted correctly by alphabetical order
    func testSortCitiesByName(){
        presenterUnderTest.saveUserCity(cityObj3!)
        presenterUnderTest.saveUserCity(cityObj2!)
        presenterUnderTest.saveUserCity(cityObj1!)
        //not sorted
        let cities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(cities.count == 3)
        
        XCTAssertTrue(cities[0].name == cityObj3!.name)
        
        presenterUnderTest.sortUserCities(0)
        let citiesSorted = presenterUnderTest.getSortedSavedUserCities()
        
        //Campinas was the last, become the first
        XCTAssertTrue(citiesSorted[0].name == cityObj1!.name)
    }
    
    //Test sorting 3 cities with different max temperatures
    //Before - 3 cities on the list with the alphabetical order
    //After - 3 cities sorted correctly by max temperature
    func testSortCitiesByHighestTemperature(){
        
        presenterUnderTest.saveUserCity(cityObj1!)
        presenterUnderTest.saveUserCity(cityObj2!)
        presenterUnderTest.saveUserCity(cityObj3!)
        
        //not sorted
        let cities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(cities.count == 3)
        
        XCTAssertTrue(cities[0].name == cityObj1!.name)
        
        presenterUnderTest.sortUserCities(1)
        let citiesSorted = presenterUnderTest.getSortedSavedUserCities()
        
        //Rio de Janeiro has the higher temperature
        XCTAssertTrue(citiesSorted[0].name == cityObj3!.name)
    }
    
    //Test sorting 3 cities with different min temperatures
    //Before - 3 cities on the list with the alphabetical order
    //After - 3 cities sorted correctly by min temperature
    func testSortCitiesByLowestTemperature(){
        
        presenterUnderTest.saveUserCity(cityObj1!)
        presenterUnderTest.saveUserCity(cityObj2!)
        presenterUnderTest.saveUserCity(cityObj3!)
        
        //not sorted
        let cities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(cities.count == 3)
        
        XCTAssertTrue(cities[0].name == cityObj1!.name)
        
        presenterUnderTest.sortUserCities(2)
        let citiesSorted = presenterUnderTest.getSortedSavedUserCities()
        
        //Sao Paulo has the lowest temperature
        XCTAssertTrue(citiesSorted[0].name == cityObj2!.name)
    }
    
    //Testing sorting function when sending a wrong sorting index.
    func testSortCitiesDefault(){
        
        presenterUnderTest.saveUserCity(cityObj1!)
        presenterUnderTest.saveUserCity(cityObj2!)
        presenterUnderTest.saveUserCity(cityObj3!)
        
        //not sorted
        let cities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(cities.count == 3)
        
        XCTAssertTrue(cities[0].name == cityObj1!.name)
        
        presenterUnderTest.sortUserCities(3)
        let citiesSorted = presenterUnderTest.getSortedSavedUserCities()
        
        //Default should keep the same
        XCTAssertTrue(citiesSorted[0].name == cityObj1!.name)
    }
}
