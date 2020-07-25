//
//  TestViewController.swift
//  ChatTest
//
//  Created by 김수환 on 2020/07/25.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
import SideMenu
import FirebaseAuth
class TestViewController:UIViewController,menuControllerDelegate{
    private var SideMenu: SideMenuNavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let menu = menuController(with: ["home","info","setting","Logout"])
        
        menu.delegate = self
        
        SideMenu=SideMenuNavigationController(rootViewController: menu)
        
        SideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = SideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        // Do any additional setup after loading the view.
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth()
    }
    private func validateAuth(){
        //        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        
        if FirebaseAuth.Auth.auth().currentUser == nil{
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav,animated: false)
        }
    }
    
    
    @IBAction func didTapButton(_ sender: UIBarButtonItem) {
        present(SideMenu!, animated: true)
        
    }
    func DidSelectMenuItem(name: String) {
        SideMenu?.dismiss(animated: true, completion: {[weak self] in
            if name == "Logout"{
                let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {[weak self] _ in
                    
                    guard let StrongSelf = self else{
                        return
                    }
                    
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
                
                self?.present(actionSheet, animated: true)
                
            }
            else if name == "info"{
                self?.view.backgroundColor = .red
            }
            else if name == "setting"{
                self?.view.backgroundColor = .green
            }
            else if name == "home"{
                self?.view.backgroundColor = .white
            }
        })
    }
    
}

