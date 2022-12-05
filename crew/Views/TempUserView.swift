//
//  TempUserView.swift
//  crew
//
//  Created by Hari Krishna on 12/2/22.
//

import SwiftUI

struct TempUserView: View {
    //registerviewmodel object to show phone number and phone code
    @StateObject var registerData = RegisterViewModel()
    
    var body: some View {
        Text("Logged in! phone number: \(registerData.phoneNumber) and phone code: \(registerData.phoneCode) and name as \(registerData.name) and birthday as \(registerData.birthday)")
            .foregroundColor(.blue)
    }
}

