//
//  WelcomeView.swift
//  crew   GOAL OF HOMEPAGE: Be obnoxiously relevant so users can't resist signing up
//  Created by Hari Krishna on 11/29/22.
//  WelcomeView.swift is the first screen a user sees before they sign up and create an account
//  App logo, schools that crew is currently available at, functionalities, and button to signup/login


import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        
        ZStack {
            
            ///A view under components of moving colored clouds set as the background
            NorthernLights()
            
            VStack {
                
                ///A view under WelcomeView that has the current header with which universities crew is open at
                HeaderText()
                    .padding(.top, 15)
                
                Spacer()
                
                ///A view under components with the crew logo and orbit adjusted, < 800 size indicates iphone mini/se
                CrewLogo()
                    .frame(width: UIScreen.main.bounds.size.height > 800 ? 263 : 197, height: UIScreen.main.bounds.size.height > 800 ? 216 : 162)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 20)
                
                ///A view under WelcomeView that has sliding horizontal text
                Marquee(text: Constants.welcomeSlidingText, font:
                        .monospacedSystemFont(ofSize: 16.0, weight: .regular))
                .padding(.bottom, 60)

                Spacer()
                
                ///A view under WelcomeView that has an animated launch button
                LiftoffButton()
                    .padding(.bottom, 25)
                
            }
        }
        //force status bar to be white tint
        .preferredColorScheme(.dark)
    }
}

// MARK: Header Text View with which universities crew is open at
struct HeaderText: View {
    
    var body: some View {
        
        Text("crew is currently live at ")
            .font(.system(size: 20.0, weight: .regular, design: .default))
            .tracking(2)
            .foregroundColor(.white)
        
        + Text("ucla")
            .font(.system(size: 20.0, weight: .bold, design: .default))
            .tracking(2)
            .foregroundColor(.white)
        
    }
}

// MARK: Animated Launch Button
struct LiftoffButton: View {
    
    // MARK: opdata indicates to go phone number view after button tapped
    @EnvironmentObject var opData:OpData
    @State private var tap = false

    var body: some View {
        VStack {
          
            Text("🚀 LIFT OFF")
                .font(.custom("ABCSocialExtended-Bold-Trial", size: 16))
                .tracking(2)
                .foregroundColor(.white)
          
        }
        .frame(width: 155, height: 50)
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1847774621, green: 0.1847774621, blue: 0.1847774621, alpha: 1)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)).opacity(tap ? 0.6 : 0.3), radius: tap ? 20 : 10, x: 0, y: tap ? 10 : 20)
        .scaleEffect(tap ? 0.8 : 1)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tap)
        .onTapGesture {
            
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            tap = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tap = false
                opData.currView = .phoneNumber
            }
        }
    }
}


// MARK: Marquee Text View
struct Marquee: View{
    
    var text: String
    // MARK: Customimazation Options
    var font: UIFont
    
    // Storing Text Size
    @State var storedSize: CGSize = .zero
    // MARK: Animation Offset
    @State var offset: CGFloat = 0
    // MARK: Updated Text
    @State var animatedText: String = ""
    
    // MARK: Animation Speed
    var animationSpeed: Double = 0.015/1.1
    var delayTime: Double = 0.0
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View{
        
        // Since it scrolls horizontal using ScrollView
        GeometryReader{proxy in
            
            let size = proxy.size
            
            let condition = textSize(text: text).width < (size.width - 50)
            
            ScrollView(condition ? .init() : .horizontal, showsIndicators: false) {
                
                Text(condition ? text : animatedText)
                    .font(Font(font))
                    .offset(x: condition ? 0 : offset)
                    .padding(.horizontal,15)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .center)
        }
        .frame(height: storedSize.height)
        // Disbaling Manual Scrolling
        .disabled(true)
        .onAppear{
            startAnimation(text: text)
        }
        // MARK: Repeating Marquee Effect with the help of Timer
        // Optional: If you want some dalay for next animation
        .onReceive(Timer.publish(every: ((animationSpeed * storedSize.width) + delayTime), on: .main, in: .default).autoconnect()) { _ in
            
            // Resetting offset to 0
            // Thus its look like its looping
            offset = 0
            withAnimation(.linear(duration: (animationSpeed * storedSize.width))){
                offset = -storedSize.width
            }
        }
        // MARK: Re-calculating text size when text is changed
        .onChange(of: text) { newValue in
            animatedText = ""
            offset = 0
            startAnimation(text: newValue)
        }
    }
    
    // MARK: Starting Animation
    func startAnimation(text: String){
        
        // MARK: Continous Text Animation
        // Adding Spacing For Continous Text
        animatedText.append(text)
        (1...15).forEach { _ in
            animatedText.append(" ")
        }
        // Stoping Animation exactly before the next text
        storedSize = textSize(text: animatedText)
        animatedText.append(text)
        
        
        // Calculating Total Secs based on Text Width
        // Our Animation Speed for Each Character will be 0.02s
        let timing: Double = (animationSpeed * storedSize.width)
        
        // Delaying FIrst Animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            withAnimation(.linear(duration: timing)){
                offset = -storedSize.width
            }
        }
    }
    
    // MARK: Fetching Text Size for Offset Animation
    func textSize(text: String)->CGSize{
        
        let attributes = [NSAttributedString.Key.font: font]
        
        let size = (text as NSString).size(withAttributes: attributes)
        
        return size
    }
}
