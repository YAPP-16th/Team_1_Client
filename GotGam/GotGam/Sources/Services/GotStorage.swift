//
//  TaskStorage.swift
//  GotGam
//
//  Created by woong on 04/04/2020.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

class GotStorage: GotStorageType {
    private var list = [
      Got(title:"1번", id: 1, latitude: 100.0 , longitude: 100.0 , isDone: false)
        ]
        
        private lazy var store = BehaviorSubject<[Got]>(value: list)
       
        
        @discardableResult
		func createMemo(title: String, id: Int64, insertedDate: Date, content: String, tag: String,
						latitude: Double, longitude: Double, isDone: Bool, place: String) -> Observable<Got> {
            let memo = Got(title: title, id: id)
            list.append(memo)
            
            store.onNext(list)
			DBManager.share.saveContext()
            
            return Observable.just(memo)
        }
        
        @discardableResult
        func memoList() -> Observable<[Got]> {
            return store
        }
        
        
        @discardableResult
		func update(title: Got, updatedtitle: String, id: Int64) -> Observable<Got> {
         let updated = Got(original: title, updatedTitle: updatedtitle)
            
            
            if let index = list.firstIndex(where: { $0 == title}) {
                list.remove(at: index)
                list.insert(updated, at: index)
            }
            
            
            store.onNext(list)
            
            
            return Observable.just(updated)
        }
        
        
        @discardableResult
        func delete(title: Got) -> Observable<Got> {
            if let index = list.firstIndex(where: { $0 == title}) {
                list.remove(at: index)
            }
    
            store.onNext(list)
    
            return Observable.just(title)
        }
}
