//
//  WeatherRpw.swift
//  Weatly
//
//  Created by Roman Mishchenko on 23.03.2020.
//  Copyright © 2020 Roman Mishchenko. All rights reserved.
//

import SwiftUI
import CoreData

struct WeatherRow: View {
    
    var item: Model
    
    var body: some View {
        HStack {
            
            VStack {
                Text(item.dtTxt)
                ZStack(alignment: .bottom) {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 65, height: 65)
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    Circle()
                        .fill(Color.gray)
                        .frame(width: CGFloat(item.cloudiness), height: CGFloat(item.cloudiness))
                    
                }
                
            }
            Spacer()
            
            VStack {
                Text(item.descript)
                    
                Text("Wind \(String(format: "%.2f", item.windSpeed))")
                Text("Humidity \(item.humidity)%")
                
            }
            Spacer()
            VStack {
                if item.temperature > 0 {
                    Text("+"+String(item.temperature))
                        .font(.largeTitle)
                } else {
                    Text(String(item.temperature))
                        .font(.largeTitle)
                }
            }
        }
    }
}
