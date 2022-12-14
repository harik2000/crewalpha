//
//  SelectedCrewView.swift
//  crew
//
//  Created by Hari Krishna on 12/13/22.
//  SelectedCrewView: Contains the current space icon to go the side menu view along with the
//  default meme crew name that ucla students join when they sign up with a scenic square photo header
//  at the top right

import SwiftUI

struct SelectedCrewView: View {
    @Binding var currentFloatIndex: CGFloat
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                HStack {
                    
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.clear)
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0.8145048022, blue: 0.8413854837, alpha: 0.8470588235)), Color(#colorLiteral(red: 0.3221585751, green: 0.3056567907, blue: 0.8743923306, alpha: 0.8470588235))]), startPoint: .trailing, endPoint: .leading).mask(
                            Image("crew")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 22)
                                .font(Font.title.weight(.regular))
                                .foregroundColor(.white)
                            )
                    )
                    .padding(.leading, 10)
                    .onTapGesture {
                        if currentFloatIndex == 0.0 {
                            currentFloatIndex = 1.0
                        } else if currentFloatIndex == 1.0 {
                            currentFloatIndex = 0.0
                        }
                    }
                    
                    Text("ucla memes for sick af teens")
                        .font(.system(size: UIScreen.main.bounds.size.height > 800 ? 28 : 24))
                        .underline()
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .frame(width: 0.7 * UIScreen.main.bounds.size.width, alignment: .leading)
                        .padding(.leading, 2)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    Image("ucla")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 40, height: 40)
                      .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                      .padding(.trailing, 20)

                }
                
                Spacer()
            }
            
        }
        .onTapGesture {
            if currentFloatIndex == 0.0 {
                currentFloatIndex = 1.0
            }
        }
    }
}
