//
//  ViewController.swift
//  instaTest
//
//  Created by 김수환 on 2020/08/02.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

struct APIResponse: Codable {
    let results: APIResponseResults
    let status: String
}

struct APIResponseResults: Codable {
    let sunrise: String
    let sunset: String
    let solar_noon: String
    let day_length: Int
    let civil_twilight_begin: String
    let civil_twilight_end: String
    let nautical_twilight_begin: String
    let nautical_twilight_end: String
    let astronomical_twilight_begin: String
    let astronomical_twilight_end: String
    
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    var models = [InstagramPost]()
    
    
    func append(){
        fetchPostdata { (posts) in
            for post in posts {
                self.models.append(InstagramPost(numberOfLikes: String(post.title), username: post.title, userImageName: "https://upload.wikimedia.org/wikipedia/commons/e/e8/Pomayrols_nature.JPEG", postImageName: "http://localhost:3000/images/1596442350001f4b63c2725aecaffbd2294b63b61cc5d.jpeg"))
            }
        }
    }
    
    override func viewDidLoad() {
        append()
        
        super.viewDidLoad()
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self

        fetchData()
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    @objc private func didPullToRefresh() {
        //refecth data
        
        fetchData()
    }
    
    private func fetchData() {
        models.removeAll()
        
        
        if table.refreshControl?.isRefreshing == true {
            print("refreshing data")
        }else {
            print("fetching data")
        }
        
        guard let url = URL(string: "https://api.sunrise-sunset.org/json?data=2020-8-1&lng=37.3230&lat=-122.0322&formatted=0") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url,completionHandler: {[weak self] data, _, error in
            guard let strongself = self, let data = data, error == nil else {
                return
            }
            var result: APIResponse?
            do {
                result = try JSONDecoder().decode(APIResponse.self, from: data)
            }
            catch
            {
                //handle error
            }
            guard let final = result else {
                return
            }
            strongself.models.append(InstagramPost(numberOfLikes: "200", username: final.results.sunrise, userImageName: "http://localhost:3000/images/1597022446144aba4c12c0307ac56aedf5e7b2dadf69b.jpeg", postImageName: "post_1"))
            //              strongself.models.append("Sunrise: \(final.results.sunrise)")
            
            
            DispatchQueue.main.async {
                strongself.table.refreshControl?.endRefreshing()
                
                strongself.table.reloadData()
            }
        })
        task.resume()
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
    
    func fetchPostdata(completionHandler: @escaping ([Post]) -> Void){
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                
                let postsData = try JSONDecoder().decode([Post].self, from: data)
                
                completionHandler(postsData)
                
            }catch{
                let error = error
                print("\(error.localizedDescription)")
            }
            
        }.resume()
    }
    
}

struct InstagramPost {
    let numberOfLikes : String
    let username: String
    let userImageName: String
    let postImageName: String
}
