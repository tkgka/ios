//
//  ViewController.swift
//  loadImageFromServerTest
//
//  Created by 김수환 on 2020/08/10.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imgOne: UIImageView!
    @IBOutlet weak var imgTwo: UIImageView!
    @IBOutlet weak var imgThree: UIImageView!
    
    
    
    
    let image1 = "https://upload.wikimedia.org/wikipedia/commons/e/e8/Pomayrols_nature.JPEG"
    let image2 = "https://upload.wikimedia.org/wikipedia/en/4/4e/Pahoeoe_fountain_JPEG_more_contrast.jpg"
    let image3 = "http://localhost:3000/images/1596442350001f4b63c2725aecaffbd2294b63b61cc5d.jpeg"
    override func viewDidLoad() {
        super.viewDidLoad()
        imgOne.load(urlString: image1)
        imgTwo.load(urlString: image2)
        imgThree.load(urlString: image3)
        
        imgOne.layer.cornerRadius = 10
        imgTwo.layer.cornerRadius = 10
        imgThree.layer.cornerRadius = 10
    }


}

