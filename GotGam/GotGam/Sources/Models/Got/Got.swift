//
//  Got.swift
//  GotGam
//
//  Created by woong on 04/04/2020.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

struct Got: Equatable {
   
    var id: String = ""
    var createdDate: Date = Date()
    var title: String = ""
    var latitude: Double
    var longitude: Double
    var radius: Double = 150
    var place: String
    var arriveMsg: String = ""
    var deparetureMsg: String
    var insertedDate: Date?
    var onArrive: Bool = true
    var onDeparture: Bool = false
    var onDate: Bool = false
    var tag : Tag?
    var isDone: Bool = false
    var readyArrive: Bool = true
    var readyDeparture: Bool = false
    // ManagedGot을 가져오기 위한
    var objectIDString: String? = ""
    var objectId: NSManagedObjectID?
    
    init(
        id: String,
        createdDate: Date,
        title: String,
        latitude: Double,
        longitude: Double,
        radius: Double,
        place: String,
        arriveMsg: String,
        deparetureMsg: String,
        insertedDate: Date?,
        onArrive: Bool,
        onDeparture: Bool,
        onDate: Bool,
        tag: Tag?,
        isDone: Bool,
        readyArrive: Bool,
        readyDeparture: Bool
    ) {
        self.id = id
        self.createdDate = createdDate
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.place = place
        self.arriveMsg = arriveMsg
        self.deparetureMsg = deparetureMsg
        self.insertedDate = insertedDate
        self.onArrive = onArrive
        self.onDeparture = onDeparture
        self.onDate = onDate
        self.tag = tag
        self.isDone = isDone
        self.readyArrive = readyArrive
        self.readyDeparture = readyDeparture
    }
    
	
    
    //타이틀만 바꿀 때
    init(original: Got, updatedTitle: String){
        self = original
        self.title = updatedTitle
        
    }
    
    //빠른심기 사용시 사용
    init(id: String, title: String, latitude: Double, longitude: Double, radius: Double = 150, place: String, insertDate: Date? = nil, tag: Tag? = nil){
        self.id = id
        self.createdDate = Date()
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.place = place
        self.arriveMsg = ""
        self.deparetureMsg = ""
        self.insertedDate = insertDate
        self.onArrive = true
        self.onDeparture = false
        self.onDate = false
        self.tag = tag
        self.isDone = false
        self.readyArrive = false
        self.readyDeparture = false
        self.objectIDString = ""
    }
    
    public static func ==(lhs: Got, rhs: Got) -> Bool {
        return lhs.objectId == rhs.objectId
    }

    
}

extension Got {
    var mapPoint: MTMapPoint {
        return .init(geoCoord: .init(latitude: latitude, longitude: longitude))
    }
    
    var locationCoordinate2D: CLLocationCoordinate2D {
        return .init(latitude: latitude, longitude: longitude)
    }
}
