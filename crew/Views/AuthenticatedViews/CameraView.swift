//
//  CameraView.swift
//  crew
//
//  Created by Hari Krishna on 12/13/22.
//  CameraView: CameraView.swift contains the camera that users use to take photos and record videos
//  to send to crews that they're a part of, the camera title toggles the camera flash icon
//  and there are search and new crew icons as well for users to access within the camera view

import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @EnvironmentObject var cameraModel: CameraViewModel
    
    // MARK: lastScaleValue captures the zoom factor of camera so that gesture isn't broken
    @State var lastScaleValue: CGFloat = 1.0

    var body: some View {
        
        GeometryReader{proxy in
            let size = proxy.size
            
            CameraPreview(size: size)
                .environmentObject(cameraModel)
                .gesture(MagnificationGesture().onChanged { val in
                    let delta = val / self.lastScaleValue
                    self.lastScaleValue = val
                    let newScale = self.lastScaleValue * delta
                    let zoomFactor: CGFloat = min(max(newScale, 1), 5)
                    cameraModel.set(zoom: zoomFactor)
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
            
            HStack {
                Text("camera")
                    .underline()
                    .font(.system(size: UIScreen.main.bounds.size.height > 800 ? 28 : 24))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.bottom, 0.05)
                
                Spacer()
                
                Button(action: {
                  let impactMed = UIImpactFeedbackGenerator(style: .soft)
                  impactMed.impactOccurred()
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
                
                Button(action: {
                  let impactMed = UIImpactFeedbackGenerator(style: .soft)
                  impactMed.impactOccurred()
                }) {
                  Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 14)
                    .font(Font.title.weight(.regular))
                    .foregroundColor(.white)
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.top, 60)
        }
        .onAppear(perform: cameraModel.checkPermission)
    }
}


struct CameraPreview: UIViewRepresentable {
    
    @EnvironmentObject var cameraModel : CameraViewModel
    var size: CGSize
    
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
