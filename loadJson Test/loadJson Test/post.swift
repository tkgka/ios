//
//  post.swift
//  loadJson Test
//
//  Created by 김수환 on 2020/08/05.
//  Copyright © 2020 김수환. All rights reserved.
//

import Foundation

//datastructure
//struct Post: Codable {
//    var userId: Int!
//    var id: Int!
//    var title: String!
//    var body: String!
//}

struct Post: Codable {
    var num: Int!
    var id: String!
    var title: String!
    var contents: String!
    var recruit:String
    var link: String!
    var tag: String!
    var boards: String!
    var dates: String!
    var heart: String!
}
