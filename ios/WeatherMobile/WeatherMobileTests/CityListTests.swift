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
    let cityListViewMock = CityListViewMock()
    let presenterUnderTest = CityListPresenter()
    var vcCityList: CityListView!
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        presenterUnderTest.attachView(cityListViewMock)
        //Clear saved cities
        presenterUnderTest.saveUserCities([])
        //View Controller
        prepareRealViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        presenterUnderTest.detachView()
        vcCityList = nil
    }
    
    func prepareRealViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: CityListView = storyboard.instantiateViewController(withIdentifier: "CityListView") as! CityListView
        vcCityList = vc
        _ = vcCityList.view
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = vc
        window.makeKeyAndVisible()
        vc.loadView()
    }
    
    //View
    func testShouldClickAddCity(){
        
        vcCityList.buttonAddCityTap(vcCityList.btnAddCity)
        XCTAssertNotNil(vcCityList.presentedViewController)
        if let vcAddList = vcCityList.presentedViewController as? CityAddView{
            vcAddList.delegate?.addCity(cityObj1)
        }
        else{
            XCTFail()
        }
        let updatedCities = vcCityList.getCitiesToDisplay()
        
        XCTAssertTrue(updatedCities.count == 1)
    }
    
    func testShouldClickSortCity(){
        presenterUnderTest.saveUserCity(cityObj3)
        presenterUnderTest.saveUserCity(cityObj2)
        presenterUnderTest.saveUserCity(cityObj1)
        vcCityList.segementedControl.selectedSegmentIndex = 0
        vcCityList.buttonSortTap(segControl: vcCityList.segementedControl)
        
        let updatedCities = vcCityList.getCitiesToDisplay()
        
        XCTAssertTrue(updatedCities[0].city == cityObj1.city)
    }
    
    func testShouldClickSortTemperatureHigh(){
        presenterUnderTest.saveUserCity(cityObj1)
        presenterUnderTest.saveUserCity(cityObj2)
        presenterUnderTest.saveUserCity(cityObj3)
        vcCityList.segementedControl.selectedSegmentIndex = 1
        vcCityList.buttonSortTap(segControl: vcCityList.segementedControl)
        
        let updatedCities = vcCityList.getCitiesToDisplay()
        
        XCTAssertTrue(updatedCities[0].city == cityObj3.city)
    }
    
    func testShouldClickSortTemperatureLow(){
        presenterUnderTest.saveUserCity(cityObj1)
        presenterUnderTest.saveUserCity(cityObj2)
        presenterUnderTest.saveUserCity(cityObj3)
        vcCityList.segementedControl.selectedSegmentIndex = 2
        vcCityList.buttonSortTap(segControl: vcCityList.segementedControl)
        
        let updatedCities = vcCityList.getCitiesToDisplay()
        
        XCTAssertTrue(updatedCities[0].city == cityObj2.city)
    }
    
    func testShouldShowEmptyCities(){
        vcCityList.buttonSortTap(segControl: vcCityList.segementedControl)
        XCTAssertTrue(!(vcCityList.emptyView?.isHidden)!)
    }
    
    func testShouldShowSomeCities(){
        presenterUnderTest.addUserCity(cityObj1)
        vcCityList.buttonSortTap(segControl: vcCityList.segementedControl)
        XCTAssertTrue((vcCityList.emptyView?.isHidden)!)
    }
    
    
    //Presenter
    func testShouldSetEmptyCities(){
        
        presenterUnderTest.getUserCities()
        
        XCTAssertTrue(cityListViewMock.setEmptyCitiesCalled)
    }
    
    func testShouldSetCities(){
        
        presenterUnderTest.saveUserCity(cityObj1)
        presenterUnderTest.getUserCities()
        
        XCTAssertTrue(cityViewMock.setUserCitiesCalled)
    }
    
    func testShouldAddAndRemoveCities(){
        
        presenterUnderTest.addUserCity(cityObj1)
        let addCities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(addCities.count == 1)
        
        presenterUnderTest.removeUserCity(cityObj1)
        let updatedCities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(updatedCities.count == 0)
    }
    
    //Persisting
    func testSaveCity(){
        
        presenterUnderTest.saveUserCity(cityObj1)
        let cities = presenterUnderTest.getSavedUserCities()
        
        XCTAssertTrue(cities[0].city == cityObj1.city)
    }
    
    func testDeleteCity(){
        
        presenterUnderTest.saveUserCity(cityObj1)
        presenterUnderTest.saveUserCity(cityObj2)
        let citiesOnlyAdding = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(citiesOnlyAdding.count == 2)
        
        presenterUnderTest.deleteUserCity(cityObj1)
        let citiesDeleted = presenterUnderTest.getSavedUserCities()
        
        XCTAssertTrue(citiesDeleted[0].city == cityObj2.city)
        XCTAssertTrue(citiesDeleted.count == 1)
    }
    
    func testGetFromCitiesFirstTime(){
        UserDefaults.standard.set(nil, forKey:"userCitiesList")
        presenterUnderTest.saveUserCity(cityObj1)
        let cities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(cities[0].city == cityObj1.city)
    }
    
    //Sorting
    func testSortCitiesByName(){
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
    
    func testSortCitiesDefaul(){
        
        presenterUnderTest.saveUserCity(cityObj1)
        presenterUnderTest.saveUserCity(cityObj2)
        presenterUnderTest.saveUserCity(cityObj3)
        
        //not sorted
        let cities = presenterUnderTest.getSavedUserCities()
        XCTAssertTrue(cities.count == 3)
        
        XCTAssertTrue(cities[0].city == cityObj1.city)
        
        presenterUnderTest.sortUserCities(3)
        let citiesSorted = presenterUnderTest.getSortedSavedUserCities()
        
        //Default should keep the same
        XCTAssertTrue(citiesSorted[0].city == cityObj1.city)
    }
    
}
