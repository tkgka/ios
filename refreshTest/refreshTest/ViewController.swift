//
//  ViewController.swift
//  refreshTest
//
//  Created by 김수환 on 2020/08/08.
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

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    private var tabledata = [String]()
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        view.addSubview(table)
        fetchData()
        
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc private func didPullToRefresh() {
        //refecth data
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    private func fetchData() {
        tabledata.removeAll()
        
        
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
            
            strongself.tabledata.append("Sunrise: \(final.results.sunrise)")
            strongself.tabledata.append("Sunset: \(final.results.sunset)")
            strongself.tabledata.append("day_length: \(final.results.day_length)")
            
            DispatchQueue.main.async {
                strongself.table.refreshControl?.endRefreshing()
                
                strongself.table.reloadData()
            }
        })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabledata.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath)
        cell.textLabel?.text = tabledata[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

