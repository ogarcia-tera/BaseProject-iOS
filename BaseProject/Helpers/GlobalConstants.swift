//
//  GlobalConstants.swift
//  Unicef Kid Power
//
//  Created by Ailicec Tovar on 8/22/17.
//  Copyright © 2017 Teravision. All rights reserved.
//

import Foundation
import UIKit

import Foundation
import UIKit
var apiUrl = ""
var filesUrl = ""
var domainUrl = ""

//MARK: Loading Configuration Details
enum Environment: String {
    case development = "development"
    case qa = "qa"
    case staging = "staging"
    case production = "production"
    
    private struct Domains {
        static let local = "http://74.208.46.27:8788"
        static let development = "http://dev-unicef.42mate.com" //"http://dev-app-unicef.42mate.com"
        static let qa = "http://dev-app-unicef.42mate.com"
        static let staging = "http://stage-unicef.42mate.com"
        static let production = "https://api.ukp.io"
    }
    
    private struct Routes {
        static let api = "/api/v1/"
        static let files = "/kidpower/public"
    }
    
    var baseUrl: String {
        switch self {
        case .development:
            return setUrl(domain: Domains.development,
                          route: Routes.api,
                          routeType:"API").apiUrl
        case .qa:
            return setUrl(domain: Domains.qa,
                          route: Routes.api,
                          routeType:"API").apiUrl
        case .staging:
            return setUrl(domain: Domains.staging,
                          route: Routes.api,
                          routeType:"API").apiUrl
        case .production:
            return setUrl(domain: Domains.production,
                          route: Routes.api,
                          routeType:"API").apiUrl
        }
    }
    
    var filesUrl: String {
        switch self {
        case .development:
            return setUrl(domain: Domains.development,
                          route: Routes.files,
                          routeType:"FILE").filesUrl
        case .qa:
            return setUrl(domain: Domains.qa,
                          route: Routes.files,
                          routeType:"FILE").filesUrl
        case .staging:
            return setUrl(domain: Domains.staging,
                          route: Routes.files,
                          routeType:"FILE").filesUrl
        case .production:
            return setUrl(domain: Domains.production, route: Routes.files, routeType:"FILE").filesUrl
        }
    }
    
    var domainUrl: String {
        switch self {
        case .development:
            return Domains.development + "/"
        case .qa:
            return Domains.qa + "/"
        case .staging:
            return Domains.staging + "/"
        case .production:
            return Domains.production + "/"
        }
    }
    
    var token: String {
        switch self {
        case .development: return "ddtopir156dsq16sbi8"
        case .qa: return "qatopir156dsq16sbi8"
        case .staging: return "statopir156dsq16sbi8"
        case .production: return "prod5zdsegr16ipsbi1lktp"
        }
    }
    
    var apiKeySegment: String {
        switch self {
        case .development:
            return GlobalConstants.Development.apiKeySegment
        case .qa:
            return GlobalConstants.QA.apiKeySegment
        case .staging:
            return GlobalConstants.Staging.apiKeySegment
        case .production:
            return GlobalConstants.Production.apiKeySegment
        }
    }
    
    var siteIdCustomerIO: String {
        switch self {
        case .development:
            return GlobalConstants.Development.siteIdCustomerIO
        case .staging:
            return GlobalConstants.Staging.siteIdCustomerIO
        case .production:
            return GlobalConstants.Production.siteIdCustomerIO
        case .qa:
            return GlobalConstants.QA.siteIdCustomerIO
        }
    }
    
    
    var apiKeyCustomerIO: String {
        switch self {
        case .development:
            return GlobalConstants.Development.apiKeyCustomerIO
        case .staging:
            return GlobalConstants.Staging.apiKeyCustomerIO
        case .production:
            return GlobalConstants.Production.apiKeyCustomerIO
        case .qa:
            return GlobalConstants.QA.apiKeyCustomerIO
        }
    }
}

func setUrl(domain:String, route:String, routeType:String)->(apiUrl: String, filesUrl: String){
    routeType == "API" ? (apiUrl = domain + route) : (filesUrl = domain + route)
    return (apiUrl, filesUrl)
}

//MARK: Parse the configuration name and initialize
struct Configuration {
    var environment: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            if configuration.range(of:"QA") != nil {
                return Environment.qa
            }else if configuration.range(of:"Staging") != nil {
                return Environment.staging
            }else if configuration.range(of:"Production") != nil {
                return Environment.production
            }
        }
        return Environment.development
    }()
}

struct GlobalConstants {
    
    //MARK: CONSTANTS
    static let errorDomain = "unicef-kidpower.error"
    static let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let buildVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    static let iosVersion = UIDevice.current.systemVersion
    static let lang =  (NSLocale.preferredLanguages[0] as NSString).substring(to: 2)
    static let kTrackerTypePowerBand = "Power Band";
    static let kTrackerTypeHealthKit = "HealthKit";
    static let kTextLimitPowerBand = 14
    //MARK: Configuring the environment
    private static let baseUrl = apiUrl
    private static let filesRoute = filesUrl
    //MARK: App Store
    private struct AppStoreUrls {
        static let iTunesUrl = "itms-apps://itunes.apple.com/app/"
        static let appName = "/unicef-kid-power/"
        static let appId = "id1033602557"
        static let mt = "?mt=8"
        static let urlWrite = "&action=write-review"
    }
    
    struct AppStore {
        static let url = AppStoreUrls.iTunesUrl+AppStoreUrls.appName+AppStoreUrls.appId
        static let writeReview = url+AppStoreUrls.mt+AppStoreUrls.urlWrite
    }
    
    //MARK: ENDPOINTS
    struct Endpoints {
        static let logoutWS = baseUrl+"users/logout"
        static let loginWS = baseUrl+"account/login"
        static let accountRegisterWS = baseUrl+"account/register"
        static let accountWS = baseUrl+"account"
        
        static let avatarsWS = baseUrl+"avatar"
        
        static let activitiesWS = baseUrl+"activity"
        static let trackersWS = baseUrl+"tracker"
        
        static let activityGroupSyncRegisterWS = baseUrl+"activity/group-sync"
        
        // new login
        
        static func getLoginWS(type:String)->String{
            return loginWS+"?type=\(type)"
        }
        static func channelWS(isGroup:Bool)->String{
            return baseUrl+"channel?size=\(Int(GlobalConstants.Device.screenHeight))&group_sync=\(isGroup ? "true" : "false")"
            //return baseUrl+"channel?size=\(Int(GlobalConstants.Device.screenHeight))\(isGroup ? "&group_sync=true" : "")"
        }
        static let channelWS2 = baseUrl+"channel/2?size=\(Int(GlobalConstants.Device.screenHeight))"
        
        static let createProfileWS = baseUrl+"profile"
        
        static func getAvatarById(avatarId:String)->String{
            return "\(baseUrl)avatar/\(avatarId)"
        }
        
        static func profileChangeWS(profileId:String)->String{
            return "\(baseUrl)profile/\(profileId)/use"
        }
        
        static func accountKeysWS(accountId:Int)->String{
            return accountWS+"/\(accountId)/keys"
        }
        
        static func trackerByIdWS(trackerId:Int)->String{
            return trackersWS+"/\(trackerId)"
        }
        
        static func getDomain(userId:String)->String{
            return "\(baseUrl)/account/\(userId)?lang=\(GlobalConstants.lang)"
        }
        
        struct Profile {
            static let profileImageURL = filesRoute + "/images"
        }
        
        struct Settings {
            static let settingsWebService = baseUrl+"/settings"
        }
        
        static func getProfileStatusInChannel(profileId:String, channelId:String)->String{
            return "\(baseUrl)profile/\(profileId)/channel/\(channelId)"
        }
        
        static func getProfileInfo(profileId:String)->String{
             return "\(baseUrl)profile/\(profileId)"
        }
        
        static func getRewardForWaypointInChannel(channelID:String, waypointID:String)->String{
            //Works for both GET and POST according to API DOC
            return "\(baseUrl)channel/\(channelID)/waypoint/\(waypointID)/reward"
        }
        
        static func checkTrackerAvailabilityWS(trackerFactoryID:String)->String{
            return "\(baseUrl)tracker/availability?tracker_factory_id=\(trackerFactoryID)"
        }
        
        static let refreshTokenWebService = baseUrl+"account/refresh"
        
        static let notificationForgotPasswordService = baseUrl + "account/notification"
        
        static let resetPasswordService = baseUrl + "account/reset"
        
        static func unlockWaypointInChannel(channelID:String, waypointID:String)->String{
            return "\(baseUrl)channel/\(channelID)/waypoint/\(waypointID)/unlock"
        }
        static func updateProfile(profileId:String)->String{
            return "\(baseUrl)profile/\(profileId)"
        }
        
        static func friendsWS(profileId:String)->String{
            return "\(baseUrl)profile/\(profileId)/friend"
        }
        
        static func deleteFriendWS(profileId:String, friendProfileId:String)->String{
            return "\(baseUrl)profile/\(profileId)/friend/\(friendProfileId)"
        }
        
        static let getLeaderboardGlobalWebService = baseUrl+"leaderboard/global"
        static let getLeaderboardFriendsWebService = baseUrl+"leaderboard/global/friends"

        static func sendFriendRequestWS(idProfileUser:String, idProfileFriend:String)->String{
            return "\(baseUrl)profile/\(idProfileUser)/friend/\(idProfileFriend)"
        }
        
        static func acceptRejectFriendRequestWS(idProfileUser:String, idProfileFriend:String)->String{
            return "\(baseUrl)profile/\(idProfileUser)/friend/\(idProfileFriend)"
        }
        
        static func searchFriendRequestWS(userNameSearch:String, page:String)->String{
            return "\(baseUrl)profile?name=\(userNameSearch)&page=\(page)"
        }
        
        static func receivedAnsweredFriendRequestWS(profileId:String)->String{
            return "\(baseUrl)profile/\(profileId)/friend"
        }
        
        static let getTrackersAvailable = baseUrl+"tracker/availability"
        
        static let getNewsUpdateVersion = baseUrl+"news/active"
        
        //Teams
        static let getTeamsWebService = baseUrl+"team"
        
        static let getPrivateTeamsWebService = baseUrl+"team/private"
        
        static func getTeamDetailWebService(teamId:String)->String{
            return "\(baseUrl)team/\(teamId)"
        }
        
        static func getTeamsByProfileWebService(profileId:String)->String{
            return "\(baseUrl)profile/\(profileId)/team"
        }
        
        static func setMembershipTeamWebService(profileId:String, teamId: String)->String{
            return "\(baseUrl)profile/\(profileId)/team/\(teamId)"
        }
        
        static func getLeaderboardByTeamWebService(teamId:String)->String{
            return "\(baseUrl)leaderboard/\(teamId)"
        }
        
        static func getLeaderboardFriendsByTeamWebService(teamId: String)->String{
            return "\(baseUrl)leaderboard/\(teamId)/friends"
        }
        
        static func cheersWS(profileId:String, targetProfileId:String)->String{
            return "\(baseUrl)profile/\(profileId)/cheer/\(targetProfileId)"
        }
        
        static func getAccountTeamsWebService(accountId:String)->String{
            return "\(baseUrl)account/\(accountId)/team"
        }
        
        static func getAccountTeamDetailWebService(accountId:String, teamId: String)->String{
            return "\(baseUrl)account/\(accountId)/team/\(teamId)"
        }
        
        static func getUpdateFWBandWebService(typeBandFW:String, FW: String)->String{
            return "\(baseUrl)firmware/\(typeBandFW)/\(FW)"
        }
        
        static func setDeviceTokenInCustomerIO(userId:String)->String{
            return "https://track.customer.io/api/v1/customers/\(userId)/devices"
        }

    }
    
    //MARK: ENVIRONMENTS
    struct Development { //DEVELOPMENT
        static let clientId = "devClientId"
        static let clientSecret = "devClientSecret"
        static let apiVersionHeader = "application/x.soma.v"+appVersion+"+json"
        static let apiKeySegment = "OPacKm2OzNcFFYweStd13pe24578OVdZ"
        static let siteIdCustomerIO = "32d9b0d76e8d8d99c80c"
        static let apiKeyCustomerIO = "29862184198a17b2acbc"
        
    }
    
    struct Staging { //Staging
        static let clientId = "intClientId"
        static let clientSecret = "intClientSecret"
        static let apiVersionHeader = "application/x.soma.v"+appVersion+"+json"
        static let apiKeySegment = "fkD5cPdND2X2nbWShy5m4lbdd7DaTNfe"
        static let siteIdCustomerIO = "33cd5fb99281ebaa36c9"
        static let apiKeyCustomerIO = "a718ef4fec3755b24575"
    }
    
    struct QA { //QA
        static let clientId = "qaClientId"
        static let clientSecret = "qaClientSecret"
        static let apiVersionHeader = "application/x.soma.v"+appVersion+"+json"
        static let apiKeySegment = "OPacKm2OzNcFFYweStd13pe24578OVdZ"
        static let siteIdCustomerIO = "32d9b0d76e8d8d99c80c"
        static let apiKeyCustomerIO = "29862184198a17b2acbc"
    }
    
    struct Production { //PRODUCTION
        static let clientId = "prodClientId"
        static let clientSecret = "prodClientSecret"
        static let apiVersionHeader = "application/x.soma.v"+appVersion+"+json"
        static let apiKeySegment = "hjZaO4Ai5OSzyyiHcSPfxDtDQByLZVwR"//"OPacKm2OzNcFFYweStd13pe24578OVdZ"
        static let siteIdCustomerIO = "32e65c18d3ef86a9efa7"
        static let apiKeyCustomerIO = "aaceefc0747bbe733fa3"
    }
    
    struct Headers {
        static let contentType = "application/json"
    }
    
    //MARK: DEVICES SIZES
    struct Device {
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height
        static let isIphone4orLess = (screenHeight < 568.0)
        static let isIphone5 = (screenHeight == 568.0)
        static let isIphone6 = (screenHeight == 667.0)
        static let isIphone6Plus = (screenHeight == 736)
        static let isIphone7 = (screenHeight == 667.0)
        static let isIphone7Plus = (screenHeight == 736)
        static let isIphone8 = (screenHeight == 812.0)
        static let isIphoneX = (screenHeight == 812.0)
        static let isIphoneXOrMore = (screenHeight >= 812.0)
        static let asDefault = "simulator"
        
        static let iPhone5Height = 568.0
        static let iPhone7Height = 667.0
        static let iPhone7PlusHeight = 736.0
        static let iPhoneXHeight = 812.0
        
        static let iPhone5Width:CGFloat = 320.0
        static let iPhone7Width:CGFloat = 375.0
        static let iPhone7PlusWidth:CGFloat = 414.0
        
        static func currentDevice()->String{
            if isIphone4orLess {
                return "Is Iphone4 or Less"
            }else if isIphone5{
                return "Is Iphone5"
            }else if isIphone6{
                return "Is Iphone6"
            }else if isIphone6Plus{
                return "Is Iphone6 Plus"
            }else if isIphone7{
                return "Is Iphone7"
            }else if isIphone7Plus{
                return "Is Iphone7 Plus"
            }else if isIphone8{
                return "Is Iphone8"
            }else if isIphoneX{
                return "Is IphoneX"
            }else if isIphoneXOrMore{
                return "Is IphoneX Or More"
            }else{
                return "simulator"
            }
        }
        
    }
    
    //MARK: Colors
    struct Colors {
        
        static let fontColor:UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        static let unicefBlue:UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        static let unicefBlue2:UIColor = #colorLiteral(red: 0, green: 0.6823529412, blue: 0.937254902, alpha: 1)
        static let buttonBlue: UIColor = #colorLiteral(red: 0, green: 0.6823529412, blue: 0.937254902, alpha: 1)
        static let grayButton: UIColor = #colorLiteral(red: 0.5254901961, green: 0.5450980392, blue: 0.5725490196, alpha: 1)
        static let greenButton: UIColor = #colorLiteral(red: 0.6470588235, green: 0.8117647059, blue: 0.3019607843, alpha: 1)
        static let buttonLoginColor:UIColor = #colorLiteral(red: 0.5725490196, green: 0.4156862745, blue: 1, alpha: 1)
        static let buttonStartHost:UIColor = #colorLiteral(red: 0.568627451, green: 0.8431372549, blue: 0, alpha: 1)
        static let buttonGray: UIColor = #colorLiteral(red: 0.4745098039, green: 0.4901960784, blue: 0.5137254902, alpha: 1)
        static let energyBarFirstColorFill: UIColor = #colorLiteral(red: 0.7254901961, green: 0.8941176471, blue: 0.9607843137, alpha: 1)
        static let shadowLabelEnergyBar: UIColor = #colorLiteral(red: 0, green: 0.2901960784, blue: 0.4, alpha: 1)
        static let disableTextField: UIColor = #colorLiteral(red: 0.900509119, green: 0.8874939084, blue: 0.851991713, alpha: 1)
        static let placeHolderTextField: UIColor = #colorLiteral(red: 0.7215686275, green: 0.737254902, blue: 0.768627451, alpha: 1)
        static let stepsExpRed: UIColor = #colorLiteral(red: 0.8196078431, green: 0.2666666667, blue: 0.2901960784, alpha: 1)
        static let fontColorToolTips:UIColor = #colorLiteral(red: 0.5294117647, green: 0.5490196078, blue: 0.5725490196, alpha: 1)
        static let fontColorButtonRed:UIColor = #colorLiteral(red: 0.9333333333, green: 0.1960784314, blue: 0.1411764706, alpha: 1)
        static let badgeColorLeaderboard:UIColor = #colorLiteral(red: 0.8901960784, green: 0.1960784314, blue: 0.1411764706, alpha: 1)
        static let noStepsBackgroundCell:UIColor = #colorLiteral(red: 0.8901960784, green: 0.8823529412, blue: 0.862745098, alpha: 1)
        static let stepsBackgroundCell:UIColor = #colorLiteral(red: 0.8823529412, green: 0.9568627451, blue: 0.9960784314, alpha: 1)
        static let noTeamTitleColor:UIColor = #colorLiteral(red: 0.2666666667, green: 0.7843137255, blue: 0.9607843137, alpha: 1)
        static let noTeamSelectedIconColor:UIColor = #colorLiteral(red: 0.7294117647, green: 0.737254902, blue: 0.7529411765, alpha: 1)
        static let noSelectedColor:UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4956261004)
        static let backgroundNotMemberCellColor:UIColor = #colorLiteral(red: 0.8823529412, green: 0.9568627451, blue: 0.9921568627, alpha: 1)
        static let backgroundIsMemberCellColor:UIColor = #colorLiteral(red: 0.8784313725, green: 0.9803921569, blue: 0.6666666667, alpha: 1)
        static let orangePendingColor:UIColor = #colorLiteral(red: 0.968627451, green: 0.4470588235, blue: 0.1647058824, alpha: 1)
        
    }
    
    struct Keys{
        static let sessionUser = "sessionUser"
        static let token = "token"
        static let channels = "channels"
        static let tutorialCompleted = "tutorialCompleted"
        static let sessionTracker = "sesionTracker"
        static let channelsDownloaded = "channelsDownloaded"
        static let bluetooth = "bluetooth"
        static let avatars = "avatars"
        static let isFirstWayPoint = "isFirstWayPoint"
        static let isSecondWayPoint = "isSecondWayPoint"
        static let lastSyncPowerPoints = "lastSyncPowerPoints"
        static let legacyPopUpValidation = "legacyPopUpValidation"
        static let groupChannelsDownloaded = "groupChannelsDownloaded"
        static let firmwareURL = "firmwareURL"
        static let firmwareName = "firmwareName"
        static let channelDataByProfile = "channelDataByProfile"
        static let currentRewards = "currentRewards"

    }
    
    struct DateFormat {
        
        static let english = "MM/dd/yyyy"
        static let spanish = "dd/MM/yyyy"
        static let englishTime24 = "MM/dd/yyyy HH:mm"
        static let englishTime = "MM/dd/yyyy h:mm a"
        static let spanishTime24 = "dd/MM/yyyy HH:mm"
        static let spanishTime = "dd/MM/yyyy h:mm a"
        static let time12Appt = "EEE, dd MMMM h:mm a"
        static let time24Appt = "EEE, dd MMMM HH:mm"
        static let orderFormat = "yyyy/MM/dd"
        static let serviceFormat = "YYYY-MM-dd"
        static let localeFormat = "en_US_POSIX"
        static let apiFormat = "yyyy-MM-dd HH:mm:ss"
        static let fromService = "dd/MM/yyyy - HH:mm"
        static let fromServicelocale = "dd/MM/yyyy - hh:mm a"
        static let dateZ = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
    
    struct TimezoneFormat {
        
        static let UTCTimezone = "UTC"
    }
    
    struct clientCredentials {
        static let client_id = ""
        static let client_secret = ""
        static let operativeSystem = "ios"
    }
    
    struct nameServices {
        static let login = "LoginWS"
        static let logout = "LogoutWS"

        static let accountRegister = "AccountRegisterWS"
        static let account = "AccountWS"
        static let accountKeys = "AccountKeysWS"
        static let accountKeysAdd = "AccountKeysAddWS"

        static let activities = "ActivitiesWS"
        static let activityRegister = "ActivityRegisterWS"
        static let activityById = "ActivityByIdWS"
        static let activityUpdate = "ActivityUpdateWS"
        static let activityDelete = "ActivityDeleteWS"
        
        static let avatars = "AvatarsWS"
        static let avatarById = "AvatarByIdWS"
        static let profileChange = "ProfileChangeWS"
        static let createProfile = "CreateProfileWS"

        static let trackers = "TrackersWS"
        static let trackerRegister = "TrackerRegisterWS"
        static let trackerById = "TrackerByIdWS"
        static let trackerUpdate = "TrackerUpdateWS"
        static let trackerDelete = "TrackerDeleteWS"
        
        static let channels = "ChannelWS"
        static let channelById = "ChannelWS2"
        static let profileStatus = "ProfileStatusWs"
        static let profileInfo = "ProfileInfo"
        static let profileUpdate = "ProfileUpdateWS"
        static let profileDelete = "ProfileDeleteWS"

        static let friends = "FriendsWS"
        static let deleteFriend = "DeleteFriendWS"
        
        static let stepsConsumption = "StepsConsumption"
        
        static let getReward = "getRewardWS"
        static let claimReward = "claimRewardWS"
        
        static let notificationForgotPassword = "notificationForgotPassword"
        static let resetForgotPassword = "resetForgotPassword"
        
        static let checkTrackerAvailability = "checkTrackerAvailabilityWS"
        
        static let refreshToken = "refrestToken"
        
        static let updateProfile = "UpdateProfileWS"
        
        static let deleteTracker = "DeleteTrackerWS"
        
        static let unlockWaypoint = "unlockWaypoint"
        
        static let getLeaderboadGlobal = "getLeaderboadGlobal"
        static let getLeaderboadFriends = "getLeaderboadFriends"

        static let sendFriendRequest = "sendFriendRequest"
        static let acceptRejectFriendRequest = "acceptRejectFriendRequest"
        static let searchFriend = "searchFriend"
        static let receivedOrAnsweredFriend = "receivedOrAnsweredFriend"
        
        static let getTeams = "getTeams"
        static let getPrivateTeams = "getPrivateTeams"
        static let getTeamsByName = "getTeamsByName"
        static let getPrivateTeamsByID = "getPrivateTeamsByID"
        static let getTeamDetail = "getTeamDetail"
        static let getTeamsByProfile = "getTeamsByProfile"
        static let joinATeam = "joinATeam"
        static let leaveATeam = "leaveATeam"
        static let leaderboardByTeam = "leaderboardByTeam"
        static let leaderboardFriendsByTeam = "leaderboardFriendsByTeam"

        static let getAccountTeams = "getAccountTeams"
        static let getAccountTeamDetail = "getAccountTeamDetail"
        static let getCheers = "GetCheersWS"
        static let sendCheers = "SendCheersWS"
        static let readCheers = "ReadCheersWS"
        static let activityGroupSyncRegister = "ActivityGroupSyncRegisterWS"
        static let getAvailableTrackersWS = "getAvailableTrackersWS"
        static let getNewsUpdate = "getNewsUpdate"
        static let getAvailableUpdateFWBandWS = "getAvailableUpdateFWBandWS"
        
        static let setDeviceTokenInCustomerIOWS = "setDeviceTokenInCustomerIOWS"

    }
    
    struct statusServices {
        static let publicService = "public"
        static let privateService = "private"
    }
    
    struct gameLogicConstants {
        
        static let powerPointBySteps = 500.0
    }
    
    struct trackerType {
        static let band = "Power Band"
        static let healthApp = "Health Kit"
        static let androidhealthApp = "Google Fit"
        static let oldBandModel = "KPB02"
    }
    
    struct Zendesk {
        
        static let appId = "bcc8c75d2cec5e80c0df820e999310be9aaef9c2cd056667"
        static let url = "https://unicefkidpowerhome.zendesk.com"
        static let clientId = "mobile_sdk_client_c9d8ee2e328eb67f66fd"
    }
    
    struct Segment {
        struct Onboarding {
            struct Register {
                static let accountCreated = "Account Created"
                static let accountCreationFailed = "Account Creation Failed"
            }
            
            struct Login {
                static let accountLogin = "Account Login"
                static let accountLoggedOut = "Account Logged Out"
            }
            
            struct Avatar {
                static let avatarSelected = "Avatar Selected"
                static let profileSwitched = "Profile Switched"
            }
            
            struct Profile {
                static let profileCreated = "Profile Created"
                static let profileSwitched = "Profile Switched"
                static let usernameSelected = "Username Selected"
                static let trackerLinked = "Tracker Linked"
                static let trackerRemoved = "Tracker Removed"
                static let trackerLinkFailed = "Tracker Link Failed"
                static let profileEdited = "Profile Edited"
                
                struct GroupSync {
                    static let gsBandLinkFailed = "GS Band Link Failed"
                }
            }
            
            struct Tutorial {
                static let tutorialStarted = "Tutorial Started"
                static let tutorialCompleted = "Tutorial Completed"
            }
            
            struct FTUE {
                static let waypointReached = "FTUE Waypoint Reached"
                static let rewardOpened = "FTUE Reward Opened"
                static let freeStepsUsed = "FTUE Free Steps Used"
            }
            
            struct GroupSync {
                static let studentBandAssociated = "Student Band Associated"
                static let gsBandLinked = "GS Band Linked"
                static let gsBandLinkFailed = "GS Band Link Failed"
            }
        }
        
        struct Mission {
            
            static let missionSwitched = "Mission Switched"
            
            struct MessageShown{
                static let message = "Message Shown"
                static let outOfEnergy = "out_of_energy"
                static let expiringEnergy = "expiring_energy"
                static let noTrackerDetected = "no_tracker_detected"
                static let powerPointInfo = "power_point_info"
                static let rutfInfo = "rutf_info"
                static let privacyPolicy = "privacy_policy"
                static let whatIsBandId = "what_is_band_id"
                static let dontSeeBandId = "dont_see_band_id"
                static let gsWelcomeTeacher = "gs_welcome_teacher"
                static let gsBandLinking = "gs_band_linking"
                static let gsGoodJob = "gs_good_job"
                static let firmwareUpdate = "firmware_update"
                static let gsBandsLinked = "gs_bands_linked"
            }
            
            struct Avatar {
                static let avatarMoved = "Avatar Moved"
            }
            
            struct Waypoint {
                static let waypointReached = "Waypoint Reached"
                static let waypointRewardOpened = "Waypoint Reward Opened"
                static let waypointLockReached = "Waypoint Lock Reached"
                static let waypointDenied = "Waypoint Denied"
                static let waypointUnlocked = "Waypoint Unlocked"
            }
            
            struct Sync {
                static let activitySynced = "Activity Synced"
                static let activitySyncFailed = "Activity Sync Failed"
            }
            
            struct CurrencyEarned {
                static let currencyEarned = "Currency Earned"
            }
            
            struct GroupSync {
                static let gsActivitySynced = "GS Activity Synced"
                static let gsActivitySyncFailed = "GS Activity Sync Failed"
            }
        
        }
        
        struct Store {
            static let productListViewed = "Product List Viewed"
            static let productClicked = "Product Clicked"
            static let checkoutStarted = "Checkout Started"
            static let orderCompleted = "Order Completed"
            static let orderCancelled = "Order Cancelled"
        }
        
        struct Community {
            static let viewedCommunity = "Viewed Community"
            static let teamJoined = "Team Joined"
            static let teamLeft = "Team Left"
            static let leaderboardPlaced = "Leaderboard Placed"
            static let cheerSent = "Cheer Sent"
            static let cheerReceived = "Cheer Received"
            static let friendSearched = "Friend Searched"
            static let friendRequestSent = "Friend Request Sent"
            static let friendRequestReceived = "Friend Request Received"
            static let friendRequestAnswered = "Friend Request Answered"
        }
    }
    
    struct UserDefaultsKeys {
        static let appWaypointReachedChatbotCount = "waypointReachedChatbot"
    }
    
}
