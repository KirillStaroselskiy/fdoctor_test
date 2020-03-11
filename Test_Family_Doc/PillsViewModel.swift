//
//  PillsViewModel.swift
//  Test_Family_Doc
//
//  Created by  user on 09.03.2020.
//  Copyright © 2020  user. All rights reserved.
//

import Foundation
import RealmSwift

class PillsViewModel {
    var servises = Services()
    var pills = RealmManager.shared.getResultsFromDB(PillsModel.self)
    
    func fetch(callBack: (() -> ())?) {
        servises.apiService.getPills({[weak self] items, error in
            guard let pills = items else {
                print(error?.localizedDescription ?? "ERROR")
                return
            }
            
            print(pills)
            self?.migrateData(current: pills){
                pills.forEach {
                    RealmManager.shared.save($0)
                }
            }
            self?.pills = RealmManager.shared.getResultsFromDB(PillsModel.self)
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            callBack?()

        })
    }
    
    func migrateData(current pills: [PillsModel], callBack: (() -> ())? ) {
        let oldPills = RealmManager.shared.getResultsFromDB(PillsModel.self)
        var oldIds = [Int]()
        var newIds = [Int]()
        var count = 0
        
        oldPills.forEach{ pill in
            if let id = pill.id.value {
                oldIds.append(id)
            }
        }
        
        pills.forEach{ task in
            if let id = task.id.value {
                newIds.append(id)
            }
        }
        
        oldIds.forEach{ oldId in
            newIds.forEach{ newId in
                if oldId == newId {
                    oldIds.remove(at: count)
                    count -= 1
                }
            }
            count += 1
        }
        
        oldPills.forEach { pill in
            if let pillId = pill.id.value {
                oldIds.forEach { id in
                    if pillId == id {
                        RealmManager.shared.deleteData(delete: pill)
                    }
                }
            }
        }
        callBack?()
    }
    
}
