//
//  Camera+PhotoLibrary.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 01/06/17.
//
//

import UIKit
import MobileCoreServices

class Camera {
    
    var delegate: (UINavigationControllerDelegate & UIImagePickerControllerDelegate)?
    
    init(delegate_: UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
        delegate = delegate_
    }
    
    func presentPhotoLibrary(target: UIViewController, canEdit: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            
            return
        }
        
        let type = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            imagePicker.sourceType = .photoLibrary
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                
                if (availableTypes as NSArray).contains(type) {
                    
                    imagePicker.mediaTypes = [type]
                    imagePicker.allowsEditing = canEdit
                }
            }
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            
            imagePicker.sourceType = .savedPhotosAlbum
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                
                if (availableTypes as NSArray).contains(type) {
                    
                    imagePicker.mediaTypes = [type]
                }
                
            }
        } else {
            
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.delegate = delegate
        target.present(imagePicker, animated: true, completion: nil)
    }
    
    func presentPhotoCamera(target: UIViewController, canEdit: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            return
        }
        
        let type1 = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                
                if (availableTypes as NSArray).contains(type1) {
                    
                    imagePicker.mediaTypes = [type1]
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                }
            }
            
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                
                imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.rear
                
            } else if UIImagePickerController.isCameraDeviceAvailable(.front) {
                
                imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.front
            }
            
        } else {
            
            return
        }
        imagePicker.allowsEditing = canEdit
        imagePicker.showsCameraControls = true
        imagePicker.delegate = delegate
        target.present(imagePicker, animated: true, completion: nil)
    }
}


/*
 //FIXME:- Example
 
 
 let camera = Camera(delegate_: VirtualTryOnVC() as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
 
 camera.presentPhotoLibrary(target: self, canEdit: true)

 */













