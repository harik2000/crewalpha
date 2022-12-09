//
//  ChooseGenderView.swift
//  crew
//
//  Created by Hari Krishna on 12/6/22.
//  ChooseGenderView.swift allows user to input in their gender as man, woman, non-binary
//  later to be used for fanmail

import SwiftUI

struct ChooseGenderView: View {
   
    var body: some View {
        ZStack() {
            ///black background during sign up flow
            Color.black.ignoresSafeArea()
            
            VStack {
                
                ///header text asking for phone number
                signUpHeaderText(headerText: Constants.genderHeaderText)
                    .padding(.top, 150)
                    .padding(.bottom, 30)

                ///give three options between man, woman, and non-binary for user to select from
                toggleGender()
            }
        }
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
    }
}

struct toggleGender: View {
    
    @State var selectedGender: String?
    @State var showNotifications = false
    @State var tap = false
    
    //registerviewmodel object to update specfic gender
    @StateObject var registerData = RegisterViewModel()
    @State var genderArray = ["man", "woman", "non-binary"]

    var body: some View {
        VStack {
            HStack {

                Spacer()
                
                VStack {
                    chooseGender(gender: genderArray[0], selectedGender: self.$selectedGender)
                    genderDescriptionText(headerText: "man")
                }
                .padding(.trailing, 10)

                
                VStack {
                    chooseGender(gender: genderArray[1], selectedGender: self.$selectedGender)
                    genderDescriptionText(headerText: "woman")
                }
                .padding(.leading, 10)
                
              
                Spacer()
                
            }
            
            HStack {

                Spacer()

                VStack {
                    chooseGender(gender: genderArray[2], selectedGender: self.$selectedGender)
                    genderDescriptionText(headerText: "non-binary")
                }

                Spacer()
            }
            .padding(.top, 20)
           
            
            ///sub header text indicating that gender is needed to complete profile on crew
            schoolGenderSubHeaderText(subheaderText: "adding your gender helps create your profile on crew")
               
            
            Spacer()
            
            HStack {
                Spacer()
                
                VStack {
                    HStack {
                        Text("done")
                            .foregroundColor(Color.black)
                            .font(.custom("ABCSocial-Bold-Trial", size: 20))
                        Image("arrowright")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .padding(.leading, 2)
                            .padding(.trailing, -5)
                    }
                }
                .frame(width: 105, height: 50)
                .background(Color.white)
                .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.trailing, 25)
                .padding(.bottom, 30)
                .scaleEffect(tap ? 0.8 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tap)
                .onTapGesture {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    tap = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        tap = false
                        registerData.updateGender(gender: selectedGender ?? "🧓")
                        showNotifications.toggle()
                    }
                }
                .disabled(self.selectedGender == nil)
                .opacity(self.selectedGender == nil ? 0.5 : 1)
                
                NavigationLink(destination: NotificationPermissionView(), isActive: $showNotifications) {
                    EmptyView()
                }
                
            }
        }.onAppear {
            determineEmoji()
        }
    }
    
    func determineEmoji(){
        if registerData.schoolYear == "freshman" {
            genderArray = ["💁‍♂️", "💁‍♀️", "💁"]
        } else if registerData.schoolYear == "sophomore" {
            genderArray = ["🙋‍♂️", "🙋‍♀️", "🙋"]
        } else if registerData.schoolYear == "junior" {
            genderArray = ["🙆‍♂️", "🙆‍♀️", "🙆"]
        } else if registerData.schoolYear == "senior" {
            genderArray = ["👨‍🎓", "👩‍🎓", "🧑‍🎓"]
        } else if registerData.schoolYear == "grad" {
            genderArray = ["👴", "👵", "🧓"]
        }
    }
}

struct chooseGender: View {
    let gender: String
    @Binding var selectedGender: String?
  
    var body: some View {
        if self.selectedGender == self.gender {
        Text(gender)
            .padding(.all, 25)
            //.frame(maxWidth: 100, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.white))
            .foregroundColor(.black)
            .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color(#colorLiteral(red: 0.3705568314, green: 0.3705568314, blue: 0.3705568314, alpha: 0.8470588235)), lineWidth: 1))
            .font(.custom("ABCSocial-Bold-Trial", size: 72))
            .onTapGesture {
                let impactMed = UIImpactFeedbackGenerator(style: .light)
                impactMed.impactOccurred()
                self.selectedGender = gender
            }
        } else {
            Text(gender)
                .padding(.all, 25)
                //.frame(maxWidth: 100, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(#colorLiteral(red: 0.1777858436, green: 0.1777858436, blue: 0.1777858436, alpha: 0.8470588235)))
                )
                .foregroundColor(.white)
                .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color(#colorLiteral(red: 0.3705568314, green: 0.3705568314, blue: 0.3705568314, alpha: 0.8470588235)), lineWidth: 1))
                .font(.custom("ABCSocial-Bold-Trial", size: 72))
                .onTapGesture {
                    let impactMed = UIImpactFeedbackGenerator(style: .light)
                    impactMed.impactOccurred()
                    self.selectedGender = gender
                }
        }
    }
}

// MARK: Sub header text for user authentication flow
struct schoolGenderSubHeaderText: View {
    
    var subheaderText: String
    
    var body: some View {
        Text(subheaderText)
            .font(.custom("ABCSocial-Bold-Trial", size: 12))
            .tracking(2)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.leading, 40)
            .padding(.trailing, 40)
            .padding(.top, 40)
    }
}

// MARK: header text for user authentication flow
struct genderDescriptionText: View {
    
    var headerText: String
    
    var body: some View {
        Text(headerText)
          .font(.custom("ABCSocial-Bold-Trial", size: 16))
          .foregroundColor(.white)
          .multilineTextAlignment(.center)
          
    }
}
