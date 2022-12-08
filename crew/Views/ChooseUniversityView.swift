//
//  ChooseUniversityView.swift
//  crew
//
//  Created by Hari Krishna on 12/6/22.
//

import SwiftUI

struct ChooseUniversityView: View {
    
    let schoolYear = ["ucla 🐻", "stanford 🌲"]
    @State var selectedYear: String?
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            ///black background during sign up flow
            Color.black.ignoresSafeArea()

            VStack {
                
                Spacer()
                
                ///header text asking for the user to input in their university
                signUpHeaderText(headerText: Constants.universityHeaderText)
                    .padding(.bottom, -30)
                signUpHeaderText(headerText: Constants.universitySubHeaderText)
                    .padding(.bottom, 30)
                
                ///selection of schools for user to select from
                ForEach(schoolYear, id: \.self) { item in
                    chooseSchoolText(schoolYear: item, selectedYear: self.$selectedYear)
                }
                
                reachOutUniversity()
                    .padding(.top, 30)

                Spacer()
                

                ///allow user to continue to next screen after selecting their university
                nextProfileButton()
                   
            }
            
        }
        .navigationBarHidden(true)
    }
}

// MARK: Privacy and TOC view
struct reachOutUniversity: View {
    
    @State private var showingOptions = false
    @State private var showPrivacy: Bool = false
    @State private var showTermsOfServices: Bool = false
    
    var body: some View {
        VStack {
            Text("don't see your university, message us on ")
                .font(.custom("ABCSocialExtended-Bold-Trial", size: 12))
                .tracking(2)
                .foregroundColor(.white)
                
            + Text("instagram")
                .font(.custom("ABCSocialExtended-Bold-Trial", size: 12))
                .tracking(2)
                .foregroundColor(.white)
                .underline()
                                
            + Text(", or ")
                .font(.custom("ABCSocialExtended-Bold-Trial", size: 12))
                .tracking(2)
                .foregroundColor(.white)
            
            + Text("email us")
                .font(.custom("ABCSocialExtended-Bold-Trial", size: 12))
                .tracking(2)
                .foregroundColor(.white)
                .underline()
            
            + Text(" to move up the waitlist")
                .font(.custom("ABCSocialExtended-Bold-Trial", size: 12))
                .tracking(2)
                .foregroundColor(.white)
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .padding(.bottom, 25)
        .multilineTextAlignment(.center)
        .onTapGesture{
            showingOptions = true
        }
        .confirmationDialog("", isPresented: $showingOptions, titleVisibility: .hidden) {
            Button("email us") {
                showPrivacy.toggle()
            }

            Button("message us on insta") {
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

struct chooseSchoolText: View {
  let schoolYear: String
  @Binding var selectedYear: String?
  
  var body: some View {
    if self.selectedYear == self.schoolYear {
      Text(schoolYear)
      .padding(.all, 10)
      .frame(maxWidth: 150, alignment: .center)
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
      .frame(maxWidth: 150, alignment: .center)
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
