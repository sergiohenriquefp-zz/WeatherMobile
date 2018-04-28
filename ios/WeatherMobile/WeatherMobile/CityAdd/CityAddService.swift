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
    func searchCity(_ text:String, callBack:@escaping ([CityObject], String) -> Void){
        
        let textEscaped = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(textEscaped)&appid=f135ebb7b7464790d66696975b923a69"
        
        Alamofire.request(urlString).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if response.response?.statusCode != 200 {
                callBack([],text)
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
                
                if let idCity = json["id"] as? Int64{
                    cityId = String(format: "%d", idCity)
                }
                if let nameCity = json["name"] as? String{
                    cityName = nameCity
                }
                if let cityMain = json["main"] as? [String : AnyObject]{
                    let temperature = cityMain["temp"] as! Double
                    cityTemp = String(format: "%.2f", temperature)
                    
                    let temperatureMin = cityMain["temp_min"] as! Double
                    cityTempMin = String(format: "%.2f", temperatureMin)
                    
                    let temperatureMax = cityMain["temp_max"] as! Double
                    cityTempMax = String(format: "%.2f", temperatureMax)
                    
                    let humidity = cityMain["humidity"] as! Double
                    cityHumidity = String(format: "%.2f", humidity)
                    
                }
                if let cityWeatherArray = json["weather"] as? [[String : AnyObject]]{
                    
                    if cityWeatherArray.count > 0 {
                        if let cityWeatherObject = cityWeatherArray.first {
                            cityWeatherCondition = cityWeatherObject["description"] as! String
                        }
                    }
                }
                
                let cities = [CityObject(id:cityId,
                                         city: cityName,
                                         temperature: cityTemp,
                                         minTemperature: cityTempMin,
                                         maxTemperature: cityTempMax,
                                         humidity: cityHumidity,
                                         weatherCondition: cityWeatherCondition)]
                
                callBack(cities, text)
                return
            }
        
            callBack([], text)
            return
        }
    }
}
