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
    
    func searchCity(_ text:String, callBack:@escaping ([City], String) -> Void){
        
        let apiKey = Bundle.main.infoDictionary!["WeatherAPI"] as! String
        let textEscaped = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(textEscaped)&appid=\(apiKey)"
        
        Alamofire.request(urlString).responseJSON { response in
            
            if let cityObj = self.parseResponseServiceCity(response){
                callBack([cityObj], text)
                return
            }
            
            callBack([], text)
            return
        }
    }
    
    func parseResponseServiceCity(_ response:DataResponse<Any>) -> City?{
        
        if response.response?.statusCode == 200 {
            if let json = response.data as Data?  {
                if let cityObj = self.parseServiceCity(json){
                    return cityObj
                }
            }
        }
        
        return nil
    }
    
    func parseServiceCity(_ jsonData:Data) -> City?{
        
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(City.self, from: jsonData)
            return jsonData
        } catch {
            return nil
        }
    }
}
