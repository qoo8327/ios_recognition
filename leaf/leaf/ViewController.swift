//
//  ViewController.swift
//  leaf
//
//  Created by wang on 2018/11/26.
//  Copyright © 2018年 wang. All rights reserved.
//即時辨識


import UIKit
import AVFoundation
import Vision
class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    //var captureSession = AVCaptureSession()
    let fullSize = UIScreen.main.bounds.size
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Label"
        label.font = label.font.withSize(30)
        return label
    }()
    let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label2.text = "time"
        label2.lineBreakMode = NSLineBreakMode.byWordWrapping
        label2.numberOfLines = 0
        label2.textColor = .white
        label2.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.8)
        view.addSubview(label2)
        // Do any additional setup after loading the view, typically from a nib.
        //setupCaptureSession()
        view.addSubview(label)
        setupLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        setupCaptureSession()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setupCaptureSession(){
        let captureSession = AVCaptureSession()
        
        
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        
        
        do{
            if let captureDevice = availableDevices.first{
                captureSession.addInput(try AVCaptureDeviceInput(device: captureDevice))
            
            }
        
        } catch{
            print(error.localizedDescription)
        }
        
        
        let captureOutput = AVCaptureVideoDataOutput()
        captureSession.addOutput(captureOutput)
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 100, width: fullSize.width, height: fullSize.width)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.startRunning()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let model = try? VNCoreMLModel(for: densenet121().model) else{return}
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            let startTime = CFAbsoluteTimeGetCurrent()
            guard let results = finishedRequest.results as? [VNClassificationObservation] else {return}
            guard let Observation = results.first else {return}
            let endTime = CFAbsoluteTimeGetCurrent()
            debugPrint("執行時間:",(endTime-startTime)*1000)
            let predclass = "\(Observation.identifier)"
            let predconfidence = String(format: "%.02f", Observation.confidence * 100)
            let time = String(format:"執行時間: (%3.2fs)",(endTime-startTime)*1000)
            DispatchQueue.main.async(execute: {
                self.label.text = "\(predclass) \(predconfidence)"
                self.label2.text = time
            })
        }
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func setupLabel(){
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("viewWillDisappear")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async(execute: {
        })
        
        print("viewDidDisappear")
    }
    
}

