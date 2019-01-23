//
//  QRReadViewController.swift
//  QRCode
//
//  Created by Prateek Sharma on 1/23/19.
//  Copyright © 2019 14K. All rights reserved.
//

import UIKit
import AVFoundation

class QRReadViewController: UIViewController {

    private let captureSession = AVCaptureSession()
    @IBOutlet weak private var qrCodeView: UIView!
    lazy private var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        return videoPreviewLayer
    }()
    
    private func setupCaptureOutput() {
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        guard let captureDevice = deviceDiscoverySession.devices.first  else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            setupCaptureOutput()
            
            view.layer.insertSublayer(videoPreviewLayer, at: 0)
            captureSession.startRunning()
        } catch {
            print(error)
        }
    }

    private func isQRInside(scanArea: CGRect) -> Bool {
        return qrCodeView.frame.insetBy(dx: 10, dy: 10).contains(scanArea)
    }
    
    private func showAlert(forQR qrText: String) {
        guard presentedViewController == nil  else { return }
        let alert = UIAlertController(title: "QR Value", message: qrText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Copy", style: UIAlertActionStyle.default, handler: { (_) in
            UIPasteboard.general.string = qrText
        }))
        alert.addAction(UIAlertAction(title: "Retake", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.default, handler: { [weak self] (_) in
            self?.captureSession.stopRunning()
            self?.dismiss(animated: true, completion: nil)
        }))
        
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension QRReadViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0,
              let extractableCodeObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
              extractableCodeObject.type == .qr, let qrText = extractableCodeObject.stringValue,
              let qrCodeObject = videoPreviewLayer.transformedMetadataObject(for: extractableCodeObject),
              isQRInside(scanArea: qrCodeObject.bounds)
        else { return }
        showAlert(forQR: qrText)
    }
    
}
