//
//  SchoolYearView.swift
//  crew
//
//  Created by Hari Krishna on 12/6/22.
//  SchoolYearView.swift allows a user to input in their school year
//  guesses school year based on birthday as freshman, sophomore, junior, senior or grad

import SwiftUI

struct SchoolYearView: View {
    
    //registerviewmodel object to update whether email code has been sent
    @StateObject var registerData = RegisterViewModel()
    
    var body: some View {
        ZStack() {
            ///black background during sign up flow
            Color.black.ignoresSafeArea()
            
            VStack {
                
                ///header text asking for phone number
                signUpHeaderText(headerText: Constants.schoolYearHeaderText)
                    .padding(.top, UIScreen.main.bounds.size.height > 800 ? 150 : 30)
                    .padding(.bottom, 30)
                
                ///gives 4 years + grad option for user to select before finishing account creation
                toggleSchoolYear(month: registerData.month, year: registerData.year)
                
                
            }
        }
        .statusBarStyle(.lightContent)
        .navigationBarHidden(true)
    }
}


struct toggleSchoolYear: View {
    
    //registerviewmodel object to update whether email code has been sent
    @StateObject var registerData = RegisterViewModel()
    
    let month: Int
    let year: Int
    
    let schoolYear = ["1️⃣  freshman", "2️⃣  sophomore", "3️⃣  junior", "4️⃣  senior", "🎓  grad"]
    @State var selectedYear: String?
    @State var showGender = false
    @State var tap = false

    var body: some View {
        
        VStack {
            ForEach(schoolYear, id: \.self) { item in
                chooseSchoolYear(schoolYear: item, selectedYear: self.$selectedYear)
            }
            
            ///sub header text indicating that gender is needed to complete profile on crew
            schoolGenderSubHeaderText(subheaderText: "adding your school year helps create your profile on crew")
            
            Spacer()
            
            HStack {
                Spacer()
                
                VStack {
                    HStack {
                        Text("next")
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
                        showGender.toggle()
                        registerData.updateSchoolYear(schoolYear: selectedYear ?? "🎓  grad")
                    }
                }
                
                NavigationLink(destination: ChooseGenderView(), isActive: $showGender) {
                    EmptyView()
                }
                
            }
        }
        .onAppear {
            selectedYear = determineSchoolYear(month: month, year: year)
        }
    }
    
    func determineSchoolYear(month: Int, year: Int) -> String{
      //december 2003 - november 2004 freshman
      var methodSchoolYear = ""
      if (year == 2004 &&  month >= 1 && month <= 11) || (year == 2003 && month == 12) {
        //freshman
        methodSchoolYear = "1️⃣  freshman"
      } else if (year == 2003 &&  month >= 1 && month <= 11) || (year == 2002 && month == 12) {
        //sophmore
        methodSchoolYear = "2️⃣  sophomore"
      } else if (year == 2002 &&  month >= 1 && month <= 11) || (year == 2001 && month == 12) {
        //junior
        methodSchoolYear = "3️⃣  junior"
      } else if (year == 2001 &&  month >= 1 && month <= 11) || (year == 2000 && month == 12) {
        //senior
        methodSchoolYear = "4️⃣  senior"
      } else {
        //grad
        methodSchoolYear = "🎓  grad"
      }
      return methodSchoolYear
    }
}


struct chooseSchoolYear: View {
  let schoolYear: String
  @Binding var selectedYear: String?
  
  var body: some View {
    if self.selectedYear == self.schoolYear {
        Text(schoolYear)
        .padding(.all, 10)
        .frame(maxWidth: 200, alignment: .leading)
        .padding(.leading, 10)
        .background(
          RoundedRectangle(
              cornerRadius: 10,
              style: .continuous
          )
          .fill(Color.white)
          
        )
        .foregroundColor(.black)
        .overlay(RoundedRectangle(cornerRadius: 10)
        .stroke(Color(#colorLiteral(red: 0.3705568314, green: 0.3705568314, blue: 0.3705568314, alpha: 0.8470588235)), lineWidth: 1))
        .font(.custom("ABCSocial-Bold-Trial", size: 20))
        .padding(.bottom, 20)
        .onTapGesture {
            let impactMed = UIImpactFeedbackGenerator(style: .light)
            impactMed.impactOccurred()

            self.selectedYear = self.schoolYear
        }
    } else {
        Text(schoolYear)
            .padding(.all, 10)
            .frame(maxWidth: 200, alignment: .leading)
            .padding(.leading, 10)
            .background(
            RoundedRectangle(
            cornerRadius: 10,
            style: .continuous
            )
            .fill(Color(#colorLiteral(red: 0.1777858436, green: 0.1777858436, blue: 0.1777858436, alpha: 0.8470588235)))

            )
            .foregroundColor(.white)
            .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color(#colorLiteral(red: 0.3705568314, green: 0.3705568314, blue: 0.3705568314, alpha: 0.8470588235)), lineWidth: 1))
            .font(.custom("ABCSocial-Bold-Trial", size: 20))
            .padding(.bottom, 20)
        .onTapGesture {
            let impactMed = UIImpactFeedbackGenerator(style: .light)
            impactMed.impactOccurred()

            self.selectedYear = self.schoolYear
        }
    }
  }
}
