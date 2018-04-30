//
//  CityListView.swift
//  WeatherMobileTests
//
//  Created by Sergio Freire on 29/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest
@testable import WeatherMobile

class CityListViewTests: BaseTest {
    
    var cityObj1: City?
    var cityObj2: City?
    var cityObj3: City?
    let presenterUnderTest = CityListPresenter()
    var vcCityList: CityListView!
    
    override func setUp() {
        super.setUp()
        
        //Cities used to test
        cityObj1 = self.getMockedCity1()
        cityObj2 = self.getMockedCity2()
        cityObj3 = self.getMockedCity3()
        //Clear saved cities
        UserDefaults.standard.set(nil, forKey:"userCitiesList")
        //View Controller to test view
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
    
    //Test Adding a new city by typing on the search bar
    //Before - 0 cities on the list
    //After - 1 city on the list
    func testShouldClickAddCity(){
        
        vcCityList.buttonAddCityTap(vcCityList.btnAddCity)
        XCTAssertNotNil(vcCityList.presentedViewController)
        if let vcAddList = vcCityList.presentedViewController as? CityAddView{
            vcAddList.delegate?.addCity(cityObj1!)
        }
        else{
            XCTFail()
        }
        let updatedCities = vcCityList.getCitiesToDisplay()
        
        XCTAssertTrue(updatedCities.count == 1)
    }
    
    //Test sorting 3 cities with different names
    //Before - 3 cities on the list with the reverse alphabetical order
    //After - 3 cities sorted correctly by alphabetical order
    func testShouldClickSortCity(){
        presenterUnderTest.saveUserCity(cityObj3!)
        presenterUnderTest.saveUserCity(cityObj2!)
        presenterUnderTest.saveUserCity(cityObj1!)
        vcCityList.segementedControl.selectedSegmentIndex = 0
        vcCityList.buttonSortTap(segControl: vcCityList.segementedControl)
        
        let updatedCities = vcCityList.getCitiesToDisplay()
        
        XCTAssertTrue(updatedCities[0].name == cityObj1!.name)
    }
    
    //Test sorting 3 cities with different max temperatures
    //Before - 3 cities on the list with the alphabetical order
    //After - 3 cities sorted correctly by max temperature
    func testShouldClickSortTemperatureHigh(){
        presenterUnderTest.saveUserCity(cityObj1!)
        presenterUnderTest.saveUserCity(cityObj2!)
        presenterUnderTest.saveUserCity(cityObj3!)
        vcCityList.segementedControl.selectedSegmentIndex = 1
        vcCityList.buttonSortTap(segControl: vcCityList.segementedControl)
        
        let updatedCities = vcCityList.getCitiesToDisplay()
        
        XCTAssertTrue(updatedCities[0].name == cityObj3!.name)
    }
    
    //Test sorting 3 cities with different min temperatures
    //Before - 3 cities on the list with the alphabetical order
    //After - 3 cities sorted correctly by min temperature
    func testShouldClickSortTemperatureLow(){
        presenterUnderTest.saveUserCity(cityObj1!)
        presenterUnderTest.saveUserCity(cityObj2!)
        presenterUnderTest.saveUserCity(cityObj3!)
        vcCityList.segementedControl.selectedSegmentIndex = 2
        vcCityList.buttonSortTap(segControl: vcCityList.segementedControl)
        
        let updatedCities = vcCityList.getCitiesToDisplay()
        
        XCTAssertTrue(updatedCities[0].name == cityObj2!.name)
    }
    
    //Test loading empty list of cities, and the empty view wasn't hidden
    func testShouldShowEmptyCities(){
        vcCityList.buttonSortTap(segControl: vcCityList.segementedControl)
        XCTAssertTrue(!(vcCityList.emptyView?.isHidden)!)
    }
    
    //Test loading a list of one city, and the empty view was hidden
    func testShouldShowSomeCities(){
        presenterUnderTest.addUserCity(cityObj1!)
        vcCityList.buttonSortTap(segControl: vcCityList.segementedControl)
        XCTAssertTrue((vcCityList.emptyView?.isHidden)!)
    }
}
