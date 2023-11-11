//
//  DeveloperService.swift
//  Sirion
//
//  Created by IC Deis on 10/17/23.
//

import Foundation

class DeveloperService {
   
   static let shared = DeveloperService()
   private init() { }
   
   func getSettingOptions() -> [SettingSectionModel] {
      let models1 = [
         SectionRowModel(title: "Profile Photo", image: "photo", color: .blue),
         SectionRowModel(title: "Display Name", image: "pencil.line", color: .systemMint.withAlphaComponent(0.7)),
         SectionRowModel(title: "Username", image: "at", color: .purple),
         SectionRowModel(title: "Bio", image: "text.badge.checkmark", color: .orange),
         SectionRowModel(title: "City Name", image: "mappin.and.ellipse", color: .orange),
         SectionRowModel(title: "App Language", image: "globe", color: .systemTeal),
         SectionRowModel(title: "Sign Out", image: "arrow.uturn.backward", color: .black)
      ]
      let models2 = [
         SectionRowModel(title: "Website", image: "photo", color: .cyan),
         SectionRowModel(title: "Privacy Policy", image: "at", color: .systemTeal),
         SectionRowModel(title: "Condition & Terms", image: "pencil", color: .green)
      ]
      
      let models3 = [
         SectionRowModel(title: "Condition & Terms", image: "pencil", color: .green)
      ]
      
      let sections = [
         SettingSectionModel(title: "Profile", rows: models1),
         SettingSectionModel(title: "Application", rows: models2),
         SettingSectionModel(title: "App", rows: models3)
      ]
      
      return sections
   }
   
  
   func getPosts() -> [Post] {
      let posts = [
         Post(
            postID: "kjk",
            userID: "dggn",
            username: "IC Deis",
            caption: "Power to change manything. Say hello to a Mac that is extreme in every way. With the greatest performance.",
            dateAdded: Date(),
            likes: ["efrg"],
            imageURL: "https://i.pinimg.com/736x/fd/1c/c2/fd1cc2bf411ea40a402470c522334785--winter-scenery-winter-trees.jpg"),
         Post(postID: "d10r", 
              userID: "dg3685",
              username: "DEVISS",
              caption: "Power to change manything. Say hello to a Mac that is extreme in every way. With the greatest performance.",
              dateAdded: Date(), 
              likes: [],
              imageURL: "https://bogatyr.club/uploads/posts/2023-03/thumbs/1678476638_bogatyr-club-p-fon-dlya-rabochego-stola-kompyutera-tsveti-30.jpg"),
         Post(
            postID: "1r9fb",
            userID: "dg6843",
            username: "EDDESS",
            caption: "Expansion and configurability yet, it is a system created to let a wide range of professionals push the limits of what is possible.",
            dateAdded: Date(),
            likes: [],
            imageURL: "https://image.winudf.com/v2/image/Y29tLnB5YXcuZmxvd2VyaGRfc2NyZWVuc2hvdHNfOV9mNDJlMWIyNg/screen-9.jpg?fakeurl=1&type=.jpg"),
         Post(postID: "d1068r", 
              userID: "34dg",
              username: "Platinium S",
              caption: "Power to change manything. Say hello to a Mac that is extreme in every way. With the greatest performance.",
              dateAdded: Date(), 
              likes: [],
              imageURL: "https://sun9-31.userapi.com/impf/XBrbexAtPVQgCP_0VLNoAP8rgvBkWoCWrjH-NA/Vg2k0W0uf0s.jpg?size=807x539&quality=96&sign=1c185aad4384322b0a7a0ca7cd091178&c_uniq_tag=0UzvCxxM9zfOFqpOMGbkAedgq1tH__IstjwCjoMjHi8&type=album"),
         Post(postID: "1r9hfb", 
              userID: "dg433",
              username: "LaaFerta",
              caption: "Expansion and configurability yet, it is a system created to let a wide range of professionals push the limits of what is possible.",
              dateAdded: Date(), 
              likes: [],
              imageURL: "https://avatars.mds.yandex.net/get-pdb/2905812/1f60975a-4d32-4631-90cd-82d750c35820/s1200?webp=false")
      ]
      return posts
   }
   
}
