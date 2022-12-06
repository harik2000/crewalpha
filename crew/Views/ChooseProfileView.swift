//
//  ChooseProfileView.swift
//  crew
//
//  Created by Hari Krishna on 12/5/22.
//  ChooseProfileView.swift lets the user choose their photo from their photo gallery
//  and crop it before presenting it, also allows the user to skip if they would like

import SwiftUI
import CropViewController 

struct ChooseProfileView: View {
    
    @StateObject var registerData = RegisterViewModel()

    var body: some View {
      
        ZStack(alignment: .top) {
            
            ///black background during sign up flow
            Color.black.ignoresSafeArea()

            VStack {

                ///allow user to skip without selecting a profile photo
                skipProfileButton()

                ///header text for profile selection screen
                profileViewMessage()

                ///image selection service for user to choose and crop profile photo from user's photo gallery
                chooseProfileImageService()

                Spacer()

                ///allow user to continue to next screen after uploading photo
                nextProfileButton()

            }

        }
        .navigationBarHidden(true)
        .onAppear{
            registerData.resetImage()
        }
    }
}

struct profileViewMessage: View {
    
    var body: some View {
        
        Text(Constants.profileHeaderText)
          .font(.custom("ABCSocial-Bold-Trial", size: 24))
          .foregroundColor(.white)
          .padding(.leading, 10)
          .fixedSize(horizontal: false, vertical: true)
          .padding(.trailing, 10)
          .multilineTextAlignment(.center)
          .padding(.bottom, 40)
          .padding(.top, UIScreen.main.bounds.size.height > 800 ? 150 : 75)
        
    }
}

struct skipProfileButton: View {
    
    @State var showEmail = false
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            NavigationLink(destination: EmailView(), isActive: $showEmail) {
                
                Text("skip")
                .font(.custom("ABCSocial-Bold-Trial", size: 22))
                .foregroundColor(.white)
                .opacity(0.5)
                .padding(.trailing, 20)
                .padding(.top, UIScreen.main.bounds.size.height > 800 ? 0 : 20)
                .onTapGesture {
                    let impactMed = UIImpactFeedbackGenerator(style: .light)
                    impactMed.impactOccurred()
                    showEmail.toggle()
                }
            }
        }
    }
}
struct nextProfileButton: View {
    
    @StateObject var registerData = RegisterViewModel()
    @State var tap = false
    @State var showEmail = false

    var body: some View {
        
        HStack {
            
            Spacer()
        
            VStack {
                HStack {
                    Text("next")
                    .foregroundColor(Color.black)
                    .font(.custom("ABCSocial-Bold-Trial", size: 20))
                    Image("arrowright")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .padding(.leading, 2)
                    .padding(.trailing, -5)
                }
            }
            .frame(width: 105, height: 50)
            .background(Color.white)
            .opacity(registerData.image_Data.count == 0 ? 0.5 : 1)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.trailing, 20)
            .padding(.bottom, 30)
            .scaleEffect(tap ? 0.8 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tap)
            .onTapGesture {

                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
                tap = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    tap = false
                        
                    if registerData.image_Data.count != 0 {
                    //go to next view
                        showEmail.toggle()
                    //registerData.upload(image!)
                    }
                }
            }
            
            NavigationLink(destination: EmailView(), isActive: $showEmail) {
                EmptyView()
            }
        }
    }
}

struct chooseProfileImageService: View {
    
    //for image picker to change profile pic
    @State var showingProfileOptions = false
    @State private var sheetIsPresented = false
      
    enum SheetType {
        case imagePick
        case imageCrop
        case share
    }

    @State private var currentSheet: SheetType = .imagePick
    @State private var croppingStyle = CropViewCroppingStyle.default
    @State private var originalImage: UIImage?
    @State private var image: UIImage?

    @StateObject var registerData = RegisterViewModel()
    
    var body: some View {
        
        ZStack {
            if registerData.image_Data.count == 0{
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color(#colorLiteral(red: 0.3705568314, green: 0.3705568314, blue: 0.3705568314, alpha: 0.8470588235)))
                .frame(width: 200, height: 200)
                .onTapGesture {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    self.showingProfileOptions = true
                }
                .overlay(
                    Image(systemName: "person.circle")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 100, height: 100)
                )
            } else {
                Image(uiImage: UIImage(data: registerData.image_Data)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .onTapGesture {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    self.showingProfileOptions = true
                }
            }

            Circle()
            .fill(.white)
            .frame(width: 50, height: 50)
            .padding(.leading, 180)
            .padding(.top, -115)
            .overlay(
                Image(systemName: "pencil")
                .resizable()
                .foregroundColor(.black)
                .frame(width: 25, height: 25)
                .padding(.leading, 180)
                .padding(.top, -104)
            )
        }
        .actionSheet(isPresented: $showingProfileOptions) {
            ActionSheet(
                title: Text("choose your profile picture"),
                buttons: [
                    .default(Text("photos")) {
                        self.sheetIsPresented = true
                    },
                    .default(Text("cancel")) {
                        showingProfileOptions = false
                    },
                ]
            )
        }
        .sheet(isPresented: $sheetIsPresented) {
            if (self.currentSheet == .imagePick) {

                ImagePickerView(croppingStyle: self.croppingStyle, sourceType: .photoLibrary, onCanceled: {               // on cancel
                }) { (image) in
                    guard let image = image else {
                        return
                    }

                    self.originalImage = image
                    DispatchQueue.main.async {
                        self.currentSheet = .imageCrop
                        self.sheetIsPresented = true
                    }
                }
            } else if (self.currentSheet == .imageCrop) {
                ZStack {
                    ImageCropView(croppingStyle: self.croppingStyle, originalImage: self.originalImage!, onCanceled: {
                        self.currentSheet = .imagePick
                        // on cancel
                    }) { (image, cropRect, angle) in
                        // on success
                        self.image = image
                        registerData.image_Data = image.pngData()!
                        self.currentSheet = .imagePick
                    }
                }
            }
        }
    }
}
