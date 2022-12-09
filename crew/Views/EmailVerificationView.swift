//
//  EmailVerificationView.swift
//  crew
//
//  Created by Hari Krishna on 12/6/22.
//  EmailVerificationView.swift allows a user to input in their 6 digit code
//  that is given to their school email previously inputted by the aws cognito service

import SwiftUI

struct EmailVerificationView: View {
    
    //registerviewmodel object to update whether email code has been sent
    @StateObject var registerData = RegisterViewModel()
    
    @State var showError = false
    
    var body: some View {
        ///Black background for user account flow
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                if registerData.sentEmailCode {
                    ///header text saying verification code has not been sent
                    signUpHeaderText(headerText: Constants.emailCodeSentText)
                } else {
                    
                    HStack {
                        ///header text saying verification code has not been sent with a loading indicator
                        signUpHeaderText(headerText: Constants.emailCodeNotSentText)
                        ProgressView().tint(Color.gray)
                            .padding(.bottom, 20)
                            .padding(.leading, 5)
                    }
                    
                }
                
                ///sub header text indicating that code has been sent to user inputted email
                signUpSubHeaderText(subheaderText: "sent to \(registerData.email)")
                
                ///text field with verification code as input
                signUpTextField(showError: $showError, textfieldPlaceholder: "000000", textfieldMaxWidth: 160, textfieldAlignment: .center, textfieldInputMinLength: 6, showBackArrow: true, passedSignUpInputType: .emailCode, textfieldKeyboardType: .numberPad, textfieldContentType: UITextContentType(rawValue: ""), textfieldFontSize: 24)
                
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .opacity(showError ? 0.0 : 1)
            
            ///show error screen if verification code input is invalid
            if showError{
              
                signUpErrorBanner(showError: $showError, signUpErrorHeaderText: Constants.emailCodeErrorHeaderText, signUpErrorSubHeaderText: Constants.emailCodeErrorSubHeaderText)
              
            }
        }
        .statusBarStyle(.lightContent)
        .navigationBarHidden(true)
        
    }
}
