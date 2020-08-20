//
//  ViewController.swift
//  uploadImageTest
//
//  Created by 김수환 on 2020/08/15.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var telField: UITextField!
    @IBOutlet var uploadBtn: UIButton!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var starImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func testJson(email: String, pw: String, tel: String) {
        let URL = "http://localhost:3000"
        
        
        let PARAM: Parameters = [
            "email":email,
            "pw": pw,
            "tel": tel
        ]
        //위의 URL와 파라미터를 담아서 POST 방식으로 통신하며, statusCode가 200번대(정상적인 통신) 인지 유효성 검사 진행
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200..<300)
        //결과값으로 문자열을 받을 때 사용
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success(let value):
                print("value: \(value)")
                self.resultLabel.text = "\(value)"
                self.sendImage(value: value)
                
            //통신실패
            case .failure(let error):
                print("error: \(String(describing: error.errorDescription))")
                self.resultLabel.text = "\(error)"
            }
        }
        
    }
    
    func sendImage(value: String){
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(self.starImage.image!.pngData()!, withName: "", fileName: "test.png", mimeType: "image/png")

        }, to: "http://localhost:3000/image/upload?id=\(value)")
        .responseJSON { response in 
        print("\(response)")
        }
        
        
        
        
    }
     

    
    
    
    
    @IBAction func btnClicked(_ sender: UIButton) {
        //sendImage(url: emailField.text!)
        testJson(email: emailField.text!, pw: pwField.text!, tel: telField.text!)
    }
}

