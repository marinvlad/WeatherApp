//
//  WeatherManager.swift
//  Clima
//
//  Created by Vlad on 7/18/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather:WeatherModel)
}
struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(forCity: String) {
        let url = "\(weatherUrl)&q=\(forCity)"
        performRequest(urlString: url)
    }
    
    func fetchWeather(forLat: Double, forLon: Double) {
        let url = "\(weatherUrl)&lat=\(forLat)&lon=\(forLon)"
        performRequest(urlString: url)
    }
    
    func performRequest(urlString : String) {
        if let url = URL(string : urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: completionHandler(data:response:error:))
            task.resume()
        }
    }
    
    func completionHandler(data:Data?, response:URLResponse?, error:Error?) {
        if let safeData = data {
            if let parsedWeather = parseJSON(weatherData: safeData){
                delegate?.didUpdateWeather(self, weather:parsedWeather)
            }
        }
    }
    
    func parseJSON(weatherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let conditionId = decodedData.weather[0].id
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            
            let weatherModel = WeatherModel(conditionId: conditionId,cityName: cityName,temperature: temperature)
            return weatherModel
        } catch {
            return nil
        }
    }
    
}
