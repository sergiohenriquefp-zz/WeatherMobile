//
//  CityObject.swift
//  WeatherMobile
//
//  Created by Sergio Freire on 26/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import Foundation

struct City : Codable {
    let name: String
    let id: Int
    let weather: [Weather]
    let main: Main
    let sys: Sys
}

struct Weather: Codable {
    let main: String
    let description : String
}

struct Main: Codable {
    let temp: Double
    let humidity : Int
    let temp_min : Double
    let temp_max : Double
}

struct Sys: Codable {
    let country: String
}


