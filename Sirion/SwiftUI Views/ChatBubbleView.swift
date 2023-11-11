//
//  ChatBubbleView.swift
//  InstaDC
//
//  Created by IC Deis on 7/24/23.
//

import SwiftUI

struct UserMessageRow: View {
   let message: String
   
   var body: some View {
      HStack(alignment: .bottom) {
         Text(message)
            .padding(EdgeInsets(top: 8, leading: 13, bottom: 8, trailing: 13))
            .background(Color.gray.opacity(0.5))
            .cornerRadius(15, corners: [.topRight, .topLeft, .bottomRight,])
            .frame(maxWidth: UIScreen.main.bounds.width * 0.85, alignment: .leading)
         
         Spacer()
      }
   }
}

struct MyMessageRow: View {
   let message: String
   
   var body: some View {
      HStack(alignment: .bottom) {
         Spacer()
         Text(message)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 10, leading: 13, bottom: 10, trailing: 13))
            .background(.blue.opacity(0.9))
            .cornerRadius(15, corners: [.topRight, .topLeft, .bottomLeft,])
            .frame(maxWidth: UIScreen.main.bounds.width * 0.85, alignment: .trailing)
      }
   }
}

struct MessageBubbleView_Previews: PreviewProvider {
   static var previews: some View {
      Group {
         UserMessageRow(message: "how are you?")
         MyMessageRow(message: "Not bad, thanks!")
      }
      
   }
}
