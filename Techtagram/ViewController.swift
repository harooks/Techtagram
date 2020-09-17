//
//  ViewController.swift
//  Techtagram
//
//  Created by Haruko Okada on 9/6/20.
//  Copyright © 2020 Haruko Okada. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var cameraImageView: UIImageView!
    var originalImage: UIImage!
    var filter: CIFilter!
    
    @IBAction func cameraBtn(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            //カメラ起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
            
        } else {
            //print error in console if camera isn't avilable
            print("error")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        cameraImageView.image = info[.editedImage] as? UIImage
        originalImage = cameraImageView.image
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func albumBtn(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func filterBtn(_ sender: Any) {
        
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        //set filter
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        
        //彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        
        //明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        
        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
    }
    
    @IBAction func shareBtn(_ sender: Any) {
        
        //投稿したときに一緒に載せるコメント
        let shareText = "写真加工イエイ"
        
        //choose photo to post
        let shareImage = cameraImageView.image!
        
        //prepare for comment and photo for posting
        let activityItmes: [Any] = [shareText, shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItmes, applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        activityViewController.excludedActivityTypes = excludedActivityTypes
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

