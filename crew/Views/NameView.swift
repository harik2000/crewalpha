//
//  NameView.swift
//  crew
//
//  Created by Hari Krishna on 12/4/22.
//  NameView.swift lets the user input in their first name, allowing them to autofill
//  from contacts, invalid input is triggered if user attempts to move fowards with
//  an empty name

import SwiftUI

struct NameView: View {
    
    @State var showError = false

    var body: some View {
        
        ///Black background for user account flow
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                ///header text asking for the user to input in their name
                signUpHeaderText(headerText: Constants.nameHeaderText)
                    .padding(.bottom, -30)
                signUpHeaderText(headerText: Constants.nameSubHeaderText)
                   
                
                ///text field with verification code as input
                signUpTextField(showError: $showError, textfieldPlaceholder: "name", textfieldMaxWidth: 235, textfieldAlignment: .center, textfieldInputMinLength: 0, showBackArrow: false, passedSignUpInputType: .name, textfieldKeyboardType: .namePhonePad, textfieldContentType: .givenName, textfieldFontSize: 24)
                
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .opacity(showError ? 0.0 : 1)
            
            ///show error screen if user name input is invalid
            if showError{
              
                signUpErrorBanner(showError: $showError, signUpErrorHeaderText: Constants.nameErrorHeaderText, signUpErrorSubHeaderText: Constants.nameErrorSubHeaderText)
              
            }
        }
        .statusBarStyle(.lightContent)
        .navigationBarHidden(true)
    }
}
 
