//
//  UsernameView.swift
//  crew
//
//  Created by Hari Krishna on 12/5/22.
//

import SwiftUI

struct UsernameView: View {
    
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
                signUpTextField(showError: $showError, textfieldPlaceholder: "username", textfieldMaxWidth: 235, textfieldAlignment: .center, textfieldInputMinLength: 4, showBackArrow: false, passedSignUpInputType: .username, textfieldKeyboardType: .alphabet, textfieldContentType: .username)
                
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
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
    }
}
 
