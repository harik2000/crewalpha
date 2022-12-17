//
//  CameraView.swift
//  crew
//
//  Created by Hari Krishna on 12/13/22.
//  CameraHelper: CameraHelper.swift contains the camera preview using the full screen with the camera model
//  as well as the stop header showing the camera title that toggles flash, as well as the search button
//  and new crew button. It addtiionally also displays a gradient rectangular progress bar when a user is recording a video

import SwiftUI
import AVFoundation

struct CameraHelper: View {
    
    @EnvironmentObject var cameraModel: CameraViewModel
    
    // MARK: lastScaleValue captures the zoom factor of camera so that gesture isn't broken
    @State var lastScaleValue: CGFloat = 1.0

    // MARK: button variable to toggle between states of tapping the search button
    @State private var tappedSearchButton = false
    // MARK: button variable to toggle between states of tapping the new crew button
    @State private var tappedNewCrewButton = false
    
    var body: some View {
        
        GeometryReader{proxy in
            let size = proxy.size
            
            // MARK: Camera Preview uses the camera model to generate the full screen camera as well as enables pinch gesture for zooming in and out
            CameraPreview(size: size)
                .environmentObject(cameraModel)
                .gesture(MagnificationGesture().onChanged { val in
                    let delta = val / self.lastScaleValue
                    self.lastScaleValue = val
                    let newScale = self.lastScaleValue * delta
                    let zoomFactor: CGFloat = min(max(newScale, 1), 5)
                    if cameraModel.camerapermission == 1 { // make sure camera permission available before gesture setting
                        cameraModel.set(zoom: zoomFactor)
                    }
                }.onEnded { val in
                    self.lastScaleValue = 1.0
                })
            
            
            VStack(alignment: .leading) {
                VStack() {
                    Rectangle()
                        .fill(.black.opacity(0.25))
                }
                .frame(height: UIScreen.main.bounds.size.height > 800 ? 111 : 10)
            }
            
            // MARK: camera title along with search and new crew button
            // camera title toggles flash on tap
            HStack {
                Text("camera")
                    .underline()
                    .font(.system(size: UIScreen.main.bounds.size.height > 800 ? 28 : 24))
                    .fontWeight(.medium)
                    .foregroundColor(cameraModel.flashOn ? Color(#colorLiteral(red: 1, green: 0.8571129441, blue: 0.009053478017, alpha: 1)) : .white)
                    .padding(.bottom, 0.05)
                    .onTapGesture {
                        cameraModel.switchFlash()
                    }
                
                Spacer()
                
                Button(action: {
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                    tappedSearchButton = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        tappedSearchButton = false
                    }
                }) {
                  Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 14)
                    .font(Font.title.weight(.regular))
                    .foregroundColor(.white)
                }
                .padding(.top, 2)
                .padding(.trailing, 18)
                .scaleEffect(tappedSearchButton ? 0.8 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedSearchButton)
                .buttonStyle(StaticButtonStyle())
                
                Button(action: {
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                    tappedNewCrewButton = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        tappedNewCrewButton = false
                    }
                }) {
                  Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 14)
                    .font(Font.title.weight(.regular))
                    .foregroundColor(.white)
                }
                .scaleEffect(tappedNewCrewButton ? 0.8 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tappedNewCrewButton)
                .buttonStyle(StaticButtonStyle())

            }
            .disabled(cameraModel.camerapermission != 1)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.top, 60)
            
            // MARK: rectangle with gradient that shows progress of video recording
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black.opacity(0.25))

                Rectangle()
                    .fill(LinearGradient(
                    gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0.8145048022, blue: 0.8413854837, alpha: 0.8470588235)), Color(#colorLiteral(red: 0.3221585751, green: 0.3056567907, blue: 0.8743923306, alpha: 0.8470588235))]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                    ))
                    .frame(width: size.width * (cameraModel.recordedDuration / cameraModel.maxDuration))
            }
            .frame(height: 8)
            .padding(.top, 111)
        }
        .onAppear(perform: cameraModel.checkPermission)
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            //start the camera session to record every 0.01 seconds for video
            if cameraModel.recordedDuration <= cameraModel.maxDuration && cameraModel.isRecording{
                cameraModel.recordedDuration += 0.01
            }
            
            //went over maximum current recording duration of 15.0 seconds
            if cameraModel.recordedDuration >= cameraModel.maxDuration && cameraModel.isRecording{
                cameraModel.stopRecording()
                cameraModel.isRecording = false
            }
        }
        //toggle between front and back camera on double tap
        .onTapGesture(count: 2) {
          if !cameraModel.isRecording {
            cameraModel.changeCamera()
          }
        }
       
    }
}


struct CameraPreview: UIViewRepresentable {
    
    @EnvironmentObject var cameraModel : CameraViewModel
    var size: CGSize
    
    //starts the camera session to start running
    func makeUIView(context: Context) ->  UIView {
     
        let view = UIView()
        cameraModel.preview = AVCaptureVideoPreviewLayer(session: cameraModel.session)
        cameraModel.preview.frame.size = size
        
        cameraModel.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraModel.preview)
        
        cameraModel.session.startRunning()

        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
