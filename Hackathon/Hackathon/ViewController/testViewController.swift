//
//  testViewController.swift
//  Hackathon
//
//  Created by 김수환 on 2020/09/19.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    @IBOutlet var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnClicked(_ sender: Any) {
        print("hello")
    }
    

}
