//
//  TakeAPicture.swift
//  leaf
//
//  Created by E508Lab on 2019/3/5.
//  Copyright © 2019年 wang. All rights reserved.
//
import UIKit
import AVFoundation
import Foundation
class TakeAPicture: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    let imagePicker = UIImagePickerController()
    let fullSize = UIScreen.main.bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()
        picture()
        /*let myButton1 = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        myButton1.setTitle("拍照", for: .normal)
        myButton1.backgroundColor = UIColor.lightGray
        myButton1.addTarget(self, action: #selector(picture), for: .touchUpInside)
        myButton1.center = CGPoint(x: fullSize.width * 0.8, y: fullSize.height * 0.3)
        self.view.addSubview(myButton1)*/

    }
    @objc func picture(){
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }

}
