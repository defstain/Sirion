//
//  SettingRowModel.swift
//  Sirion
//
//  Created by IC Deis on 10/17/23.
//

import UIKit

struct SettingSectionModel {
   let title: String
   let rows: [SectionRowModel]
}


struct SectionRowModel {
   let id = UUID().uuidString
   let title: String
   let image: String
   let color: UIColor

}
