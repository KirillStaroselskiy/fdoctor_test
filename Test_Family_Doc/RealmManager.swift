//
//  RealmManager.swift
//  Test_Family_Doc
//
//  Created by  user on 10.03.2020.
//  Copyright © 2020  user. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

open class RealmManager {
    
    static let shared = RealmManager()
    
    private let realm = try! Realm()
    private var token: NotificationToken?

    func saveAsync<T: Object>(_ modal: T) {
        let backgroundQueue = DispatchQueue(label: ".realm", qos: .background)
        backgroundQueue.async {
            let realm = try! Realm()
            try! realm.write {
                realm.add(modal, update: .modified)
            }
        }
    }
    
    func save<T: Object>(_ modal: T) {
        do{
            try? realm.write {
                    realm.add(modal, update: .modified)
            }
        }
    }
    
    func update(_ block: ()->Void) {
         do{
            try? realm.write(block)
            
        }
    }
    
     func getResultsFromDB<T: Object>(_ modal: T.Type) -> Results<T> {
        return realm.objects(modal.self)
    }
    
    func getResultFromDB<T: Object, KeyType>(_ modal: T.Type, forPrimaryKey: KeyType) -> T? {
        return realm.object(ofType: modal.self, forPrimaryKey: forPrimaryKey)

    }
    
    func deleteData<T: Object>(delete modal: T){
        do{
            try? realm.write {
                realm.delete(modal)
            }
        }
    }
    
    func deleteAllData(){
        do{
            try? realm.write {
                realm.deleteAll()
            }
        }
    }
}
