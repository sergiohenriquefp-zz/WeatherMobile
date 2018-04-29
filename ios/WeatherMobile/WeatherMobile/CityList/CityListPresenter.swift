//
//  CityListPresenter.swift
//  WeatherMobile
//
//  Created by Sergio Freire on 26/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import Foundation

protocol CityListProtocol: NSObjectProtocol{
    func setUserCities(_ cities: [City])
    func setEmptyCities()
}

class CityListPresenter{
    
    weak fileprivate var cityListView : CityListProtocol?
    var sort : Int = 0
    //city = 0
    //high = 1
    //low = 2
    
    func attachView(_ view:CityListProtocol){
        cityListView = view
    }
    
    func detachView() {
        cityListView = nil
    }
    
    func sortUserCities(_ sortFactor:Int) {
        
        self.sort = sortFactor
        getUserCities()
    }
    
    func getUserCities() {
        
        let updatedUserCityList = self.getSortedSavedUserCities()
        
        if updatedUserCityList.count == 0{
            self.cityListView?.setEmptyCities()
        }
        else{
            self.cityListView?.setUserCities(updatedUserCityList)
        }
    }
    
    func addUserCity(_ city:City){
        self.saveUserCity(city)
        self.getUserCities()
    }
    
    func removeUserCity(_ city:City){
        self.deleteUserCity(city)
        self.getUserCities()
    }
    
    //Persist
    func saveUserCity(_ city:City) {
        var userCitiesList = self.getSavedUserCities()
        if !userCitiesList.contains(where: {$0.id == city.id}) {
            userCitiesList.append(city)
            self.saveUserCities(userCitiesList)
            let newUserCitiesList = getSavedUserCities()
            self.cityListView?.setUserCities(newUserCitiesList)
        }
    }
    
    func deleteUserCity(_ city:City) {
        var userCitiesList = self.getSavedUserCities()
        if let i = userCitiesList.index(where: { $0.id == city.id }) {
            userCitiesList.remove(at: i)
        }
        self.saveUserCities(userCitiesList)
        let newUserCitiesList = getSavedUserCities()
        self.cityListView?.setUserCities(newUserCitiesList)
    }
    
    func getSortedSavedUserCities() -> [City] {
        
        var updatedUserCityList = self.getSavedUserCities()
        
        switch self.sort {
            case 0:
                updatedUserCityList = updatedUserCityList.sorted { $0.name < $1.name }
                break
            case 1:
                updatedUserCityList = updatedUserCityList.sorted { $0.main.temp_max > $1.main.temp_max }
                break
            case 2:
                updatedUserCityList = updatedUserCityList.sorted { $0.main.temp_min < $1.main.temp_min }
                break
            default:
                break
        }
        
        return updatedUserCityList
    }
    
    func getSavedUserCities() -> [City] {
        
        if let data = UserDefaults.standard.value(forKey:"userCitiesList") as? Data {
            return try! PropertyListDecoder().decode(Array<City>.self, from: data)
        }
        
        return []
    }
    
    func saveUserCities(_ cities:[City]) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(cities), forKey:"userCitiesList")
    }
    
}
