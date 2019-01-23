//
//  QRGenerateViewController.swift
//  QRCode
//
//  Created by Prateek on 30/09/17.
//  Copyright © 2017 14K. All rights reserved.
//

import UIKit


class QRGenerateViewController: UIViewController {

    @IBOutlet weak private var qrImage: UIImageView!
    @IBOutlet weak private var textField: UITextField!
    private var qrText: String?
    
    @IBAction func generateAction(_ sender: UIButton) {
        view.endEditing(true)
        guard let inputStr = textField.text, inputStr != qrText,
              let ciImage = CIImage.createQRCode(from: inputStr)
        else { return }
        qrImage.set(ciImage: ciImage, scaleToFitBounds: true)
        qrText = inputStr
    }
    
}

