//
//  MainTableViewCell.swift
//  ChatTest
//
//  Created by 김수환 on 2020/08/18.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
class MainTableViewCell: UITableViewCell {
    @IBOutlet var PostImageView: UIImageView!
    @IBOutlet var TextView: UILabel!
    
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
}
