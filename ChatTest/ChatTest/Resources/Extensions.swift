//
//  Extensions.swift
//  ChatTest
//
//  Created by 김수환 on 2020/07/23.
//  Copyright © 2020 김수환. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    public var width: CGFloat{
        return self.frame.size.width
    }
    public var height: CGFloat{
        return self.frame.size.height
    }
    public var top: CGFloat{
        return self.frame.origin.y
    }
    public var bottom: CGFloat{
        return self.frame.size.height + self.frame.origin.y
    }
    public var left: CGFloat{
        return self.frame.origin.x
    }
    public var rigth: CGFloat{
        return self.frame.size.width + self.frame.origin.x
    }
}
