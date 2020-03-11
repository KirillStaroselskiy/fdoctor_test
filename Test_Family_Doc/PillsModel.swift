//
//  PillsModel.swift
//  Test_Family_Doc
//
//  Created by  user on 09.03.2020.
//  Copyright © 2020  user. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

struct PillsModelWrapper: Codable, Parseable, Equatable {
    typealias ParseableType = PillsModelWrapper
    
    let status: String?
    let pills: [PillsModel]?
    
}

class PillsModel:Object, Codable, Parseable{
    typealias ParseableType = PillsModel

    var id = RealmOptional<Int>()
    @objc dynamic var name: String?
    @objc dynamic var img: String?
    @objc dynamic var desription: String?
    @objc dynamic var dose: String?
    
    
    override static func primaryKey() -> String?
       {
           return "id"
       }
}
