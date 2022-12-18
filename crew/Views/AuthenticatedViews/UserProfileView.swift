//
//  UserProfileView.swift
//  crew
//
//  Created by Hari Krishna on 12/13/22.
//  UserProfileView: UserProfileView.swift currently ahs the user's name, heart icon for fanmail, gear icon for settings
//  along with a friends and classes tabs that the user can toggle with a tap or swipe

import SwiftUI

struct UserProfileView: View {
    
    // MARK: binding variables, profileIndex and offset and disableProfileAnimate are used for friends and classes tabs
    // index 1 for friends and index 2 for classes and disable the animation when tapping on the user profile tab icon
    @Binding var profileIndex : Int
    @Binding var profileOffset : CGFloat
    @Binding var disableProfileAnimate : Bool

    // MARK: show profile banner shows the 3 photos of the user profile
    @Binding var showProfileBanner: Bool

    var width = UIScreen.main.bounds.width

    // MARK: show selected profile banner (left, middle, right) accordingly
    @State var selectedBannerPosition = "middle"
    
    var body: some View {
        
        ZStack() {
            Color.white.ignoresSafeArea()

            VStack {
                
                //user's name, fanmail button and settings button
                UserProfileNameButtonHeader()
                
                HStack(alignment: .center, spacing: 0) {
                    
                    //contain's the user's year and major in university
                    UserYearMajor()
                    
                    Spacer()
                    
                    //has the user's three picture profile banner with a left, main middle, and right
                    UserProfileBanner(showProfileBanner: $showProfileBanner, selectedBannerPosition: $selectedBannerPosition)
                    
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 10)
                
                //contains the user's handle surrounded in a box
                UserUsername()
                
                //tab menu that allows users to toggle between the friends and classes view on tap and swipe gesture
                FriendsClassesTab(index: self.$profileIndex, offset: self.$profileOffset)
                    .padding(.top, 25)
                
                GeometryReader { g in
                    HStack(spacing: 0) {
                        //view that contain's list of user's friends
                        UserFriendsView()
                           .frame(width: g.frame(in: .global).width)
                        
                        //view that contain's list of user's classes
                        UserClassesView()
                            .frame(width: g.frame(in: .global).width)
                    }
                    .offset(x: self.profileOffset)
                }
                Spacer()
            }
            
            UserProfileActionButtons()
            
            if showProfileBanner {
                ProfileBannerView(showProfileBanner: $showProfileBanner, selectedBannerPosition: $selectedBannerPosition)
            }
        }
    }
}

struct UserProfileActionButtons: View {
    
    // MARK: button variable to toggle between states of tapping the friends button
    @State private var tappedFriendsButton = false
    
    // MARK: button variable to toggle between states of tapping the search button
    @State private var tappedSearchButton = false
    
    // MARK: button variable to toggle between states of tapping the crew button
    @State private var tappedCrewButton = false
    
    var body: some View {
        
        HStack {
          
            Spacer()
          
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .frame(width: 52, height: 62)
                .foregroundColor(.black.opacity(0.9))
                .scaleEffect(tappedFriendsButton ? 0.8 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedFriendsButton)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue, Color(#colorLiteral(red: 0, green: 0.8145048022, blue: 0.8413854837, alpha: 0.8470588235))]),
                        startPoint: .trailing,
                        endPoint: .leading
                    ).mask(
                        Image(systemName: "person.2.wave.2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 22)
                        .scaleEffect(tappedFriendsButton ? 0.8 : 1)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedFriendsButton)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.white)
                    ).onTapGesture {
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                        tappedFriendsButton = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            tappedFriendsButton = false
                        }
                    }
                )

            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .frame(width: 52, height: 62)
                .foregroundColor(.black.opacity(0.9))
                .padding(.trailing, 30)
                .padding(.leading, 30)
                .scaleEffect(tappedSearchButton ? 0.8 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedSearchButton)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0.8145048022, blue: 0.8413854837, alpha: 0.8470588235)), Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ).mask(
                        Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 22, height: 22)
                        .scaleEffect(tappedSearchButton ? 0.8 : 1)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedSearchButton)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.white)
                    )
                    .onTapGesture {
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                        tappedSearchButton = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            tappedSearchButton = false
                        }
                    }
                )

            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .frame(width: 52, height: 62)
                .foregroundColor(.black.opacity(0.9))
                .scaleEffect(tappedCrewButton ? 0.8 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedCrewButton)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue, Color(#colorLiteral(red: 0, green: 0.8145048022, blue: 0.8413854837, alpha: 0.8470588235))]),
                        startPoint: .trailing,
                        endPoint: .leading
                    ).mask(
                        Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 14)
                        .scaleEffect(tappedCrewButton ? 0.8 : 1)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedCrewButton)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.blue)
                    )
                    .onTapGesture {
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                        tappedCrewButton = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            tappedCrewButton = false
                        }
                    }
                )
          
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 65)
    }
}
// MARK: below view contains the user's names along with the fanmail button and settings button
struct UserProfileNameButtonHeader: View {
    
    // MARK: button variable to toggle between states of tapping the fan mail button
    @State private var tappedFanmailButton = false
    // MARK: button variable to toggle between states of tapping the settings button
    @State private var tappedSettingsButton = false
    
    var body: some View {
        HStack(alignment: .top) {
            Text("hari krishna")
                .underline()
                .font(.system(size: UIScreen.main.bounds.size.height > 800 ? 28 : 24))
                .fontWeight(.medium)
                .foregroundColor(.black)
                .padding(.bottom, 0.05)
            
            Spacer()
            
            Button(action: {
                let impactMed = UIImpactFeedbackGenerator(style: .soft)
                impactMed.impactOccurred()
                tappedFanmailButton = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    tappedFanmailButton = false
                }
            }) {
              Image(systemName: "heart")
                .resizable()
                .scaledToFill()
                .frame(width: 24, height: 14)
                .font(Font.title.weight(.regular))
                .foregroundColor(.blue)
            }
            .padding(.trailing, 18)
            .scaleEffect(tappedFanmailButton ? 0.8 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedFanmailButton)
            .buttonStyle(StaticButtonStyle())
            .padding(.top, 10)

            Button(action: {
                let impactMed = UIImpactFeedbackGenerator(style: .soft)
                impactMed.impactOccurred()
                tappedSettingsButton = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    tappedSettingsButton = false
                }
            }) {
              Image(systemName: "gearshape")
                .resizable()
                .scaledToFill()
                .frame(width: 24, height: 14)
                .font(Font.title.weight(.regular))
                .foregroundColor(.blue)
            }
            .scaleEffect(tappedSettingsButton ? 0.8 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedSettingsButton)
            .buttonStyle(StaticButtonStyle())
            .padding(.top, 10)

        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .padding(.top, 20)
    }
}

// MARK: below view has the user's year and major at university
struct UserYearMajor: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("👨‍🎓 senior")
                .font(.system(size: UIScreen.main.bounds.size.height > 800 ? 16 : 14))
                .fontWeight(.regular)
                .tracking(1.5)
                .foregroundColor(.gray)
            
            Text("📚 central and east european languages and cultures")
                .font(.system(size: UIScreen.main.bounds.size.height > 800 ? 16 : 14))
                .fontWeight(.regular)
                .tracking(1.5)
                .foregroundColor(.gray)
                .padding(.top, 1.5)
            
        }
        .padding(.top, 5)
    }
}

struct UserProfileBanner: View {
    
    @Binding var showProfileBanner: Bool
    
    // MARK: show selectedBannerPosition banner for position of 3 photos for the user profile between left, middle, and right
    @Binding var selectedBannerPosition: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            
            Image("ucla")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.size.height > 900 ? 90 : 80, height: UIScreen.main.bounds.size.height > 900 ? 90 : 80)
                .cornerRadius(10)
                .padding(.trailing, -30)
                .overlay(
                  RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(LinearGradient(
                      gradient: Gradient(colors: [Color.black.opacity(0.25), Color.black.opacity(0.25)]),
                      startPoint: .topTrailing,
                      endPoint: .bottomLeading
                    ), lineWidth: 2.5)
                    .padding(.trailing, -30)

                )
                .onTapGesture {
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                    self.selectedBannerPosition = "left"
                    self.showProfileBanner = true
                }
            
            Image("main")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.size.height > 900 ? 110 : 100, height: UIScreen.main.bounds.size.height > 900 ? 110 : 100)
                .cornerRadius(10)
                .overlay(
                  RoundedRectangle(cornerRadius: 10)
                    .stroke(LinearGradient(
                      gradient: Gradient(colors: [Color.black.opacity(0.25), Color.black.opacity(0.25)]),
                      startPoint: .topTrailing,
                      endPoint: .bottomLeading
                    ), lineWidth: 2.5)

                  )
                .onTapGesture {
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                    self.selectedBannerPosition = "middle"
                    self.showProfileBanner = true
                }
                .zIndex(1)

            Image("right")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.size.height > 900 ? 90 : 80, height: UIScreen.main.bounds.size.height > 900 ? 90 : 80)
                .cornerRadius(10)
                .padding(.leading, -30)
                .overlay(
                  RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(LinearGradient(
                      gradient: Gradient(colors: [Color.black.opacity(0.25), Color.black.opacity(0.25)]),
                      startPoint: .topTrailing,
                      endPoint: .bottomLeading
                    ), lineWidth: 2.5)
                    .padding(.leading, -30)

                )
                .onTapGesture {
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                    self.selectedBannerPosition = "right"
                    self.showProfileBanner = true
                }
        }
    }
}

struct UserUsername: View {
    var body: some View {
        HStack {
            Spacer()
            
            Text(" @" + "harik2000")
                .font(.system(size: UIScreen.main.bounds.size.height > 800 ? 16 : 14))
                .fontWeight(.medium)
                .tracking(2)
                .foregroundColor(.gray)
                .overlay(
                  RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(Color.gray, lineWidth: 1.5)
                    .padding(.all, -5)
                    //.padding(.trailing, 2)

                )
        }
        .padding(.trailing, 25)
        .padding(.top, 20)
    }
}

struct ProfileBannerView: View {
    // MARK: show profile banner shows the 3 photos of the user profile
    @Binding var showProfileBanner: Bool

    // MARK: show selectedBannerPosition banner for position of 3 photos for the user profile between left, middle, and right
    @Binding var selectedBannerPosition: String
    
    var body: some View {
        
        Rectangle()
            .foregroundColor(Color.black.opacity(0.9))
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                let impactMed = UIImpactFeedbackGenerator(style: .soft)
                impactMed.impactOccurred()
                showProfileBanner = false
            }
        
        VStack {
            
            ProfileBannerHeader(showProfileBanner: $showProfileBanner)
            
            ProfileBannerImages(selectedBannerPosition: $selectedBannerPosition)

            ProfileBannerUpdateButton(selectedBannerPosition: $selectedBannerPosition)
            
        }
        .padding(.bottom, 30)
    }
}

// MARK: below view contains the status of user along with a x button to close the profile banner
struct ProfileBannerHeader: View {
    var width = UIScreen.main.bounds.width

    // MARK: show profile banner shows the 3 photos of the user profile
    @Binding var showProfileBanner: Bool

    var body: some View {
        let bannerWidth = 0.85 * width
        HStack {
            Text("🔒 cuffed")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
            
            Spacer()
            
            Button(action: {
                let impactMed = UIImpactFeedbackGenerator(style: .soft)
                impactMed.impactOccurred()
                showProfileBanner = false
            }, label: {
                ZStack {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 27, height: 27)
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 13.7, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(2)
                .contentShape(Circle())
            })
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .padding(.bottom, 10)
        .frame(width: bannerWidth + 15)
    }
}

// MARK: below view contains the left middle and right profile images of the user
struct ProfileBannerImages: View {
    var width = UIScreen.main.bounds.width

    // MARK: show selectedBannerPosition banner for position of 3 photos for the user profile between left, middle, and right
    @Binding var selectedBannerPosition: String
   
    var body: some View {
        let bannerWidth = 0.85 * width
        let bannerHeight = 1.618 * bannerWidth
        VStack {
            TabView(selection: $selectedBannerPosition) {
                Image("ucla")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: bannerWidth, height: bannerHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                          .stroke(LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.25), Color.black.opacity(0.25)]),
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                          ), lineWidth: 2.5)
                    )
                    .tag("left")
                
                Image("main")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: bannerWidth, height: bannerHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                          .stroke(LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.25), Color.black.opacity(0.25)]),
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                          ), lineWidth: 2.5)
                    )
                    .tag("middle")

                Image("right")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: bannerWidth, height: bannerHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                          .stroke(LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.25), Color.black.opacity(0.25)]),
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                          ), lineWidth: 2.5)
                    )
                    .tag("right")
                
            }
            .frame(width: bannerWidth + 15, height: bannerHeight)
            .tabViewStyle(.page)
            .animation(.none, value: selectedBannerPosition)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .padding(.bottom, 20)
    }
}

// MARK: below contains the change profile button for the user to open the image picker
struct ProfileBannerUpdateButton: View {
    
    var width = UIScreen.main.bounds.width
    // MARK: show selectedBannerPosition banner for position of 3 photos for the user profile between left, middle, and right
    @Binding var selectedBannerPosition: String
    
    var body: some View {
        let bannerWidth = 0.85 * width
        Button(action: {
            let impactMed = UIImpactFeedbackGenerator(style: .light)
            impactMed.impactOccurred()
            
        }) {
            HStack {
                Text("change this photo")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .tracking(1)
                    .foregroundColor(Color.black)
            }
            .padding(.all, 10)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .frame(maxWidth: bannerWidth)
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
}
struct UserFriendsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("friends top").foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Text("friends bottom").foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 45)
        .background(Color.white)
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct UserClassesView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("classes top").foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Text("classes bottom").foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 45)
        .background(Color.white)
        .frame(width: UIScreen.main.bounds.width)
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

