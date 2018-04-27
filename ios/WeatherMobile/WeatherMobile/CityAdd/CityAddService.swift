//
//  CityListService.swift
//  WeatherMobile
//
//  Created by Sergio Freire on 26/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import Foundation
import Alamofire

class CityAddService {
    
    //the service delivers mocked data with a delay
    func searchCity(_ cityName:String, callBack:@escaping ([CityObject]) -> Void){
        
        let textEscaped = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(textEscaped)&appid=f135ebb7b7464790d66696975b923a69"
        
        Alamofire.request(urlString).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if response.response?.statusCode != 200 {
                callBack([])
                return
            }
            
            if let json = response.result.value as? [String : AnyObject]  {
                
                var cityId = ""
                var cityName = ""
                var cityTemp = ""
                var cityTempMin = ""
                var cityTempMax = ""
                var cityHumidity = ""
                var cityWeatherCondition = ""
                
                if let idCity = json["id"] as? String{
                    cityId = idCity
                }
                if let nameCity = json["name"] as? String{
                    cityName = nameCity
                }
                if let cityMain = json["main"] as? [String : AnyObject]{
                    cityTemp = cityMain["temp"] as! String
                    cityTempMin = cityMain["temp_min"] as! String
                    cityTempMax = cityMain["temp_max"] as! String
                    cityHumidity = cityMain["humidity"] as! String
                }
                if let cityWeather = json["weather"] as? [String : AnyObject]{
                    cityWeatherCondition = cityWeather["description"] as! String
                }
                
                let cities = [CityObject(id:cityId,
                                         city: cityName,
                                         temperature: cityTemp,
                                         minTemperature: cityTempMin,
                                         maxTemperature: cityTempMax,
                                         humidity: cityHumidity,
                                         weatherCondition: cityWeatherCondition)]
                
                callBack(cities)
            }
        
            callBack([])
        }
    }
}
