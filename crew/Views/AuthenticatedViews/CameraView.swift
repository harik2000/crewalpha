//
//  MainCameraView.swift
//  crew
//
//  Created by Hari Krishna on 12/13/22.
//  CameraView: CameraView.swift contains the camera that users use to take photos and record videos
//  to send to crews that they're a part of, the camera title toggles the camera flash icon
//  and there are search and new crew icons as well for users to access within the camera view

import SwiftUI
import AVKit
import CropViewController

struct CameraView: View {
    // MARK: currentFloatIndex is a binding variable passed from the home view which indicates which view (0: side menu, 1: selected crew, 2: camera, 3: user profile)
    @Binding var currentFloatIndex: CGFloat

    // MARK: cameraModel makes use of the view model to handle the necessary camera functionality
    @StateObject var cameraModel = CameraViewModel()

    // MARK: below variables are to register both a tap for photo click as well as press for video recording
    // drag to make sure that users can stray away from the shutter button to record but the recording stops when
    // they let go of their finger on the camera view
    @GestureState var longPress = false
    @GestureState var longDrag = false
    
    // MARK: below variables are for image picker sheet whe nuser selects an image from their photo gallery
    @State private var showingProfileOptions = false
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
    @State private var showNewPost = false
    @State private var userSelectedImage = Data(count: 0)

    @State var timeRemaining = 1.0
    @State var isTimerRunning = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        
        // MARK: Camera View
        ZStack {
            Color.black.ignoresSafeArea()
            
            //disable this to make it work on simulator
            CameraHelper().environmentObject(cameraModel).ignoresSafeArea()
          
            if cameraModel.camerapermission != 1 {
                cameraErrorBanner(signUpErrorHeaderText: Constants.cameraErrorHeaderText, signUpErrorSubHeaderText: Constants.cameraErrorSubHeaderText)
            }
            // MARK: camera controls with photo gallery button shutter button and switch camera button
            if cameraModel.camerapermission == 1 { //show the controls if successfully have permissions
                makeCameraControls()
            }
        }
        // MARK: below functions add a timer to count down from one second every time user leaves camera view to smoothly stop user camera session
        .onReceive(timer) { _ in
            if self.isTimerRunning {
                if timeRemaining > 0 {
                    timeRemaining -= 0.5
                } else if timeRemaining <= 0.0 {
                    self.stopTimer()
                    self.isTimerRunning = false
                    if currentFloatIndex != 2 {
                        cameraModel.stopSession()
                    }
                }
            }
        }
        .onAppear{
            cameraModel.restartSession()
            self.stopTimer()
        }
        .onChange(of: currentFloatIndex) { newValue in
            if newValue == 2 {
                if !cameraModel.session.isRunning {
                    self.stopTimer()
                    self.isTimerRunning = false
                    cameraModel.restartSession()
                } else { // reset the timer back if user swipes back into camera view while camera session is running
                    self.timeRemaining = 1.0
                    self.stopTimer()
                    self.isTimerRunning = false
                }
            } else if newValue != 2 && cameraModel.session.isRunning {
                if !self.isTimerRunning {
                    self.timeRemaining = 1.0
                    self.startTimer()
                    self.isTimerRunning = true
                }
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
          if (self.currentSheet == .imagePick) {
            ImagePickerView(croppingStyle: self.croppingStyle, sourceType: .photoLibrary, onCanceled: {
                // on cancel
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
                    self.userSelectedImage = image.pngData()!
                    self.showNewPost.toggle()
                    self.currentSheet = .imagePick
                }
            }
          }
        }
        .fullScreenCover(isPresented: $cameraModel.showPreview, content: {
          if let url = cameraModel.previewURL {
            if let thumbnailData = cameraModel.thumbnailData {
                // MARK: toggle new post view and stop the camera session on appear with the user taken camera video
                // restart once it's done and reset the video url all back to initial state
                NewPostView(url: url, photoData: Data(count: 0), thumbnailData: thumbnailData)
                    .onAppear{
                        cameraModel.stopSession()
                    }
                    .onDisappear{
                        cameraModel.restartSession()
                        cameraModel.recordedDuration = 0
                        cameraModel.previewURL = nil
                        cameraModel.recordedURLs.removeAll()
                    }
            }
          }
          if let photoData = cameraModel.picData {
            if photoData.count != 0 {
                // MARK: toggle new post view and stop the camera session on appear with the user taken camera photo
                // restart once it's closed along with resetting the camera's current take
                NewPostView(url: URL(string: "http://www.example.com/image.jpg")!, photoData: photoData, thumbnailData: Data(count: 0))
                    .onAppear {
                        cameraModel.stopSession()
                    }
                    .onDisappear {
                        cameraModel.restartSession()
                        cameraModel.reTake()
                    }
            }
          }
        })
        .fullScreenCover(isPresented: $showNewPost, content: {
            if image != nil {
                // Mark: toggle new post view and stop the camera session on appear with user selected image from photo gallery
                // restart once it's closed along with resetting the user selected image
                NewPostView(url: URL(string: "http://www.example.com/image.jpg")!, photoData: userSelectedImage, thumbnailData: Data(count: 0))
                    .onAppear {
                        cameraModel.stopSession()
                    }
                    .onDisappear {
                        cameraModel.restartSession()
                        self.userSelectedImage = Data(count: 0)
                    }
            }
        })
    }
    
    func makeCameraControls() -> some View {
        // MARK: Controls
        ZStack {
            
            // MARK: below handles logic for taking a picture as well as show the flash for a second
            let longPressGestureDelay = DragGesture(minimumDistance: 0)
            .updating($longDrag) { currentstate, gestureState, transaction in
                gestureState = true
            }
            .onEnded { value in
                //user has let go of finger on camera so stop recording and show the recorded video preview
                cameraModel.stopRecording()
            }

            // MARK: below handles logic for taking a picture as well as show the flash for a second
            let shortPressGesture = LongPressGesture(minimumDuration: 0)
            .onEnded { _ in
                if cameraModel.isRecording {
                    cameraModel.stopRecording()
                } else {
                    cameraModel.takePic()
                    if cameraModel.flashOn {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            cameraModel.showPreview.toggle()
                        }
                    } else {
                        cameraModel.showPreview.toggle()
                    }
                }
            }

            let longTapGesture = LongPressGesture(minimumDuration: 0.25)
              .updating($longPress) { currentstate, gestureState, transaction in
                  gestureState = true
            }
            .onEnded { _ in
                cameraModel.startRecording()
            }

            // MARK: below handles the shutter button along with the tap gesture to
            // take a photo and long press gesture to start and stop recording
            // create a big transparent rectangle to have a wider frame for shutter
            let tapBeforeLongGestures = longTapGesture.sequenced(before:longPressGestureDelay).exclusively(before: shortPressGesture)
            ZStack {
                ZStack {
                    Rectangle()
                    .frame(width: 150, height: 150)
                    .background(Color.white)
                    .opacity(0.0001)
                    .highPriorityGesture(tapBeforeLongGestures)
                    .disabled(cameraModel.showPreview)
                }
                
                ZStack {
                    Circle()
                    .fill(cameraModel.isRecording ? .red : .white)
                    .frame(width: 35, height: 35)

                    Circle()
                    .stroke(cameraModel.isRecording ? .red : .white, lineWidth: 4)

                }
                .frame(width: 70, height: 70)
            }
          
            // MARK: button to present photo gallery sheet for user to select from
            Button(action: {
                self.sheetIsPresented = true
            }) {
                VStack {
                  
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color(.white))
    
                }
                .frame(width: 100, height: 100)
            }
            .frame(maxWidth: .infinity,alignment: .center)
            .padding(.trailing, 200)

            // MARK: button to toggle between front and back camera
            Button(action: {
                if !cameraModel.isRecording {
                    cameraModel.changeCamera()
                }
            }) {
                VStack {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 28, height: 28)
                        .foregroundColor(Color(.white))
                }
                .frame(width: 100, height: 100)
            }
            .frame(maxWidth: .infinity,alignment: .center)
            .padding(.leading, 200)
          
            // Preview Button to handle video url
            Button {
                if let _ = cameraModel.previewURL{
                    let avAsset = AVURLAsset(url: cameraModel.previewURL!, options: nil)
                    let imageGenerator = AVAssetImageGenerator(asset: avAsset)
                    imageGenerator.appliesPreferredTrackTransform = true
                    var thumbnail: UIImage?

                    do {
                        thumbnail = try UIImage(cgImage: imageGenerator.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: 1), actualTime: nil))
                        print("generated thumbnail \(String(describing: thumbnail))")
                    } catch let e as NSError {
                        print("Error: \(e.localizedDescription)")
                    }
                  
                    cameraModel.showPreview.toggle()
                }
            } label: {
                // MARK: below group creates the preview url for an instant after the user stops recording
                Group {
                    if cameraModel.previewURL == nil && !cameraModel.recordedURLs.isEmpty{
                    // Merging Videos
                        ProgressView()
                            .tint(.black)
                    }
                    else{
                        if let _ = cameraModel.previewURL{
                            Label {
                                Image(systemName: "camera.aperture")
                                .font(.callout).foregroundColor(.white)
                            } icon: {
                                Text("")
                                .onAppear{
                                    cameraModel.showPreview.toggle()
                                }
                            }
                            .foregroundColor(.black)
                        } else {
                            Label {
                                Image(systemName: "chevron.right")
                                .font(.callout)
                            } icon: {
                                Text("loading ... ")
                            }
                            .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal,20)
                .padding(.vertical,8)
            }
            .frame(maxWidth: .infinity,alignment: .trailing)
            .padding(.trailing)
            .opacity((cameraModel.previewURL == nil && cameraModel.recordedURLs.isEmpty) || cameraModel.isRecording ? 0 : 1)
        }
        .padding(.bottom, 30)
        .frame(maxHeight: .infinity,alignment: .bottom)
    }
    
    // MARK: stops the timer once it's started to count down from 1 second after leaving the camera view
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    // MARK: starts the timer once uesr has left the camera view and resets every time user enters the camera view
   func startTimer() {
       self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
   }
}

// MARK: Final Video Preview
extension View {
    func onTouchDownGesture(callback: @escaping () -> Void) -> some View {
        modifier(OnTouchDownGestureModifier(callback: callback))
    }
}

private struct OnTouchDownGestureModifier: ViewModifier {
    @State private var tapped = false
    let callback: () -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !self.tapped {
                        self.tapped = true
                        self.callback()
                    }
                }
                .onEnded { _ in
                    self.tapped = false
                })
    }
}


// MARK: Error handler for Camera and opens settings to allow user to give access to camera and micorphone before proceeding
struct cameraErrorBanner: View {
        
    //error message header and subheader text
    var signUpErrorHeaderText: String
    var signUpErrorSubHeaderText: String
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(signUpErrorHeaderText)
                            .foregroundColor(Color.white)
                            .font(.custom("ABCSocialExtended-Bold-Trial", size: 20))
                            .tracking(2)
                            .padding(.bottom, 5)

                        Text(signUpErrorSubHeaderText)
                            .foregroundColor(Color.white)
                            .font(.custom("ABCSocialExtended-Bold-Trial", size: 12))
                            .tracking(2)
                            .opacity(0.75)
                            .padding(.bottom, 15)
                    }
                    
                    Spacer()
                }
               
            
                Button(action: {
                    
                    let impactMed = UIImpactFeedbackGenerator(style: .light)
                    impactMed.impactOccurred()
                    self.settingsOpener()
                    
                }) {
                    HStack {
                        Text("open settings")
                        .font(.custom("ABCSocialExtended-Bold-Trial", size: 16))
                        .tracking(2)
                    }
                    .padding(.all, 10)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 10,
                            style: .continuous
                        )
                        .fill(Color.white)
                    )
                }
                .buttonStyle(ScaleButtonStyle())
          }
          .padding()
          .padding(.top, 5)
          .padding(.bottom, 5)
          .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0.8145048022, blue: 0.8413854837, alpha: 0.8470588235)), Color(#colorLiteral(red: 0.3221585751, green: 0.3056567907, blue: 0.8743923306, alpha: 0.8470588235))]), startPoint: .topTrailing, endPoint: .bottomLeading))
          .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
          .padding(.bottom, 150)
            
        }.padding(.leading, 10)
        .padding(.trailing, 10)
        .padding(.top, 50)
        .transition(.move(edge: .trailing))
        .zIndex(1)
    }
    
    private func settingsOpener(){
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
