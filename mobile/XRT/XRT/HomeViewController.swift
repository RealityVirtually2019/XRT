//
//  HomeViewController.swift
//  XRT
//
//  Created by Travis Ho on 1/19/19.
//  Copyright © 2019 Travis Ho. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterButton.layer.cornerRadius = 8
    }
}
