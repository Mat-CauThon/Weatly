//
//  SwiftUiList.swift
//  Weatly
//
//  Created by Roman Mishchenko on 23.03.2020.
//  Copyright © 2020 Roman Mishchenko. All rights reserved.
//

import SwiftUI

struct SwiftUIList: View {
    
    @ObservedObject var model: DataModel
    @Binding var selectorIndex: Int
    
//    Check for first launch
    func initExample(modelArray: [Model]) -> Model {
        
        var weatherExample = Model(descript: "No Data", dt: 1, dtTxt: " ", windSpeed: 0, cloudiness: 0, temperature: 0, pressure: 0, humidity: 0)
        
        if modelArray.count > 0 {
            
            weatherExample = Model(descript: modelArray[0].descript, dt: modelArray[0].dt, dtTxt: "Current", windSpeed: modelArray[0].windSpeed, cloudiness: modelArray[0].cloudiness, temperature: modelArray[0].temperature, pressure: modelArray[0].pressure, humidity: modelArray[0].humidity)

            
        }
        return weatherExample
    }
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                WeatherRow(item: self.initExample(modelArray: model.modelData))
                Spacer()
            }
            
//            Variants of View (For 5 fays, for Tomorrow's and Today's)
            if selectorIndex == 2 {
                List(model.modelData){ modelly in
                    WeatherRow(item: modelly)
                }
            } else if selectorIndex == 1 {
                List(model.modelData.filter({ (model) -> Bool in
                    let currentTime = Date()
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: currentTime)!
                    let modelTime = Date(timeIntervalSince1970: model.dt)
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    let resultTomorrow = formatter.string(from: tomorrow)
                    let resultModel = formatter.string(from: modelTime)
                    
                   
                    if resultTomorrow == resultModel {
                        return true
                    }
                    return false
                })){ modelly in
                    WeatherRow(item: modelly)
                }
            } else if selectorIndex == 0{
                List(model.modelData.filter({ (model) -> Bool in
                    let currentTime = Date()
                    let modelTime = Date(timeIntervalSince1970: model.dt)
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    let resultCurrent = formatter.string(from: currentTime)
                    let resultModel = formatter.string(from: modelTime)
                    
                   
                    if resultCurrent == resultModel {
                        return true
                    }
                    return false
                })){ modelly in
                    WeatherRow(item: modelly)
                }
            }
            
        }
        
        
        
    }
}
