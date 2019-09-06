/** This is custom made class which initialize the default image picker with third party cropper.
 
 Cropper used
 URL :- https://github.com/sprint84/PhotoCropEditor
 
 */
import UIKit
import AVFoundation

public protocol CustomImagePickerProtocol {
    func didFinishPickingImage(image:UIImage)
    func didCancelPickingImage()
}

public class CustomImagePicker: NSObject {
    
    public var viewController:UIViewController?
    public var delegate:CustomImagePickerProtocol!
    
    
    /**
     This function will present the custom image picker.
     */
    
    public func openImagePickerOn(_ controller:UIViewController) {
        self.viewController = controller
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraBtnTitle = localizedTextFor(key: CustomImagePickerText.openCamera.rawValue)
        
        let galleryBtnTitle = localizedTextFor(key: CustomImagePickerText.openGallery.rawValue)
        
        let cameraBtn = UIAlertAction(title:cameraBtnTitle , style: .default) { (action) in
            
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                self.openCamera()
            }
            else if AVCaptureDevice.authorizationStatus(for: .video) ==  .denied {
                CustomAlertController.sharedInstance.showAlert(subTitle: localizedTextFor(key: GeneralText.cameraPermission.rawValue), type: .warning)
            }
            else if AVCaptureDevice.authorizationStatus(for: .video) ==  .notDetermined {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                    if granted {
                        self.openCamera()
                    }
                })
            }
        }
        
        let galleryBtn = UIAlertAction(title:galleryBtnTitle , style: .default) { (action) in
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.viewController?.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelBtn = UIAlertAction(title:localizedTextFor(key: GeneralText.cancel.rawValue) , style: .cancel) { (action) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cameraBtn)
        alertController.addAction(galleryBtn)
        alertController.addAction(cancelBtn)
        
        alertController.popoverPresentationController?.sourceView = viewController?.view
        
        self.viewController?.present(alertController, animated: true, completion: nil)
    }
    
    func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.viewController?.present(imagePicker, animated: true, completion: nil)
    }
}

extension CustomImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let pickedImage = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        
        let controller = CropViewController()
        controller.delegate = self
        controller.image = pickedImage
        
        picker.dismiss(animated: true, completion: nil)
        let newNav = UINavigationController(rootViewController: controller)
        self.viewController?.present(newNav, animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CustomImagePicker: CropViewControllerDelegate {
    
    public func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        delegate.didFinishPickingImage(image: image)
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func cropViewControllerDidCancel(_ controller: CropViewController) {
        delegate.didCancelPickingImage()
        controller.dismiss(animated: true, completion: nil)
    }
}
