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
    @IBOutlet weak var omitirButon: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        actualizarButton.layer.cornerRadius = 10
        actualizarButton.clipsToBounds = true
        omitirButon.layer.cornerRadius = 10
        omitirButon.clipsToBounds = true
    }
    
    @IBAction func actualizar(_ sender: Any) {
    }
    
}
