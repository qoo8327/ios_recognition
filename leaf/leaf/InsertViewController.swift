//
//  InsertViewController.swift
//  leaf
//
//  Created by E508Lab on 2019/2/26.
//  Copyright © 2019年 wang. All rights reserved.
//上傳新資料

import UIKit
import AVFoundation
import MobileCoreServices
import AssetsLibrary
import AVKit

class InsertViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let URL_SAVE_TEAM = "http://192.168.92.1/ios_data/createdis.php"
    let URL_SAVE_IMG = "http://192.168.92.1/ios_data/uploadimg_v2.php"
    let fullSize = UIScreen.main.bounds.size
    var textFielddis: UITextField!
    var textFieldtest: UITextField!
    let picker = UIImagePickerController()
    var imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    let imagePicker = UIImagePickerController()
    var filename:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.lightGray
        
        textFielddis = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        textFielddis.placeholder = "輸入疾病名稱"
        textFielddis.backgroundColor = UIColor.lightGray
        textFielddis.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.1)
        textFielddis.delegate = self
        self.view.addSubview(textFielddis)

        textFieldtest = UITextField(frame: CGRect(x: 0, y: 50, width: 200, height: 50))
        textFieldtest.placeholder = "輸入測試"
        textFieldtest.backgroundColor = UIColor.lightGray
        textFieldtest.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.2)
        textFieldtest.delegate = self
        self.view.addSubview(textFieldtest)

        let myButton1 = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        myButton1.setTitle("圖片", for: .normal)
        myButton1.backgroundColor = UIColor.lightGray
        myButton1.addTarget(self, action: #selector(photoLib), for: .touchUpInside)
        myButton1.center = CGPoint(x: fullSize.width * 0.8, y: fullSize.height * 0.3)
        self.view.addSubview(myButton1)
        
        imageview.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.4)
        self.view.addSubview(imageview)
        
        let myButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
         myButton2.setTitle("拍照", for: .normal)
         myButton2.backgroundColor = UIColor.lightGray
         myButton2.addTarget(self, action: #selector(picture), for: .touchUpInside)
         myButton2.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.6)
         self.view.addSubview(myButton2)
        
        
        let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        myButton.setTitle("送出", for: .normal)
        myButton.backgroundColor = UIColor.lightGray
        myButton.addTarget(self, action: #selector(upload), for: .touchUpInside)
        myButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.7)
        self.view.addSubview(myButton)
        
    }
    //send
    @objc func uploadDis(name: String!) {
        //created NSURL
        let requestURL = URL(string: URL_SAVE_TEAM)

        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL!)

        //setting the method to post
        request.httpMethod = "POST"

        //getting values from text fields
        let disName = textFielddis.text
        let testext = textFieldtest.text
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "dis_name="+disName!+"&img_name="+name+"&test="+testext!;
        print(postParameters)
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        //message box
        

        let task1 = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error is \(String(describing: error))")
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
        }
        //executing the task
        task1.resume()
        
    }
    //open albunm
    @objc func photoLib(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){


            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }else{
            print("read error")
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //img to jpg
        let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imageview.image = pickedImage
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        self.dismiss(animated: true, completion:nil)

    }
    func uploadImage(name: String){
        //created NSURL
        let uploadurl = URL(string: URL_SAVE_IMG)
        
        //creating NSMutableURLRequest
        let requesturl = NSMutableURLRequest(url: uploadurl!)
        
        //setting the method to post
        requesturl.httpMethod = "POST"
        let disName = textFielddis.text
        let param = [
        "disname"    : disName!
        ]
     
        let boundary = generateBoundaryString()
     
        requesturl.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData = imageview.image!.jpegData(compressionQuality: 1)
        if(imageData==nil)  { return; }
     
        requesturl.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary,filename: name) as Data
     
        
     
        let task = URLSession.shared.dataTask(with: requesturl as URLRequest) {
            data, response, error in
     
            if error != nil {
                print("error is \(String(describing: error))")
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
     
        }
     
         task.resume()
    }
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String, filename: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {return "Boundary-\(NSUUID().uuidString)"}

    @objc func upload(){
        if (textFielddis.text == "") || (textFieldtest.text == "") || (imageview.image == nil){
            confirmf()
        }
        else{
            let name = uuid()
            uploadDis(name: name)
            uploadImage(name: name)
            self.confirm()
            textFielddis.text = nil
            textFieldtest.text = nil
            imageview.image = nil
        }

    }
    
    func uuid() ->String{
        let uuid = UUID().uuidString
        let imagename = uuid+".jpg"
        return imagename
    }
    
    
    func confirm(){
        let alertController = UIAlertController(title: "success", message: "成功傳送資料", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認",style: .default)
        alertController.addAction(okAction)
        self.present(alertController,animated: true,completion: nil)
    }
    
    func confirmf(){
        let alertController = UIAlertController(title: "fail", message: "資料不完全", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認",style: .default)
        alertController.addAction(okAction)
        self.present(alertController,animated: true,completion: nil)
    }
    
    @objc func picture(){
        let image = UIImage(named: "mask.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 450, height: 450)
        imageView.center = CGPoint(x: fullSize.width*0.48, y: fullSize.height*0.55)
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        imagePicker.cameraOverlayView = imageView
    }
    
    /*func imagePickerController2(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }*/
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 設定delegate 為self後，可以自行增加delegate protocol
    // 開始進入編輯狀態
    func textFieldDidBeginEditing(_ textField: UITextField){
        debugPrint("textFieldDidBeginEditing:" + textField.text!)
    }
    
    // 可能進入結束編輯狀態
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    // 結束編輯狀態(意指完成輸入或離開焦點)
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    // 按下Return後會反應的事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //利用此方式讓按下Return後會Toogle 鍵盤讓它消失
        textField.resignFirstResponder()
        return false
    }
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
