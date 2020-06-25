//
//  ViewController.swift
//  DrawingTest
//
//  Created by 김수환 on 2020/06/25.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func LineBtn(_ sender: UIButton) {
        UIGraphicsBeginImageContext(ImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.red.cgColor)
        
        context.move(to: CGPoint(x:70, y:50))
        context.addLine(to: CGPoint(x:270,y:250))
        
        context.strokePath()
        
        context.setLineWidth(4.0)
        context.setStrokeColor(UIColor.black.cgColor)
        
        context.move(to: CGPoint(x:170, y:200))
        context.addLine(to: CGPoint(x:270,y:350))
        context.addLine(to: CGPoint(x:70,y:350))
        context.addLine(to: CGPoint(x:170,y:200))
        
        context.strokePath()
        
        ImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        
    }
    @IBAction func SquareBtn(_ sender: UIButton) {
    }
    @IBAction func CircleBtn(_ sender: UIButton) {
    }
    
    @IBAction func RoundBtn(_ sender: UIButton) {
    }
    @IBAction func FillBtn(_ sender: UIButton) {
    }
    
}

