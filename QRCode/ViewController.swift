//
//  ViewController.swift
//  QRCode
//
//  Created by Prateek on 30/09/17.
//  Copyright © 2017 14K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        textField.becomeFirstResponder()
    }
    
    @IBAction func generateAction(_ sender: UIButton) {
        
        if let inputStr = textField.text{
            
            let data = inputStr.data(using: .ascii, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            let img = UIImage(ciImage: (filter?.outputImage)!)
            
           
            qrImage.image = img
            
            
        }
        
    }
    
}

