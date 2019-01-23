//
//  QRGenerateViewController.swift
//  QRCode
//
//  Created by Prateek on 30/09/17.
//  Copyright © 2017 14K. All rights reserved.
//

import UIKit


class QRGenerateViewController: UIViewController {

    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
   
    @IBAction func generateAction(_ sender: UIButton) {
        view.endEditing(true)
        if let inputStr = textField.text{
            
            let data = inputStr.data(using: .ascii, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            let img = UIImage(ciImage: (filter?.outputImage)!)
            
           
            qrImage.image = img
            
            
        }
        
    }
    
}

