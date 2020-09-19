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
import SDWebImage

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

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
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
    private let conversationid: String?
    public var isNewConversation = false
    
    
    private var messages = [Message]()
    
    private var SelfSender: sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        return sender(photoURL: "", senderId: safeEmail, displayName: "me")
        
    }
    
    
    
    init(with email: String, id:String?){
        self.conversationid = id
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
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputBtn()
        
    }
    
    private func setupInputBtn() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside {[weak self] _ in
            self?.presentInputActionSheet()
        }
        
        
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    private func presentInputActionSheet(){
        let actionSheet = UIAlertController(title: "attach Media", message: "what would you llike to attache?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "photo", style: .default, handler: {[weak self] _ in
            self?.presentPhotoInputActionSheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "video", style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        present(actionSheet, animated: true)
    }
    
    private func presentPhotoInputActionSheet(){
        let actionSheet = UIAlertController(title: "attach photo", message: "Where would you like to attach photo from", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "camero", style: .default, handler: {[weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "photo Library", style: .default, handler: {[weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        present(actionSheet, animated: true)
    }
    
    
    private func listenForMessages(id: String, shouldScorlltoBottom: Bool) {
        DatabaseManager.shared.getAllMessagesForConversation(with: id, Completion: {[weak self] result in
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else{
                    return
                }
                self?.messages = messages
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    if shouldScorlltoBottom{
                        self?.messagesCollectionView.scrollToBottom()
                    }
                    
                }
                
            case .failure( _):
                print("fail to get message")
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        if let conversationId = conversationid {
            listenForMessages(id: conversationId, shouldScorlltoBottom: true)
        }
    }
    
    
}
extension ChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
            let imageData = image.pngData(),
            let messageId = createMessageId(),
            let conversationId = conversationid,
            let name = self.title,
            let selfSender = SelfSender else{
                return
        }
        
        let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"
        
        StoragManager.shared.uploadPhoto(with: imageData, fileName: fileName, completion: {[weak self] result in
            guard let strongSelf = self else{
                return
            }
            switch result {
            case .success(let urlString):
                print("uploaded messagePhoto: \(urlString)")
                
                guard let url  = URL(string: urlString),
                    let plcaceholder = UIImage(systemName: "plus") else {
                        return
                }
                
                let media = Media(url: url, image: nil, placeholderImage: plcaceholder, size: .zero)
                
                let message = Message(sender: selfSender,
                                      messageId: messageId,
                                      sentDate: Date(),
                                      kind: .photo(media))
                
                DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in
                    if success {
                        print("sent photo message")
                    }else {
                        print("failed to send photo message")
                    }
                    
                })
                
            case .failure( _):
                print("message photo upload error")
            }
        })
        
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
        let message = Message(sender: selfSender,
                              messageId: messageId,
                              sentDate: Date(),
                              kind: .text(text))
        
        messageInputBar.inputTextView.text = ""
        if isNewConversation{
            
            //????????????????????????
            DatabaseManager.shared.createNewConversation(with: otherUserEmail,name:self.title ?? "User" ,firstMessage: message, completion: {[weak self] success in
                if success {
                    print("message sent")
                    self?.isNewConversation = false
                }
                else{
                    print("fail to sent")
                }
            })
        }else{
            guard let conversationId = conversationid, let name = self.title else {
                return
                
            }
            
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name:name ,newMessage: message, completion: { success in
                if success {
                    print("message sent")
                    
                    
                }else{
                    print("failed to send")
                }
            })
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
        //        return sender(photoURL: " ", senderId: " ", displayName: "")
        
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            break
        }
        
    }
    
    
}
extension ChatViewController: MessageCellDelegate{
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexpath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        let message = messages[indexpath.section]
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            let vc = PhotoViewerViewController(with: imageUrl)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
