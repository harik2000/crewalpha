//
//  HomeView.swift
//  crew
//
//  Created by Hari Krishna on 12/13/22.
//

import SwiftUI

// MARK: HomeView contains the 4 main views that a user interacts with when they are logged in
// CrewSideMenuView, SelectedCrewView, CameraView, UserProfileView are all contained are all loaded immediately
// when the user opens the app when they're logged in, each view is offset exactly its position * device width away
// and the user can go back and forth along with swipe gestures or the bottom tab bar. Swipe gesture for the class
// and friend menu is also handled within the HomeView
//GITHUB 

struct HomeView: View {
    
    // MARK: cameraModel makes use of the view model to handle the necessary camera permissions
    @StateObject var cameraModel = CameraViewModel()
    
    // MARK: variables used for swiping between tabs in the home page
    
    // MARK: width var determines width of ios device where each tab is offset its position * width of device
    var width = UIScreen.main.bounds.width
    
    // MARK: offsetX var is used to update current x position of screen while screen is in the gesture of being dragged but not fully swiped
    @GestureState private var offsetX: CGFloat = 0
    
    // MARK: currentFloatIndex var indicates the current tab, 0: crew side menu; 1: selected crew view; 2: camera view on app open; 3: profile view
    @State var currentFloatIndex: CGFloat = 2
    
    // MARK: pageCount var indicates number of views in homepage (crew side menu, selected crew view, camera view, profile view)
    let pageCount: Int = 4
    
    // MARK: skipTab var detects when a tab has been skipped to remove animation
    @State var skipTab = false

    // MARK: for profile tabs, friends & classes
    @State var profileIndex = 1 //default is friends menu
    @State var profileOffset : CGFloat = 0 //friends & classes menu initial offset
    @State var disableProfileAnimate : Bool = false //disable sliding animation for user profile when other tabs are selected
    
    // MARK: showProfileBanner creates the banner of 3 profile images for the user
    @State var showProfileBanner = false
   
    //Home View contains the 4 views (side menu, selected crew, camera, and user) along with a bottom tab
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    SideMenuView()
                        .frame(width: geometry.frame(in: .global).width)
                    
                    SelectedCrewView(currentFloatIndex: $currentFloatIndex)
                        .frame(width: geometry.frame(in: .global).width)
                        .offset(x: UIScreen.main.bounds.size.height < 800 && self.currentFloatIndex == 0 ? 12.5 : 0)
                    
                    CameraView(currentFloatIndex: $currentFloatIndex)
                        .frame(width: geometry.frame(in: .global).width)
                    
                    UserProfileView(profileIndex: $profileIndex, profileOffset: $profileOffset, disableProfileAnimate: self.$disableProfileAnimate, showProfileBanner: $showProfileBanner)
                        .frame(width: geometry.frame(in: .global).width)
                }
                .onAppear {
                }
                .statusBarStyle(self.currentFloatIndex == 0 ? .darkContent : .lightContent)
                .padding(.top, !UIDevice.current.hasNotch ? -20 : 0)
                .offset(x: self.offsetX)
                .offset(x: self.currentFloatIndex == 0 ? -60 : -CGFloat(self.currentFloatIndex) * geometry.size.width) //offset by 60 for side menu
                .gesture(
                    //updates drag gesture while in the process of being dragged and disables current drag state if switching between friends and classes menu in profile view
                    DragGesture().updating(self.$offsetX) { value, state, _ in
                        if currentFloatIndex == 1 {
                            if value.translation.width < 1 {
                                state = value.translation.width
                            }
                        } else if currentFloatIndex == 3 {
                            if self.profileIndex == 2 {
                            } else if value.translation.width > 1 && !showProfileBanner { //don't allow swipe gesture when profile banner is showing
                                state = value.translation.width
                            }
                        } else if currentFloatIndex != 0 {
                            state = value.translation.width
                        }
                    }
                    .onEnded({ (value) in
                        
                        if cameraModel.camerapermission == 1 && !showProfileBanner { //make sure camera and mic permissions given as well as profile banner not showing
                            let offset = value.translation.width / geometry.size.width
                            let offsetPredicted = value.predictedEndTranslation.width / geometry.size.width
                            let newIndex = CGFloat(self.currentFloatIndex) - offset
                            self.currentFloatIndex = newIndex
                            
                            if(offsetPredicted < -0.2 && offset > -0.8) {
                                //swiped left and animation has ended so move to the view on the right
                                skipTab = false
                                disableProfileAnimate = false
                                let tempIndex = self.currentFloatIndex
                                self.currentFloatIndex = CGFloat(min(max(Int(newIndex.rounded() + 1), 0), self.pageCount - 1))
                                if tempIndex > 3 && self.currentFloatIndex == 3 { //to switch profile tab from friends to classes
                                    if self.profileIndex == 1 {
                                        self.profileIndex = 2
                                        self.profileOffset = -self.width
                                    }
                                }
                            } else if (offsetPredicted > 0.2 && offset < 0.8) {
                                //swiped right and animation has ended so move to the view on the left
                                skipTab = false
                                disableProfileAnimate = false
                                let tempIndex = self.currentFloatIndex
                                if tempIndex < 3 && tempIndex >= 2 { //to switch profile tab from friends to classes
                                    if self.profileIndex == 2 {
                                        self.profileIndex = 1
                                        self.profileOffset = 0
                                        
                                        self.currentFloatIndex = 3.0
                                    } else {
                                        self.currentFloatIndex = CGFloat(min(max(Int(newIndex.rounded() - 1), 0), self.pageCount - 1))
                                    }
                                } else {
                                    self.currentFloatIndex = CGFloat(min(max(Int(newIndex.rounded() - 1), 0), self.pageCount - 1))
                                }

                            } else {
                                //swiped to stay on current screen so don't change views
                                skipTab = false
                                disableProfileAnimate = false
                                self.currentFloatIndex = CGFloat(min(max(Int(newIndex.rounded()), 0), self.pageCount - 1))
                            }
                        }
                        
                    })
                )
                .onChange(of: self.currentFloatIndex) { newValue in
                    if self.currentFloatIndex == 2 { //change status bar to be white color if in camera tab otherwise dark color
                        UIApplication.setStatusBarStyle(.lightContent)
                    } else {
                        UIApplication.setStatusBarStyle(.darkContent)
                    }
                }
            }
            
            //Bottom tab bar that has selected crew, camera, and profile
            BottomTab(skipTab: self.$skipTab, currentFloatIndex: self.$currentFloatIndex, profileIndex: self.$profileIndex, profileOffset: self.$profileOffset, disableProfileAnimate: self.$disableProfileAnimate, showProfileBanner: self.$showProfileBanner)
                .offset(x: self.currentFloatIndex == 0 ? width - 60 : 0)
                .animation(skipTab ? .none : .interactiveSpring (response: 0.3, dampingFraction: 0.95, blendDuration: 0.25), value: UUID())

        }
        .animation(skipTab ? .none : .interactiveSpring (response: 0.3, dampingFraction: 0.95, blendDuration: 0.25), value: UUID())
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .background(Color.white)
    }
}

// MARK: Bottom tab is the black tab that the user sees when they are logged in with the crew icon, camera icon, and user profile icon respectively
struct BottomTab: View {
    //MARK: tab variables to be changed on user interaction
    
    //MARK: toggle skip tab when tab icon pressed to disable swiping animation
    @Binding var skipTab : Bool
    
    //MARK: currentFloatIndex indicates the tab position (0: side menu, 1: selected crew, 2: camera, 3: user profile)
    @Binding var currentFloatIndex : CGFloat
    
    //MARK: width is used to determine the frame of the tab bar width
    var width = UIScreen.main.bounds.width
    
    //MARK: user profile variables for friends and classes menu
    @Binding var profileIndex : Int
    @Binding var profileOffset : CGFloat
    @Binding var disableProfileAnimate : Bool
    
    // MARK: cameraModel makes use of the view model to handle the necessary camera permissions
    @StateObject var cameraModel = CameraViewModel()
    
    // MARK: show profile banner shows the 3 photos of the user profile
    @Binding var showProfileBanner: Bool

    // MARK: button variable to toggle between states of tapping the crew tab button
    @State private var tappedCrewTabIcon = false
    
    // MARK: button variable to toggle between states of tapping the crew tab button
    @State private var tappedCameraTabIcon = false
    
    // MARK: button variable to toggle between states of tapping the user tab button
    @State private var tappedUserTabIcon = false
   
    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea()
            
                HStack {
                    Spacer()
                    
                    //selected crew tab icon
                    Button(action: {
                        resetProfileOnTap() //resets user profile tab to friends menu when other tab is selected
                        self.disableProfileAnimate = true
                        self.currentFloatIndex = 1
                        skipTab = true
                        
                        //if user attempts to switch tabs while having profile banner viewed, hide profile banner
                        if showProfileBanner {
                            showProfileBanner = false
                        }
                        tappedCrewTabIcon = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            tappedCrewTabIcon = false
                        }
                    }) {
                        Image(self.currentFloatIndex == 1 || self.currentFloatIndex == 0  ? "purplecircles" : "circles")
                          .resizable()
                          .scaledToFill()
                          .frame(width: 28, height: 18)
                          .font(Font.title.weight(.regular))
                    }
                    .scaleEffect(tappedCrewTabIcon ? 0.9 : 1)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedCrewTabIcon)
                    .buttonStyle(StaticButtonStyle())

                    Spacer()
                    
                    //camera tab icon
                    Button(action: {
                        resetProfileOnTap() //resets user profile tab to friends menu when other tab is selected
                        self.disableProfileAnimate = true
                        self.currentFloatIndex = 2
                        skipTab = true
                        
                        //if user attempts to switch tabs while having profile banner viewed, hide profile banner
                        if showProfileBanner {
                            showProfileBanner = false
                        }
                        tappedCameraTabIcon = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            tappedCameraTabIcon = false
                        }
                    }) {
                        Image(systemName: "camera")
                          .resizable()
                          .scaledToFill()
                          .frame(width: 30, height: 20)
                          .font(Font.title.weight(.regular))
                          .padding(.leading, 10)
                          .padding(.trailing, 10)
                          .foregroundColor(self.currentFloatIndex == 2  ?  Color.blue : Color(#colorLiteral(red: 0.9083711505, green: 0.921818316, blue: 0.9405590296, alpha: 1)))
                    }
                    .scaleEffect(tappedCameraTabIcon ? 0.9 : 1)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedCameraTabIcon)
                    .buttonStyle(StaticButtonStyle())

                    Spacer()
                    
                    //user profile tab icon
                    Button(action: {
                        self.currentFloatIndex = 3
                        skipTab = true
                        disableProfileAnimate = true
                        
                        tappedUserTabIcon = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            tappedUserTabIcon = false
                        }
                    }) {
                        Image(systemName: "person.crop.circle")
                          .resizable()
                          .scaledToFill()
                          .frame(width: 24, height: 14)
                          .font(Font.title.weight(.regular))
                          .foregroundColor(self.currentFloatIndex == 3  ? Color(#colorLiteral(red: 0, green: 0.8145048022, blue: 0.8413854837, alpha: 1)) : Color(#colorLiteral(red: 0.9083711505, green: 0.921818316, blue: 0.9405590296, alpha: 1)))
                    }
                    .scaleEffect(tappedUserTabIcon ? 0.9 : 1)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedUserTabIcon)
                    .buttonStyle(StaticButtonStyle())
                    
                    Spacer()
                }
                .padding(.bottom, UIScreen.main.bounds.size.height < 800 ? 15 : 25) //small screen needs to be 30 <800
        }
        .disabled(cameraModel.camerapermission != 1) //DISABLE THIS FOR SIMULATOR
        .frame(width: 30 + width, height: 80) //add 20 to bottom tab bar for
    }
    
    //resets user profile tab to friends menu when other tab is selected
    func resetProfileOnTap() {
        self.profileIndex = 1
        self.profileOffset = 0
    }

}

// MARK: returns whether iphone device has a notch
extension UIDevice {
    var hasNotch: Bool {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        let bottom = window?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}


class ContentHostingController: UIHostingController<ContentView> {
      // 1. We change this variable
    private var currentStatusBarStyle: UIStatusBarStyle = .default
      // 2. To change this property of `UIHostingController`
    override var preferredStatusBarStyle: UIStatusBarStyle {
        currentStatusBarStyle
    }
      // 3. A function we can call to change the style programmatically
    func changeStatusBarStyle(_ style: UIStatusBarStyle) {
        self.currentStatusBarStyle = style
          // 4. Required for view to update
        self.setNeedsStatusBarAppearanceUpdate()
    }
}

extension UIApplication {
      // 1. Function that we can call via `UIApplication.setStatusBarStyle(...)`
    class func resetStatusBarStyle(_ style: UIStatusBarStyle) {
          // Get the root view controller, which we've set to be `ContentHostingController`
        if let vc = UIApplication.getKeyWindow()?.rootViewController as? ContentHostingController {
                 // Call the method we've defined
            vc.changeStatusBarStyle(style)
        }
    }
      // 2. Helper function to get the key window
    private class func getKeyWindow() -> UIWindow? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first { $0.isKeyWindow }
    }
}
