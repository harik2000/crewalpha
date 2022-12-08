//
//  ContactsPermissionView.swift
//  crew
//
//  Created by Hari Krishna on 12/8/22.
//

import SwiftUI

struct ContactsPermissionView: View {
    var body: some View {
        
        ZStack(alignment: .top) {
            
            ///black background during sign up flow
            Color.black.ignoresSafeArea()
            
            VStack {
                
                ///allow user to move forward without requesting contact permission
                skipContactButton()
                    
                //header text telling user that crew works better with contacts
                contactViewMessage()
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                
                //address book emoji
                contactEmoji()
                
                //use cases for contacts telling them about mutual friends and classmates no crew
                contactDescription()
                
                Spacer()
                
                //button to trigger app to request for contacts permission
                contactButton()

            }
        }
    }
}

struct contactDescription: View {
    var body: some View {
        VStack {
            contactFooterTitle(text: "get contacts to...")
            contactFooterMessage(text: "friend students on campus", sfsymbol: "heart.fill")
            contactFooterMessage(text: "add classmates who join crew", sfsymbol: "studentdesk")
            contactFooterMessage(text: "find your friend's friends", sfsymbol: "message.fill")
        }
    }
}
struct contactEmoji: View {
    
    var body: some View {
        
        Text("📔")
          .font(.custom("ABCSocial-Bold-Trial", size: 96))
          .foregroundColor(.white)
          .padding(.leading, 10)
          .fixedSize(horizontal: false, vertical: true)
          .padding(.trailing, 10)
          .multilineTextAlignment(.center)
          .padding(.bottom, 40)
          //.padding(.top, UIScreen.main.bounds.size.height > 800 ? 150 : 75)
        
    }
}

struct contactViewMessage: View {
    
    var body: some View {
        
        Text(Constants.contactHeaderText)
          .font(.custom("ABCSocial-Bold-Trial", size: 24))
          .foregroundColor(.white)
          .padding(.leading, 10)
          .fixedSize(horizontal: false, vertical: true)
          .padding(.trailing, 10)
          .multilineTextAlignment(.center)
          .padding(.bottom, 10)
          .padding(.top, UIScreen.main.bounds.size.height > 800 ? 120 : 75)
        
    }
}

struct skipContactButton: View {
    
    @State var showHome = false
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            NavigationLink(destination: TempUserView(), isActive: $showHome) {
                
                Text("later")
                    .font(.custom("ABCSocial-Bold-Trial", size: 18))
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .padding(.trailing, 25)
                    .padding(.top, 10)
                    .padding(.top, UIScreen.main.bounds.size.height > 800 ? 0 : 20)
                    .onTapGesture {
                        let impactMed = UIImpactFeedbackGenerator(style: .light)
                        impactMed.impactOccurred()
                        showHome.toggle()
                    }
            }
        }
    }
}


struct contactFooterMessage: View {
    
    var text: String
    var sfsymbol: String
    
    var body: some View {
        HStack {
            Image(systemName: sfsymbol)
                .font(.system(size: 16.0))
            
            Text(text)
              .font(.custom("ABCSocial-Bold-Trial", size: 16))
              .foregroundColor(.white)
              .padding(.top, 2.5)
        }
        .frame(maxWidth: 330, alignment: .leading)
    }
}

struct contactFooterTitle: View {
    var text: String
    
    var body: some View {

        Text(text)
            .font(.custom("ABCSocial-Bold-Trial", size: 16))
            .foregroundColor(.white)
            .frame(maxWidth: 330, alignment: .leading)
            .padding(.top, 2.5)
    }
}

struct contactButton: View {
    
    @StateObject var registerData = RegisterViewModel()
    @State var tap = false
    @State var showHome = false

    var body: some View {
        
        VStack {
            NavigationLink(destination: TempUserView(), isActive: $showHome) {
                EmptyView()
            }
            
            HStack {
                
                Spacer()
            
                VStack {
                    Text("allow contacts")
                    .foregroundColor(Color.black)
                    .font(.custom("ABCSocial-Bold-Trial", size: 14))
                    .tracking(1)
                    .multilineTextAlignment(.center)

                }
                .frame(width: 150, height: 45)
                .background(Color.white)
                .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.bottom, 30)
                .scaleEffect(tap ? 0.8 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tap)
                .onTapGesture {

                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    tap = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        tap = false

                    }
                }
                
                Spacer()
                
                
            }
        }

    }
}
