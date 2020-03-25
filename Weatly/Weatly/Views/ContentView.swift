//
//  ContentView.swift
//  Weatly
//
//  Created by Roman Mishchenko on 23.03.2020.
//  Copyright © 2020 Roman Mishchenko. All rights reserved.
//

import SwiftUI

//Main View
struct ContentView: View {
    
    @State private var selectorIndex = 0

    var items = ["Today","Tomorrow","5 Days"]
    
    
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack{
                
                    CustomScrollView(width: geometry.size.width, height: geometry.size.height, selectorIndex: self.$selectorIndex, modelData: DataModel(modelData: (UIApplication.shared.delegate as! AppDelegate).modelArray))
                    
                    Spacer()
                            
                    Picker("Range", selection: self.$selectorIndex, content: {
                        ForEach(0..<self.items.count) { index in
                            Text(self.items[index]).tag(index)
                        }
                    })
                        
                    .pickerStyle(SegmentedPickerStyle())
                }
                        
                .navigationBarTitle("Weatly")
                .listStyle(GroupedListStyle())
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
