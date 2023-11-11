//
//  StorageManager.swift
//  InstaDC
//
//  Created by IC Deis on 6/22/23.
//

import SwiftUI
import FirebaseStorage


final class StorageManager {
   
   static let shared = StorageManager()
   private init() { }
   
   let imageCache: NSCache<NSString, UIImage> = {
      let cache = NSCache<NSString, UIImage>()
      cache.totalCostLimit = 1024 * 1024 * 200
      cache.countLimit = 200
      return cache
   }()
   enum Bucket: String {
      case profile = "profile"
      case post = "post"
   }
   
   private let storage = Storage.storage().reference()
   private func userReference(uid: String) -> StorageReference { storage.child("photos").child(uid) }
   private var photoReference: StorageReference { storage.child("photos") }
   private func bucketReference(filename: String, bucket: Bucket, uid: String) -> StorageReference {
      if bucket == .profile {
         return userReference(uid: uid).child(filename)
      } else {
         return storage.child("postImages").child(filename)
      }
   }
   
   /// This function uploads image to Firebase Storage and returns image's absolute string url
   func uploadImage(image: UIImage, filename: String, bucket: Bucket) async throws -> (path: String, url: String) {
      guard let imageData = getCompressedImage(image: image) else { throw URLError(.cannotDecodeContentData) }
      let user = try UserManager.shared.getUserCurrent()
      let meta = StorageMetadata()
      meta.contentType = "image/jpeg"
      
      let metadata = try await bucketReference(filename: filename, bucket: bucket,
                                               uid: user.uid).putDataAsync(imageData, metadata: meta)
      guard let imagePath = metadata.path else { throw URLError(.badServerResponse) }
      
      return (imagePath, try await getImageUrl(path: imagePath))
   }
   
   
   func getProfilePhoto(withUid uid: String, completion: @escaping (_ image: UIImage) -> Void) {
      let path = getImagePath(with: uid)
      getImage(path: path) { image in
         completion(image)
      }
   }
   
   func getPostImage(withUrl urlString: String, completion: @escaping (_ image: UIImage) -> Void) {
      let path = storage.storage.reference(forURL: urlString)
      getImage(path: path) { image in
         completion(image)
      }
   }
   
   private func getImageUrl(path: String) async throws -> String {
      let url = try await photoReference.storage.reference(withPath: path).downloadURL()
      return url.absoluteString
   }
   
   func getImage(withUrl urlString: String) async throws -> UIImage {
      if let cachedImage = imageCache.object(forKey: urlString as NSString) {
         return cachedImage
      } else {
         guard let url = URL(string: urlString) else { throw URLError(.badURL) }
         let (data, response) = try await URLSession.shared.data(from: url)
         guard let res = response as? HTTPURLResponse,
               res.statusCode >= 200 && res.statusCode < 300 else { throw URLError(.badServerResponse) }
         
         guard let uiImage = UIImage(data: data) else { throw URLError(.cannotDecodeRawData) }
         saveToCache(path: urlString, image: uiImage)
         return uiImage
      }
   }

   func updateCache(uid: String, image: UIImage) {
      let path = getImagePath(with: uid)
      saveToCache(path: path.fullPath, image: image)
   }
   
}


extension StorageManager {
   
   private func getImage(path: StorageReference, completion: @escaping (_ image: UIImage) -> Void) {
      if let cachedImage = imageCache.object(forKey: path.fullPath as NSString) {
         completion(cachedImage)
      } else {
         path.getData(maxSize: 20 * 1024 * 1024) { data, error in
            if let _ = error { return }
            guard let imageData = data else { return }
            guard let uiimage = UIImage(data: imageData) else { return }
            self.saveToCache(path: path.fullPath, image: uiimage)
            completion(uiimage)
         }
      }
   }
   
   private func saveToCache(path: String, image: UIImage) {
      self.imageCache.setObject(image, forKey: path as NSString)
   }
   
   private func getImagePath(with uid: String) -> StorageReference {
      return Storage.storage().reference(withPath: "photos/\(uid)/profile_photo")
   }
   
   private func getCompressedImage(image: UIImage) -> Data? {
      var compression: CGFloat = 1.0
      let maxCompression: CGFloat = 0.05
      let maxFileSize: Int = 240 * 240
      
      guard var imageData = image.jpegData(compressionQuality: compression) else { return nil }
      
      while imageData.count > maxFileSize && compression > maxCompression {
         compression -= 0.05
         if let data = image.jpegData(compressionQuality: compression) {
            imageData = data
         }
      }
      return imageData
   }
   
}
