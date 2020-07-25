//
//  sidemenu.swift
//  ChatTest
//
//  Created by 김수환 on 2020/07/25.
//  Copyright © 2020 김수환. All rights reserved.
//

import Foundation
import UIKit
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
}
