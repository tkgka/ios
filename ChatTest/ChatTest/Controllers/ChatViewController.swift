//
//  ChatViewController.swift
//  ChatTest
//
//  Created by 김수환 on 2020/07/26.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message:MessageType{
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
    
}
extension MessageKind {
    var messageKindString: String {
        switch self {
            
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "video"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .custom(_):
            return "custom"
        }
    }
}

struct sender:SenderType {
   public var photoURL: String
   public var senderId: String
   public var displayName: String
}


class ChatViewController: MessagesViewController {
    
    public static let dataFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    public let otherUserEmail: String
    public var isNewConversation = false
    
    
    private var messages = [Message]()
    
    private var SelfSender: sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        return sender(photoURL: "", senderId: email, displayName: "Tkgka")
    }
    
    init(with email: String){
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    
}

extension ChatViewController: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: " ").isEmpty,
            let selfSender = self.SelfSender,
            let messageId = createMessageId() else{
                return
        }
        
        print("sending: \(text)")
        
        //send message
        
        if isNewConversation{
            let message = Message(sender: selfSender,
                                  messageId: messageId,
                                  sentDate: Date(),
                                  kind: .text(text))
            
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, firstMessage: message, completion: { success in
                if success {
                    print("message sent")
                }
                else{
                    print("fail to sent")
                }
            })
        }else{
            
        }
        
    }
    
    private func createMessageId() -> String? {
        //date , otherUserEmail, senderEmail, randomInt
        
        
        guard let currentuserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentuserEmail)
        
        let dateString = Self.dataFormatter.string(from: Date())
        
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
        print("message ID: \(newIdentifier)")
        return newIdentifier
    }
    
}


extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    func currentSender() -> SenderType {
        if let sender = SelfSender {
            return sender
        }
        fatalError("self sender is nil, email should be catched")
        return sender(photoURL: " ", senderId: " ", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
