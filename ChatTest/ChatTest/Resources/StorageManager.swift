//
//  StorageManager.swift
//  ChatTest
//
//  Created by 김수환 on 2020/07/26.
//  Copyright © 2020 김수환. All rights reserved.
//

import Foundation
import FirebaseStorage

final class StorageManager{
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    ///upload Picture to fireBase Storage and return with url String to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: {metadata , err in
            guard err == nil else{
                print("Failed to upload data to firebase for picture")
                completion(.failure(StrogeErrors.FaildToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else{
                    print("")
                    completion(.failure(StrogeErrors.FailedtoGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("download URl returned: \(urlString)")
                completion(.success(urlString))
            })
        })
        
    }
    
    ///Upload image that will be sent in a conversation message
    public func uploadPhoto(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
          storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: {metadata , err in
              guard err == nil else{
                  print("Failed to upload data to firebase for picture")
                  completion(.failure(StrogeErrors.FaildToUpload))
                  return
              }
              
              self.storage.child("message_images/\(fileName)").downloadURL(completion: {url, error in
                  guard let url = url else{
                      print("")
                      completion(.failure(StrogeErrors.FailedtoGetDownloadUrl))
                      return
                  }
                  
                  let urlString = url.absoluteString
                  print("download URl returned: \(urlString)")
                  completion(.success(urlString))
              })
          })
          
      }
    
    
    public enum StrogeErrors: Error{
        case FaildToUpload
        case FailedtoGetDownloadUrl
    }
    
    public func downloadURL (for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        reference.downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                completion(.failure(StrogeErrors.FailedtoGetDownloadUrl))
                return
            }
            completion(.success(url))
        })
    
    }
    
    
}
