//
//  crewApp.swift
//  crew
//
//  Created by Hari Krishna on 11/29/22.
//

import SwiftUI

//create an observable object to go to name view after welcome view
enum CurrView: Int {
  case welcome
  case phoneNumber
}

class OpData : ObservableObject {
  @Published var currView = CurrView.welcome
}

@main
struct crewApp: App {
    
    private var opData = OpData()

    init() {

    }
    
    var body: some Scene {
        WindowGroup {
            //wrap main view in RootView
            RootView {
                ContentView()
                    .environmentObject(opData)
            }
            
        }
    }
}
