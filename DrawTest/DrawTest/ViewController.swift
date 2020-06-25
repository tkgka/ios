//
//  ViewController.swift
//  DrawTest
//
//  Created by 김수환 on 2020/06/25.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var ImageView: UIImageView!
   
    
    var lastPoint: CGPoint!
    var lineSize = 2.0
    var lineColor = UIColor.red.cgColor
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func ClearBtn(_ sender: UIButton) {
        ImageView.image = nil
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        lastPoint = touch.location(in: ImageView)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContext(ImageView.frame.size)
        UIGraphicsGetCurrentContext()?.setStrokeColor(lineColor)
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
        
        
        UIGraphicsGetCurrentContext()?.setLineWidth(CGFloat(lineSize))
        let touch = touches.first! as UITouch
        let currentpoint = touch.location(in: ImageView)
        
        ImageView.image?.draw(in: CGRect(x: 0, y: 0, width: ImageView.frame.size.width, height: ImageView.frame.size.height))
        
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currentpoint.x, y: currentpoint.y))
        UIGraphicsGetCurrentContext()?.strokePath()
        
        ImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        lastPoint = currentpoint
                
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContext(ImageView.frame.size)
        UIGraphicsGetCurrentContext()?.setStrokeColor(lineColor)
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
        
        UIGraphicsGetCurrentContext()?.setLineWidth(CGFloat(lineSize))
        
        ImageView.image?.draw(in: CGRect(x: 0, y: 0, width: ImageView.frame.size.width, height: ImageView.frame.size.height))
        
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        UIGraphicsGetCurrentContext()?.strokePath()
        
        ImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

    }
    
    
    @IBAction func redBtn(_ sender: UIButton) {
        lineColor = UIColor.red.cgColor
    }
    @IBAction func BlueBtn(_ sender: UIButton) {
        lineColor = UIColor.blue.cgColor
    }
    @IBAction func YelloBtn(_ sender: UIButton) {
        lineColor = UIColor.yellow.cgColor
    }
    @IBAction func GreenBtn(_ sender: UIButton) {
        lineColor = UIColor.green.cgColor
    }
    @IBAction func BlackBtn(_ sender: UIButton) {
        lineColor = UIColor.black.cgColor
    }
    
}

