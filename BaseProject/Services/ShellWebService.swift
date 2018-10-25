//
//  ShellWebService.swift
//  Unicef Kid Power
//
//  Created by Ailicec Tovar on 8/22/17.
//  Copyright © 2017 Teravision. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import KSToastView
import KVNProgress
import CocoaLumberjack

class ShellWebService : Service {
    
    var currentChannel:String = "0"
    var currentId = 0
    var teamId = 0
    var refresh: Int = 0
    var tokenRefreshBool: Bool = true
    var idProfileFriend = ""
    var userNameSearch = ""
    var pageFriend = ""
    var currentUserId = ""

    func selectWebService(service:String, params:[String:AnyObject]?, returnService: ((_ method: HTTPMethod, _ serviceUrl: String?, _ typeEncoding: ParameterEncoding) -> Void)){
        
        tokenRefreshBool = true
        
        switch service {
        case GlobalConstants.nameServices.logout:
            returnService(.post,GlobalConstants.Endpoints.logoutWS, JSONEncoding())
            tokenRefreshBool = false
            break
        case GlobalConstants.nameServices.login:
            // returnService(.post,GlobalConstants.Endpoints.loginWS, JSONEncoding())
            let type = params?["type"] as! String
            returnService(.post,GlobalConstants.Endpoints.getLoginWS(type: type), JSONEncoding())
            tokenRefreshBool = false
            break
        case GlobalConstants.nameServices.accountRegister:
            returnService(.post,GlobalConstants.Endpoints.accountRegisterWS, JSONEncoding())
            tokenRefreshBool = false
            break
        case GlobalConstants.nameServices.account:
            returnService(.get,GlobalConstants.Endpoints.accountWS, URLEncoding())
            break
        case GlobalConstants.nameServices.accountKeys:
            let id = params?["accountId"] as! Int
            returnService(.get,GlobalConstants.Endpoints.accountKeysWS(accountId: id), URLEncoding())
            break
        case GlobalConstants.nameServices.accountKeysAdd:
            let id = params?["accountId"] as! Int
            returnService(.post,GlobalConstants.Endpoints.accountKeysWS(accountId: id), JSONEncoding())
            break
        case GlobalConstants.nameServices.activityRegister:
            returnService(.post,GlobalConstants.Endpoints.activitiesWS, JSONEncoding())
            break
        case GlobalConstants.nameServices.activityUpdate:
            returnService(.put,GlobalConstants.Endpoints.activitiesWS, JSONEncoding())
            break
        case GlobalConstants.nameServices.activityDelete:
            returnService(.delete,GlobalConstants.Endpoints.activitiesWS, JSONEncoding())
            break
        case GlobalConstants.nameServices.activities:
            returnService(.get,GlobalConstants.Endpoints.activitiesWS, URLEncoding())
            break
        case GlobalConstants.nameServices.activityById:
            returnService(.get,GlobalConstants.Endpoints.activitiesWS, URLEncoding())
            break
        case GlobalConstants.nameServices.avatars:
            returnService(.get,GlobalConstants.Endpoints.avatarsWS, URLEncoding())
            break
        case GlobalConstants.nameServices.avatarById:
            returnService(.get,GlobalConstants.Endpoints.getAvatarById(avatarId:String(currentId)), URLEncoding())
            break
        case GlobalConstants.nameServices.profileChange:
            returnService(.post,GlobalConstants.Endpoints.profileChangeWS(profileId: String(currentId)), JSONEncoding())
            break
        case GlobalConstants.nameServices.profileDelete:
            returnService(.delete,GlobalConstants.Endpoints.getProfileInfo(profileId: String(currentId)), JSONEncoding())
            break
        case GlobalConstants.nameServices.trackerRegister:
            returnService(.post,GlobalConstants.Endpoints.trackersWS, JSONEncoding())
            break
        case GlobalConstants.nameServices.trackerUpdate:
            returnService(.put,GlobalConstants.Endpoints.trackerByIdWS(trackerId: currentId), JSONEncoding())
            break
        case GlobalConstants.nameServices.trackerDelete:
            returnService(.delete,GlobalConstants.Endpoints.trackerByIdWS(trackerId: currentId), JSONEncoding())
            break
        case GlobalConstants.nameServices.trackers:
            returnService(.get,GlobalConstants.Endpoints.trackersWS, URLEncoding())
            break
        case GlobalConstants.nameServices.trackerById:
            let id = params?["trackerId"] as! Int
            returnService(.get,GlobalConstants.Endpoints.trackerByIdWS(trackerId: id), URLEncoding())
            break
        case GlobalConstants.nameServices.channels:
            let isGroup = params?["isGroup"] as! Bool
            returnService(.get,GlobalConstants.Endpoints.channelWS(isGroup: isGroup), URLEncoding())
            break
        case GlobalConstants.nameServices.channelById:
            returnService(.get,GlobalConstants.Endpoints.channelWS2, URLEncoding())
            break
        case GlobalConstants.nameServices.profileStatus: 
            let id = params?["profileId"] as! String
            let channel = params?["channelId"] as! String
            returnService(.get,GlobalConstants.Endpoints.getProfileStatusInChannel(profileId: id, channelId: channel ), URLEncoding())
            break
        case GlobalConstants.nameServices.profileInfo:
            if let id = UKPHelper.currentUser()?.profile?.entityId{
                returnService(.get,GlobalConstants.Endpoints.getProfileInfo(profileId: String(id)), URLEncoding())
            }
            break
        case GlobalConstants.nameServices.profileUpdate:
            if let id = UKPHelper.currentUser()?.profile?.entityId{
                returnService(.put,GlobalConstants.Endpoints.getProfileInfo(profileId: String(id)), JSONEncoding())
            }
            break
        case GlobalConstants.nameServices.stepsConsumption:
            let id = String(UKPHelper.currentUser()!.profile!.entityId!)
            returnService(.post,GlobalConstants.Endpoints.getProfileStatusInChannel(profileId: id, channelId: currentChannel)+"/energy", JSONEncoding())
            break
        case GlobalConstants.nameServices.getReward:
            let channel = params?["channelId"] as! String
            let waypoint = params?["waypointId"] as! String
            returnService(.get,GlobalConstants.Endpoints.getRewardForWaypointInChannel(channelID:channel, waypointID:waypoint), URLEncoding())
            break
        case GlobalConstants.nameServices.claimReward:
            let channel = params?["channelId"] as! String
            let waypoint = params?["waypointId"] as! String
            returnService(.post,GlobalConstants.Endpoints.getRewardForWaypointInChannel(channelID:channel, waypointID:waypoint), URLEncoding())
            break
        case GlobalConstants.nameServices.checkTrackerAvailability:
            let trackerFactoryID = params?["tracker_factory_id"] as! String
            returnService(.get,GlobalConstants.Endpoints.checkTrackerAvailabilityWS(trackerFactoryID: trackerFactoryID), URLEncoding())
            break
        case GlobalConstants.nameServices.createProfile:
            returnService(.post,GlobalConstants.Endpoints.createProfileWS, JSONEncoding())
            break
        case GlobalConstants.nameServices.refreshToken:
            returnService(.post,GlobalConstants.Endpoints.refreshTokenWebService, JSONEncoding())
            break
        case GlobalConstants.nameServices.updateProfile:
            if let id = UKPHelper.currentUser()?.profile?.entityId{
                let profileID = UKPHelper.isGroup() ? String(params?["roster_id"] as! Int) :  String(id)
                returnService(.put,GlobalConstants.Endpoints.updateProfile(profileId: profileID), JSONEncoding())
            }
        case GlobalConstants.nameServices.deleteTracker:
            let id = params?["trackerId"] as! Int
            returnService(.delete,GlobalConstants.Endpoints.trackerByIdWS(trackerId: id), URLEncoding())
            break
        case GlobalConstants.nameServices.notificationForgotPassword:
            returnService(.post,GlobalConstants.Endpoints.notificationForgotPasswordService, JSONEncoding())
            break
        case GlobalConstants.nameServices.resetForgotPassword:
            returnService(.post,GlobalConstants.Endpoints.resetPasswordService, JSONEncoding())
            break
        case GlobalConstants.nameServices.unlockWaypoint:
            let channel = params?["channelId"] as! String
            let waypoint = params?["waypointId"] as! String
            returnService(.post,GlobalConstants.Endpoints.unlockWaypointInChannel(channelID: channel, waypointID: waypoint), JSONEncoding())
            break
        case GlobalConstants.nameServices.friends:
            let id = params?["profileId"] as! String
            returnService(.get,GlobalConstants.Endpoints.friendsWS(profileId: id), URLEncoding())
            break
        case GlobalConstants.nameServices.deleteFriend:
            let profileId = params?["profileId"] as! String
            let friendProfileId = params?["friendProfileId"] as! String
            returnService(.delete,GlobalConstants.Endpoints.deleteFriendWS(profileId: profileId, friendProfileId: friendProfileId), URLEncoding())
            break
        case GlobalConstants.nameServices.sendFriendRequest:
            var idUser = ""
            if let id = UKPHelper.currentUser()?.profile?.entityId{
                idUser = String(id)
            }
            returnService(.put,GlobalConstants.Endpoints.sendFriendRequestWS(idProfileUser: idUser, idProfileFriend: idProfileFriend), JSONEncoding())
            break
        case GlobalConstants.nameServices.acceptRejectFriendRequest:
            var idUser = ""
            if let id = UKPHelper.currentUser()?.profile?.entityId{
                idUser = String(id)
            }
            returnService(.post,GlobalConstants.Endpoints.acceptRejectFriendRequestWS(idProfileUser: idUser, idProfileFriend: idProfileFriend), JSONEncoding())
            break
        case GlobalConstants.nameServices.getLeaderboadGlobal:
            returnService(.get,GlobalConstants.Endpoints.getLeaderboardGlobalWebService, URLEncoding())
            break
        case GlobalConstants.nameServices.getLeaderboadFriends:
            returnService(.get,GlobalConstants.Endpoints.getLeaderboardFriendsWebService, URLEncoding())
            break
        case GlobalConstants.nameServices.searchFriend:
            returnService(.get,GlobalConstants.Endpoints.createProfileWS, URLEncoding())
            break
        case GlobalConstants.nameServices.receivedOrAnsweredFriend:
            var idUser = ""
            if let id = UKPHelper.currentUser()?.profile?.entityId{
                idUser = String(id)
            }
            returnService(.get,GlobalConstants.Endpoints.receivedAnsweredFriendRequestWS(profileId: idUser), URLEncoding())
            break
        case GlobalConstants.nameServices.getTeams:
            returnService(.get,GlobalConstants.Endpoints.getTeamsWebService, URLEncoding())
            break
        case GlobalConstants.nameServices.getPrivateTeams:
            returnService(.get,GlobalConstants.Endpoints.getPrivateTeamsWebService, URLEncoding())
            break
        case GlobalConstants.nameServices.getTeamsByName:
            returnService(.get,GlobalConstants.Endpoints.getTeamsWebService, URLEncoding())
            break
        case GlobalConstants.nameServices.getPrivateTeamsByID:
            returnService(.get,GlobalConstants.Endpoints.getPrivateTeamsWebService, URLEncoding())
            break
        case GlobalConstants.nameServices.getTeamDetail:
            returnService(.get,GlobalConstants.Endpoints.getTeamDetailWebService(teamId: String(teamId)), URLEncoding())
            break
        case GlobalConstants.nameServices.getTeamsByProfile:
            returnService(.get,GlobalConstants.Endpoints.getTeamsByProfileWebService(profileId: String(currentId)), URLEncoding())
            break
        case GlobalConstants.nameServices.joinATeam:
            returnService(.put,GlobalConstants.Endpoints.setMembershipTeamWebService(profileId:String(currentId), teamId: String(teamId)), URLEncoding())
            break
        case GlobalConstants.nameServices.leaveATeam:
            returnService(.delete,GlobalConstants.Endpoints.setMembershipTeamWebService(profileId:String(currentId), teamId: String(teamId)), URLEncoding())
            break
        case GlobalConstants.nameServices.leaderboardByTeam:
            break
        case GlobalConstants.nameServices.leaderboardFriendsByTeam:
            returnService(.get,GlobalConstants.Endpoints.getLeaderboardFriendsByTeamWebService(teamId: String(teamId)), URLEncoding())
            break
        case GlobalConstants.nameServices.getCheers:
            var currentProfileID = ""
            if let id = UKPHelper.currentUser()?.profile?.entityId{
                currentProfileID = String(id)
            }
            returnService(.get,GlobalConstants.Endpoints.cheersWS(profileId: currentProfileID, targetProfileId:""), URLEncoding())
            break
        case GlobalConstants.nameServices.sendCheers:
            var currentProfileID = ""
            if let id = UKPHelper.currentUser()?.profile?.entityId{
                currentProfileID = String(id)
            }
            let friendProfileId = params?["friendProfileId"] as! String
            returnService(.put,GlobalConstants.Endpoints.cheersWS(profileId: currentProfileID, targetProfileId:friendProfileId), URLEncoding())
            break
        case GlobalConstants.nameServices.readCheers:
            var currentProfileID = ""
            if let id = UKPHelper.currentUser()?.profile?.entityId{
                currentProfileID = String(id)
            }
            returnService(.post,GlobalConstants.Endpoints.cheersWS(profileId: currentProfileID, targetProfileId:""), URLEncoding())
            break
        case GlobalConstants.nameServices.getAccountTeams:
            var currentAccountID = ""
            if let id = UKPHelper.currentUser()?.entityId{
                currentAccountID = String(id)
            }
            returnService(.get,GlobalConstants.Endpoints.getAccountTeamsWebService(accountId: String(currentAccountID)), URLEncoding())
            break
        case GlobalConstants.nameServices.getAccountTeamDetail:
            var currentAccountID = ""
            if let id = UKPHelper.currentUser()?.entityId{
                currentAccountID = String(id)
            }
            returnService(.get,GlobalConstants.Endpoints.getAccountTeamDetailWebService(accountId: currentAccountID, teamId: String(teamId)), URLEncoding())
            break
        case GlobalConstants.nameServices.activityGroupSyncRegister:
            returnService(.post,GlobalConstants.Endpoints.activityGroupSyncRegisterWS, JSONEncoding())
            break
        case GlobalConstants.nameServices.getAvailableTrackersWS:
            returnService(.post,GlobalConstants.Endpoints.getTrackersAvailable, JSONEncoding())
            break
        case GlobalConstants.nameServices.getAvailableUpdateFWBandWS:
            let typeBandFW = params?["typeBandFW"] as! String
            let fwVersion = params?["fwVersion"] as! String
            returnService(.get,GlobalConstants.Endpoints.getUpdateFWBandWebService(typeBandFW: typeBandFW, FW: fwVersion), URLEncoding())
            break
        case GlobalConstants.nameServices.getNewsUpdate:
            returnService(.get,GlobalConstants.Endpoints.getNewsUpdateVersion, URLEncoding())
            break
        case GlobalConstants.nameServices.setDeviceTokenInCustomerIOWS:
            returnService(.put,GlobalConstants.Endpoints.setDeviceTokenInCustomerIO(userId: currentUserId), JSONEncoding())
            break
        default:
            break
        }
    }
    
    func editParameters(parameters: [String : AnyObject]?)->[String : AnyObject]?{
        
        var parametersEdited:[String : AnyObject] = [:]
        if parameters != nil{
            parametersEdited = parameters!
        }
        
        return parametersEdited
    }
    
    func settingHeader()->[String : String]?{
        
        var header:[String : String] = ["Content-Type": GlobalConstants.Headers.contentType, "Accept":GlobalConstants.Headers.contentType]
        if(self.tokenRefreshBool){
            if let token = (UKPSessionHelper.getSession(key: GlobalConstants.Keys.token) as? String) {
                header["Authorization"] = "Bearer " + token
            }
        }
        
        return header
    }
    
    func callServiceWithBasicAuth(parameters:[String: AnyObject]?,service:String, withCompletionBlock: @escaping ((AnyObject?, _ error: NSError?) -> Void)){
        selectWebService(service: service, params:parameters,  returnService: { (method, url, typeEncoding) -> Void in
            
            let conf = Configuration()
            let username = conf.environment.siteIdCustomerIO
            let password = conf.environment.apiKeyCustomerIO
            
            Alamofire.request(url!, method: method, parameters: parameters, encoding: typeEncoding, headers:nil)
                .authenticate(user: username, password: password)
                .responseJSON { response  in
                    if (response.result.error == nil){
                        withCompletionBlock(response.result.value as AnyObject, nil)
                    }else{
                        withCompletionBlock(nil, response.result.error! as NSError)
                    }
            }
        })
    }
    
    
    func callServiceObject(parameters:[String: AnyObject]?,service:String, withCompletionBlock: @escaping ((AnyObject?, _ error: NSError?) -> Void)){
        
        selectWebService(service: service, params:parameters,  returnService: { (method, url, typeEncoding) -> Void in
            
            let headers = settingHeader()
            let parametersEdited = self.editParameters(parameters: parameters)
            
            DDLogInfo("----------API SERVICE PARAMETERS-------------")
            DDLogInfo(url ?? "nil")
            if url?.lowercased().range(of:"login") == nil{
                DDLogVerbose("\(parametersEdited ?? ["parameterEdited": "nil" as AnyObject])")
            }
            DDLogVerbose("\(headers ?? ["header" : "nil"])")
            DDLogInfo("----------END API SERVICE PARAMETERS----------")
            
            
            Alamofire.request(url!, method: method, parameters: parametersEdited, encoding: typeEncoding, headers:headers)
                .responseObject{ (response: DataResponse<JSONResponse>) in
                    if(response.response?.statusCode != nil){
                        DDLogVerbose("\(String(describing: response.response?.statusCode))")
                    }else{
                        DDLogError("nil status code")
                    }
                    
                    if let statusCode = response.response?.statusCode, statusCode == 422 {
                        var errorMessage = ""
                        switch response.result{
                        case .success:
                            if !response.result.value!.message!.isEmpty {
                                errorMessage = response.result.value!.message!
                            } else if !response.result.value!.error!.isEmpty {
                                errorMessage = response.result.value!.error!
                            }else {
                                errorMessage = "errorServer".localized
                            }
                            break
                        case .failure( _):
                            errorMessage = "errorServer".localized
                            break
                        }
                        
                        let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: statusCode, userInfo: ["message":errorMessage])
                        DDLogError("Error code: \(error.code) Description: \(error.description) ")
                        withCompletionBlock(nil, error)
                        return
                    } else if let statusCode = response.response?.statusCode, statusCode == 401 {
                        if(self.tokenRefreshBool){
                            let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: statusCode, userInfo: ["message":"tokenExpired".localized])
                            DDLogError("Error code: \(error.code) Description: \(error.description) ")
                            DDLogInfo("go to refresh Attempts \(self.refresh)")
                            self.refreshToken(isArray: false, statuCode: statusCode, parameters: parameters, service: service, withCompletionBlock: withCompletionBlock)
                            return
                        }
                    }
                    
                    switch response.result{
                    case .success:
                        let code = response.result.value!.code
                        
                        if code! <= 299{
                            withCompletionBlock(response.result.value,nil)
                        }else{
                            var entity : AnyObject = "" as AnyObject
                            if let entityError = response.result.value{
                                entity = entityError
                            }
                            var errorMessage = ""
                            if !response.result.value!.message!.isEmpty {
                                errorMessage = response.result.value!.message!
                            } else {
                                if let resultErrorValue = response.result.value?.error{
                                    errorMessage = resultErrorValue
                                }else{
                                    errorMessage = "errorServer".localized
                                }
                            }
                            let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: code!, userInfo: ["message":errorMessage, "entity" : entity])
                            DDLogError("Error code: \(error.code) Description: \(error.description) ")
                            withCompletionBlock(nil,error)
                        }
                        break
                        
                    case .failure(let error):
                        var messageResponse = "errorServer".localized
                        let code : Int?
                        if response.response?.statusCode != nil{
                            code = response.response!.statusCode
                        }else{
                            if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet{
                                DDLogInfo("noInternetConection".localized.uppercased())
                                NotificationCenter.default.post(name: .noConections, object: nil)
                            }
                            code = 500
                        }
                        
                        DDLogInfo(response.result.error!.localizedDescription)
                        
                        let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: code!, userInfo: ["message": messageResponse])
                        DDLogError("Error code: \(error.code) Description: \(error.description) ")
                        withCompletionBlock(nil,error)
                        break
                    }//Switch
            }//Alamofire
        })//SelectWebService
    }//Function
    
    
    
    func callServiceObjectArray(parameters:[String: AnyObject]?,service:String, withCompletionBlock: @escaping ((AnyObject?, _ error: NSError?) -> Void)){
        
        selectWebService(service: service, params:parameters,  returnService: { (method, url, typeEncoding) -> Void in
            
            let headers = settingHeader()
            let parametersEdited = self.editParameters(parameters: parameters)
            var arrayParameters:[AnyObject] = []
            
            DDLogInfo("----------API SERVICE PARAMETERS-------------")
            DDLogInfo(url ?? "nil")
            DDLogVerbose("\(parametersEdited ?? ["parameterEdited": "nil" as AnyObject])")
            DDLogVerbose("\(headers ?? ["header" : "nil"])")
            DDLogInfo("----------END API SERVICE PARAMETERS----------")
            
            var request = URLRequest(url: URL(string: url!)!)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            
            
            if parameters != nil{
                request.httpBody = try! JSONSerialization.data(withJSONObject: parametersEdited!)
            }
            
            if ((parameters?.index(forKey: "data")) != nil){
                
                for myValue in (parameters?.values)! {
                    arrayParameters.append(myValue)
                }
                request.httpBody = try! JSONSerialization.data(withJSONObject: arrayParameters[0])
            }
            
            DDLogVerbose("\(arrayParameters)")
            //Alamofire.request(url!, method: method, parameters: parametersEdited, encoding: typeEncoding, headers:headers)
            
            Alamofire.request(request)
                .validate(statusCode: 200..<500)
                .responseJSON { response in
                    DDLogInfo("\(response)")
                    
                }
                .responseObject{ (response: DataResponse<JSONResponse>) in
                    if(response.response?.statusCode != nil){
                        DDLogVerbose("\(String(describing: response.response?.statusCode))")
                    }else{
                        DDLogError("nil status code")
                    }
                    
                    if let statusCode = response.response?.statusCode, statusCode == 422 {
                        
                        var errorMessage = ""
                        switch response.result{
                        case .success:
                            if !response.result.value!.message!.isEmpty {
                                errorMessage = response.result.value!.message!
                            } else if !response.result.value!.error!.isEmpty {
                                errorMessage = response.result.value!.error!
                            }else {
                                errorMessage = "errorServer".localized
                            }
                            break
                        case .failure( _):
                                errorMessage = "errorServer".localized
                                break
                        }
                        
                        let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: statusCode, userInfo: ["message":errorMessage])
                        DDLogError("Error code: \(error.code) Description: \(error.description) ")
                        withCompletionBlock(nil, error)
                        return
                    } else if let statusCode = response.response?.statusCode, statusCode == 401 {
                        if(self.tokenRefreshBool){
                            let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: statusCode, userInfo: ["message":"tokenExpired".localized])
                            DDLogError("Error code: \(error.code) Description: \(error.description) ")
                            DDLogInfo("go to refresh Attempts \(self.refresh)")
                            self.refreshToken(isArray: true, statuCode: statusCode, parameters: parameters, service: service, withCompletionBlock: withCompletionBlock)
                            return
                        }
                    }
                    
                    switch response.result{
                    case .success:
                        let code = response.result.value!.code
                        
                        if code! <= 299{
                            withCompletionBlock(response.result.value,nil)
                        }else{
                            var entity : AnyObject = "" as AnyObject
                            if let entityError = response.result.value{
                                entity = entityError
                            }
                            var errorMessage = ""
                            if !response.result.value!.message!.isEmpty {
                                errorMessage = response.result.value!.message!
                            } else {
                                errorMessage = response.result.value!.error!
                            }
                            let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: code!, userInfo: ["message":errorMessage, "entity" : entity])
                            DDLogError("Error code: \(error.code) Description: \(error.description) ")
                            withCompletionBlock(nil,error)
                        }
                        break
                        
                    case .failure(let error):
                        var messageResponse = "errorServer".localized
                        let code : Int?
                        if response.response?.statusCode != nil{
                            code = response.response!.statusCode
                        }else{
                            if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet{
                                DDLogInfo("noInternetConection".localized.uppercased())
                                NotificationCenter.default.post(name: .noConections, object: nil)
                            }
                            code = 500
                        }
                        
                        DDLogError(response.result.error!.localizedDescription)
                        
                        let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: code!, userInfo: ["message": messageResponse])
                        DDLogError("Error code: \(error.code) Description: \(error.description) ")
                        withCompletionBlock(nil,error)
                        break
                    }//Switch
            }//Alamofire
        })//SelectWebService
    }//Function
    
    func callServiceObjectWithImagen(parameters:[String: AnyObject]?,service:String, withCompletionBlock: @escaping ((AnyObject?, _ error: NSError?) -> Void)) {
        
        selectWebService(service: service, params:parameters,returnService: { (method,url,typeEncoding) -> Void in
            
            let parametersEdited = self.editParameters(parameters: parameters)
            
            DDLogInfo("--------------IMAGE-----------------------")
            DDLogInfo(url ?? "nil")
            DDLogVerbose("\(parametersEdited ?? ["parameterEdited": "nil" as AnyObject])")
            DDLogInfo("-------------------------------------------")
            
            
            guard let userId = parametersEdited?["userId"] as? String, let language = parametersEdited?["lang"] as? String, let accessToken = parametersEdited?["accessToken"] as? String else {
                let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: 400, userInfo: ["message": "errorServer".localized])
                DDLogError("Error code: \(error.code) Description: \(error.description) ")
                withCompletionBlock(nil,error)
                return
            }
            
            /*var imageData:Data?
             if let image = parameters?["image"] as? Data {
             imageData = Data(base64Encoded: image, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
             }*/
            
            let headers:[String : String] = [:]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                let randomString = UKPHelper.randomString(length: 22)+".jpg"
                
                if let imageD = parameters?["profilePicture"] as? Data {
                    multipartFormData.append(imageD, withName: "fileToUpload", fileName: randomString, mimeType: "image/jpg")
                } else {
                    let delete = "true"
                    multipartFormData.append(delete.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "delete")
                }
                
                multipartFormData.append(language.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "lang")
                multipartFormData.append(userId.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "userId")
                multipartFormData.append(accessToken.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "accessToken")
                
            }, usingThreshold: UInt64.init(), to: url!, method: method, headers: headers, encodingCompletion: { encodingResult in
                
                switch encodingResult {
                    
                case .success(let upload, _, _):
                    
                    upload.responseJSON(completionHandler:  { response in
                        
                        if let statusCode = response.response?.statusCode, statusCode == 401 {
                            let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: statusCode, userInfo: ["message":"unathorized"])
                            DDLogError("Error code: \(error.code) Description: \(error.description) ")
                            withCompletionBlock(nil, error)
                            return
                        }
                        
                        switch response.result{
                            
                        case .success:
                            let code = response.response!.statusCode
                            
                            if code <= 299{
                                withCompletionBlock(response.result.value as AnyObject?,nil)
                            }else{
                                var message = "Server error"
                                DDLogError("\(response.result)")
                                if let unwrappedResult = response.result.value as? [String:AnyObject], let unwrappedMessage = unwrappedResult["message"] as? String {
                                    message = unwrappedMessage
                                }
                                
                                let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: code, userInfo: ["message":message])
                                DDLogError("Error code: \(error.code) Description: \(error.description) ")
                                withCompletionBlock(nil,error)
                            }
                            break
                            
                        case .failure:
                            let code = (response.result.error! as NSError).code
                            DDLogError(response.result.error!.localizedDescription)
                            
                            let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: code, userInfo: ["message": "errorServer".localized])
                            DDLogError("Error code: \(error.code) Description: \(error.description) ")
                            withCompletionBlock(nil,error)
                            break
                        }})
                    break
                default:
                    break
                }
            })
        })//SelectWebService
    }
    
    
    func callServiceObjectWithMultimedia(parameters:[String: AnyObject]?,service:String, type: String, withCompletionBlock: @escaping ((AnyObject?, _ error: NSError?) -> Void)) {
        
        selectWebService(service: service, params:parameters,returnService: { (method,url,typeEncoding) -> Void in
            
            let parametersEdited = self.editParameters(parameters: parameters)
            
            
            guard let tasks = parametersEdited?["tasks"] as? String, let language = parametersEdited?["lang"] as? String, let accessToken = parametersEdited?["accessToken"] as? String, let length = parametersEdited?["length"] as? String else {
                let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: 400, userInfo: ["message": "errorServer".localized])
                DDLogError("Error code: \(error.code) Description: \(error.description) ")
                withCompletionBlock(nil,error)
                return
            }
            
            let headers:[String : String] = [:]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                var ext = ""
                if type == "video/mp4"{
                    ext = ".mp4"
                }else{
                    ext = ".jpg"
                }
                
                
                let randomString = UKPHelper.randomString(length: 22)+ext
                
                if let video = parameters?["fileToUpload"] as? Data {
                    multipartFormData.append(video, withName: "fileToUpload", fileName: randomString, mimeType: type)
                } else {
                    let delete = "true"
                    multipartFormData.append(delete.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "delete")
                }
                
                multipartFormData.append(language.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "lang")
                multipartFormData.append(tasks.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "tasks")
                multipartFormData.append(accessToken.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "accessToken")
                multipartFormData.append(length.data(using: String.Encoding.utf8, allowLossyConversion: false)!,withName: "length")
                
            }, usingThreshold: UInt64.init(), to: url!, method: method, headers: headers, encodingCompletion: { encodingResult in
                
                switch encodingResult {
                    
                case .success(let upload, _, _):
                    
                    upload.responseJSON(completionHandler:  { response in
                        
                        if let statusCode = response.response?.statusCode, statusCode == 401 {
                            let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: statusCode, userInfo: ["message":"unathorized"])
                            DDLogError("Error code: \(error.code) Description: \(error.description) ")
                            withCompletionBlock(nil, error)
                            return
                        }
                        
                        switch response.result{
                            
                        case .success:
                            let code = response.response!.statusCode
                            
                            if code <= 299{
                                withCompletionBlock(response.result.value as AnyObject?,nil)
                            }else{
                                var message = "Server error"
                                DDLogError("\(response.result)")
                                if let unwrappedResult = response.result.value as? [String:AnyObject], let unwrappedMessage = unwrappedResult["message"] as? String {
                                    message = unwrappedMessage
                                }
                                
                                let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: code, userInfo: ["message":message])
                                DDLogError("Error code: \(error.code) Description: \(error.description) ")
                                withCompletionBlock(nil,error)
                            }
                            break
                            
                        case .failure:
                            let code = (response.result.error! as NSError).code
                            DDLogError(response.result.error!.localizedDescription)
                            
                            let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: code, userInfo: ["message": "errorServer".localized])
                            DDLogError("Error code: \(error.code) Description: \(error.description) ")
                            withCompletionBlock(nil,error)
                            break
                        }})
                    break
                default:
                    break
                }
            })
        })
    }
    
    struct JSONArrayEncoding: ParameterEncoding {
        private let array: [Parameters]
        
        init(array: [Parameters]) {
            self.array = array
        }
        
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            var urlRequest = try urlRequest.asURLRequest()
            
            let data = try JSONSerialization.data(withJSONObject: array, options: [])
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = data
            
            return urlRequest
        }
    }
    
    //MARK: Refresh Token
    func refreshToken(isArray:Bool, statuCode:Int,parameters:[String: AnyObject]?,service:String, withCompletionBlock: @escaping ((AnyObject?, _ error: NSError?) -> Void)){
        
        callServiceObject(parameters:[:], service: GlobalConstants.nameServices.refreshToken) { (result, error) in
            if result != nil && error == nil{
                
                let jsonResponse = result as! JSONResponse
                if let data = jsonResponse.data as? Dictionary<String, Any> {
                    let token:String = data["token"] as! String
                    UKPSessionHelper.saveAnyObjectInSession(object: token as AnyObject , key: GlobalConstants.Keys.token)
                    DDLogVerbose("Session token: \(UKPSessionHelper.getSession(key: GlobalConstants.Keys.token)! as Any)")
                    self.refresh = 0
                    DDLogInfo("Success refresh Token")
                    if(isArray){
                        self.callServiceObjectArray(parameters: parameters, service: service, withCompletionBlock: withCompletionBlock)
                    }else{
                        self.callServiceObject(parameters: parameters, service: service, withCompletionBlock: withCompletionBlock)
                    }
                }else{
                    self.refresh = self.refresh + 1
                    let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: statuCode, userInfo: ["message":"tokenExpired".localized])
                    DDLogError("Error code: \(error.code) Description: \(error.description) ")
                    DDLogError("Error in parse Token")
                    if(self.refresh > 3){
                        self.refresh = 0
                        KVNProgress.dismiss(completion: {
                            NotificationCenter.default.post(name: .isModalPopUpShow, object: nil)
                            DDLogVerbose("3 times")
                            KSToastView.ks_showToast(error.userInfo["message"] as! String)
                            if let currrentVC = UKPHelper.getTopViewController(){
                                UKPHelper.doLogout(vc:currrentVC)
                            }
                        })
                    }else{
                        DDLogError("error in parse Token")
                        self.refreshToken(isArray: isArray, statuCode: statuCode, parameters: parameters, service: service, withCompletionBlock: withCompletionBlock)
                    }
                }
            }else{
                self.refresh = self.refresh + 1
                let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: statuCode, userInfo: ["message":"tokenExpired".localized])
                DDLogError("Error code: \(error.code) Description: \(error.description) ")
                DDLogError("error in refresh Token")
                if(self.refresh > 3){
                    self.refresh = 0
                    KVNProgress.dismiss(completion: {
                        NotificationCenter.default.post(name: .isModalPopUpShow, object: nil)
                        DDLogVerbose("3 times")
                        KSToastView.ks_showToast(error.userInfo["message"] as! String)
                        if let currrentVC = UKPHelper.getTopViewController(){
                        UKPHelper.doLogout(vc:currrentVC)
                        }
                    })
                }else{
                    self.refreshToken(isArray: isArray, statuCode: statuCode, parameters: parameters, service: service, withCompletionBlock: withCompletionBlock)
                }
            }
        }
        
    }
    
}
