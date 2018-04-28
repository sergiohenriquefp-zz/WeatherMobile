//
//  CityAddTests.swift
//  WeatherMobileTests
//
//  Created by Sergio Freire on 26/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest
@testable import WeatherMobile

class CityAddServiceMock: CityAddService {
    fileprivate let cities: [CityObject]
    fileprivate let text: String
    init(cities:[CityObject], text:String) {
        self.cities = cities
        self.text = text
    }
    override func searchCity(_ text:String, callBack:@escaping ([CityObject], String) -> Void){
        callBack(cities,text)
    }
    
}

class CityAddViewMock : NSObject, CityAddProtocol{
    var searchBar: UISearchBar?
    var setCitiesCalled = false
    var setEmptyCitiesCalled = false
    
    override init() {
        super.init()
        searchBar = UISearchBar.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        searchBar?.text = ""
    }
    
    func setCities(_ cities: [CityObject]){
        setCitiesCalled = true
    }
    
    func setEmptyCities() {
        setEmptyCitiesCalled = true
    }
}

class CityAddTests: XCTestCase {
    
    let emptyCitiesServiceMock = CityAddServiceMock(cities:[CityObject](), text:"")
    
    let towCitiesServiceMock = CityAddServiceMock(cities:[CityObject(id:"1", city:"Campinas", temperature:"26", minTemperature:"20", maxTemperature:"30", humidity:"30%", weatherCondition:"Clear")],text:"Campinas")
    
    let cityAddViewMock = CityAddViewMock()
    
    var vcCityList: CityListView!
    var vcCityAdd: CityAddView!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    //View
    func testShouldShowEmptyCities(){
        let presenterUnderTest = CityAddPresenter(cityAddService: emptyCitiesServiceMock)
        vcCityAdd.cityAddPresenter = presenterUnderTest
        presenterUnderTest.attachView(vcCityAdd)
        vcCityAdd.searchBar(vcCityAdd.searchBar!, textDidChange: "")
        XCTAssertTrue(!(vcCityAdd.emptyView?.isHidden)!)
    }
    
    func testShouldShowSomeCities(){
        let presenterUnderTest = CityAddPresenter(cityAddService: towCitiesServiceMock)
        vcCityAdd.cityAddPresenter = presenterUnderTest
        presenterUnderTest.attachView(vcCityAdd)
        vcCityAdd.searchBar(vcCityAdd.searchBar!, textDidChange: "")
        XCTAssertTrue((vcCityAdd.emptyView?.isHidden)!)
    }
    
    func testSearchBarTextUpdate(){
        let presenterUnderTest = CityAddPresenter(cityAddService: emptyCitiesServiceMock)
        vcCityAdd.cityAddPresenter = presenterUnderTest
        presenterUnderTest.attachView(vcCityAdd)
        vcCityAdd.searchBar?.text = "c"
        vcCityAdd.searchBar(vcCityAdd.searchBar!, textDidChange: "c")
        XCTAssertTrue(vcCityAdd.searchBar?.text != "")
    }
    
    func testAddingCityToUserList(){
        let presenterUnderTest = CityAddPresenter(cityAddService: towCitiesServiceMock)
        vcCityAdd.cityAddPresenter = presenterUnderTest
        presenterUnderTest.attachView(vcCityAdd)
        vcCityAdd.searchBar(vcCityAdd.searchBar!, textDidChange: "")
        vcCityAdd.tableView(vcCityAdd.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        let updatedCities = vcCityList.getCitiesToDisplay()
        XCTAssertTrue(updatedCities.count == 1)
    }
    
    //Presenter
    func testShouldSetEmptyCities(){
        
        let presenterUnderTest = CityAddPresenter(cityAddService: emptyCitiesServiceMock)
        presenterUnderTest.attachView(cityAddViewMock)
        presenterUnderTest.searchCities("")
        XCTAssertTrue(cityAddViewMock.setEmptyCitiesCalled)
        presenterUnderTest.detachView()
    }
    
    func testShouldSetCities(){
        
        let presenterUnderTest = CityAddPresenter(cityAddService: towCitiesServiceMock)
        presenterUnderTest.attachView(cityAddViewMock)
        presenterUnderTest.searchCities("")
        XCTAssertTrue(cityAddViewMock.setCitiesCalled)
        presenterUnderTest.detachView()
    }
    
    
    
    
    
}
