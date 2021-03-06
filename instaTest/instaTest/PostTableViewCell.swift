//
//  PostTableViewCell.swift
//  instaTest
//
//  Created by 김수환 on 2020/08/02.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet var userimageView: UIImageView!
        @IBOutlet var postimageView: UIImageView!
        @IBOutlet var usernameLable: UILabel!
        @IBOutlet var HeartLable: UILabel!
    
        
        static let identifier = "postTableViewCell"
        
        static func nib() -> UINib {
            return UINib(nibName: "PostTableViewCell", bundle: nil)
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
         
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        func configure(with model: InstagramPost){

            self.usernameLable.text = model.username
            self.HeartLable.text = model.numberOfLikes
//            self.userimageView.image = UIImage(named: model.userImageName)
            self.userimageView.load(urlString: model.userImageName)
            self.postimageView.load(urlString: model.postImageName)
//            self.postimageView.image = UIImage(named: model.postImageName)
        }

    }
