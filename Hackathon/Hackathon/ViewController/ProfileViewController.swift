//
//  ProfileViewController.swift
//  Hackathon
//
//  Created by 김수환 on 2020/09/18.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
import FirebaseAuth

import GoogleSignIn

class ProfileViewController: UIViewController {
        @IBOutlet var tableView: UITableView!
        
        let data = ["Log out"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableHeaderView = createTableHeader()
            // Do any additional setup after loading the view.
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
            
            let imageView = UIImageView(frame: CGRect(x: (view.width - 150)/2, y: 75, width: 150, height: 150))
            
            
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
                case .failure( _):
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

    extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath)
            cell.textLabel?.text = data[indexPath.row]
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            
            let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {[weak self] _ in
                
                guard let StrongSelf = self else{
                    return
                }
                
                //LogOut Facebook
               
                
                //google Logout
                GIDSignIn.sharedInstance()?.signOut()
                
                do{
                    try FirebaseAuth.Auth.auth().signOut()
                    
                    let vc = LoginViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    StrongSelf.present(nav,animated: true)
                }
                catch{
                    print("failed to log out")
                }
                
            }))
            actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
            
            present(actionSheet, animated: true)
            
            
        }
    @IBAction func chatBtnClicked(_ sender: UIBarButtonItem) {
        let vc = ConversationsViewController()
               vc.title = ""
               navigationController?.pushViewController(vc, animated: true)
    }
    
}
