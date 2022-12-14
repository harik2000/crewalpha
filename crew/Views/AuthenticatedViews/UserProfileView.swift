//
//  UserProfileView.swift
//  crew
//
//  Created by Hari Krishna on 12/13/22.
//  UserProfileView: UserProfileView.swift currently ahs the user's name, heart icon for fanmail, gear icon for settings
//  along with a friends and classes tabs that the user can toggle with a tap or swipe

import SwiftUI

struct UserProfileView: View {
    @Binding var profileIndex : Int
    @Binding var profileOffset : CGFloat
    var width = UIScreen.main.bounds.width
    @Binding var disableProfileAnimate : Bool

    var body: some View {
        
        ZStack() {
            Color.white.ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("hari")
                        .underline()
                        .font(.system(size: UIScreen.main.bounds.size.height > 800 ? 28 : 24))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .padding(.bottom, 0.05)
                    
                    Spacer()
                    
                    Button(action: {
                      let impactMed = UIImpactFeedbackGenerator(style: .soft)
                      impactMed.impactOccurred()
                    }) {
                      Image(systemName: "heart")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 14)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.blue)
                    }
                    .padding(.trailing, 18)
                    
                    Button(action: {
                      let impactMed = UIImpactFeedbackGenerator(style: .soft)
                      impactMed.impactOccurred()
                    }) {
                      Image(systemName: "gearshape")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 14)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.blue)
                    }
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 20)
                
                FriendsClassesTab(index: self.$profileIndex, offset: self.$profileOffset)
                    .padding(.top, 165)
                
                GeometryReader { g in
                    HStack(spacing: 0) {
                        
                        UserFriendsView()
                           .frame(width: g.frame(in: .global).width)
                        
                        UserClassesView()
                            .frame(width: g.frame(in: .global).width)
                    }
                    .offset(x: self.profileOffset)
                }
                Spacer()
            }
        }
    }
}


struct UserFriendsView: View {
    var body: some View {
        GeometryReader {_ in
            VStack {
                Text("friends").foregroundColor(Color.black)
            }
        }
        .background(Color.white)
    }
}

struct UserClassesView: View {
    var body: some View {
        GeometryReader {_ in
            VStack {
                Text("classes").foregroundColor(Color.black)
            }
        }
        .background(Color.white)
    }
}

struct FriendsClassesTab: View {
    
    @Binding var index : Int
    @Binding var offset : CGFloat

    var width = UIScreen.main.bounds.width
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Button(action: {
                    switchFriendsAndClasses(left: false)
                }) {
                    VStack(spacing: 8) {
                        HStack(spacing: 12) {
                            Text("friends")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(self.index == 1 ? Color.black : Color(#colorLiteral(red: 0.6823525429, green: 0.6823533177, blue: 0.6995556951, alpha: 1)))
                        }
                        
                        Rectangle()
                            .fill(self.index == 1 ? Color.blue : Color.clear)
                            .frame(height: 4)
                    }

                }
                
                Button(action: {
                    switchFriendsAndClasses(left: true)
                }) {
                    VStack(spacing: 8) {
                        HStack(spacing: 12) {
                            Text("classes")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(self.index == 2 ? Color.black : Color(#colorLiteral(red: 0.6823525429, green: 0.6823533177, blue: 0.6995556951, alpha: 1)))
                        }
                        
                        Rectangle()
                            .fill(self.index == 2 ? Color.blue : Color.clear)
                            .frame(height: 4)
                    }

                }
                
            }
        }
        .background(Color.white)
        
    }
    
    //changes menu from friends to classes
    func switchFriendsAndClasses(left: Bool) {
        if left {
            if self.index != 2 {
                self.index += 1
            }
        }
        else {
            if self.index != 1 {
                self.index -= 1
            }
        }
        
        if self.index == 1 {
            self.offset = 0
            
        } else if self.index == 2 {
            self.offset = -self.width
        }
    }

}

