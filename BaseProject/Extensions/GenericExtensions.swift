//
//  GenericExtensions.swift
//  Unicef Kid Power
//
//  Created by Ailicec Tovar on 8/22/17.
//  Copyright © 2017 Teravision. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import MIBadgeButton_Swift
import CocoaLumberjack

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func setFormat()->String{
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.locale = Locale(identifier: "en_US")
        
        let formattedNumber = numberFormatter.string(from: Double(self)! as NSNumber)
        return String(describing: formattedNumber!)
    }
    
    func containsIgnoringCase(_ find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

extension CGFloat {
    
    func round(to places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return Darwin.round(self * divisor) / divisor
    }
    
}

extension UIButton
{
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat, color: UIColor){
        
        let roundLayer = CAShapeLayer()
        roundLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = roundLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = roundLayer.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = 1
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
    
    func customRoundedButton(corners:UIRectCorner, radius: CGFloat){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii:CGSize(width:radius, height:radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
    
    func underlineButton(text: String) {
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, text.characters.count))
        self.setAttributedTitle(titleString, for: .normal)
    }
    
    func addShadow() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 10.0, height: 3)
        self.layer.shadowOpacity = 10.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
    }
    
    func greenButton(textButton:String){
        self.backgroundColor = GlobalConstants.Colors.buttonStartHost
        self.setTitle(textButton, for: .normal)
        self.layer.cornerRadius = 9.0
    }
    
    func grayButton(textButton:String){
        self.backgroundColor = GlobalConstants.Colors.grayButton
        self.setTitle(textButton, for: .normal)
        self.layer.cornerRadius = 9.0
    }
    
    func redButton(textButton:String){
        self.backgroundColor = GlobalConstants.Colors.fontColorButtonRed
        self.setTitle(textButton, for: .normal)
        self.layer.cornerRadius = 9.0
    }
    
    func blueButton(textButton:String){
        self.backgroundColor = GlobalConstants.Colors.buttonBlue
        self.setTitle(textButton, for: .normal)
        self.layer.cornerRadius = 9.0
    }
    
    func customButton(textButton:String, color: UIColor, type: String, sizeFont: CGFloat){
        
        self.backgroundColor = color
        self.setTitle(textButton, for: .normal)
        self.titleLabel!.font = UIFont(name: type, size: UKPDesignRuleHelper.valueEquivalenceWidthByDevice(value: sizeFont, baseDeviceWidth: Double(GlobalConstants.Device.iPhone7PlusWidth)))!
        self.layer.cornerRadius = 9.0
    }
    
    /*func grayButton(textButton:String){
        self.backgroundColor = GlobalConstants.Colors.buttonGray
        self.setTitle(textButton, for: .normal)
        self.layer.cornerRadius = 9.0
    }*/
    
    func animationDampingButton(delay:TimeInterval, isXPosition: Bool, position:CGFloat){
        
        self.isHidden = false
        
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(
                duration: 0.5,
                dampingRatio:0.6){
                    
                    if isXPosition{
                        self.frame.origin.x = position
                    }else{
                        self.frame.origin.y = position
                    }
            }
            animator.startAnimation(afterDelay: delay)
        } else {
            // Fallback on earlier versions
            UIView.animate(withDuration: 0.1, delay: delay, options: .curveEaseOut, animations: {
                if isXPosition{
                    self.frame.origin.x = position
                }else{
                    self.frame.origin.y = position
                }
            }, completion: { (_) in
                DDLogInfo("animationAvatarsDamping finished")
            })
        }
    }
    
    func highlightButton(){
        
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }
    
    func boingAppear(){
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                self.isHidden = false
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }
    
    func animateLoadingButton(animate: Bool){
        DDLogInfo("animateLoadingButton")
        var pointCount:Int = 1
        var buttonTitle = "baseLoading".localized
        
        while animate {
            pointCount = (pointCount > 3) ? 1 : pointCount + 1
            for _ in 0...pointCount {
                buttonTitle.append(".")
            }
            self.setTitle(buttonTitle, for: .normal)
        }
    }
    
    func animateLoadingButtonWithTitle(animate: Bool, title: String){
        DDLogInfo("animateLoadingButton")
        var pointCount:Int = 1
        var buttonTitle = title
        
        while animate {
            pointCount = (pointCount > 3) ? 1 : pointCount + 1
            for _ in 0...pointCount {
                buttonTitle.append(".")
            }
            self.setTitle(buttonTitle, for: .normal)
        }
    }
    
    func setDoubleLine(title:String, fontSize:CGFloat, fontType:String){
        
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.textAlignment = .center
        self.setTitle(title.uppercased(), for: .normal)
        self.titleLabel?.font = UIFont(name: fontType, size: UKPDesignRuleHelper.valueEquivalenceWidthByDevice(value: fontSize, baseDeviceWidth: Double(GlobalConstants.Device.iPhone7PlusWidth)))
        
    }
    
}

extension MIBadgeButton{
    
    func setBadgeColor(value:Int){
        
        if value > 0{
            self.badgeTextColor = UIColor.white
            self.badgeBackgroundColor = GlobalConstants.Colors.unicefBlue
        }else{
            self.badgeTextColor = UIColor.clear
            self.badgeBackgroundColor = UIColor.clear
        }
        
    }
    
    
    
}

extension UITextField{
    
    
    func setBottomBorder(borderColor: UIColor){
        
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        let width = CGFloat(1.0)
        
        let borderLine = UIView(frame: CGRect(x: 0.0, y: self.frame.height, width: width, height: width))
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
    func initTextFieldStyle(color:UIColor,radius:CGFloat){
        
        self.backgroundColor = color
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        
    }
    
    func customRoundedCorners(corners:UIRectCorner, radius: CGFloat){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii:CGSize(width:radius, height:radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
}

extension UITextView{
    
    func setTextMessageFontTextView(fontType:String,iphone5Size:CGFloat,iPhonePlusSize:CGFloat,otherSize:CGFloat,iPadSize:CGFloat){
        if(GlobalConstants.Device.isIphone5){
            self.font = UIFont(name: fontType, size: iphone5Size)
        }else if(GlobalConstants.Device.screenHeight >= CGFloat(GlobalConstants.Device.iPhone7PlusHeight)){
            self.font = UIFont(name: fontType, size: iPhonePlusSize)
        }else{
            self.font = UIFont(name: fontType, size: otherSize)
        }
        
        if UKPHelper.deviceIsIpad(){
            self.font = UIFont(name: fontType, size: iPadSize)
        }
    }
    
    func boingAppear(){
        
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                self.isHidden = false
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }
    
    func boingAppearVerticall(){
        
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 1.0, y: 0.2)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                self.isHidden = false
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }
}

extension UIFont {
    
    /*static func primaryFont(_ type:primaryFontStyle, size:CGFloat = 17 )-> UIFont {
        return UIFont(name: type.rawValue, size: size)!
    }*/
    
}

extension Foundation.Notification.Name {
    static let SHOW_MESSAGE = Foundation.Notification.Name("SHOW_MESSAGE")
    
}

extension Notification.Name {
    static let updateView = Notification.Name("updateView")
    static let loadCrateDialog = Notification.Name("loadCrateDialog")
    static let updateWaypoint = Notification.Name("updateWaypoint")
    static let updateValueSync = Notification.Name("updateValueSync")
    static let activateArrow = Notification.Name("activateArrow")
    static let enableButtons = Notification.Name("enableButtons")
    static let updateEnergyAfterSync = Notification.Name("updateEnergyAfterSync")
    static let fromBgChannelVc = Notification.Name("fromBgChannelVc")
    static let loadChannelHost = Notification.Name("loadChannelHost")
    static let loadLockedDialog = Notification.Name("loadLockedDialog")
    static let loadKeysDialog = Notification.Name("loadKeysDialog")
    static let haveTracker = Notification.Name("haveTracker")
    static let noSteps = Notification.Name("noSteps")
    static let healthKitHandler = Notification.Name("healthKitHandler")
    static let isModalPopUpShow = Notification.Name("isModalPopUpShow")
    static let stopSyncing = Notification.Name("stopSyncing")
    static let refreshProfile = Notification.Name("refreshProfile")
    static let showPopIntro = Notification.Name("showPopIntro")
    static let goToStore = Notification.Name("goToStore")
    static let launchSummary = Notification.Name("launchSummary")
    static let reOpenCrate = Notification.Name("reOpenCrate")
    static let finishChannel = Notification.Name("finishChannel")
    static let haveProblem = Notification.Name("haveProblem")
    static let goToProfileFromHost = Notification.Name("goToProfileFromHost")
    static let noConections = Notification.Name("noConections")
    static let needMoreEnergy = Notification.Name("needMoreEnergy")
    static let isFirtsRutf = Notification.Name("isFirtsRutf")
    static let isUserInFTUX = Notification.Name("isUserInFTUX")
    static let showToolTipsProfile = Notification.Name("showToolTipsProfile")
    static let showTooltipsApplyEnergyForTheFirstTime = Notification.Name("showTooltipsApplyEnergyForTheFirstTime")
    static let showTooltipsKeepGoing = Notification.Name("showTooltipsKeepGoing")
    static let showTooltipsStepsSync = Notification.Name("showTooltipsStepsSync")
    static let forceToOpenCrate = Notification.Name("forceToOpenCrate")
    static let showReward = Notification.Name("showReward")
    static let showBadge = Notification.Name("showBadge")
    static let isAllSetPopUp = Notification.Name("isAllSetPopUp")
    static let stopShakeAnimation = Notification.Name("stopShakeAnimation")
    static let resumeShakeAnimation = Notification.Name("resumeShakeAnimation")
    static let hideRightButtons = Notification.Name("hideRightButtons")
    static let showWelcomeForLegacyUsersPopup = Notification.Name("showWelcomeForLegacyUsersPopup")
    static let syncTrackers =  Notification.Name("syncTrackers")
    static let extraKeysLegacy = Notification.Name("extraKeysLegacy")
    static let updateGetPendingRequests =  Notification.Name("updateGetPendingRequests")
    static let goToStoreFromPopUp = Notification.Name("goToStoreFromPopUp")
    static let energyApplicationStarted = Notification.Name("energyApplicationStarted")
    static let newMissionLoaded = Notification.Name("newMissionLoaded")
    static let zendeksDynamic = Notification.Name("zendeksDynamic")
    static let teamDetail = Notification.Name("teamDetail")
    static let groupWinRuft = Notification.Name("groupWinRuft")
    static let addBands = Notification.Name("addBands")
    static let loadAnotherPopUp = Notification.Name("loadAnotherPopUp")
    static let loadGoodJobPopUp = Notification.Name("loadGoodJobPopUp")
    static let updateNumBandSynced = Notification.Name("updateNumBandSynced")
    static let updateFromGroupSyncing = Notification.Name("updateFromGroupSyncing")
    static let updateNewVersionFeaturesPopUp = Notification.Name("updateNewVersionFeaturesPopUp")
    static let showHealtKitNoStep = Notification.Name("showHealtKitNoStep")
    static let commingFromNoTracker = Notification.Name("commingFromNoTracker")
    static let downloadComplete = Notification.Name("downloadComplete")
    static let goSyncAfterNews = Notification.Name("goSyncAfterNews")
    static let needUpdateBand = Notification.Name("needUpdateBand")
    static let downloadedFirmwared = Notification.Name("downloadedFirmwared")
    static let sendToProfileForUpdate = Notification.Name("sendToProfileForUpdate")
    static let updateFirmwareSuccess = Notification.Name("updateFirmwareSuccess")
    static let updateFirmwareFail = Notification.Name("updateFirmwareFail")
    static let backToEditProfile = Notification.Name("backToEditProfile")
    static let sendToEditProfile = Notification.Name("sendToEditProfile")
    static let triggerBandUpdate = Notification.Name("triggerBandUpdate")
    static let sentTicketWithLog = Notification.Name("sentTicketWithLog")
    static let showFirmwareUpdate = Notification.Name("showFirmwareUpdate")
    static let goToTeamPicker = Notification.Name("goToTeamPicker")
    static let eventForSegmentInFTUE = Notification.Name("eventForSegmentInFTUE")
    static let showRatingForApp = Notification.Name("showRatingForApp")
    static let showRatingForAppInGS = Notification.Name("showRatingForAppInGS")

}

extension UITextField {
    
    func configurePlaceholder(textPlaceholder:String, fontColor:UIColor, fontSize:CGFloat){
        /*self.attributedPlaceholder = NSAttributedString(string:textPlaceholder, attributes:[NSForegroundColorAttributeName: fontColor, NSFontAttributeName: UIFont.primaryFont(.regular, size: fontSize)])*/
    }
    
    func setTextFieldStyleForValidations(bgColor:UIColor, textColor: UIColor, isEnabled:Bool){
        self.backgroundColor = bgColor
        self.textColor = textColor
        self.isEnabled = isEnabled
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
        self.resignFirstResponder()
    }
    
}
class NMTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension DateFormatter {
    
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
        //self.locale = NSLocale.current
    }
    
}

extension Date {
    
    func addDays(days:Int) -> Date{
        let newDate = NSCalendar.current.date(byAdding: .day, value: days, to: self)
        return newDate!
    }
}

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.characters.count
    }
    //Compare two version strings
    func versionToInt() -> [Int] {
        return self.components(separatedBy: ".")
            .map { Int.init($0) ?? 0 }
    }
}

extension Int{
    
    func setFormat()->String{
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.locale = Locale(identifier: "en_US")
        let formattedNumber = numberFormatter.string(from: NSNumber(value:self))
        let stringFormattedNumber = String(describing: formattedNumber!)
        
        return stringFormattedNumber
    }
    
    
}

extension UIImage {
    func trim(trimRect :CGRect) -> UIImage {
        if CGRect(origin: CGPoint.zero, size: self.size).contains(trimRect) {
            if let imageRef = self.cgImage?.cropping(to: trimRect) {
                return UIImage(cgImage: imageRef)
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(trimRect.size, true, self.scale)
        self.draw(in: CGRect(x: -trimRect.minX, y: -trimRect.minY, width: self.size.width, height: self.size.height))
        let trimmedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = trimmedImage else { return self }
        
        return image
    }
    
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    
    var circleMasked: UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let cgImage = cgImage?.cropping(to: CGRect(origin:
            CGPoint(
                x: isLandscape ? floor((size.width - size.height) / 2) : 0,
                y: isPortrait  ? floor((size.height - size.width) / 2) : 0),
                                                         size: breadthSize))
            else { return nil }
        
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
            .draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    var originalMasked: UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let cgImage = cgImage?.cropping(to: CGRect(origin:
            CGPoint(
                x: 0,
                y: 0),
                                                         size: breadthSize))
            else { return nil } 
        

        UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
            .draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func maskImage(withMask maskImage: UIImage) -> UIImage {
        
        let maskRef = maskImage.cgImage
        
        let mask = CGImage(
            maskWidth: maskRef!.width,
            height: maskRef!.height,
            bitsPerComponent: maskRef!.bitsPerComponent,
            bitsPerPixel: maskRef!.bitsPerPixel,
            bytesPerRow: maskRef!.bytesPerRow,
            provider: maskRef!.dataProvider!,
            decode: nil,
            shouldInterpolate: false)
        
        let masked = self.cgImage!.masking(mask!)
        let maskedImage = UIImage(cgImage: masked!)
        
        return maskedImage
    }
}

extension UIImageView {
    
    func setRandomDownloadImage(_ width: Int, height: Int) {
        if self.image != nil {
            self.alpha = 1
            return
        }
        self.alpha = 0
        let url = URL(string: "http://lorempixel.com/\(width)/\(height)/")!
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                //DDLogError("Error: \(String(describing: error?.localizedDescription)) Description: \(String(describing: error.debugDescription)) ")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode / 100 != 2 {
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.alpha = 1
                        }, completion: { (finished: Bool) -> Void in
                        })
                    })
                }
            }
        }
        task.resume()
    }
    
    func clipParallaxEffect(_ baseImage: UIImage?, screenSize: CGSize, displayHeight: CGFloat) {
        if let baseImage = baseImage {
            if displayHeight < 0 {
                return
            }
            let aspect: CGFloat = screenSize.width / screenSize.height
            let imageSize = baseImage.size
            let imageScale: CGFloat = imageSize.height / screenSize.height
            
            let cropWidth: CGFloat = floor(aspect < 1.0 ? imageSize.width * aspect : imageSize.width)
            let cropHeight: CGFloat = floor(displayHeight * imageScale)
            
            let left: CGFloat = (imageSize.width - cropWidth) / 2
            let top: CGFloat = (imageSize.height - cropHeight) / 2
            
            let trimRect : CGRect = CGRect(x: left, y: top, width: cropWidth, height: cropHeight)
            self.image = baseImage.trim(trimRect: trimRect)
            self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: displayHeight)
        }
    }
    
    func boingAppear(){
        
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                self.isHidden = false
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }
    
    func customBoingAppear(initialScale:CGFloat, timeAnimation:Double, completion:@escaping (Bool) -> Void){
        
        UIView.animate(withDuration: timeAnimation, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: initialScale, y: initialScale)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: timeAnimation, animations: {() -> Void in
                self.isHidden = false
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                completion(true)
            })
        })
    }
    
    func setImage(color:UIColor){
        self.image = self.image!.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    func setBorderRound(color:UIColor, borderWidth: CGFloat){
        self.layer.cornerRadius = self.frame.width/2.0
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
    }
    
    
    func rotateView(duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            self.transform = self.transform.rotated(by: CGFloat(Double.pi))
        }) { finished in
            //if isSpinning{
                self.rotateView(duration: duration)
            //}
        }
    }
}

extension UILabel{
    
    func boingAppear(){
        
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                self.isHidden = false
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }
    
    func boingAppear(text:String?){
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 2.2, y: 2.2)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                    self.isHidden = false
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: { (finish) in
                    if(finish){
                        if(text != nil){
                            self.text = text
                        }
                    }
                })
        })
    }
    
    func colorString(text: String?, coloredText: String?, font: UIFont? = UIFont(name: "Univers", size: 12.0), color: UIColor? = GlobalConstants.Colors.unicefBlue2) {
        
        let attributedString = NSMutableAttributedString(string: text!)
        let range = (text! as NSString).range(of: coloredText!)
        attributedString.setAttributes([NSForegroundColorAttributeName: color!,NSFontAttributeName:font!],
                                       range: range)
        self.attributedText = attributedString
    }
    
    func fadeOut(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
        })
    }
    
    func setFontSizeByDevice(baseSize:CGFloat){
        
        let newFontSize = UKPDesignRuleHelper.valueEquivalenceWitdh(value: baseSize)//GlobalConstants.Device.screenHeight * (baseSize/CGFloat(GlobalConstants.Device.iPhone7PlusHeight))
        self.font = self.font.withSize(newFontSize)
    }
    
    func setFontSizeByDevice(value:CGFloat, baseSize:Double){
        
        let newFontSize = UKPDesignRuleHelper.valueEquivalenceWidthByDevice(value: value, baseDeviceWidth: baseSize)
        self.font = self.font.withSize(newFontSize)
    }
    
    func setFontLabel(fontType:String,iphone5Size:CGFloat,iPhonePlusSize:CGFloat,otherSize:CGFloat,iPadSize:CGFloat){
        if(GlobalConstants.Device.isIphone5){
            self.font = UIFont(name: fontType, size: iphone5Size)
        }else if(GlobalConstants.Device.screenHeight >= CGFloat(GlobalConstants.Device.iPhone7PlusHeight)){
            self.font = UIFont(name: fontType, size: iPhonePlusSize)
        }else{
            self.font = UIFont(name: fontType, size: otherSize)
        }
        
        if UKPHelper.deviceIsIpad(){
            self.font = UIFont(name: fontType, size: iPadSize)
        }
    }
    
    func textDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
    }
    
    static func createCustomLabel() -> UILabel {
        let label = UILabel()
        label.textDropShadow()
        return label
    }
}

extension UIColor {
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.length) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
}

public extension UITableView {
    
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func scrollToTop(){
        self.beginUpdates()
        self.setContentOffset(CGPoint.zero, animated: false)
        self.endUpdates()
    }

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = GlobalConstants.Colors.placeHolderTextField
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Univers-Bold", size: UKPDesignRuleHelper.valueEquivalenceWidthByDevice(value: 20.0, baseDeviceWidth: Double(GlobalConstants.Device.iPhone7PlusWidth)))
        messageLabel.sizeToFit()

        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(messageLabel)

        messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

extension UIView {
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func animationDampingView(delay:TimeInterval, position:CGFloat, axis:Character){
        
        self.isHidden = false
        
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(
                duration: 0.9,
                dampingRatio:0.6){
                    if axis == "x" {
                        self.frame.origin.x = position
                    }else{
                        self.frame.origin.y = position
                    }
            }
            animator.startAnimation(afterDelay: delay)
        } else {
            // Fallback on earlier versions
            UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseOut, animations: {
                if axis == "x" {
                    self.frame.origin.x = position
                }else{
                    self.frame.origin.y = position
                }
            }, completion: { (_) in
                DDLogInfo("animationDampingView finished")
            })
        }
    }
    
    func getOutOfTheView(){
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: {
                self.frame.origin.x = UIScreen.main.bounds.size.width
            })
            animator.startAnimation(afterDelay: 0.3)
        } else {
            // Fallback on earlier versions
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                self.frame.origin.x = UIScreen.main.bounds.size.width
            }, completion: { (_) in
                DDLogInfo("getOutOfTheView finished")
            })
        }
    }
    func boingAppear_(){
        
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                self.isHidden = false
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }
    func animationDamping(delay:TimeInterval, isXPosition: Bool, position:CGFloat){
        
        self.isHidden = false
        
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(
                duration: 1.0,
                dampingRatio:0.4){
                    
                    if isXPosition{
                        self.frame.origin.x = position
                    }else{
                        self.frame.origin.y = position
                    }
            }
            animator.startAnimation(afterDelay: delay)
        } else {
            // Fallback on earlier versions
            UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseOut, animations: {
                if isXPosition{
                    self.frame.origin.x = position
                }else{
                    self.frame.origin.y = position
                }
            }, completion: { (_) in
                DDLogInfo("animationDamping finished")
            })
        }
    }
    
    func animationDamping(delay:TimeInterval, isXPosition: Bool, position:CGFloat, completion: Void){
        
        self.isHidden = false
        
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(
                duration: 7.0,
                dampingRatio:0.4){
                    
                    if isXPosition{
                        self.frame.origin.x = position
                    }else{
                        self.frame.origin.y = position
                    }
            }
            
            animator.addAnimations {
                self.alpha = 0
            }
            animator.addCompletion({ position in
                switch position {
                case .end: DDLogInfo("Completion handler called at end of animation")
                    self.removeFromSuperview()
                            completion
                case .current: DDLogInfo("Completion handler called mid-way through animation")
                case .start: DDLogInfo("Completion handler called  at start of animation")
                }
            })
            animator.startAnimation(afterDelay: delay)
            
        } else {
            // Fallback on earlier versions
            UIView.animate(withDuration: 7.0, delay: delay, options: .curveEaseOut, animations: {
                if isXPosition{
                    self.frame.origin.x = position
                }else{
                    self.frame.origin.y = position
                }
            }, completion: { (finished) in
                if(finished){
                    self.removeFromSuperview()
                    completion
                }
            })
            

        }
    }
    
    
    func animationAvatarsDamping(delay:TimeInterval, isXPosition: Bool, position:CGFloat){
        
        self.isHidden = false
        
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(
                duration: 1.0,
                dampingRatio:2.5
            ){
                
                if isXPosition{
                    self.frame.origin.x = position
                }else{
                    self.frame.origin.y = position
                }
            }
            animator.startAnimation(afterDelay: delay)
        } else {
            // Fallback on earlier versions
            UIView.animate(withDuration: 1.0, delay: delay, options: .curveEaseOut, animations: {
                if isXPosition{
                    self.frame.origin.x = position
                }else{
                    self.frame.origin.y = position
                }
            }, completion: { (_) in
                DDLogInfo("animationAvatarsDamping finished")
            })
        }
    }
    
    func highlightView(){
        
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }
    
    func customRoundedView(corners:UIRectCorner, radius: CGFloat){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii:CGSize(width:radius, height:radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
    
}

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        return viewController
    }
}

//MARK : Sprite Kit extensions
extension SKLabelNode {
    func setupShadow(fontNamed font: String, andText text: String, andSize size: CGFloat, withShadow shadow: UIColor) {

        self.text = text
        self.fontSize = size
        self.fontName = font
        self.zPosition = -1
        self.fontColor = shadow
        self.position = CGPoint(x: 2, y: -2)

    }
}

extension NSLayoutConstraint {
    
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
    
    func changeMultiplier(_ constraint: NSLayoutConstraint, multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: constraint.firstItem,
            attribute: constraint.firstAttribute,
            relatedBy: constraint.relation,
            toItem: constraint.secondItem,
            attribute: constraint.secondAttribute,
            multiplier: multiplier,
            constant: constraint.constant)
        
        newConstraint.priority = constraint.priority
        
        NSLayoutConstraint.deactivate([constraint])
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
}

//MARK : Badge in BarButtonItem
extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0;

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        var badgeWidth = 8
        var numberOffset = 4
        
        if number > 9 {
            badgeWidth = 12
            numberOffset = 6
        }
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(7)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = kCAAlignmentCenter
        label.fontSize = 11
        label.frame = CGRect(origin: CGPoint(x: location.x - CGFloat(numberOffset), y: offset.y), size: CGSize(width: badgeWidth, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }

}
