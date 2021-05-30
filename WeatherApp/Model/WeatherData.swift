//
//  WeatherData.swift
//  WeatherApp
//
//  Created by macbook  on 30/05/21.
//  Copyright © 2021 Almaalik. All rights reserved.
//

import Foundation

struct WeatherData: Codable{
    
    let timezone : String
    let current : Current
    let daily : [Daily]
}

struct Current : Codable {
    let dt : Double
    let temp : Double
    let weather : [Weather]
}
struct Weather : Codable {
    let description : String
    let id : Int
}

struct Daily : Codable {
    let dt : Double
    let temp : Temp
    let weather : [Weather2]
}

struct Temp : Codable {
    let min : Double
    let max : Double
}


struct Weather2 : Codable {
    let id : Int
}


struct LocationName : Codable {
    let name : String
}

