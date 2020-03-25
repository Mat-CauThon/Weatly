//
//  CustomScrollView.swift
//  Weatly
//
//  Created by Roman Mishchenko on 23.03.2020.
//  Copyright © 2020 Roman Mishchenko. All rights reserved.
//

import Foundation
import SwiftUI

struct CustomScrollView : UIViewRepresentable {


    var width : CGFloat
    var height : CGFloat
    @Binding var selectorIndex: Int
    var modelData: DataModel
        
    func makeCoordinator() -> Coordinator {
        Coordinator(self, model: modelData)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
        
        let control = UIScrollView()
        control.refreshControl = UIRefreshControl()
        control.refreshControl?.addTarget(context.coordinator,
                                          action: #selector(Coordinator.handleRefreshControl),
                                          for: .valueChanged)
        
//        Send Picker state and Data for List in SwiftUIList
        let childView = UIHostingController(rootView: SwiftUIList(model: modelData, selectorIndex: self.$selectorIndex))
        childView.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        control.addSubview(childView.view)
        
        return control
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    
    class Coordinator: NSObject {
        var control: CustomScrollView
        var model : DataModel
        
        init(_ control: CustomScrollView, model: DataModel) {
            self.control = control
            self.model = model
        }
        @objc func handleRefreshControl(sender: UIRefreshControl) {
            sender.endRefreshing()
            

            model.getElements()
            
        
        }
    }
}
