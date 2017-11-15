//
//  UpdatesViewController.swift
//  alwaysLocationTest
//
//  Created by MacBook Air on 14/11/17.
//  Copyright © 2017 Desarrollo Software. All rights reserved.
//

import UIKit

class UpdatesViewController: UIViewController {

    @IBOutlet weak var actualizarButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        actualizarButton.layer.cornerRadius = 12
        actualizarButton.clipsToBounds = true
       
    }
    
    @IBAction func actualizar(_ sender: Any) {
        
        let url = URL(string: "https://www.google.com")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            //If you want handle the completion block than
            UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                
                print("Open url : \(success)")
            })
        }
    }
    
}
