//
//  ContentView.swift
//  crew
//
//  Created by Hari Krishna on 11/30/22.
//
import SwiftUI

struct ContentView: View {
    
    //stored variable that tells app whether user is logged in
    @AppStorage("status") var status = false

    //stored variable that tells app to go to welcome back view if user attempts to sign
    //in and already has an account
    @AppStorage("hasAccount") var hasAccount = false

    //environment object tells view to go to phone view after welcome view
    @EnvironmentObject var opData:OpData
    
    var body: some View {
        
        if status {
            TempUserView()
        } else if hasAccount {
            WelcomeBackView()
        } else {
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
}
