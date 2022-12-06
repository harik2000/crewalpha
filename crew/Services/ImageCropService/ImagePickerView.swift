//
//  ImagePickerView.swift
//  crew
//
//  Created by Hari Krishna on 12/5/22.
//

import SwiftUI
import CropViewController

public struct ImagePickerView: UIViewControllerRepresentable {

    private var croppingStyle = CropViewCroppingStyle.default
    private let sourceType: UIImagePickerController.SourceType
    private let onCanceled: () -> Void
    private let onImagePicked: (UIImage?) -> Void
    
    public init(croppingStyle: CropViewCroppingStyle, sourceType: UIImagePickerController.SourceType, onCanceled: @escaping () -> Void, onImagePicked: @escaping (UIImage?) -> Void) {
        self.croppingStyle = croppingStyle
        self.sourceType = sourceType
        self.onCanceled = onCanceled
        self.onImagePicked = onImagePicked
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        if croppingStyle == .circular {
            imagePicker.modalPresentationStyle = .popover
//        imagePicker.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
            imagePicker.preferredContentSize = CGSize(width: 100, height: 100)
        }
        imagePicker.sourceType = self.sourceType
        imagePicker.allowsEditing = false
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onCanceled: self.onCanceled,
            onImagePicked: self.onImagePicked
        )
    }

    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        private let onCanceled: () -> Void
        private let onImagePicked: (UIImage?) -> Void

        init(onCanceled: @escaping () -> Void, onImagePicked: @escaping (UIImage?) -> Void) {
            self.onCanceled = onCanceled
            self.onImagePicked = onImagePicked
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            
            guard let image = info[.originalImage] as? UIImage else {
                picker.dismiss(animated: true) {
                    self.onImagePicked(nil)
                }
                return
            }
            
            picker.dismiss(animated: true) {
                self.onImagePicked(image)
            }
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) {
                self.onCanceled()
            }
        }
    }
}

