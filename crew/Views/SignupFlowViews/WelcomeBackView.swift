//
//  WelcomeBackView.swift
//  crew
//
//  Created by Hari Krishna on 12/9/22.
//

import SwiftUI

struct WelcomeBackView: View {
    
    //registerviewmodel object to get user name
    @StateObject var registerData = RegisterViewModel()
    
    var body: some View {
        ///Black background for user account flow
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    
                    ///header text asking for the user to input in their name
                    signUpHeaderText(headerText: Constants.welcomeBackText + ", \(registerData.name) :)")
                        .padding(.bottom, 40)

                    welcomeBackProfile()
                    
                    welcomeBackButton()
                        .padding(.top, 60)

                    Spacer()
                }
            }
        }
        
    }
}

struct welcomeBackProfile: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 25, style: .continuous)
        .fill(Color(#colorLiteral(red: 0.3705568314, green: 0.3705568314, blue: 0.3705568314, alpha: 0.8470588235)))
        .frame(width: 200, height: 200)
        .overlay(
            Image(systemName: "person.circle")
            .resizable()
            .foregroundColor(.white)
            .frame(width: 100, height: 100)
        )
    }
}
// MARK: Animated welcome back Button
struct welcomeBackButton: View {
    
    // MARK: go to notification permission after tap has been pressed
    @State private var tap = false
    @State var showNotifications = false

    var body: some View {
      
        VStack {
          
            Text("CONTINUE")
                .font(.custom("ABCSocialExtended-Bold-Trial", size: 14))
                .tracking(2)
                .foregroundColor(.black)
          
        }
        .frame(width: 155, height: 50)
        .background(Color.white)
        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .scaleEffect(tap ? 0.8 : 1)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tap)
        .onTapGesture {
            
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            tap = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tap = false
                self.showNotifications.toggle()
            }
        }
        
        NavigationLink(destination: NotificationPermissionView(), isActive: $showNotifications) {
            EmptyView()
        }
        
    }
}
