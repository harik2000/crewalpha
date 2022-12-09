//
//  NotificationPermissionView.swift
//  crew
//
//  Created by Hari Krishna on 12/8/22.
//

import SwiftUI

struct NotificationPermissionView: View {
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            ///black background during sign up flow
            Color.black.ignoresSafeArea()
            
            ///notification alert dialog that prompts user for notification permission
            ///and then goes to contact screen
            notificationAlert()
            
            ///animated pointer emoji that bounces up and down
            notificationPointer()
            
            ///header text saying that crew works best with notifications
            notificationHeader()
            
        }
        .navigationBarHidden(true)
    }
}

struct notificationHeader: View {
    var body: some View {
        VStack {
            //header text telling user that crew works better with contacts
            Spacer()
            
            notificationViewMessage()
                .padding(.leading, 0)
                .padding(.trailing, 0)
                .padding(.bottom, 500)
            
            Spacer()
        }
    }
}

struct notificationAlert: View {
    
    @State var showContact = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            NavigationLink(destination: ContactsPermissionView(), isActive: $showContact) {
                EmptyView()
            }
        }
        .uniAlert(
            isShowing: .constant(true),
            content: {
                VStack {
                    Text(" \"crew\" Would Like to Send You Notifications")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.bottom, 2)
                        .padding(.top, 15)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(colorScheme == .light ? .black : .white) //dark mode
                    Text("Notifications may include alerts sounds, and icon badges. These can be configured in Settings.")
                        .font(.system(size: 18, weight: .regular))
                        .padding(.bottom, 4)
                        .foregroundColor(colorScheme == .light ? .black : .white) //dark mode
                }
                .padding(.bottom, 8)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.black)
            },
            actions: [
                .destructive(content: {
                    Text("Don't Allow")
                        .foregroundColor(Color.blue)
                        .font(.system(size: 18, weight: .regular))
                }, action: {
                    showContact.toggle()
                }),
                .regular(content: {
                    Text("Allow")
                        .foregroundColor(Color.blue)
                        .font(.system(size: 18, weight: .semibold))
                }, action:
                    {
                        let center = UNUserNotificationCenter.current()
                        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                            
                          //self.notificationDialog = true
                            if error != nil {
                                // Handle error here
                            }
                          withAnimation {
                            showContact.toggle()
                          }
                        }
                    }
                )
            ]
        )
    }
}

struct notificationPointer: View {
    
    @State var toggleAnimation = false
    @State var bounceHeight: BounceHeight? = nil

    var body: some View {
        
        VStack {
            Spacer()
            
            VStack {
                Text("☝️")
                    .font(.system(size: 80))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
            }
            .padding(8)
            .frame(width: 72, height: 72)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(radius: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 2)
            )
            .offset(y: bounceHeight?.associatedOffset ?? 0)
            .offset(x: 75)
            .onChange(of: toggleAnimation) { newValue in
                bounceAnimation()
            }
            
            Spacer()
        }
        .padding(.top, UIScreen.main.bounds.size.height * 0.45)
        .onAppear {
            for i in 0...1000 {
                DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 1.5)) {
                    toggleAnimation.toggle()
                }
            }
        }
    }
    
    func bounceAnimation() {
        withAnimation(Animation.easeOut(duration: 0.3).delay(0)) {
            bounceHeight = .up100
        }
        withAnimation(Animation.easeInOut(duration: 0.04).delay(0)) {
            bounceHeight = .up100
        }
        withAnimation(Animation.easeIn(duration: 0.3).delay(0.34)) {
            bounceHeight = .base
        }
        withAnimation(Animation.easeOut(duration: 0.2).delay(0.64)) {
            bounceHeight = .up40
        }
        withAnimation(Animation.easeIn(duration: 0.2).delay(0.84)) {
            bounceHeight = .base
        }
        withAnimation(Animation.easeOut(duration: 0.1).delay(1.04)) {
            bounceHeight = .up10
        }
        withAnimation(Animation.easeIn(duration: 0.1).delay(1.14)) {
            bounceHeight = .none
        }
    }
    
}

struct notificationViewMessage: View {
    
    var body: some View {
        
        Text(Constants.notificationHeaderText)
          .font(.custom("ABCSocial-Bold-Trial", size: 24))
          .foregroundColor(.white)
          .padding(.leading, 0)
          .fixedSize(horizontal: false, vertical: true)
          .padding(.trailing, 0)
          .multilineTextAlignment(.center)
          .padding(.bottom, 10)
          .padding(.top, UIScreen.main.bounds.size.height > 800 ? 120 : 75)
        
    }
}


extension View {

    func uniAlert<Content>(
        isShowing: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content,
        actions: [UniAlertButton]
    ) -> some View where Content: View {
        UniAlert(
            isShowing: isShowing,
            displayContent: content(),
            buttons: actions,
            presentationView: self
        )
    }
}

struct UniAlert<Presenter, Content>: View where Content: View, Presenter: View {
    
    @Binding private (set) var isShowing: Bool
    
    let displayContent: Content
    let buttons: [UniAlertButton]
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var backgroundColor: Color = Color.black
    var contentBackgroundColor: Color = Color.white
    var contentPadding: CGFloat = 16
    var contentCornerRadius: CGFloat = 12.5
    let presentationView: Presenter

    private var requireHorizontalPositioning: Bool {
        let maxButtonPositionedHorizontally = 2
        return buttons.count > maxButtonPositionedHorizontally
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                presentationView.disabled(isShowing)

                backgroundColorView()
                let expectedWidth = geometry.size.width * 0.631
                VStack(spacing: 0) {
                    VStack {
                        displayContent
                        
                    }
                    .padding(.leading, contentPadding)
                    .padding(.trailing, contentPadding)
                    buttonsPad(expectedWidth)
                }
                .background(colorScheme == .light ? contentBackgroundColor : Color(#colorLiteral(red: 0.1891054511, green: 0.1841467917, blue: 0.1885398924, alpha: 0.85)))
                .cornerRadius(contentCornerRadius)
                .shadow(radius: 1)
                .padding(.top, 10)
                .opacity(self.isShowing ? 1 : 0)
                .frame(
                    minWidth: expectedWidth,
                    maxWidth: expectedWidth
                )
                .background(Color.clear)
                .animation(.easeInOut, value: isShowing)
            }
            .edgesIgnoringSafeArea(.all)
            .zIndex(Double.greatestFiniteMagnitude)
            .padding(.top, 0)
        }
    }
    
    private func backgroundColorView() -> some View {
        backgroundColor
            .edgesIgnoringSafeArea(.all)
            .opacity(self.isShowing ? 0.8 : 0)
    }
    
    private func buttonsPad(_ expectedWidth: CGFloat) -> some View {
        VStack {
            if requireHorizontalPositioning {
                verticalButtonPad()
                    .padding([.bottom], 12)
            } else {
                horizontalButtonsPadFor(expectedWidth)
                    
            }
        }
        //.background(Color.blue)
    }
    
    private func verticalButtonPad() -> some View {
        VStack {
            ForEach(0..<buttons.count, id: \.self) {
                Divider()
                    .padding([.leading, .trailing], -contentPadding)
                let current = buttons[$0]
                Button(action: {
                    current.action()
                    withAnimation {
                        self.isShowing.toggle()
                    }
                }, label: {
                    current.content.frame(height: 30)
                })
            }
        }
    }
    
    private func horizontalButtonsPadFor(_ expectedWidth: CGFloat) -> some View {
        VStack {
            Divider()
                .padding([.leading, .trailing], -contentPadding)
            HStack {
                let sidesOffset = contentPadding * 2
                let maxHorizontalWidth = expectedWidth - sidesOffset
                Spacer()
                ForEach(0..<buttons.count, id: \.self) {
                    Spacer()
                    if $0 != 0 {
                        Divider().frame(height: 50)
                            .padding(.top, -8)
                            .padding(.bottom, -12)
                    }
                    let current = buttons[$0]
                    Button(action: {
                        current.action()
                        withAnimation {
                            self.isShowing.toggle()
                        }
                    }, label: {
                        current.content.frame(height: 25)
                            .multilineTextAlignment(.center)
                    })
                    .frame(maxWidth: maxHorizontalWidth, minHeight: 30)
                    .background(
                            
                        Rectangle()
                            .fill(colorScheme == .light ? Color(#colorLiteral(red: 0.02032593824, green: 0.6649320722, blue: 0.9497163892, alpha: 0.85)) : Color(#colorLiteral(red: 0, green: 0.3349497914, blue: 0.6118904352, alpha: 0.85)))
                            .cornerRadius(12.5, corners: [.bottomRight])
                            .padding(-7)
                            .padding(.top, -1.5)
                            .padding(.leading, -0.75)
                            .padding(.trailing, -1.5)
                            .opacity(current.isDestructive ? 0 : 1)

                    )
                    .onAppear {
                        print("button is \(buttons.count) and current is \(current.isDestructive)")
                    }
                }
                
                Spacer()
            }
            .padding([.bottom], 7)
            
        }
    }
}

struct UniAlertButton {
    
    enum Variant {
        
        case destructive
        case regular
    }
    
    let content: AnyView
    let action: () -> Void
    let type: Variant
    
    var isDestructive: Bool {
        type == .destructive
    }
    
    static func destructive<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        action: @escaping () -> Void
    ) -> UniAlertButton {
        UniAlertButton(
            content: content,
            action: action,
            type: .destructive)
    }
    
    static func regular<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        action: @escaping () -> Void
    ) -> UniAlertButton {
        UniAlertButton(
            content: content,
            action: action,
            type: .regular)
    }
    
    private init<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        action: @escaping () -> Void,
        type: Variant
    ) {
        self.content = AnyView(content())
        self.type = type
        self.action = action
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


enum BounceHeight {
case up100, up40, up10, base
var associatedOffset: Double {
    switch self {
    case .up100:
        return -65
    case .up40:
        return -30
    case .up10:
        return -10
    case .base:
        return 0
    }
}
}
