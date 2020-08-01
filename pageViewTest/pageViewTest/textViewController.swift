//
//  textViewController.swift
//  pageViewTest
//
//  Created by 김수환 on 2020/08/01.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

class textViewController: UIViewController {
    
    let myText: String
    
    private let myTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 24)
        textView.textColor = .black
        return textView
    }()
    
    init(with Text: String) {
        self.myText = Text
        myTextView.text = self.myText
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(self.myTextView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTextView.frame = view.bounds
    }
  

}
