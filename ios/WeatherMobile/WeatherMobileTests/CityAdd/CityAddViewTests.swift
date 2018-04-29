//
//  CityAddViewTests.swift
//  WeatherMobileTests
//
//  Created by Sergio Freire on 29/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest
import Alamofire
@testable import WeatherMobile

class CityAddViewTests: BaseTest {
    
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
        //View Controller
        prepareRealViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
        
        vcCityList.buttonAddCityTap(vcCityList.btnAddCity)
        XCTAssertNotNil(vcCityList.presentedViewController)
        if let vcAddList = vcCityList.presentedViewController as? CityAddView{
            vcCityAdd = vcAddList
        }
        else{
            XCTFail()
        }
    }
    
    //Test loading empty list of cities, and the empty view wasn't hidden
    func testShouldShowEmptyCities(){
        let presenterUnderTest = CityAddPresenter(cityAddService: emptyCitiesServiceMock!)
        vcCityAdd.cityAddPresenter = presenterUnderTest
        presenterUnderTest.attachView(vcCityAdd)
        vcCityAdd.searchBar(vcCityAdd.searchBar!, textDidChange: "")
        XCTAssertTrue(!(vcCityAdd.emptyView?.isHidden)!)
    }
    //Test loading a list of one city, and the empty view was hidden
    func testShouldShowSomeCities(){
        let presenterUnderTest = CityAddPresenter(cityAddService: towCitiesServiceMock!)
        vcCityAdd.cityAddPresenter = presenterUnderTest
        presenterUnderTest.attachView(vcCityAdd)
        vcCityAdd.searchBar(vcCityAdd.searchBar!, textDidChange: "")
        XCTAssertTrue((vcCityAdd.emptyView?.isHidden)!)
    }
    
    //Test if the searchBar updates the text from "" to "c"
    func testSearchBarTextUpdate(){
        let presenterUnderTest = CityAddPresenter(cityAddService: emptyCitiesServiceMock!)
        vcCityAdd.cityAddPresenter = presenterUnderTest
        presenterUnderTest.attachView(vcCityAdd)
        vcCityAdd.searchBar?.text = "c"
        vcCityAdd.searchBar(vcCityAdd.searchBar!, textDidChange: "c")
        XCTAssertTrue(vcCityAdd.searchBar?.text != "")
    }
    
    //Testing the full process to click the add button
    //Mock the list with a fake city
    //Make it appear by updating the text
    //Click in the first cell
    //Go to citylistView and check the list with 1 city
    func testAddingCityToUserList(){
        let presenterUnderTest = CityAddPresenter(cityAddService: towCitiesServiceMock!)
        vcCityAdd.cityAddPresenter = presenterUnderTest
        presenterUnderTest.attachView(vcCityAdd)
        vcCityAdd.searchBar(vcCityAdd.searchBar!, textDidChange: "")
        vcCityAdd.tableView(vcCityAdd.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        let updatedCities = vcCityList.getCitiesToDisplay()
        XCTAssertTrue(updatedCities.count == 1)
    }
    
}
