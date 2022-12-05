//
//  ContentView.swift
//  crew
//
//  Created by Hari Krishna on 11/30/22.
//

import SwiftUI

struct ContentView: View {
    
    //environment object tells view to go to phone view after welcome view
    @EnvironmentObject var opData:OpData
    
    var body: some View {
        
        //MARK: switch between welcome view and phone number view for user flow if not signed in
        switch(opData.currView) {
            case .welcome:
                WelcomeView()
                    .environmentObject(opData)
            case .phoneNumber:
                PhoneNumberView()
                    .environmentObject(opData)
            
        }
        
    }
}
