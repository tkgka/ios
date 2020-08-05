//
//  ViewController.swift
//  pageViewTest
//
//  Created by 김수환 on 2020/08/01.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var myControllers = [UIViewController]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchPostdata { (posts) in
                  
                  for post in posts {
                    let vc = textViewController(with: post.title)
                    self.myControllers.append(vc)
                  }
              }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.presentPageVC()
        })
    }
    
    func presentPageVC() {
        guard let first = myControllers.first else{
            return
        }
        let vc = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        
        vc.delegate = self
        vc.dataSource = self
        vc.setViewControllers([first], direction: .forward, animated: true, completion: nil)
        
        present(vc, animated: true)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = myControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        let before = index - 1
        return myControllers[before]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = myControllers.firstIndex(of: viewController), index < (myControllers.count - 1) else {
            return nil
        }
        let after = index + 1
        return myControllers[after]
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

