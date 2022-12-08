//
//  EmailView.swift
//  crew
//
//  Created by Hari Krishna on 12/5/22.
//  EmailView.swift allows a user to input in their school email which will
//  be sent to aws cognito to be verified

import SwiftUI

struct EmailView: View {
    
    @State var showError = false
    
    var body: some View {

            ZStack() {
                
                ///black background during sign up flow
                Color.black.ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    
                    ///header text asking for the user to input in their school email
                    signUpHeaderText(headerText: Constants.emailHeaderText)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    
                    HStack {
                        
                        
                        ///text field with phone number as input
                        signUpTextField(showError: $showError, textfieldPlaceholder: "email", textfieldMaxWidth: 200, textfieldAlignment: .center, textfieldInputMinLength: 0, showBackArrow: false, passedSignUpInputType: .email, textfieldKeyboardType: .alphabet, textfieldContentType: UITextContentType(rawValue: ""), textfieldFontSize: 20)
                        
                        ///default school email as ucla
                        emailUniversityExtension()
                        
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .opacity(showError ? 0.0 : 1)
                
                ///show error screen if user name input is invalid
                if showError{
                    
                    signUpErrorBanner(showError: $showError, signUpErrorHeaderText: Constants.emailErrorHeaderText, signUpErrorSubHeaderText: Constants.emailErrorSubHeaderText)
                    
                }
            }
            .preferredColorScheme(.light)
            .navigationBarHidden(true)
        
    }
}

struct emailUniversityExtension: View {
    
    var body: some View {
        VStack {
            Text("@g.ucla.edu")
            .font(.custom("ABCSocialExtended-Bold-Trial", size: 18))
            .tracking(0)
            .foregroundColor(.white)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .padding(.leading, 5)
            .padding(.trailing, 5)
        }
        .frame(width: 150, height: 50)
        .background(Color(#colorLiteral(red: 0.1777858436, green: 0.1777858436, blue: 0.1777858436, alpha: 0.8470588235)))
        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
        RoundedRectangle(cornerRadius: 10)
        .stroke( Color(#colorLiteral(red: 0.3705568314, green: 0.3705568314, blue: 0.3705568314, alpha: 0.8470588235)), lineWidth: 1)
        )
    }
}
