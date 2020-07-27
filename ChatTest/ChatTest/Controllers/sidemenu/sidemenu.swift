//
//  sidemenu.swift
//  ChatTest
//
//  Created by 김수환 on 2020/07/25.
//  Copyright © 2020 김수환. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
protocol menuControllerDelegate {
    func DidSelectMenuItem(name: String)
    
}




class menuController:UITableViewController{
    public var delegate:menuControllerDelegate?
    
    private let MenuItem: [String]
    
    init(with MenuItem: [String]){
        self.MenuItem=MenuItem
        super.init(nibName:nil,bundle:nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkGray
        view.backgroundColor = .darkGray
        tableView.tableHeaderView = createTableHeader()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItem.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuItem[indexPath.row]
        cell.textLabel?.textColor = .red
        cell.backgroundColor = .darkGray
        cell.contentView.backgroundColor = .darkGray
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //relay to delegate about menu item selection
        let selectedItem = MenuItem[indexPath.row]
        delegate?.DidSelectMenuItem(name: selectedItem)
    }
    
    
    

    
      


    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        
        let path = "images/"+filename
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 300))
        
        headerView.backgroundColor = .link
        
        let imageView = UIImageView(frame: CGRect(x: (view.width - 120)/5, y: 75, width: 120, height: 120))
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width/2
        headerView.addSubview(imageView)
        StorageManager.shared.downloadURL(for: path, completion: {[weak self] result in
            switch result {
            case .success(let url):
                self?.downloadImage(imageView: imageView, url: url)
            case .failure(let error):
                print("Fail to download url")
            }
        })
        
        return headerView
    }
    func downloadImage(imageView: UIImageView, url: URL){
        URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }).resume()
    }
    
    
}
