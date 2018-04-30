//
//  CityAddPresenterTests.swift
//  WeatherMobileTests
//
//  Created by Sergio Freire on 29/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest
import Alamofire
@testable import WeatherMobile

class CityAddViewMock : NSObject, CityAddProtocol{
    var searchBar: UISearchBar?
    var setCitiesCalled = false
    var setEmptyCitiesCalled = false
    
    override init() {
        super.init()
        searchBar = UISearchBar.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        searchBar?.text = ""
    }
    
    func setCities(_ cities: [City]){
        setCitiesCalled = true
    }
    
    func setEmptyCities() {
        setEmptyCitiesCalled = true
    }
}

class CityAddPresenterTests: BaseTest {
    
    var cityObj1: City?
    var emptyCitiesServiceMock : CityAddService?
    var towCitiesServiceMock : CityAddService?
    let cityAddViewMock = CityAddViewMock()
    
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
    
    //Test the logic if the presenter is telling the view to show empty view
    func testShouldSetEmptyCities(){
        
        let presenterUnderTest = CityAddPresenter(cityAddService: emptyCitiesServiceMock!)
        presenterUnderTest.attachView(cityAddViewMock)
        presenterUnderTest.searchCities("")
        XCTAssertTrue(cityAddViewMock.setEmptyCitiesCalled)
        presenterUnderTest.detachView()
    }
    
    //Test the logic if the presenter is telling the view to show the list of cities
    func testShouldSetCities(){
        
        let presenterUnderTest = CityAddPresenter(cityAddService: towCitiesServiceMock!)
        presenterUnderTest.attachView(cityAddViewMock)
        presenterUnderTest.searchCities("")
        XCTAssertTrue(cityAddViewMock.setCitiesCalled)
        presenterUnderTest.detachView()
    }
}
