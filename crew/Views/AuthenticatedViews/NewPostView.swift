//
//  NewPostView.swift
//  crew
//
//  Created by Hari Krishna on 12/14/22.
//

import SwiftUI

struct NewPostView: View {
    
    // MARK: presentation mode handles navigation back to camera view when user dismisses sending a new post
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    // MARK: below variables are for the passed in media type from user when sending a new post
    // url contains a url to the video that the user recorded from the camera view < 15 sec
    // photo data contains the photo image data that the user either took from camera or from the photo gallery
    // thumbnail data contains the initial frame for the thumbnail to be used for the video preview
    var url: URL
    var photoData: Data
    var thumbnailData: Data
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("new post").foregroundColor(Color.black)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
            }
        }
    }
}
