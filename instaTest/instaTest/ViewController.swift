//
//  ViewController.swift
//  instaTest
//
//  Created by 김수환 on 2020/08/02.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var table: UITableView!
    
    var models = [InstagramPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        models.append(InstagramPost(numberOfLikes: 200, username: "hello", userImageName: "head", postImageName: "post_1"))
        models.append(InstagramPost(numberOfLikes: 200, username: "ichyun", userImageName: "head", postImageName: "post_2"))
        models.append(InstagramPost(numberOfLikes: 200, username: "hasdf", userImageName: "head", postImageName: "post_3"))
        models.append(InstagramPost(numberOfLikes: 200, username: "qqwer", userImageName: "head", postImageName: "post_1"))
        models.append(InstagramPost(numberOfLikes: 200, username: "qwretq", userImageName: "head", postImageName: "post_2"))
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120+130+view.frame.size.width
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    


}

struct InstagramPost {
    let numberOfLikes : Int
    let username: String
    let userImageName: String
    let postImageName: String
}
