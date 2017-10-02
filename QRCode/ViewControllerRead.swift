//
//  ViewControllerRead.swift
//  QRCode
//
//  Created by Prateek on 30/09/17.
//  Copyright © 2017 14K. All rights reserved.
//

import UIKit
import AVFoundation

class ViewControllerRead: UIViewController , AVCaptureMetadataOutputObjectsDelegate {

    var video = AVCaptureVideoPreviewLayer()
    @IBOutlet weak var focusSq: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch{
            print("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        
        video.frame = view.frame
        view.layer.addSublayer(video)
        
        view.bringSubview(toFront: focusSq)
        session.startRunning()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if((metadataObjects != nil)||(metadataObjects.count > 0)){
            
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                
                if object.type == AVMetadataObject.ObjectType.qr{
                    
                    let alert = UIAlertController(title: "QR Value", message: object.stringValue, preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Retake", style: UIAlertActionStyle.default, handler: nil))
                    
                    alert.addAction(UIAlertAction(title: "Copy", style: UIAlertActionStyle.default, handler: { (nil) in
                        UIPasteboard.general.string = object.stringValue
                    }))
                    
                    present(alert, animated: true, completion: nil)
                }
                
            }
            
        }
        
        
    }
    
    
}
