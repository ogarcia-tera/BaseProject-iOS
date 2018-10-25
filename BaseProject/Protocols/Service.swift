//
//  Service.swift
//  Unicef Kid Power
//
//  Created by Ailicec Tovar on 8/22/17.
//  Copyright © 2017 Teravision. All rights reserved.
//

import Foundation

protocol Service{
    
    func callServiceObject(parameters:[String: AnyObject]?,service:String, withCompletionBlock: @escaping  ((AnyObject?, _ error: NSError?) -> Void))
    
}
