//
//  Extension.swift
//  loadImageFromServerTest
//
//  Created by 김수환 on 2020/08/10.
//  Copyright © 2020 김수환. All rights reserved.
//

import Foundation
import UIKit

extension Int{
    func cube() -> Int {
        return self * self * self
    }
    
    func hexa() -> Int {
        return self.cube() * self.cube()
    }
    
}

extension UIImageView{
    func load(urlString : String) {
        guard let url = URL(string: urlString) else {return}
        
        DispatchQueue.global().async { [weak self ] in
            if let data = try? Data (contentsOf: url) {
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
