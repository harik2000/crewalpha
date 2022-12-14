//
//  MainCameraView.swift
//  crew
//
//  Created by Hari Krishna on 12/13/22.
//

import SwiftUI
import AVKit
import CropViewController



struct MainCameraView: View {

  @StateObject var cameraModel = CameraViewModel()

  @State var longPressTimer: Timer?
  
  @State var tapSearch = false
  @State var tapCompose = false
  @State var isClicked = false

  
  @GestureState var longPress = false
  @GestureState var longDrag = false
  
  //for image picker to upload a pic
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
  
  

    var body: some View {
      
        ZStack() {
            // MARK: Camera View
            
            
          
          //disable this to make it work on simulator
          CameraView().environmentObject(cameraModel).ignoresSafeArea()
          
          
              
              


            // MARK: Controls
            ZStack{
              // 2.
              let longPressGestureDelay = DragGesture(minimumDistance: 0)
                  .updating($longDrag) { currentstate, gestureState, transaction in
                          gestureState = true
                  }
              .onEnded { value in
                  print(value.translation) // We can use value.translation to see how far away our finger moved and accordingly cancel the action (code not shown here)
                  print("long press action goes here")
                  //self.bgColor = self.dataRouter.darkButton
                cameraModel.stopRecording()
              }

              let shortPressGesture = LongPressGesture(minimumDuration: 0)
              .onEnded { _ in
                  print("short press goes here")
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
                 // self.bgColor = self.dataRouter.lightButton
                cameraModel.startRecording()
              }

              let tapBeforeLongGestures = longTapGesture.sequenced(before:longPressGestureDelay).exclusively(before: shortPressGesture)
              ZStack {
                ZStack {
                  Text("9")
                    .frame(width: 150, height: 150)
                    .background(Color.white)
                    .opacity(0.0001)
                    .gesture(tapBeforeLongGestures)
                    .disabled(cameraModel.showPreview)
                }
                ZStack {
                
                  Circle()
                      .fill(cameraModel.isRecording ? .red : .white)
                      .frame(width: 35, height: 35)
                    
                  Circle()
                    .stroke(cameraModel.isRecording ? .red : .white, lineWidth: 4)

                  }.frame(width: 70, height: 70)
                
                
              }
              
                 
              Button(action: {
                self.sheetIsPresented = true
                
              }) {
                VStack {
                  
                  Image(systemName: "photo.on.rectangle.angled")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(.white))
                    

                  
                }.frame(width: 100, height: 100)
              }.frame(maxWidth: .infinity,alignment: .center)
                .padding(.trailing, 200)
               // .padding(.trailing)

              Button(action: {
                //self.sheetIsPresented = true
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
                    

                  
                }.frame(width: 100, height: 100)
              }.frame(maxWidth: .infinity,alignment: .center)
                .padding(.leading, 200)
              
                // Preview Button
                Button {
                    if let _ = cameraModel.previewURL{
                      var avAsset = AVURLAsset(url: cameraModel.previewURL!, options: nil)
                      var imageGenerator = AVAssetImageGenerator(asset: avAsset)
                      imageGenerator.appliesPreferredTrackTransform = true
                      var thumbnail: UIImage?

                      do {
                          thumbnail = try UIImage(cgImage: imageGenerator.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: 1), actualTime: nil))
                        print("generated thumbnail")
                      } catch let e as NSError {
                          print("Error: \(e.localizedDescription)")
                      }
                      
                        cameraModel.showPreview.toggle()
                      
                    }
                } label: {
                    Group{
                        if cameraModel.previewURL == nil && !cameraModel.recordedURLs.isEmpty{
                            // Merging Videos
                            ProgressView()
                                .tint(.black)
                        }
                        else{
                          if let _ = cameraModel.previewURL{
                              //cameraModel.showPreview.toggle()
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
        .onAppear{
         
      
          
          
          cameraModel.restartSession()
          
//          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            if currentTab == "Camera" && !cameraModel.session.isRunning {
//              cameraModel.restartSession()
//            }
//          }
          
        }
//        .onDisappear{
//          if cameraModel.camerapermission == 1 && cameraModel.session.isRunning {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//
//              if currentTab != "Camera" {
//                cameraModel.stopSession()
//              }
//            }
//          }
//
//        }
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
                Color("imagecropcolor").edgesIgnoringSafeArea(.all)
                ImageCropView(croppingStyle: self.croppingStyle, originalImage: self.originalImage!, onCanceled: {
                    self.currentSheet = .imagePick
                    // on cancel
                }) { (image, cropRect, angle) in
                    // on success
                    self.image = image
                  self.userSelectedImage = image.pngData()!
                  self.showNewPost.toggle()
                 // cameraModel.showPreview.toggle()
                    //userData.updateProfilePic(image)
                   // registerData.image_Data = image.pngData()!
                    self.currentSheet = .imagePick
                }
            }
          }
          
        }
      
        .fullScreenCover(isPresented: $cameraModel.showPreview, content: {
          if let url = cameraModel.previewURL {
            if let thumbnailData = cameraModel.thumbnailData {
            
              //TODO: New Post View with camera video from old code
            }
          }
          
          if let photoData = cameraModel.picData {
              
            if photoData.count != 0 {
                //TODO: New Post View with camera photo from old code

            }
           
          }
          

          
        })
        .fullScreenCover(isPresented: $showNewPost, content: {
          
            if let image = image {
                //TODO: New Post View with photo gallery photo from old code

            }
        })
      
        
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


