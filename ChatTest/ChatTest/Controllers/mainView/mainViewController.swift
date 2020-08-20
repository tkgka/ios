//
//  mainViewController.swift
//  ChatTest
//
//  Created by 김수환 on 2020/08/18.
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

class mainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var table: UITableView!
    var models = [InstagramPost]()
    
    func append(){
        fetchPostdata { (posts) in
            for post in posts {
                self.models.append(InstagramPost(TextViewName: post.pw, postImageName: "http://localhost:3000/images/1597672784648364be8860e8d72b4358b5e88099a935a.png"))
            }
        }
    }
    
    override func viewDidLoad() {
       append()
        
        super.viewDidLoad()
        table.register(MainTableViewCell.nib(), forCellReuseIdentifier: MainTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        fetchdata()
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    
    @objc private func didPullToRefresh() {
           //refecth data
           
           fetchdata()
       }
    
    private func fetchdata(){
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
            strongself.models.append(InstagramPost(TextViewName: final.results.sunrise, postImageName: "http://localhost:3000/images/1597672784648364be8860e8d72b4358b5e88099a935a.png"))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func fetchPostdata(completionHandler: @escaping ([Post]) -> Void){
        
        let url = URL(string: "http://localhost:3000")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self](data, response, error) in
            guard let strongself = self,
            let data = data else { return }
            
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
    let TextViewName: String
    let postImageName: String
}
struct Post: Codable {
 
    var id: String!
    var pw: String!
}
