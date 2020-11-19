//
//  WeatherModel.swift
//  Weather App
//
//  Created by Artur Saenko on 19/11/2020.
//  Copyright © 2020 Artur Saenko. All rights reserved.
//

enum ConditionType: String, Codable {
    case clear = "clear sky"
    case fewClouds = "few clouds"
    case scattereClouds = "scattered clouds"
    case brokenClouds = "broken clouds"
    case showerRain = "shower rain"
    case rain = "rain"
    case thunderstorm = "thunderstorm"
    case snow = "snow"
    case mist = "mist"
}

struct WeatherModel: Codable {
    let condition: [ConditionWeatherModel]
    let temperature: TemperatureModel
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case condition = "weather"
        case temperature = "main"
        case city = "name"
    }
}

struct ConditionWeatherModel: Codable {
    let main: String
    let type: ConditionType
    
    enum CodingKeys: String, CodingKey {
        case main = "main"
        case type = "description"
    }
}

struct TemperatureModel: Codable {
    let real: Double
    let feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case real = "temp"
        case feelsLike = "feels_like"
    }
}
