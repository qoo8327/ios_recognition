//
//  PictureToRecon.swift
//  leaf
//
//  Created by E508Lab on 2019/3/8.
//  Copyright © 2019年 wang. All rights reserved.
//拍照及選擇圖片辨識和上傳辨識

import UIKit
import AVFoundation
import MobileCoreServices
import AssetsLibrary
import AVKit
import Vision
import CoreML

class PictureToRecon: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let URL_Recon_IMG = "http://192.168.92.1/ios_data/uploadimg_v3_re.php"
    let fullSize = UIScreen.main.bounds.size
    let picker = UIImagePickerController()
    var imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
    let imagePicker = UIImagePickerController()
    let model = densenet121()
    var partString:String = ""
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
    let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
    /*let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Label"
        label.font = label.font.withSize(20)
        return label
    }()*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        
        
        let myButton1 = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        myButton1.setTitle("圖片", for: .normal)
        myButton1.backgroundColor = UIColor.blue
        myButton1.addTarget(self, action: #selector(photoLib), for: .touchUpInside)
        myButton1.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.65)
        self.view.addSubview(myButton1)
        
        imageview.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.3)
        self.view.addSubview(imageview)
        
        
        let myButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        myButton2.setTitle("拍照", for: .normal)
        myButton2.backgroundColor = UIColor.blue
        myButton2.addTarget(self, action: #selector(picture), for: .touchUpInside)
        myButton2.center = CGPoint(x: fullSize.width * 0.2, y: fullSize.height * 0.65)
        self.view.addSubview(myButton2)
        
        let myButton3 = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        myButton3.setTitle("電腦辨識", for: .normal)
        myButton3.backgroundColor = UIColor.blue
        myButton3.addTarget(self, action: #selector(upload), for: .touchUpInside)
        myButton3.center = CGPoint(x: fullSize.width * 0.8, y: fullSize.height * 0.65)
        self.view.addSubview(myButton3)
        
        
        label2.text = "Labelllll"
        label2.lineBreakMode = NSLineBreakMode.byWordWrapping
        label2.numberOfLines = 0
        label2.textColor = .white
        label2.center = CGPoint(x: fullSize.width * 1.1, y: fullSize.height * 0.8)
        view.addSubview(label2)
        
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.center = CGPoint(x: fullSize.width * 0.4, y: fullSize.height * 0.8)
        view.addSubview(label)
        setupLabel()
        
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
        
        predictUsingVision(image: pickedImage!)
        self.dismiss(animated: true, completion:nil)
        
        
    }

    
    @objc func picture(){
        let image = UIImage(named: "mask.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 450, height: 450)
        imageView.center = CGPoint(x: fullSize.width*0.48, y: fullSize.height*0.35)
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        imagePicker.cameraOverlayView = imageView
    }


    
    func predictUsingVision(image: UIImage) {
        guard let visionModel = try? VNCoreMLModel(for: model.model) else {
            fatalError("Someone did a baddie")
        }

        let request = VNCoreMLRequest(model: visionModel) { request, error in
            if let observations = request.results as? [VNClassificationObservation] {
                //print(observations)
                // The observations appear to be sorted by confidence already, so we
                // take the top 5 and map them to an array of (String, Double) tuples.
                let top = observations.prefix(through: 2)
                    .map { ($0.identifier, Double($0.confidence)) }
                debugPrint(top)
                self.show(results: top)
                //DispatchQueue.main.async(execute: {
                    //self.label.text = "(\(top))"
                //})
            }
        }
        
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        try? handler.perform([request])
    }
    
    typealias Prediction = (String, Double)
    func show(results: [Prediction]) {
        label.text = ""
        var s: [String] = []
        var s1: [String] = []
        for (i, pred) in results.enumerated() {
            s.append(String(format: "%d: %@ (%3.2f%%)", i + 1, pred.0, pred.1 * 100))
            s1.append(String(pred.0))
        }
        //label.text = s.joined(separator: "\n\n")
        //print(s)
        debugPrint(s1)
        label.text = s1.joined(separator: "\n\n")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupLabel(){
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
    }
    
    func uploadImage(name: String){
        //created NSURL
        let uploadurl = URL(string: URL_Recon_IMG)
        
        //creating NSMutableURLRequest
        let requesturl = NSMutableURLRequest(url: uploadurl!)
        
        //setting the method to post
        requesturl.httpMethod = "POST"
        /*let disName = "123"
        let param = [
            "disname"    : disName
        ]*/
        
        let boundary = generateBoundaryString()
        
        requesturl.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData = imageview.image!.jpegData(compressionQuality: 1)
        if(imageData==nil)  { return; }
        //parameters: param
        requesturl.httpBody = createBodyWithParameters(filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary,filename: name) as Data
        
        
        
        let task = URLSession.shared.dataTask(with: requesturl as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error is \(String(describing: error))")
                return
            }
            //let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("****** response data = \(responseString!)")
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: String], let response = json["Answer"] {
                    print("response = \(response)")
                    let cnt = response.count
                    self.partString = String(response[response.index(response.startIndex, offsetBy: 7)..<response.index(response.startIndex, offsetBy: cnt)])
                    print("partString = \(self.partString)")
                    DispatchQueue.main.async {
                        self.label2.text = self.partString
                    }
                    //self.label2.text = self.partString
                }
            } catch let parseError {
                print("parsing error: \(parseError)")
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                print("raw response: \(responseString)")
            }
            
            
        }
        task.resume()
    }
    //parameters: [String: String]?
    func createBodyWithParameters(filePathKey: String?, imageDataKey: NSData, boundary: String, filename: String) -> NSData {
        let body = NSMutableData();
        
        /*if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }*/
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
        label2.text = ""
        if (imageview.image == nil){
            confirmf()
        }
        else{
            let name = uuid()

            uploadImage(name: name)
            self.confirm()
            //imageview.image = nil
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
}


extension UIImage {
    func buffer(with size:CGSize) -> CVPixelBuffer? {
        if let image = self.cgImage {
            let frameSize = size
            var pixelBuffer:CVPixelBuffer? = nil
            let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), kCVPixelFormatType_32BGRA , nil, &pixelBuffer)
            if status != kCVReturnSuccess {
                return nil
            }
            CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
            let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
            let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
            context?.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
            CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            
            return pixelBuffer
        }else{
            return nil
        }
    }
}
/*
extension UIImage {
    public func buffer(width: Int, height: Int) -> CVPixelBuffer? {
        var maybePixelBuffer: CVPixelBuffer?
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs as CFDictionary,
                                         &maybePixelBuffer)
        
        guard status == kCVReturnSuccess, let pixelBuffer = maybePixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        guard let context = CGContext(data: pixelData,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
            else {
                return nil
        }
        
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1, y: -1)
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}*/

