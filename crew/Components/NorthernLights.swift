//
//  NorthernLights.swift
//  crew
//
//  Created by Hari Krishna on 11/29/22.
//  NorthernLights.swift has 4 moving gradient circles for the initial WelcomeView.swift

import SwiftUI

struct Cloud: View {
    @StateObject var provider = CloudProvider()
    @State var move = false
    let proxy: GeometryProxy
    let color: Color
    let rotationStart: Double
    let duration: Double
    let alignment: Alignment

    var body: some View {
        Circle()
            .fill(color)
            .offset(provider.offset)
            .rotationEffect(.init(degrees: move ? rotationStart : rotationStart + 360) )
            .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false), value: move)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .onAppear {
                move.toggle()
            }
    }
}
struct NorthernLights: View {
    @Environment(\.colorScheme) var scheme
    let blur: CGFloat = 60

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Theme.generalBackground
                ZStack {
                    Cloud(proxy: proxy,
                          color: Theme.ellipsesBottomTrailing(forScheme: scheme),
                          rotationStart: 0,
                          duration: 60/15,
                          alignment: .bottomTrailing)
                    Cloud(proxy: proxy,
                          color: Theme.ellipsesTopTrailing(forScheme: scheme),
                          rotationStart: 240,
                          duration: 50/15,
                          alignment: .topTrailing)
                    Cloud(proxy: proxy,
                          color: Theme.ellipsesBottomLeading(forScheme: scheme),
                          rotationStart: 120,
                          duration: 80/15,
                          alignment: .bottomLeading)
                    Cloud(proxy: proxy,
                          color: Theme.ellipsesTopLeading(forScheme: scheme),
                          rotationStart: 180,
                          duration: 70/15,
                          alignment: .topLeading)
                  
                }
                .blur(radius: blur)
              
              
            }
            .ignoresSafeArea()
        }
    }
}
class CloudProvider: ObservableObject {
    let offset: CGSize
    let frameHeightRatio: CGFloat
 
    init() {
        frameHeightRatio = CGFloat.random(in: 0.7 ..< 1.4)
        offset = CGSize(width: CGFloat.random(in: -150 ..< 150),
                        height: CGFloat.random(in: -150 ..< 150))
    }
}
struct Theme {
    static var generalBackground: Color {
        Color(#colorLiteral(red: 0.1649651527, green: 0.4884144068, blue: 0.8743425012, alpha: 1))
        
    }

    static func ellipsesTopLeading(forScheme scheme: ColorScheme) -> Color {
        Color(#colorLiteral(red: 0, green: 0.7229090333, blue: 0.8806269765, alpha: 1))
    }
    
    static func ellipsesTopTrailing(forScheme scheme: ColorScheme) -> Color {
        Color(#colorLiteral(red: 0, green: 0.8190268874, blue: 0.880504787, alpha: 1))
    }

    static func ellipsesBottomTrailing(forScheme scheme: ColorScheme) -> Color {
        Color(#colorLiteral(red: 0.3217363954, green: 0.3130704463, blue: 0.8450446725, alpha: 1))
    }

    static func ellipsesBottomLeading(forScheme scheme: ColorScheme) -> Color {
        Color(#colorLiteral(red: 0.1884640753, green: 0.4745456576, blue: 0.8775883317, alpha: 1))
    }
    
}
