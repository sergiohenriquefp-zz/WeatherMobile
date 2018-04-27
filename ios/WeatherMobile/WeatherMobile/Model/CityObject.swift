//
//  CityObject.swift
//  WeatherMobile
//
//  Created by Sergio Freire on 26/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import Foundation

struct CityObject: Codable {
    let id: String
    let city: String
    let temperature: String
    let minTemperature: String
    let maxTemperature: String
    let humidity: String
    let weatherCondition: String
}
