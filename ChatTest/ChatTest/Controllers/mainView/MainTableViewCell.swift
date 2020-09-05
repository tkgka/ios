//
//  MainTableViewCell.swift
//  ChatTest
//
//  Created by 김수환 on 2020/08/18.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
import Alamofire
class MainTableViewCell: UITableViewCell {
    @IBOutlet var PostImageView: UIImageView!
    @IBOutlet var TextView: UILabel!
    @IBOutlet var likeBtn: UIButton!
    
    static let identifier = "MainTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "MainTableViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with model: InstagramPost){
        self.PostImageView.load(urlString: model.postImageName)
        self.TextView.text = model.TextViewName
        
    }
    
    func testJson(id: String, value: String) {
            let URL = "http://localhost:3000/heart"
            
            
            let PARAM: Parameters = [
                "id":id,
                "value": value,
                
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
    //                self.resultLabel.text = "\(value)"
    //                self.sendImage(value: value)
                    
                //통신실패
                case .failure(let error):
                    print("error: \(String(describing: error.errorDescription))")
    //                self.resultLabel.text = "\(error)"
                }
            }
            
        }
    
    
    @IBAction func likeBtnTapped(_ sender: Any) {
        guard let text = TextView.text else {return}
        testJson(id: "TestID", value: TextView.text!)
        print(text)
        
    }
}
