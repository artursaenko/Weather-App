//
//  WeatherModel.swift
//  Weather App
//
//  Created by Artur Saenko on 19/11/2020.
//  Copyright © 2020 Artur Saenko. All rights reserved.
//

enum ConditionType: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case drizzle = "Drizzle"
    case rain = "Rain"
    case thunderstorm = "Thunderstorm"
    case snow = "Snow"
    case mist = "Atmosphere"
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
    let main: ConditionType
    
    enum CodingKeys: String, CodingKey {
        case main = "main"
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
