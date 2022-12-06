//
//  PhoneNumberView.swift
//  crew 
//
//  Created by Hari Krishna on 11/30/22.
//  PhoneNumberView.swift is the second screen a user sees if they are not logged in
//  Saves the phone number to send a verification code and logs the user in afterwards
//  if the user already has an account, otherwise proceeds to sign up and create an account

import SwiftUI

struct PhoneNumberView: View {
    
    @State var showError = false

    var body: some View {
        
        //navigation view handles view flow if user is not logged in
        NavigationView {
            
            ///Black background for user account flow
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    
                    ///header text asking for phone number
                    signUpHeaderText(headerText: Constants.phoneNumberHeaderText)
                    
                    HStack {
                        
                        ///showing american +1 phone number with 🇺🇸
                        americaPhoneExtension()
                       
                        ///text field with phone number as input
                        signUpTextField(showError: $showError, textfieldPlaceholder: "phone number", textfieldMaxWidth: .infinity, textfieldAlignment: .leading, textfieldInputMinLength: 10, showBackArrow: false, passedSignUpInputType: .phoneNumber, textfieldKeyboardType: .numberPad, textfieldContentType: UITextContentType(rawValue: ""))
                        
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    
                    Spacer()
                    
                    ///privacy and toc text that user agrees to
                    PrivacyTerms()
                        .padding(.bottom, 10)
                    
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .opacity(showError ? 0.0 : 1)
                
                ///show error screen if phone number input invalid
                if showError{
                  
                    signUpErrorBanner(showError: $showError, signUpErrorHeaderText: Constants.phoneNumberErrorHeaderText, signUpErrorSubHeaderText: Constants.phoneNumberErrorSubHeaderText)
                  
                }
                
            }
            .preferredColorScheme(.light)
            .navigationBarHidden(true)
        }

    }
}

// MARK: america +1 phone extension before phone number field
struct americaPhoneExtension: View {
    var body: some View {
        VStack {
            Text(" 🇺🇸 +1")
                .font(.custom("ABCSocialExtended-Bold-Trial", size: 16))
                .tracking(0)
                .foregroundColor(.white)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .padding(.leading, 5)
                .padding(.trailing, 5)

        }
        .frame(width: 70, height: 50)
        .background(Color(#colorLiteral(red: 0.1777858436, green: 0.1777858436, blue: 0.1777858436, alpha: 0.8470588235)))
        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke( Color(#colorLiteral(red: 0.3705568314, green: 0.3705568314, blue: 0.3705568314, alpha: 0.8470588235)), lineWidth: 1)
        )
    }
}


// MARK: Privacy and TOC view
struct PrivacyTerms: View {
    
    @State private var showingOptions = false
    @State private var showPrivacy: Bool = false
    @State private var showTermsOfServices: Bool = false
    
    var body: some View {
        VStack {
            Text("by tapping continue, you are agreeing with our ")
                .font(.custom("ABCSocialExtended-Bold-Trial", size: 12))
                .tracking(2)
                .foregroundColor(.white)
                
            + Text("privacy policy")
                .font(.custom("ABCSocialExtended-Bold-Trial", size: 12))
                .tracking(2)
                .foregroundColor(.white)
                .underline()
                                
            + Text(", and ")
                .font(.custom("ABCSocialExtended-Bold-Trial", size: 12))
                .tracking(2)
                .foregroundColor(.white)
            
            + Text("terms of services")
                .font(.custom("ABCSocialExtended-Bold-Trial", size: 12))
                .tracking(2)
                .foregroundColor(.white)
                .underline()
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .padding(.bottom, 25)
        .multilineTextAlignment(.center)
        .onTapGesture{
            showingOptions = true
        }
        .confirmationDialog("", isPresented: $showingOptions, titleVisibility: .hidden) {
            Button("Privacy Policy") {
                showPrivacy.toggle()
            }

            Button("Terms of Services") {
                showTermsOfServices.toggle()
            }
        }
        .fullScreenCover(isPresented: $showPrivacy, content: {
            SFSafariViewWrapper(url: URL(string: "https://violet-taxicab-0d3.notion.site/Crew-Privacy-Policy-761b9c221a1145238553226988982432")!)
        })
        .fullScreenCover(isPresented: $showTermsOfServices, content: {
            SFSafariViewWrapper(url: URL(string: "https://violet-taxicab-0d3.notion.site/Crew-Terms-and-Conditions-b456339923a046679a12b440d2c7eb61")!)
        })
    }
}


// MARK: header text for user authentication flow
struct signUpHeaderText: View {
    
    var headerText: String
    
    var body: some View {
        Text(headerText)
          .font(.custom("ABCSocial-Bold-Trial", size: 24))
          .foregroundColor(.white)
          .multilineTextAlignment(.center)
          .padding(.bottom, 20)
          
    }
}

// MARK: Sub header text for user authentication flow
struct signUpSubHeaderText: View {
    
    var subheaderText: String
    
    var body: some View {
        Text(subheaderText)
            .font(.custom("ABCSocial-Bold-Trial", size: 12))
            .tracking(2)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.bottom, 40)
            .padding(.top, -10)
    }
}

enum signUpInputType {
    case phoneNumber, phoneCode, name, username
}

// MARK: textfield during user sign up for inputs
struct signUpTextField: View {
    
    //registerviewmodel object to pass in phone number
    @StateObject var registerData = RegisterViewModel()
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    //parameters to be updated for textfield
    var textfieldPlaceholder : String
    var textfieldMaxWidth : CGFloat
    var textfieldAlignment : TextAlignment
    var textfieldInputMinLength : Int
    var showBackArrow : Bool
    var passedSignUpInputType : signUpInputType
    var textfieldKeyboardType : UIKeyboardType
    var textfieldContentType : UITextContentType
    
    //variables for textfield
    @Binding var showError: Bool
    @FocusState var isFocused: Bool
    @State var textfieldInput: String = ""
    //to move to next view in user sign up flow
    @State var showVerificationView = false
    @State var showNameView = false
    @State var showAgeView = false
    @State var showProfileView = false

    //check if user tapped right to go forward in toolbar or left to go backward in toolbar
    @State var tappedRight = false
    @State var tappedLeft = false

    
    
    init(showError: Binding<Bool>, textfieldPlaceholder: String, textfieldMaxWidth: CGFloat, textfieldAlignment: TextAlignment, textfieldInputMinLength: Int, showBackArrow: Bool, passedSignUpInputType : signUpInputType, textfieldKeyboardType : UIKeyboardType, textfieldContentType : UITextContentType) {
        self._showError = showError
        self.textfieldPlaceholder = textfieldPlaceholder
        self.textfieldMaxWidth = textfieldMaxWidth
        self.textfieldAlignment = textfieldAlignment
        self.textfieldInputMinLength = textfieldInputMinLength
        self.showBackArrow = showBackArrow
        self.passedSignUpInputType = passedSignUpInputType
        self.textfieldKeyboardType = textfieldKeyboardType
        self.textfieldContentType = textfieldContentType
        
        UIToolbar.appearance().isTranslucent = false
        UIToolbar.appearance().barStyle = .black
        UIToolbar.appearance().clipsToBounds = true
    }
    
    var body: some View {
        //make textfield input lowercased
        let lowerCasedTextFieldInput = Binding<String>(get: {
            self.textfieldInput
        }, set: {
            self.textfieldInput = $0.lowercased()
        })
        
        TextField(textfieldPlaceholder, text: lowerCasedTextFieldInput).modifier(customViewModifier(textColor: .white, alignment: textfieldAlignment, fontSize: 24))
            .frame(maxWidth: textfieldMaxWidth)
            .foregroundColor(.white)
            .accentColor(.white)
            .focused($isFocused)
            .keyboardType(textfieldKeyboardType)
            .textContentType(textfieldContentType)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .accentColor(.white)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    
                    if showBackArrow {
                        VStack {

                            Image("arrowright")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .padding(.leading, 2)
                                .rotationEffect(.degrees(-180))
                        }
                        .frame(width: 40, height: 40)
                        .background(Color.gray)
                        .mask(RoundedRectangle(cornerRadius: 10))
                        .scaleEffect(tappedLeft ? 0.8 : 1)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedLeft)
                        .padding(.bottom, 3)
                        .onTapGesture {
                            if registerData.sentPhoneCode { //TODO: doesn't allow you to go back if code hasn't been sent, fix to account for test phone number
                                let impactMed = UIImpactFeedbackGenerator(style: .light)
                                impactMed.impactOccurred()
                                tappedLeft = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    tappedLeft = false
                                }
                                withAnimation(.spring()) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }
                    
                    Spacer()

                    NavigationLink(destination: PhoneVerificationView(), isActive: $showVerificationView) {
                        EmptyView().hidden()
                    }
                    NavigationLink(destination: NameView(), isActive: $showNameView) {
                        EmptyView().hidden()
                    }
                    NavigationLink(destination: AgeView(), isActive: $showAgeView) {
                        EmptyView().hidden()
                    }
                    NavigationLink(destination: TempUserView(), isActive: $showProfileView) {
                        EmptyView().hidden()
                    }
                    
                    Spacer()
                    
                    VStack {
                        if passedSignUpInputType == .phoneCode {
                            if registerData.phoneCodeVerifyLoadingIndicator {
                                ProgressView()
                                  .frame(width: 15, height: 15)
                                  .tint(.gray)
                            } else {
                                Image("arrowright")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 2)
                            }
                        } else {
                            Image("arrowright")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .padding(.leading, 2)
                        }
                        
                    }
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .mask(RoundedRectangle(cornerRadius: 10))
                    .scaleEffect(tappedRight ? 0.8 : 1)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedRight)
                    .padding(.bottom, 3)
                    .onTapGesture {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        tappedRight = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            tappedRight = false
                        }
                            
                        switch passedSignUpInputType {
                        case .phoneNumber:
                            if textfieldInput.count != textfieldInputMinLength {
                                withAnimation(.spring()) {
                                    showError.toggle()
                                    isFocused = false
                                }
                                
                            } else {
                                registerData.updatePhoneNumber(phoneNumber: textfieldInput)
                                showVerificationView.toggle()
                            }
                            
                        case .phoneCode:
                            if textfieldInput.count != textfieldInputMinLength {
                                withAnimation(.spring()) {
                                    showError.toggle()
                                    isFocused = false
                                }
                            } else {
                                if !registerData.phoneCodeVerifyLoadingIndicator {
                                    registerData.updatePhoneCode(phoneCode: textfieldInput)
                                }
                            }
                        case .name:
                            if textfieldInput.count == textfieldInputMinLength {
                                withAnimation(.spring()) {
                                    showError.toggle()
                                    isFocused = false
                                }
                            } else {
                                registerData.updateName(name: textfieldInput)
                                showAgeView.toggle()
                            }
                        case .username:
                            if textfieldInput.count < textfieldInputMinLength {
                                withAnimation(.spring()) {
                                    showError.toggle()
                                    isFocused = false
                                }
                            } else {
                                print("inside name")
                                registerData.updateUsername(username: textfieldInput)
                                showProfileView.toggle()
                            }
                        }
                        
                                
                    }
                    .onChange(of: registerData.phoneAuthCode) { newValue in
                        //check phone auth code flag, 1 is correct code and 2 is wrong code
                        if passedSignUpInputType == .phoneCode {
                            if newValue == 1 {
                                showNameView.toggle()
                            } else if newValue == 2 {
                                withAnimation(.spring()) {
                                    showError.toggle()
                                    isFocused.toggle()
                                }
                                registerData.resetPhoneCode()
                            }
                        }
                    }
                    .onChange(of: textfieldInput) { newValue in
                        //auto verify phone code once 6 digits have been inputted by user
                        if passedSignUpInputType == .phoneCode {
                            if textfieldInput.count == 6 {
                                registerData.updatePhoneCode(phoneCode: textfieldInput)
                            }
                        }
                        
                    }
                    
                    
                }
            }
            .onAppear {
                //print("appeared phone number and is focused is \(isFocused)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    isFocused = true
                    
                    //workaround when not focused when returning back to view
                    if !isFocused {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isFocused = true
                        }
                    }
                }
            }
            .onChange(of: showError) { newValue in
                if showError == false {
                    isFocused = true
                }
            }
    }
    
}



// MARK: Error handler for Sign Up
struct signUpErrorBanner: View {
    
    @Binding var showError: Bool
    
    //error message header and subheader text
    var signUpErrorHeaderText: String
    var signUpErrorSubHeaderText: String
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(signUpErrorHeaderText)
                            .foregroundColor(Color.white)
                            .font(.custom("ABCSocialExtended-Bold-Trial", size: 20))
                            .tracking(2)
                            .padding(.bottom, 5)

                        Text(signUpErrorSubHeaderText)
                            .foregroundColor(Color.white)
                            .font(.custom("ABCSocialExtended-Bold-Trial", size: 12))
                            .tracking(2)
                            .opacity(0.75)
                            .padding(.bottom, 15)
                    }
                    
                    Spacer()
                }
               
            
                Button(action: {
                    
                  let impactMed = UIImpactFeedbackGenerator(style: .light)
                  impactMed.impactOccurred()
                  showError.toggle()
                    
                }) {
                    HStack {
                        Text("roger that")
                        .font(.custom("ABCSocialExtended-Bold-Trial", size: 16))
                        .tracking(2)
                    }
                    .padding(.all, 10)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 10,
                            style: .continuous
                        )
                        .fill(Color.white)
                    )
                }
                .buttonStyle(ScaleButtonStyle())
          }
          .padding()
          .padding(.top, 5)
          .padding(.bottom, 5)
          .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0.8145048022, blue: 0.8413854837, alpha: 0.8470588235)), Color(#colorLiteral(red: 0.3221585751, green: 0.3056567907, blue: 0.8743923306, alpha: 0.8470588235))]), startPoint: .topTrailing, endPoint: .bottomLeading))
          .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
          .padding(.bottom, 150)
            
        }.padding(.leading, 10)
        .padding(.trailing, 10)
        .transition(.move(edge: .trailing))
        .zIndex(1)
    }
}
