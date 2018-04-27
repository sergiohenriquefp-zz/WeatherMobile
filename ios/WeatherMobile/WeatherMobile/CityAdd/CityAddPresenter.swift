//
//  CityAddPresenter.swift
//  WeatherMobile
//
//  Created by Sergio Freire on 26/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import Foundation

protocol CityAddProtocol: NSObjectProtocol{
    func setCities(_ cities: [CityObject])
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
        
        self.cityAddService.searchCity(text) { (cities) in
            if cities.count == 0{
                self.cityAddView?.setEmptyCities()
            }
            else{
                self.cityAddView?.setCities(cities)
            }
        }
    }
    
    func addCity(_ city:CityObject) {
        
    }
}
