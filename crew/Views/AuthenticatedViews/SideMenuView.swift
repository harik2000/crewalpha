//
//  CrewSideMenuView.swift
//  crew
//
//  Created by Hari Krishna on 12/13/22.
//  SideMenuView: side menu view currently has the title "crews" which will eventually list the crews that a user is a part of
//  the user can swipe back and forth from the selected crew view as well as tap on the space star icon to go back to the
//  selected crew view if they're currently on the side menu view

import SwiftUI

struct SideMenuView: View {
    //width and height used for rectangle border between crew side menu and selected crew view
    var height = UIScreen.main.bounds.height
    var width = UIScreen.main.bounds.width
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            //MARK: vertical rectangle that separates the crew side menu and selected crew view
            HStack {
                Spacer()
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 15, height: height)
            }
            
            //MARK: list of crews that user is in with title "crews"
            VStack {
                HStack {
                    Text("crews")
                        .font(.system(size: UIScreen.main.bounds.size.height > 800 ? 28 : 24))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        .padding(.top, !UIDevice.current.hasNotch ? 50 : 60)
                    
                    Spacer()
                }
                Spacer()
            }
            .offset(x: 60)
        }
    }
}
