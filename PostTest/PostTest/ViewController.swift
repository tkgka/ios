//
//  ViewController.swift
//  PostTest
//
//  Created by 김수환 on 2020/08/03.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBOutlet var button: UIButton!
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func galleryShow(_ sender: Any) {
        let alert =  UIAlertController(title: "프로필 사진 변경", message: "", preferredStyle: .actionSheet)
         
         
                let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
         
                }
         
         
                let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
         
         
                alert.addAction(library)
         
         
                alert.addAction(cancel)
         
                present(alert, animated: true, completion: nil)
         
            }
    
    
    

            func openLibrary(){
         
              picker.sourceType = .photoLibrary
         
              present(picker, animated: false, completion: nil)
            }
    }






