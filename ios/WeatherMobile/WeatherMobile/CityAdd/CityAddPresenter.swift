//
//  CityAddPresenter.swift
//  WeatherMobile
//
//  Created by Sergio Freire on 26/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import Foundation
import UIKit

protocol CityAddProtocol: NSObjectProtocol{
    
    var searchBar : UISearchBar? { get set }
    func setCities(_ cities: [City])
    func setEmptyCities()
}

class CityAddPresenter{
    
    fileprivate let cityAddService:CityAddService
    weak fileprivate var cityAddView : CityAddProtocol?
    
    init(cityAddService:CityAddService){
        self.cityAddService = cityAddService
    }
    
    func attachView(_ view:CityAddProtocol){
        cityAddView = view
    }
    
    func detachView() {
        cityAddView = nil
    }
    
    func searchCities(_ text:String) {
        
        self.cityAddService.searchCity(text) { (cities, searchText) in
            
            if self.cityAddView?.searchBar?.text == searchText{
                if cities.count == 0{
                    self.cityAddView?.setEmptyCities()
                }
                else{
                    self.cityAddView?.setCities(cities)
                }
            }
        }
    }
}
