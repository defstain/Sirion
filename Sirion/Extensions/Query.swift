//
//  Query.swift
//  InstaDC
//
//  Created by IC Deis on 6/26/23.
//

import Firebase

extension Query {
   
   /// Generic JSON Decoder function
   func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
      let snapshot = try await self.getDocuments()
      return try snapshot.documents.map { try $0.data(as: T.self) }
   }
   
}
