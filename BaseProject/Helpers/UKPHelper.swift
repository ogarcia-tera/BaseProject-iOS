//
//  UKPHelper.swift
//  Unicef Kid Power
//
//  Created by Ailicec Tovar on 8/22/17.
//  Copyright © 2017 Teravision. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SDWebImage
import KVNProgress
import Alamofire
import Firebase
import Analytics


struct Font {
    static let normal = UIFont(name: "Univers", size: 15.0)!
    static let bold = UIFont(name: "Univers-Bold", size: 15.0)!
    static let boldNavTitle = UIFont(name: "Univers-Bold", size: 20.0)!
}

struct SpriteType {
    static let defaultSprite = "default"
    static let rutfSprite = "rutfSprite"
}

enum ChannelType : String {
    case kidPower = "KID POWER"
    case all = "ALL"
}

class UKPHelper{
    
    var viewController : UIViewController?
    var pickerDelegate : UIPickerViewDelegate?
    var pickerDatasource : UIPickerViewDataSource?
    static var expectedDownloads = 0
    static var downloadCount = 0
    static var downloadError = false
    static var continueDownloading = true
    static var appAvatars = [Avatar]()
    static var imagesToDownload = [String]()
    static var appChannels = [Channel]()
    
    static var imageDownloader = SDWebImageDownloader.shared()
    static let sharedInstance = UKPHelper()
    
    static var bandManager = CCLDBandManager()
    static var pointCount = 0
    static var haveNewMissions:Bool = false
    static let cheerInterval = 1800 //30 minutes
    
    func createToolBarForPicker(_ tag: Int, title: String, doneActionName : String!, cancelActionName : String!) -> UIToolbar {
        
        let toolBar = createSingleToolBar()
        let tintColorButtons = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        let doneButton = createBarButtonForPicker(doneActionName, title: "donePicker".localized)
        doneButton.tag = tag
        doneButton.tintColor = tintColorButtons
        
        let firstSpace = createBarButtonFlexibleSpace()
        
        let title = createBarButtonTitle(title)
        
        let secondSpace = createBarButtonFlexibleSpace()
        
        let cancelButton = createBarButtonForPicker(cancelActionName, title: "cancelPicker".localized)
        cancelButton.tag = tag
        cancelButton.tintColor = tintColorButtons
        
        toolBar.setItems([cancelButton, firstSpace, title, secondSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
        
    }
    
    func createSingleToolBar() -> UIToolbar {
        let backgroundColorToolBar = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        //toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        toolBar.layer.borderWidth = 1.0
        toolBar.layer.borderColor = UIColor.lightText.cgColor
        toolBar.layer.backgroundColor = backgroundColorToolBar.cgColor
        
        return toolBar
    }
    
    func createBarButtonForPicker(_ selectorName : String, title : String) -> UIBarButtonItem {
        
        let selector = selectorName + ":"
        
        if (viewController != nil) {
            let button = UIBarButtonItem(
                title:title, style: UIBarButtonItemStyle.plain, target: viewController, action: Selector(selector)
            )
            
            return button
            
        } else {
            let button = UIBarButtonItem(
                title:title, style: UIBarButtonItemStyle.plain, target: pickerDelegate, action: Selector(selector)
            )
            
            return button
        }
    }
    
    func createBarButtonFlexibleSpace() -> UIBarButtonItem {
        
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    }
    
    func createBarButtonTitle(_ title : String!) -> UIBarButtonItem {
        let screenSize: CGRect = UIScreen.main.bounds
        let toolbarLabel = UILabel(frame: CGRect(x: 0, y: 0, width: (screenSize.width * 0.60), height: 21))
        toolbarLabel.font = UIFont.systemFont(ofSize: 15.0)
        toolbarLabel.text = title
        toolbarLabel.textColor = UIColor.black
        toolbarLabel.textAlignment = .center
        
        return UIBarButtonItem(customView: toolbarLabel)
    }
    
    static func setTextFormat(htmlString:String)->NSAttributedString{
        
        
        let htmlData = NSString(string: htmlString).data(using: String.Encoding.unicode.rawValue)
        
        let attributedString = try! NSAttributedString(data: htmlData!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        
        
        return attributedString
    }
    
    static func addMenuBackForNav (nvc: UINavigationController) {
        /* Used to center the image, you may need to adjust the top and bottom to move your image up or down
         if it is not centered. */
        
        let inserts = UIEdgeInsets(top: 0,left: 0,bottom: -5,right: 0)
        // Load the image centered
        let imgBackArrow = UIImage(named: "ic-nav-back")?.withAlignmentRectInsets(inserts)
        // Set the image
        nvc.navigationBar.backIndicatorImage = imgBackArrow
        // Set the image mask
        nvc.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        
        nvc.navigationBar.topItem?.title = ""
    }
    
    static func currentUser()->User?{
        
        var user:User?
        if UKPSessionHelper.sessionConstains(key: GlobalConstants.Keys.sessionUser){
            if let current = Mapper<User>().map(JSON:UKPSessionHelper.getSession(key: GlobalConstants.Keys.sessionUser) as! [String : Any]){
                user = current
            }
        }
        return user
    }
    
    static func isGroup()->Bool{
        
        var isGroupGlobal = false
        if UKPSessionHelper.sessionConstains(key: GlobalConstants.Keys.sessionUser){
            if let current = Mapper<User>().map(JSON:UKPSessionHelper.getSession(key: GlobalConstants.Keys.sessionUser) as! [String : Any]){
                if let isTeacher = current.isEducator {
                    //print("isGroup in Helper: \(isTeacher)")
                    isGroupGlobal = isTeacher
                }
            }
        }
        return isGroupGlobal
    }
    
    static func loadMenu(window:UIWindow?, isLogged:Bool){
        var channelController:UIViewController!
        let channel = UIStoryboard(name: "Channel", bundle: nil)
        channelController = channel.instantiateViewController(withIdentifier: "ChannelVC")
        
        var mainController:UIViewController!
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        mainController = mainStoryboard.instantiateViewController(withIdentifier: "Welcome")
        
        var addDeviceController:UIViewController!
        addDeviceController = mainStoryboard.instantiateViewController(withIdentifier: "addDeviceVC")
        
        var teamPickerController:UIViewController!
        teamPickerController = mainStoryboard.instantiateViewController(withIdentifier: "selectAvatar")
        
        var menuController:UIViewController!
        let storyboardMenu = UIStoryboard(name: "Menu", bundle: nil)
        menuController = storyboardMenu.instantiateViewController(withIdentifier: "MenuController")
        
        
        let nav:UINavigationController!
        if isLogged{
            /*if UKPHelper.isGroup(), !UKPHelper.currentUser()!.isLinked! {
                nav = UINavigationController(rootViewController: addDeviceController)
            }else{
                nav = UINavigationController(rootViewController: channelController)
            }*/
            if UKPHelper.isGroup() {
                if let isLinked = UKPHelper.currentUser()?.isLinked{
                    if !isLinked {
                        if let myTeams = UKPHelper.currentUser()?.teams{
                            if myTeams.count > 1{
                                nav = UINavigationController(rootViewController: teamPickerController)
                            }else{
                                nav = UINavigationController(rootViewController: addDeviceController)
                            }
                        }else{
                            nav = UINavigationController(rootViewController: addDeviceController)
                        }
                    }else{
                        nav = UINavigationController(rootViewController: channelController)
                    }
                }else{
                    nav = UINavigationController(rootViewController: mainController)
                }
            }else{
                nav = UINavigationController(rootViewController: channelController)
            }
            
        }else{
            nav = UINavigationController(rootViewController: mainController)
        }
        
        let navigationController = SlideMenuController(mainViewController: nav, leftMenuViewController: menuController, rightMenuViewController: UIViewController())
        navigationController.removeRightGestures()
        navigationController.removeLeftGestures()
        
        navigationController.changeLeftViewWidth(GlobalConstants.Device.screenWidth * 0.62 )

        
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.rootViewController = navigationController
            keyWindow.makeKeyAndVisible()
        } else{
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
        
    }

    static func doLogout(vc:UIViewController){
        
        UKPSessionHelper.removeSession(key: GlobalConstants.Keys.sessionUser)
        UKPSessionHelper.removeSession(key: GlobalConstants.Keys.token)
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let initialViewController = mainStoryBoard.instantiateViewController(withIdentifier: "Welcome")
        vc.slideMenuController()?.mainViewController?.show(initialViewController, sender: nil)
        vc.slideMenuController()?.closeRight()
    }
    
    static func deviceIsIpad()->Bool{
        if UIDevice.current.userInterfaceIdiom == .pad{
            return true
        }else{
            return false
        }
    }
    
    static func setDateFormat(dateString:String)->String{
        
        let date:Date = dateString.toDateCustomFormat(GlobalConstants.DateFormat.apiFormat)
        
        var newStringDate = date.toStringCustomFormat(GlobalConstants.DateFormat.english)
        if GlobalConstants.lang == "es"{
            newStringDate = date.toStringCustomFormat(GlobalConstants.DateFormat.spanish)
        }
        return newStringDate
    }
    
    static func hoursToHoursMinutesSeconds (totalHours : Double) -> (timeString:String,hours:Int,minutes:Int,seconds:Int) {
        let intSeconds:Int = Int(totalHours * 3600)
        
        let hours = Int(intSeconds) / 3600
        let minutes = Int(intSeconds) / 60 % 60
        let seconds = Int(intSeconds) % 60
        return (timeString:String(format:"%02i:%02i:%02i", hours, minutes, seconds),hours:hours,minutes:minutes,seconds:seconds)
    }
    
    // MARK: CUSTOMIZE LABEL WITH ATTRIBUTES
    static func customLabel(firstString:String,secondString:String,firstSizeFont:CGFloat,secondSizeFont:CGFloat,firstTypeFont:String,secondTypeFont:String)->NSAttributedString{
        
        let attributesFirstFont = [NSFontAttributeName : UIFont(name:firstTypeFont, size: firstSizeFont) as Any] as [String:Any]
        let firstLabel = NSMutableAttributedString(string:firstString, attributes:attributesFirstFont)
        
        let attributesSecondFont = [NSFontAttributeName : UIFont(name:secondTypeFont, size: secondSizeFont) as Any] as [String:Any]
        let secondLabel = NSMutableAttributedString(string: secondString, attributes:attributesSecondFont)
        
        let atributtedLabel = NSMutableAttributedString()
        
        atributtedLabel.append(firstLabel)
        atributtedLabel.append(secondLabel)
        
        return atributtedLabel
        
    }
    
    static func customLabelWithColor(firstString:String,secondString:String,firstSizeFont:CGFloat,secondSizeFont:CGFloat,firstTypeFont:String,secondTypeFont:String, firstColorString: UIColor, secondColorString: UIColor)->NSMutableAttributedString{
        
        let att = [NSFontAttributeName : UIFont(name:firstTypeFont, size: firstSizeFont)  as Any, NSForegroundColorAttributeName: firstColorString] as [String:Any]
        let firstLabel = NSMutableAttributedString(string:firstString, attributes:att)
        
        let att2 = [NSFontAttributeName : UIFont(name:secondTypeFont, size: secondSizeFont) as Any,  NSForegroundColorAttributeName: secondColorString] as [String:Any]
        let secondLabel = NSMutableAttributedString(string: secondString, attributes:att2)
        
        let atributtedLabel = NSMutableAttributedString()
        
        atributtedLabel.append(firstLabel)
        atributtedLabel.append(secondLabel)
        
        return atributtedLabel
        
    }
    
    static func addBoldText(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        
        let nonBoldFontAttribute = [NSFontAttributeName:font!]
        let boldFontAttribute = [NSFontAttributeName:boldFont!]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
    
    static func manageErrors(vc:UIViewController, error:NSError){
        
        DDLogError("Error code: \(error.code) Description: \(error.description) ")
        if error.code == 403{
            let alert = UIAlertController(title: "message".localized, message: error.userInfo["message"] as? String, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: { (action) in
                //UKPHelper.doLogout()
            }))
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    static func randomString(length: Int) -> String {
        
        var randomString = ""
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        for _ in 1...length {
            let randomIndex  = Int(arc4random_uniform(UInt32(letters.characters.count)))
            let a = letters.index(letters.startIndex, offsetBy: randomIndex)
            randomString +=  String(letters[a])
        }
        
        return randomString
    }
    
    // MARK: CREATE SIMPLE ALERT
    static func createSimpleAlert(vc:UIViewController,title:String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel){_ in})
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    static func prefetchImagesFromArray(imageURLs:[String]) -> Int{
        
        let imageManager = SDWebImageManager.shared()
        let imagePrefecther = SDWebImagePrefetcher.shared()
        imagePrefecther?.maxConcurrentDownloads = 30
        imagePrefecther?.options = .retryFailed
        continueDownloading = true
        downloadError = false
        downloadCount = 0
        expectedDownloads = 0
        imageDownloader = SDWebImageDownloader.shared()
        imageDownloader!.cancelAllDownloads()
        
        var imagesToDownload = [URL]()
        
        for url in imageURLs {
            
            let assetURL = URL.init(string: url)
            
            if imageManager!.cachedImageExists(for: assetURL){
                continue
            }
            
            if assetURL != nil {
                imagesToDownload.append(assetURL!)
            }
        }
        
        expectedDownloads = imagesToDownload.count
        
        if imagesToDownload.count > 0 {

            imagePrefecther?.prefetchURLs(imagesToDownload, progress: { (noOfFinishedUrls, noOfTotalUrls) in
                //DDLogInfo("noOfFinishedUrls \(noOfFinishedUrls) noOfTotalUrls \(noOfTotalUrls)")
            }, completed: { (noOfFinishedUrls, noOfSkippedUrls) in
                //DDLogInfo("noOfFinishedUrls \(noOfFinishedUrls) noOfTotalUrls \(noOfSkippedUrls)")
            })
            
        }else{
            imageAssetsDownloadedSuccessfuly()
        }
        DDLogInfo("imagesToDownload.count \(imagesToDownload.count)")
        //DDLogInfo("imagesToDownload \(imagesToDownload)")
        return imagesToDownload.count
        
    }
    
    // MARK: IS CONECTION TO INTERNET
    static func haveConections()->Bool{
        let manager = NetworkReachabilityManager(host: "www.google.com")
         return manager?.isReachable ?? false
    }
    
    //MARK: LOAD IMAGE FROM URL
    static func loadImageFromURL(isChannel: Bool, urlString: String, completion:@escaping (UIImage?, Error?) -> Void){
        
        let imageManager = SDWebImageManager.shared()
        let imageCache = SDImageCache.shared()
        
        if imageManager!.cachedImageExists(for: URL(string: urlString)){
            let key = imageManager?.cacheKey(for: URL(string: urlString))
            if let cachedImage = imageCache?.imageFromDiskCache(forKey: key){
                //DDLogInfo("loadImageFromURL cachedImageExists \(urlString)")
                completion(cachedImage ,nil)
                //dismissLoadingScreenWithProgress()
                return
            }
        }
        
        downloadImageFromURL(urlString: urlString) { (downloadedImage, error) in
            
            if downloadedImage != nil{
                
                if !downloadError && continueDownloading{
                    imageCache?.store(downloadedImage, forKey: urlString)
                    let filename = urlString.components(separatedBy: "/").last!
                    self.saveImageToDocumentsDirectory(image: downloadedImage!, fileName: filename)
                    downloadCount += 1
                }
                
                DispatchQueue.global(qos: .background).async {
                    let downloadProgress = CGFloat(downloadCount)/CGFloat(expectedDownloads)
                    
                    /*print("downloadProgress \(downloadProgress)")
                    print("downloadCount \(downloadCount)")
                    print("expectedDownloads \(expectedDownloads)")*/
                    // Bounce back to the main thread to update the UI
                    DispatchQueue.main.async {
                        //DDLogError("Error downloading previous? \(downloadError)")
                        if !downloadError && continueDownloading{
                            if expectedDownloads == downloadCount{
                                DDLogInfo("Downloads finished successfuly")
                                UKPHelper.imageAssetsDownloadedSuccessfuly()
                                DDLogInfo("loadImageFromURL navigateToChannelScreen")
                                if haveNewMissions{
                                    haveNewMissions = false
                                    NotificationCenter.default.post(name: .newMissionLoaded, object: nil)
                                }else{
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "navigateToChannelScreen"), object: nil)
                                }
                            }
                        }
                    }
                }
                
                completion(downloadedImage, nil)
                
            }else{
                imageDownloader!.cancelAllDownloads()
                
                DispatchQueue.global(qos: .background).async {
                    //DDLogError("Error in loadImageFromURL \n \(error!) \n")
                    continueDownloading = false
                    completion(nil, error)
                    // Bounce back to the main thread to update the UI
                    DispatchQueue.main.async {
                        if !downloadError{
                            downloadError = true
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "downloadError"), object: nil)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: DOWNLOAD IMAGE FROM URL
    static func downloadImageFromURL(urlString: String, completion:@escaping (UIImage?, Error?) -> Void){
        
        imageDownloader!.maxConcurrentDownloads = 20
        imageDownloader!.shouldDecompressImages = true
        imageDownloader!.downloadTimeout = 30
        //print("currentDownloadCount \(imageDownloader!.currentDownloadCount)")
//        if expectedDownloads < Int(imageDownloader!.currentDownloadCount){
//            expectedDownloads = Int(imageDownloader!.currentDownloadCount)
//        }
        
        if continueDownloading{
            imageDownloader!.downloadImage(with: URL(string: urlString), options: [.useNSURLCache], progress: { (receivedSize, expectedSize) in
                if (expectedSize > 0) {
                    _ = CGFloat(receivedSize/expectedSize)
                }
            }, completed: { (image, data, error, finished) in
                
                if finished {
                    completion(image, error)
                }
            })
        }
        
    }
    
    static func initScreenProgress(){
        
        let configuration = KVNProgressConfiguration.init()
        configuration.circleStrokeBackgroundColor = UIColor.white.withAlphaComponent(0.3)
        configuration.circleStrokeForegroundColor = UIColor.white//GlobalConstants.Colors.fontColor
        configuration.successColor = UIColor.white//GlobalConstants.Colors.fontColor
        configuration.errorColor = UIColor.white//GlobalConstants.Colors.fontColor
        configuration.isFullScreen = true
        configuration.statusColor = UIColor.white//GlobalConstants.Colors.fontColor
        configuration.statusFont = Font.bold
        configuration.backgroundFillColor = GlobalConstants.Colors.unicefBlue
        configuration.backgroundType = .solid
        configuration.minimumDisplayTime = 3.0
        configuration.minimumSuccessDisplayTime = 3.0
        configuration.minimumErrorDisplayTime = 3.0
        KVNProgress.setConfiguration(configuration)
        
    }
    
    static func initLoadingScreenWithProgress(){
        
        initScreenProgress()
        
        KVNProgress.show(0.001, status: "Downloading App Content...")
    }
    
    static func updateLoadingScreenWithProgress(progress: CGFloat){
        var statusMessage:String!
        
        if progress <= 0.45 {
            statusMessage = "Downloading App Content..."
        }else if (progress > 0.45 && progress <= 0.80){
            statusMessage = "Setting up Channels..."
        }else if (progress > 0.80 && progress <= 1.0) {
            statusMessage = "Almost ready..."
        }
        
        KVNProgress.update(progress, animated: true)
        KVNProgress.updateStatus(statusMessage)
    }
    
    static func dismissLoadingScreenWithProgress(){
        DDLogInfo("---------------------------dismissLoadingScreenWithProgress---------------------------")
        KVNProgress.dismiss {
            DDLogError("Error downloading? \(downloadError)")
        }
    }
    
    static func successfullyCompleteFirstWaypoint(profileID:Int){
        let ftuxKey = "ftuxProfile\(profileID)"
        UKPSessionHelper.saveObjectInSession(object: "completed", key: ftuxKey)
    }
    
    static func hasCompletedTutorial(profileID:Int) -> Bool{
        let ftuxKey = "ftuxProfile\(profileID)"
        if UKPSessionHelper.getSession(key: ftuxKey) != nil {
            return true
        }else{
            return false
        }
    }
    
    static func legacyPopupWasShown(profileID:Int)->Bool{
        
        let legacyPopUpValidationKey = GlobalConstants.Keys.legacyPopUpValidation+"_"+String(profileID)
        if UKPSessionHelper.getSession(key: legacyPopUpValidationKey) != nil{
            return true
        }
        return false
    }
    
    static func getProfileStatusPerChannel(channelID:Int, completion:@escaping (Int?, [Reward]?, [Int]?, Error?) -> Void) {
        
        if let profileID = UKPHelper.currentUser()?.profile?.entityId{

            let parameters:[String : String] = ["profileId": String(describing: profileID), "channelId": String(channelID)]
            var unlockedRewards = [Reward]()
            var unlockedWaypoints = [Int]()
            
            let service:ShellWebService = ShellWebService()
            service.callServiceObject(parameters: parameters as [String : AnyObject], service: GlobalConstants.nameServices.profileStatus, withCompletionBlock: { (result, error) in
                if result != nil && error == nil{
                    let jsonResponse = result as! JSONResponse
                    if let data = jsonResponse.data as? Dictionary<String, Any> {
                        
                        let appliedActivity = data["activity_applied"] as? Int
                        //DDLogInfo("----------------------------------- Unlocked rewards for profileID \(profileID) in channelID \(channelID) ----------------------------------")
                        
                        if let rewardData = data["rewards"] as? NSArray{
                            for rwdData in rewardData{
                                if let parsedRwd = rwdData as? Dictionary<String, Any> {
                                    //Get waypointId
                                    let waypointId = parsedRwd["waypoint_id"] as? Int
                                    //Get concreteReward for badges and chatbots/impact-stories
                                    if let concreteReward = parsedRwd["concrete_reward"] as? [String : Any] {
                                        let reward:Reward = Mapper<Reward>().map(JSON:concreteReward)!
                                        reward.waypointId = waypointId
                                        unlockedRewards.append(reward)
                                    }else{
                                        //Only RUTF rewards
                                        let reward:Reward = Reward()
                                        reward.type = "rutf"
                                        reward.waypointId = waypointId
                                        unlockedRewards.append(reward)
                                    }
                                }
                            }
                            
                        }
                        //DDLogInfo("unlockedRewards \(unlockedRewards.toJSON())")
                        
                        //Get unlocked waypoints array
                        if let waypointsData = data["unlocked"] as? NSArray{
                            for wpData in waypointsData{
                                if let waypoint = wpData as? Dictionary<String, Any> {
                                    let waypointID = waypoint["waypoint_id"] as! Int
                                    //DDLogInfo("waypointID: \(waypointID)")
                                    unlockedWaypoints.append(waypointID)
                                }
                            }
                        }
                        
                        completion(appliedActivity,unlockedRewards,unlockedWaypoints, nil)
                    }
                }else{
                    completion(nil, nil, nil, error)
                }
            })
        }
    }
    
    static func updateProfile(parameters:[String : AnyObject], completion:@escaping (Bool?, Error?) -> Void) {
        DDLogInfo("updateProfile parameters \(parameters)")
        ShellWebService().callServiceObject(parameters: parameters as [String : AnyObject], service: GlobalConstants.nameServices.profileUpdate, withCompletionBlock: { (result, error) in
            if result != nil && error == nil{
                let jsonResponse = result as! JSONResponse
                if let data = jsonResponse.data as? Dictionary<String, Any> {
                    let profile:Profile = Mapper<Profile>().map(JSON:data["profile"] as! [String : Any] )!
                    let user:User = UKPHelper.currentUser()!
                    user.profile?.energy = profile.energy
                    UKPSessionHelper.saveInSession(object: user, key: GlobalConstants.Keys.sessionUser)
                    completion(true, error)
                }
            }else{
                completion(nil, error)
            }
        })
    }
    
    static func imageAssetsDownloadedSuccessfuly(){
        let storedObject = (isGroup()) ? "downloaded" : "groupDownloaded"
        let storedObjectKey = ( UKPHelper.isGroup() ) ? GlobalConstants.Keys.groupChannelsDownloaded : GlobalConstants.Keys.channelsDownloaded
        UKPSessionHelper.saveObjectInSession(object: storedObject, key: storedObjectKey)
        let channelKey = (isGroup()) ? "groupChannels" : "channels"
        
        
        if let channelData = UKPSessionHelper.loadObjectInSessionWithKey(key: channelKey) {
            if let channels = NSKeyedUnarchiver.unarchiveObject(with: channelData as! Data) as? [Channel] {
                if appChannels.count > channels.count{
                    UKPSessionHelper.saveObjectInSession(object: appChannels, key: channelKey)
                }
            }
        }else{
            UKPSessionHelper.saveObjectInSession(object: appChannels, key: channelKey)
        }
        
        
    }
    
    static func channelHostWelcomeSeen(channelID:Int, profileID:Int){
        let hostKey = "host\(channelID)profile\(profileID)"
        DDLogInfo("profile \(profileID) just saw host welcome in channel \(channelID)")
        UKPSessionHelper.saveObjectInSession(object: "completed", key: hostKey)
    }
    
    static func hasSeenHostWelcome(channelID:Int, profileID:Int) -> Bool{
        let hostKey = "host\(channelID)profile\(profileID)"
        if UKPSessionHelper.getSession(key: hostKey) != nil {
            DDLogInfo("profile \(profileID) already seen host welcome in channel \(channelID)")
            return true
        }else{
            DDLogInfo("profile \(profileID) haven't seen host welcome in channel \(channelID)")
            return false
        }
    }
    
    static func channelHostMultiMisionTutorial(profileID:Int){
        let hostKey = "hostMultiMisiontutorialprofile\(profileID)"
        DDLogInfo("profile \(profileID) just saw host MultiMision-tutorial")
        UKPSessionHelper.saveObjectInSession(object: "completed", key: hostKey)
    }
    
    static func hasSeenHostMultiMisionTutorial(profileID:Int) -> Bool{
        let hostKey = "hostMultiMisiontutorialprofile\(profileID)"
        if UKPSessionHelper.getSession(key: hostKey) != nil {
            DDLogInfo("profile \(profileID) already seen host MultiMision-tutorial")
            return true
        }else{
            DDLogInfo("profile \(profileID) haven't seen host MultiMision-tutorial")
            return false
        }
    }
    
    static func hasImageInDirectory(currentChannel:Channel, completion:@escaping (UIImage?) -> Void){
            let hostImage = currentChannel.avatarImageURL?.components(separatedBy: "/").last!
            if let imageFileName = hostImage, imageFileName.length > 0{
                if let currentHostImage = UKPHelper.loadImageFromDocumentsDirectory(fileName: imageFileName) {
                    completion(currentHostImage)
                }else{
                    UKPHelper.loadImageFromURL(isChannel: false, urlString: currentChannel.avatarImageURL!, completion: { (image, error) in
                        if(image != nil && error == nil){
                            completion(image)
                        }else{
                            //DDLogError("Error: \(String(describing: error?.localizedDescription)) Description: \(String(describing: error.debugDescription)) ")
                           completion(nil)
                        }
                    })
                }
            }
    }
    
    static func saveImageToDocumentsDirectory(image: UIImage, fileName: String) -> Void{
        if let data = UIImagePNGRepresentation(image) {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let filename = paths[0].appendingPathComponent(fileName)
            //print("saveImageToDocumentsDirectory \(filename)")
            try? data.write(to: filename)
        }
    }
    
    static func loadImageFromDocumentsDirectory(fileName: String) -> UIImage?{
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(fileName).path
            if FileManager.default.fileExists(atPath: filePath) {
                DDLogVerbose("|-----------------------------------------------|")
                DDLogVerbose("FileName: \(fileName) for path: \(filePath)")
                DDLogVerbose("|-----------------------------------------------|")
                guard let image = UIImage(contentsOfFile: filePath) else {
                    DDLogError("File exist at \(filePath) : Unable to create image")
                    return nil
                }
                return image
            }else{
                DDLogError("File does not exist at \(filePath)")
                return nil
            }
    }
    
    static func switchToProfile(profileID:Int, completion:@escaping (Bool) -> Void){

        let service = ShellWebService()
        service.currentId = profileID
        service.callServiceObject(parameters: nil, service: GlobalConstants.nameServices.profileChange) { (result, error) in
            if result != nil && error == nil{
                let jsonResponse = result as! JSONResponse
                if let data = jsonResponse.data as? Dictionary<String, Any> {
                    DDLogInfo("switchToProfile data: \(data)")
                    let token = data["token"] as? String
                    UKPSessionHelper.saveAnyObjectInSession(object: token as AnyObject , key: GlobalConstants.Keys.token)
                    //UKPHelper.getCustomerIdentityForSegment()
                    /*SEGAnalytics.shared().track(GlobalConstants.Segment.Onboarding.Login.accountLogin,
                                                properties: ["successful": true,
                                                             "app": "ios"])*/
                    DDLogVerbose("New Session token: \(UKPSessionHelper.getSession(key: GlobalConstants.Keys.token)! as Any)")
                    completion(true)
                }else{
                    DDLogError("ERROR switchToProfile: Error parsing data")
                    completion(false)
                }
            }else{
                completion(false)
                DDLogError("ERROR switchToProfile: \(error!.userInfo["message"]!)")
            }
        }
    }
    
    static func createProfileWithValues(avatarID:Int, username:String, isChild: Bool, completion: @escaping ((Bool, _ error: NSError?) -> Void)){
        
        let parameters = ["avatar_id":avatarID, "name":username, "is_child":isChild] as [String : Any]
        var user = self.currentUser()!
        
        ShellWebService().callServiceObject(parameters: parameters as [String : AnyObject], service: GlobalConstants.nameServices.createProfile) { (result, error) in
            if result != nil && error == nil{
                let jsonResponse = result as! JSONResponse
                if let data = jsonResponse.data as? Dictionary<String, Any> {
                    DDLogInfo("createProfileWithValues data: \(data)")
                    let currentProfile:Profile = Mapper<Profile>().map(JSON:data["newProfile"] as! [String : Any])!
                    user.profile = currentProfile
                    user.profiles!.append(currentProfile)
                    DDLogInfo("New profile created with entityID: \(user.profile!.entityId!)")
                    //Store auto-generated token
                    let token = data["token"] as? String
                    UKPSessionHelper.saveAnyObjectInSession(object: token as AnyObject , key: GlobalConstants.Keys.token)
                    //Store user changes
                    user = user.saveManagedModel()
                    UKPSessionHelper.saveInSession(object: user, key: GlobalConstants.Keys.sessionUser)
                    UKPMechanicsHelper.setTokenDeviceInCustomerIO()
                    completion(true, nil)
                }else{
                    DDLogError("ERROR createProfileWithValues: Error parsing data")
                    completion(false, error)
                }
            }else{
                completion(false, error)
                DDLogError("ERROR createProfileWithValues: \(error!.userInfo["message"]!)")
            }
        }
        
    }
    
    static func changeNameForStore(name:String) -> String {
        var modName = "BUNDLES OF KEYS"
        switch (name) {
        case "BUNDLE OF KEYS":
            modName = "bundle_02"
            break;
        case "POUCH OF KEYS":
            modName = "pouch_15"
            break;
        case "BUCKET OF KEYS":
            modName = "bucket_75"
            break;
        case "CHEST OF KEYS":
            modName = "chest_160"
            break;
        default:
            break;
        }
        
        return modName
    }
    
    static func updateProfileWithValues(avatarID:Int?,rosterID: Int?, username:String?, isDefault: Bool, completion: @escaping ((Bool, _ error: NSError?) -> Void)){
        
        var parameters = ["default":isDefault] as [String : Any]
        
        if avatarID != nil{
            parameters["avatar_id"] = avatarID
        }
        
        if username != nil{
            parameters["name"] = username
        }
        
        if self.isGroup() || rosterID != nil{
            parameters["roster_id"] = rosterID
        }

        var user = self.currentUser()!
        
        ShellWebService().callServiceObject(parameters: parameters as [String : AnyObject], service: GlobalConstants.nameServices.updateProfile) { (result, error) in
            if result != nil && error == nil{
                let jsonResponse = result as! JSONResponse
                if let data = jsonResponse.data as? Dictionary<String, Any> {
                    DDLogInfo("Update Profile With Values data: \(data)")
                    let currentProfile:Profile = Mapper<Profile>().map(JSON:data["profile"] as! [String : Any])!
                    user.profile = currentProfile
                    completion(true, nil)
                }else{
                    DDLogError("ERROR createProfileWithValues: Error parsing data")
                    completion(false, error)
                }
            }else{
                completion(false, error)
                DDLogError("ERROR createProfileWithValues: \(error!.userInfo["message"]!)")
            }
        }
        
    }
    
    static func addTrackerToProfileWithDevice(newTracker: CCLDBandDevice, completion:@escaping (Bool, Error?) -> Void){
        let user = self.currentUser()!
        
        var trackerName = newTracker.deviceName!
        if newTracker.type == GlobalConstants.trackerType.healthApp{
            trackerName = UIDevice.current.name
        }
        
        var trackerFactoryID:String?
        
        if (newTracker.type == GlobalConstants.trackerType.healthApp) {
            if let deviceName = newTracker.deviceName {
                trackerFactoryID = deviceName
            }else{
                let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: 404, userInfo: ["message": "TRACKER NOT FOUND"])
                DDLogError("Error code: \(error.code) Description: \(error.description) ")
                completion(false, error)
            }
        }else{
            if let fullMACAddress = newTracker.fullMACAddress {
                trackerFactoryID = fullMACAddress
            }else{
                let error:NSError = NSError(domain: GlobalConstants.errorDomain, code: 404, userInfo: ["message": "TRACKER NOT FOUND"])
                DDLogError("Error code: \(error.code) Description: \(error.description) ")
                completion(false, error)
            }
        }
        //let trackerFactoryID = (newTracker.type == GlobalConstants.trackerType.healthApp) ? newTracker.deviceName! : newTracker.fullMACAddress!
        
        var parameters = ["name": trackerName,
                          "type": newTracker.type!,
                          "version": (newTracker.fwVersion ?? "1"),
                          "tracker_factory_id": trackerFactoryID,
                          "start_date": Date().toStringCustomFormat(GlobalConstants.DateFormat.apiFormat),
                          "linked": true,
                          "end_date": Date().toStringCustomFormat(GlobalConstants.DateFormat.apiFormat)] as [String: AnyObject]
        
        if(newTracker.type == GlobalConstants.trackerType.band){
            parameters["firmware_version"] = newTracker.fwVersionWithoutPoint as AnyObject
            parameters["factory_model"] = newTracker.codeTypeBand as AnyObject
        }
        
        
        ShellWebService().callServiceObject(parameters: parameters, service: GlobalConstants.nameServices.trackerRegister, withCompletionBlock: { (result, error) in
            
            if result != nil && error == nil{
                let jsonResponse = result as! JSONResponse
                if let data = jsonResponse.data as? Dictionary<String, Any> {
                    let tracker:Tracker = Mapper<Tracker>().map(JSON:data["newTracker"] as! [String : Any])!
                    DDLogInfo("tracker created \(tracker.toJSON())")
                    //user.profile!.currentTracker = tracker
                    user.profile!.trackers?.append(tracker)
                    //Save last activity batch to prevent cheating after relink
                    if let lastBatch = tracker.lastBatch, lastBatch.steps != nil {
                        UKPHelper.saveCurrentProfileLastBatch(lastBatch: lastBatch, profileID: user.profile!.entityId!)
                    }
                    
                    UKPSessionHelper.saveInSession(object: user, key: GlobalConstants.Keys.sessionUser)
                    var trackerType = "unset"
                    
                    if let trackers = user.profile?.trackers{
                        if trackers.count > 0{
                            trackerType = getTrackerTypeForSegment(trackerType: (tracker.type)!)
                        }
                    }
                    
                    //Analytics.logEvent("tracker_linked", parameters: ["type" : trackerType ?? "" as NSObject])
                    if !UKPHelper.isGroup() {
                        UKPHelper.getCustomerIdentityForSegment()
                        SEGAnalytics.shared().track(GlobalConstants.Segment.Onboarding.Profile.trackerLinked,
                                                    properties: ["type":  trackerType as NSObject])
                    }
                    //Analytics.setUserProperty(trackerType ?? "" as String, forName: "type")
                    completion(true, nil)
                }else{
                    DDLogError("ERROR addTrackerToProfileWithDevice: Error parsing data")
                    completion(false, error)
                }
            }else{
                DDLogError("ERROR createProfileWithValues: \(error!.userInfo["message"]!)")
                completion(false, error)
            }
        })
    }
    
    static func linkTrackerWithProfile(newTracker: Tracker, completion:@escaping (Bool, Error?, Tracker?) -> Void){
        
        //let user = UKPHelper.currentUser()!
        let trackerName = newTracker.name
        let trackerFactoryID:String = newTracker.trackerFactoryId!
        
        let parameters = ["name": trackerName as AnyObject,
                          "type": newTracker.type! as AnyObject,
                          "version": (newTracker.version ?? "1"),
                          "tracker_factory_id": trackerFactoryID,
                          "start_date": Date().toStringCustomFormat(GlobalConstants.DateFormat.apiFormat),
                          "linked": true,
                          "profile_id" : newTracker.profileId as AnyObject,
                          "end_date": Date().toStringCustomFormat(GlobalConstants.DateFormat.apiFormat)] as [String: AnyObject]
        
        ShellWebService().callServiceObject(parameters: parameters, service: GlobalConstants.nameServices.trackerRegister, withCompletionBlock: { (result, error ) in
            
            if result != nil && error == nil{
                let jsonResponse = result as! JSONResponse
                if let data = jsonResponse.data as? Dictionary<String, Any> {

                    let tracker:Tracker = Mapper<Tracker>().map(JSON:data["newTracker"] as! [String : Any])!
                    
                    if !UKPHelper.isGroup() {
                        var trackerType = "n/a"
                        trackerType = getTrackerTypeForSegment(trackerType: (tracker.type)!)
                        UKPHelper.getCustomerIdentityForSegment()
                        SEGAnalytics.shared().track(GlobalConstants.Segment.Onboarding.Profile.trackerLinked,
                                                    properties: ["type":  trackerType as NSObject])
                    }
                    completion(true, nil , tracker)
                }else{
                    DDLogError("ERROR addTrackerToProfileWithDevice: Error parsing data")
                    if UKPHelper.isGroup() {
                        SEGAnalytics.shared().track(GlobalConstants.Segment.Onboarding.GroupSync.gsBandLinkFailed,
                                                    properties: ["reason":  "api_request_failed" as NSObject])
                    }
                    completion(false, error, nil)
                }
            }else{
                DDLogError("ERROR createProfileWithValues: \(error!.userInfo["message"]!)")
                if UKPHelper.isGroup() {
                    SEGAnalytics.shared().track(GlobalConstants.Segment.Onboarding.GroupSync.gsBandLinkFailed,
                                                properties: ["reason":  "api_request_failed" as NSObject])
                }
                completion(false, error, nil)
            }
        })
    }
    
    static func getTopViewController()->UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    static func downloadAvatarsData(){
        
        ShellWebService().callServiceObject(parameters: nil,
                                            service: GlobalConstants.nameServices.avatars,
                                            withCompletionBlock: { (result, error) in
                                                
            if result != nil && error == nil{
                let jsonResponse = result as! JSONResponse
                if let data = jsonResponse.data as? Dictionary<String, Any> {
                    //DDLogInfo("getAvatarsCall \(data)")
                    if let avatarArray = data["avatars"] as? NSArray{
                        for avatarData in avatarArray{
                            let avatar:Avatar = Mapper<Avatar>().map(JSON:avatarData as! [String : Any])!
                            imagesToDownload.append(avatar.imageUrl!)
                            appAvatars.append(avatar)
                        }
                        UKPSessionHelper.saveObjectInSession(object: appAvatars, key: "avatars")
                        self.initImageAssetsDowload()
                    }
                }
            }else{
                DDLogError("Error downloadAvatarsData: \(error!.userInfo["message"]!)")
                downloadError = true
            }
        })
    }
    
    static func validateIfHaveNewChannels(currentMissionCount:Int, isGroup:Bool, completion:@escaping (Bool) -> Void){
        
        let parameters = ["isGroup": isGroup] as [String: AnyObject]
        
        ShellWebService().callServiceObject(parameters:parameters, service: GlobalConstants.nameServices.channels,withCompletionBlock: { (result, error) in
            if result != nil && error == nil{
                let jsonResponse = result as! JSONResponse
                if let data = jsonResponse.data as? Dictionary<String, Any> {
                    if let channelsArray = data["channels"] as? NSArray{
                        if currentMissionCount < channelsArray.count{
                            completion(true)
                        }else{
                            completion(false)
                        }
                    }
                }
            }
        })
    }
    
    static func downloadChannelsData(isGroup:Bool, channelsAvailable:[ChannelType]){
        
        imagesToDownload = [String]()
        appChannels = [Channel]()
        appAvatars = [Avatar]()
        
        let parameters = ["isGroup": isGroup] as [String: AnyObject]
        
        ShellWebService().callServiceObject(parameters: parameters,
                                            service: GlobalConstants.nameServices.channels,
                                            withCompletionBlock: { (result, error) in
            
            if result != nil && error == nil{
                let jsonResponse = result as! JSONResponse
                if let data = jsonResponse.data as? Dictionary<String, Any> {
                    if let channelsArray = data["channels"] as? NSArray{
                        for channelData in channelsArray{
                            let channel:Channel = Mapper<Channel>().map(JSON:channelData as! [String : Any])!
                            var isDowmloadChannel = false
                        
                            for channelSelection in channelsAvailable{
                                switch channelSelection{
                                case .kidPower:do {
                                    if ChannelType.kidPower.rawValue == channel.name{
                                        isDowmloadChannel = true
                                    }
                                    }
                                default:do {
                                    //All
                                    isDowmloadChannel = true
                                    }
                                }
                            }
                            
                            if isDowmloadChannel || isGroup{
                                for layer in channel.layers! {
                                    for section in layer.sections! {
                                        imagesToDownload.append(section.imageURL!)
                                    }
                                }
                                appChannels.append(channel)
                            }
                        }
                        //DDLogInfo("myChannels \(myChannels)")
//                        let channelKey = (isGroup) ? "groupChannels" : "channels"
//                        UKPSessionHelper.saveObjectInSession(object: appChannels, key: channelKey)
                        self.downloadAvatarsData()
                    }
                }
            }else{
                DDLogError("Error downloadChannelsData: \(error!.userInfo["message"]!)")
                downloadError = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "downloadError"), object: nil)
            }
        })
    }
    
    static func initImageAssetsDowload(){
        
        let nonCachedImages = UKPHelper.prefetchImagesFromArray(imageURLs: imagesToDownload.reversed())
        
        if nonCachedImages > 0 {
            for imageURL in imagesToDownload.reversed() {
                UKPHelper.loadImageFromURL(isChannel: true, urlString: imageURL, completion: { (_, error) in
                })
            }
        }else{
            DDLogInfo("initImageAssetsDowload navigateToChannelScreen")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "navigateToChannelScreen"), object: nil)
        }
    }
    
    static func downloadHostImage(channelList:[Channel]){
        
        if channelList.count > 0{
            for myChannel in channelList{
                UKPHelper.loadImageFromURL(isChannel: false, urlString: myChannel.avatarImageURL!, completion: { (image, error) in
                    if image != nil, error == nil {
                        DDLogInfo("Host downloaded")
                    }else{
                        //DDLogError("Image couldn't be downloaded \(myChannel.avatarImageURL!)")
                    }
                })
            }
        }
    }
    
    static func downloadTeamsImage(teamsList:[Team], isBackground:Bool){
        
        if teamsList.count > 0{
            for myTeam in teamsList{
                var imageUrl = myTeam.iconUrl
                if isBackground{
                    imageUrl = myTeam.backgroundUrl
                }
                
                UKPHelper.loadImageFromURL(isChannel: false, urlString: imageUrl!, completion: { (image, error) in
                    if image != nil, error == nil {
                        DDLogInfo("Team Images downloaded")
                    }else{
                        //DDLogError("Image couldn't be downloaded \(imageUrl!)")
                    }
                })
            }
        }
    }
    
    
    
    static func startLoadingAnimationForButton(button:UIButton){
        
        var buttonTitle = "baseLoading".localized
        pointCount = (pointCount >= 3) ? 1 : pointCount + 1
        for _ in 0...pointCount-1 {
            buttonTitle.append(".")
            button.setTitle(buttonTitle, for: .normal)
        }
    }
    
    static func startTitleAnimationForButton(button:UIButton, title: String){
        
        var buttonTitle = title
        pointCount = (pointCount >= 3) ? 1 : pointCount + 1
        for _ in 0...pointCount-1 {
            buttonTitle.append(".")
            button.setTitle(buttonTitle, for: .normal)
        }
    }
    
    static func checkIfAvatarsDownloadFinished()->Bool{
        
        var currentCount = 0 //Number of images downloaded
        //let imageManager = SDWebImageManager.shared()
        let imageCache = SDImageCache.shared()
        
        if let avatarsData = UKPSessionHelper.loadObjectInSessionWithKey(key: GlobalConstants.Keys.avatars) as? Data {
            if let avatars = NSKeyedUnarchiver.unarchiveObject(with: avatarsData) as? [Avatar] {
                for myAvatar in avatars{
                    if let avatarFilename = myAvatar.imageUrl?.components(separatedBy: "/").last! {
                        if UKPHelper.loadImageFromDocumentsDirectory(fileName: avatarFilename) != nil {
                            currentCount += 1
                        }else{
                            if let imageURL = myAvatar.imageUrl{
                                imageCache?.removeImage(forKey: imageURL)
                            }
                            /*let key = imageManager?.cacheKey(for: URL(string: myAvatar.imageUrl!))
                            if imageCache?.imageFromDiskCache(forKey: key) != nil {
                                DDLogInfo("loadImageFromURL cachedImageExists \(myAvatar.imageUrl!)")
                                currentCount += 1
                            }*/
                        }
                    }
                }
                DDLogInfo("currentCount \(currentCount) avatars.count \(avatars.count)")
                return (currentCount == avatars.count)
            }
            return false
        }
        
        return false
    }
    
    static func getOffsetCurrent()->String{
        let seconds = TimeZone.current.secondsFromGMT()
        
        let hours = seconds/3600
        let minutes = abs(seconds/60) % 60
        
        let tz = String(format: "%+.2d:%.2d", hours, minutes)
        return tz
    }
    
    static func saveCheerSentToFriend(friendProfileID:Int, profileID:Int){
        let cheerKey = "friendProfileID\(friendProfileID)profile\(profileID)"
        DDLogInfo("saveCheerSentToFriend \(cheerKey)")
        UKPSessionHelper.saveObjectInSession(object: Date(), key: cheerKey)
    }
    
    static func hasSentCheerToFriendsLately(friendProfileID:Int, profileID:Int) -> Bool{
        let cheerKey = "friendProfileID\(friendProfileID)profile\(profileID)"
        DDLogInfo("cheerKey \(cheerKey)")
        if let lastCheerData = UKPSessionHelper.loadObjectInSessionWithKey(key: cheerKey) as? Data {
            if let lastCheer = NSKeyedUnarchiver.unarchiveObject(with: lastCheerData) as? Date {
                let today = Date()
                let cheerAvailabilityDate = lastCheer.addingTimeInterval(TimeInterval(cheerInterval))
                DDLogInfo("hasSentCheerToFriendsLately today \(today)")
                DDLogInfo("hasSentCheerToFriendsLately cheerAvailabilityDate \(cheerAvailabilityDate)")
                DDLogInfo("result????? \(today.isGreaterThanDate(cheerAvailabilityDate))")
                return today.isGreaterThanDate(cheerAvailabilityDate)
            }
        }
        
        return true
    }
    
    static func saveCurrentProfileLastBatch(lastBatch:Activity, profileID:Int){
        let key = "lastBatchProfile\(profileID)"
        DDLogInfo("lastBatchProfile \(lastBatch.toJSON())")
        UKPSessionHelper.saveInSession(object: lastBatch, key: key)
    }
    
    static func getCurrentProfileLastBatch(profileID:Int)->Activity?{
        
        let key = "lastBatchProfile\(profileID)"
        var lastBatch:Activity?
        if UKPSessionHelper.sessionConstains(key: key){
            if let lastActivityBatch = Mapper<Activity>().map(JSON:UKPSessionHelper.getSession(key: key) as! [String : Any]){
                lastBatch = lastActivityBatch
            }
        }
        return lastBatch
    }
    
    static func getFileNameForDownload(key:String)->String{
        let name = URL(string: UKPSessionHelper.getSession(key: key) as! String)
        let fileName = (name?.pathComponents.split(separator: "/").last!.last!)!
        
        return fileName
    }
    
    static func getURLForDownload(key:String)->URL{
        
        var urlPath:URL = URL(fileURLWithPath: "")
        if UKPSessionHelper.sessionConstains(key: key){
            let name = URL(string: UKPSessionHelper.getSession(key: key) as! String)
            let fileName = (name?.pathComponents.split(separator: "/").last!.last!)!
            if let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                urlPath = paths.appendingPathComponent(fileName)
            }
        }
        
        return urlPath
    }
    
    static func cancelBandConnection(){
        
        var currentPeripheral:CCLDBandDevice?
        let bandManagerLocal = UKPHelper.bandManager
        let user = self.currentUser()
        if let trackers = user?.profile?.trackers{
            if trackers.count > 0{
                if let trackerId = user?.profile?.trackers![0].name{
                    currentPeripheral = bandManagerLocal.band(forId: trackerId)
                    
                    if currentPeripheral != nil{
                        DDLogInfo("Cancelling band connection")
                        bandManagerLocal.cancelConnect(to: currentPeripheral)
                    }else{
                        DDLogInfo("Couldn´t cancel band connection")
                    }
                }
            }
        }
    }
    
    static func cancelGSBandConnectionByProfile(profiles:[Profile]){
        
        var currentPeripheral:CCLDBandDevice?
        let bandManagerLocal = UKPHelper.bandManager
            if profiles.count > 0{
                for myProfile in profiles{
                    if let trackerId = myProfile.trackers?[0].name{
                        currentPeripheral = bandManagerLocal.band(forId: trackerId)
                        
                        if currentPeripheral != nil{
                            print("Cancelling band connection")
                            bandManagerLocal.cancelConnect(to: currentPeripheral)
                        }else{
                            print("Couldn´t cancel band connection")
                        }
                    }
                }
            }
    }
    
    //MARK: - Haptics validation
    
    static func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    static var hasHapticFeedback: Bool {
        return ["iPhone9,1", "iPhone9,2", "iPhone9,3", "iPhone9,4","iPhone10,1", "iPhone10,2","iPhone10,3", "iPhone10,4","iPhone10,5", "iPhone10,6"].contains(self.modelIdentifier())
    }
    
    static func profileFinishedFTUETutorial(profileID:Int){
        let hostKey = "profileFinishedFTUETutorial\(profileID)"
        print("profile \(profileID) finished FTUE tutorial")
        UKPSessionHelper.saveObjectInSession(object: "completed", key: hostKey)
    }
    
    static func hasFinishedFTUETutorial(profileID:Int) -> Bool{
        let hostKey = "profileFinishedFTUETutorial\(profileID)"
        if UKPSessionHelper.getSession(key: hostKey) != nil {
            print("profile \(profileID) already finished FTUE tutorial")
            return true
        }else{
            print("profile \(profileID) haven't finished FTUE tutorial")
            return false
        }
    }
    
    //MARK: - Segment
    static func getCustomerIdentityForSegment() {
        DDLogInfo("Customer Identity For Segment")
        let user = self.currentUser()!
        var trackerType = "unset"
        if let trackers = user.profile?.trackers{
            if trackers.count > 0{
                trackerType = getTrackerTypeForSegment(trackerType: (trackers[0].type)!)
            }
        }
        
        
        if let profile = user.profile {
            
            var userIdWithProfileId = ""
            if self.isGroup() {
                if let profiles = user.profiles, profiles.count > 0, let profileIdGhost:Int = profiles[0].entityId {
                    userIdWithProfileId = "\(String(describing: user.entityId!))-\(String(describing: profileIdGhost))"
                }else{
                    userIdWithProfileId = "\(String(describing: user.entityId!))-\(String(describing: profile.entityId!))"
                }
            }else{
                userIdWithProfileId = "\(String(describing: user.entityId!))-\(String(describing: profile.entityId!))"
            }
            var traits : [String : AnyObject] = ["email": user.email as AnyObject,
                                                "type": (self.isGroup() ? "gs_team" : "profile") as AnyObject,
                                                "group_sync_user": self.isGroup() as AnyObject]
            if !self.isGroup() {
                let totalMembers:AnyObject = UKPSessionHelper.getSession(key: "totalTeams\(String(describing: profile.entityId!))") as AnyObject
                let countFriends:AnyObject = UKPSessionHelper.getSession(key: "totalFriends\(String(describing: profile.entityId!))") as AnyObject
                let totalFriends = Int(countFriends as? String ?? "") ?? 0
                var totalTeamsCount:Int = 0
                if let total:Int = totalMembers as? Int {
                    totalTeamsCount = total
                }
                traits["createdAt"] = Date().timeIntervalSince1970 as AnyObject
                traits["username"] = profile.name! as AnyObject
                traits["account_id"] = user.entityId as AnyObject
                traits["under_13"] = profile.isChild as AnyObject
                traits["tracker"] = trackerType as AnyObject
                traits["app_user"] = true as AnyObject
                traits["friend_count"] = totalFriends as AnyObject
                if totalTeamsCount > 0{
                    traits["team_count"] = totalTeamsCount as AnyObject
                }
            }else{
                traits["team_name"] = user.team?.teamName as AnyObject
            }
            
            SEGAnalytics.shared().reset()
            SEGAnalytics.shared().identify(userIdWithProfileId, traits: traits)
        }else{
            let traits : [String : AnyObject] = [ "createdAt": Date().timeIntervalSince1970 as AnyObject,
                                                  "email": user.email as AnyObject,
                                                  "type": "account" as AnyObject,
                                                  "app_user": true as AnyObject]

            SEGAnalytics.shared().reset()
            SEGAnalytics.shared().identify(String(describing: user.entityId!), traits: traits)
        }
    }
    
    static func getTrackerTypeForSegment(trackerType:String)->String {
        switch trackerType {
        case GlobalConstants.trackerType.band:
            return "kid_power_band"
        case GlobalConstants.trackerType.healthApp:
            return "apple_health"
        case GlobalConstants.trackerType.androidhealthApp:
            return "google_fit"
        default:
            return "unset"
        }
    }
    
    static func sendForSegmentWithoutProperties(_ event: String) {
        SEGAnalytics.shared().track(event, properties: nil)
    }
    
    static func validateIfTeamIsExpired(endDate:String)->Bool{
        
        let newEndDate:Date = endDate.changeDateFormatToDate(type: GlobalConstants.DateFormat.serviceFormat)

        return Date().isGreaterThanDate(newEndDate)
    }
    
    static func getCurrentRewards()->[Reward]{
        
        var currentRewardsList:[Reward] = []
        if let rewardsData = UKPSessionHelper.loadObjectInSessionWithKey(key:  GlobalConstants.Keys.currentRewards) {
            if let myRewards = NSKeyedUnarchiver.unarchiveObject(with: rewardsData as! Data) as? [Reward] {
                currentRewardsList = myRewards
            }
        }
        
        return currentRewardsList
    }
    
    static func showPushNotificationsDialog(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if !UIApplication.shared.isRegisteredForRemoteNotifications{
            appDelegate.registerRemoteNotifications(application: UIApplication.shared)
        }
    }
}

extension String {
    
    var dateFromServiceToLocale: String {
        
        return changeDateFormat(type:GlobalConstants.DateFormat.fromServicelocale)
    }
    
    func changeDateFormat(type:String)->String{
        
        let format = DateFormatter(format: GlobalConstants.DateFormat.fromService)
        format.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
        guard let date = format.date(from: self) else {
            return " "
        }
        
        format.dateFormat = type
        format.timeZone = NSTimeZone.local
        let newDate = format.string(from: date)
        return newDate
        
    }
    
    func changeDateFormat(type:String, type2:String)->String{
        
        let format = DateFormatter(format: type2)
        format.timeZone = NSTimeZone(abbreviation: "UTC") as! TimeZone
        guard let date = format.date(from: self) else {
            return " "
        }
        
        format.dateFormat = type
        let newDate = format.string(from: date)
        return newDate
        
    }
    
    func changeDateFormatToDate(type:String)->Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type
        var dateInDateFormat = Date()
        if let newDate = dateFormatter.date(from: self){
            dateInDateFormat = newDate
        }
        
        return dateInDateFormat
    }
    
    func replaceString(subString:String, chart:String)->String{
        
        var newString = ""
        newString = self.replacingOccurrences(of: chart, with: subString, options: .literal, range: nil)
        
        return newString
    }

}

