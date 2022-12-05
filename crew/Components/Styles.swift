//
//  Styles.swift
//  crew
//
//  Created by Hari Krishna on 12/1/22.
//

import SwiftUI

// MARK: textfield modifier for color, alignment, and fontsize used in textfield input during sign up/login
struct customViewModifier: ViewModifier {
    
    var textColor: Color
    var alignment: TextAlignment
    var fontSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(.all, 10)
            .background(
                RoundedRectangle(
                    cornerRadius: 10,
                    style: .continuous
                )
                .fill(Color(#colorLiteral(red: 0.1777858436, green: 0.1777858436, blue: 0.1777858436, alpha: 0.8470588235)))
            )
            .foregroundColor(textColor)
            .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color(#colorLiteral(red: 0.3705568314, green: 0.3705568314, blue: 0.3705568314, alpha: 0.8470588235)), lineWidth: 1))
            .font(.custom("ABCSocial-Bold-Trial", size: fontSize))
            .multilineTextAlignment(alignment)
    }
}

// MARK: button modifier to scale in and out used in error handler during sign up/login
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
