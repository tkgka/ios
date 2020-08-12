//
//  ViewController.swift
//  TikTokViewTest
//
//  Created by 김수환 on 2020/08/07.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

struct VideoModel {
    let caption: String
    let username: String
    let audioTrackName: String
    let VideoFileName: String
    let VideoFileFormat: String
}

class ViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    private var data = [VideoModel]()
    
    private func append() {
        fetchPostdata { (posts) in
                   
                   for post in posts {
                       print("\(post.title!)\n")
                       let model = VideoModel(caption: post.title,
                                              username: "@tkgka",
                                              audioTrackName: "test_song",
                                              VideoFileName: "video",
                                              VideoFileFormat: "mov")
                       
                       self.data.append(model)
                       
                   }
               }
               
               
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        append()

        for _ in 0..<10 {
            let model = VideoModel(caption: "this is a coll car",
                                   username: "@tkgka",
                                   audioTrackName: "gucci gang",
                                   VideoFileName: "video",
                                   VideoFileFormat: "mov")

            self.data.append(model)
            
        }
        
        
        
        
        
        
        
        
        
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
        collectionView?.isPagingEnabled = true
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = data[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as! VideoCollectionViewCell
        cell.configure(with: model)
        cell.delegate = self
        return cell
    }
}

extension ViewController: VideoCollectionViewCellDelegate {
    func didTapLikeButton(with model: VideoModel) {
        print(model.username)
        print(model.audioTrackName)
        print(model.VideoFileName)
        print("likebuttonTapped")
    }
    
    func didTapprofileButton(with model: VideoModel) {
        print("profilebuttonTapped")
    }
    
    func didTapShareButton(with model: VideoModel) {
        print("sharebuttonTapped")
    }
    
    func didTapCommentButton(with model: VideoModel) {
        print("commentbuttonTapped")
    }
    
    
    //patch data from internet
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
    
    
    
    
    //datastructure
    struct Post: Codable {
        var userId: Int!
        var id: Int!
        var title: String!
        var body: String!
    }
    
    
}
