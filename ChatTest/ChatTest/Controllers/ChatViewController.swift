//
//  ChatViewController.swift
//  ChatTest
//
//  Created by 김수환 on 2020/07/26.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
import MessageKit

struct Message:MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
}

struct sender:SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}


class ChatViewController: MessagesViewController {

    private var messages = [Message]()
    
    private let SelfSender = sender(photoURL: "", senderId: "1", displayName: "Tkgka")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: SelfSender, messageId: "1", sentDate: Date(), kind: .text("Hello world Message")))
        messages.append(Message(sender: SelfSender, messageId: "1", sentDate: Date(), kind: .text("Hello world Message hello world")))
        
        view.backgroundColor = .red
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    

}


extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    func currentSender() -> SenderType {
        return SelfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
