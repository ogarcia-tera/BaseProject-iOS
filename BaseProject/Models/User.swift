//
//  User.swift
//  Unicef Kid Power
//
//  Created by Ailicec Tovar on 8/22/17.
//  Copyright © 2017 Teravision. All rights reserved.
//

import Foundation
import ObjectMapper


class User: NSObject, NSCoding, Mappable{
    
    var entityId:Int?
    var email:String?
    
    
    override init() {}
    
    required init?(map: Map) {
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        entityId = aDecoder.decodeObject(forKey: "entityId") as? Int
        email = aDecoder.decodeObject(forKey: "email") as? String
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(entityId, forKey: "entityId")
        aCoder.encode(email, forKey: "email")
        
    }
    
    func mapping(map: Map) {
        
        entityId <- map["account.id"]
        email <- map["account.email"]
        
    }
    
}
