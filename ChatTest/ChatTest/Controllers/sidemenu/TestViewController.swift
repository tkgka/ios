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
import Alamofire
class TestViewController:UIViewController,menuControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    private var SideMenu: SideMenuNavigationController?
    
    @IBOutlet var imageview: UIImageView!
    @IBOutlet var button: UIButton!
    @IBOutlet var sendBtn: UIButton!
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        picker.delegate = self
        //sidebar
        let menu = menuController(with: ["home","info","setting","Logout"])
        
        menu.delegate = self
        
        SideMenu=SideMenuNavigationController(rootViewController: menu)
        
        SideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = SideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        // Do any additional setup after loading the view.
        
    }

    @IBAction func galleryShow(_ sender: Any) {
    
        let alert =  UIAlertController(title: "프로필 사진 변경", message: "", preferredStyle: .actionSheet)
         
         
                let library =  UIAlertAction(title: "사진앨범", style: .default) { [weak self](action) in
                    guard let strongself = self else{
                        return
                    }
                    strongself.openLibrary()
         
                }
         
         
                let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
         
         
                alert.addAction(library)
         
         
                alert.addAction(cancel)
         
                present(alert, animated: true, completion: nil)
         
            }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            picker.dismiss(animated: true, completion: nil)
                    imageview.image = image
                    
                }

    }
        
            
            func openLibrary(){
         
              picker.sourceType = .photoLibrary
         
              present(picker, animated: false, completion: nil)
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
                let actionSheet = UIAlertController(title: "로그아웃", message: "", preferredStyle: .actionSheet)
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
    
    func sendImage(){
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(self.imageview.image!.pngData()!, withName: "", fileName: "test.png", mimeType: "image/png")

        }, to: "http://localhost:3000/image/upload")
        .responseJSON { response in
        print("\(response)")
            self.alertSendSuccess()
        }
        
        
        
        
    }
    
    func alertSendSuccess() {
           let alert = UIAlertController(title: "success", message: "success to send image", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
           present(alert, animated: true)
       }
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        if imageview.image != nil{sendImage()}
        imageview.image = nil
        
    }
}

