//
//  ViewController.swift
//  loadJson Test
//
//  Created by 김수환 on 2020/08/05.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchPostdata { (posts) in
            
            for post in posts {
                print("\(post.title!)\n")
                print("\(post.body!)\n")
            }
        }
    }


    //patch data from internet
    func fetchPostdata(completionHandler: @escaping ([Post]) -> Void){
        
        let url = URL(string: "http://localhost:3000")!
        
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

