//
//  PhoneVerificationView.swift
//  crew
//
//  Created by Hari Krishna on 12/1/22.
//  PhoneVerificationView.swift is the third screen a user sees if they are not logged in
//  Sends a verification code using Twilio and authenticates user, checks if user already
//  has a crew account otherwise procceeds to sign up flow with name,username,birthday, etc
//  allows user to go back to phone number screen if wrong phone number or resend code after 30 seconds


import SwiftUI

struct PhoneVerificationView: View {
    
    //registerviewmodel object to update whether phone code has been sent
    @StateObject var registerData = RegisterViewModel()
    
    @State var showError = false
    
    var body: some View {
        ///Black background for user account flow
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                if registerData.sentPhoneCode {
                    ///header text saying verification code has not been sent
                    signUpHeaderText(headerText: Constants.phoneCodeSentText)
                } else {
                    
                    HStack {
                        ///header text saying verification code has not been sent with a loading indicator
                        signUpHeaderText(headerText: Constants.phoneCodeNotSentText)
                        ProgressView().tint(Color.gray)
                            .padding(.bottom, 20)
                            .padding(.leading, 5)
                    }
                    
                }
                
                ///sub header text indicating that code has been sent to user inputted number
                signUpSubHeaderText(subheaderText: "sent to \(registerData.phoneNumber)")
                
                ///text field with verification code as input
                signUpTextField(showError: $showError, textfieldPlaceholder: "000000", textfieldMaxWidth: 160, textfieldAlignment: .center, textfieldInputMinLength: 6, showBackArrow: true, passedSignUpInputType: .phoneCode, textfieldKeyboardType: .numberPad, textfieldContentType: .oneTimeCode)
                
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .opacity(showError ? 0.0 : 1)
            
            ///show error screen if verification code input is invalid
            if showError{
              
                signUpErrorBanner(showError: $showError, signUpErrorHeaderText: Constants.phoneCodeErrorHeaderText, signUpErrorSubHeaderText: Constants.phoneCodeErrorSubHeaderText)
              
            }
        }
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
    }
}
