//
//  JSONResponse.swift
//  Unicef Kid Power
//
//  Created by Ailicec Tovar on 8/22/17.
//  Copyright © 2017 Teravision. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class JSONResponse: Mappable{
    
    var message:String?
    var error: String?
    var code:Int?
    var data: AnyObject?
    var pager: Pager?
    
    required init?(map: Map) {
        //mapping(map)
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        error <- map["error"]
        code <- map["status"]
        data <- map["data"]
        pager <- map["pager"]
    }
}
