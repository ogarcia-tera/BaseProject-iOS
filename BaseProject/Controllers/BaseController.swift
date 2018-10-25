//
//  BaseController.swift
//  Unicef Kid Power
//
//  Created by Ailicec Tovar on 8/22/17.
//  Copyright © 2017 Teravision. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class BaseController: UIViewController {
    
    let service:ShellWebService = ShellWebService()
    var presentWindow : UIWindow?
    var user:User?
    
    //MARK:  Initialize Configuration
    let configuration = Configuration()
    var baseUrl="", filesUrl="", domainUrl="", environment=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DDLogVerbose("-----Initial Class-----")
        //MARK: Environment URL
        environment = configuration.environment.rawValue
        baseUrl = configuration.environment.baseUrl
        filesUrl = configuration.environment.filesUrl
        domainUrl = configuration.environment.domainUrl
        
        setup()
        setupLanguage()
        DDLogInfo("Base Url: \(baseUrl)")
        UKPHelper.initScreenProgress()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //recordScreenView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        user = UKPHelper.currentUser()
        registerNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.navigationBar.isHidden = !noMenuView
        unRegisterNotifications()
    }
    
    func tapOutside(){
        view.endEditing(true)
    }
    
    func recordScreenView() {
        // These strings must be <= 36 characters long in order for setScreenName:screenClass: to succeed.
        /*guard let screenName = title else {
            return
        }*/
        //let screenClass = classForCoder.description()
        
        // [START set_current_screen]
        //Analytics.setScreenName(screenName, screenClass: screenClass)
        // [END set_current_screen]
    }
    
    //MARK: Settings
    func setup(){}
    
    //MARK: Language Settings
    func setupLanguage(){}
    
    func registerNotifications(){}
    
    func unRegisterNotifications(){}
    
    func settingActivityIndicator(){
        //UIView.hr_setToastThemeColor(color: GlobalConstants.Colors.bgLoading)
        //UIView.hr_setToastFontColor(color: GlobalConstants.Colors.fontLoading)
        presentWindow = UIApplication.shared.keyWindow
    }
    
    @IBAction func backAction(_ sender: Any) {
        DDLogVerbose("back")
        backRedirection()
    }
    
    func backRedirection(){
        DDLogVerbose("Go back")
        _ = navigationController?.popViewController(animated: true)
    }
    
    func goToHome(){
        DDLogVerbose("Going home")
    }
    
    func initNavigation(title:String, hasBack:Bool, fontNavTitle: UIFont){
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        let textAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: fontNavTitle]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = title
        
        if hasBack{
            let backItem = UIBarButtonItem(customView: setIcon(position: 0.0, imageName:"btn-navigation-arrow"))
            backItem.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backRedirection)))
            self.navigationItem.leftBarButtonItem = backItem
//            let helpItem = UIBarButtonItem(image: UIImage(named: "helpIcon"), style: .plain, target: self, action: #selector(backRedirection))
//            self.navigationItem.rightBarButtonItem = helpItem
            self.navigationItem.hidesBackButton = false
        }else{
            self.navigationItem.hidesBackButton = true
        }
        
    }
    
    func setIcon(position: Double, imageName:String)->UIView{
        
        let iconView: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 38.0, height: 38.0))
        let logoImageView:UIImageView = UIImageView(frame: CGRect(x: position, y: 0.0, width: 38.0, height: 38.0))
        logoImageView.image = UIImage(named: imageName)
        iconView.addSubview(logoImageView)
        
        return iconView
    }
    
    func addRightIcon(iconImageName:String, hasBagde:Bool, badgeValue:String){
        
        var rightItem = UIBarButtonItem(customView: setIcon(position:0.0, imageName: iconImageName))
        
        if hasBagde{
            var rightBadgeButton:MIBadgeButton?
            rightBadgeButton = MIBadgeButton(frame: CGRect(x: 0.0, y: 0.0, width: 38.0, height: 38.0))
            rightBadgeButton?.badgeBackgroundColor = GlobalConstants.Colors.unicefBlue
            rightBadgeButton?.badgeString = badgeValue
            rightBadgeButton?.badgeEdgeInsets = UIEdgeInsetsMake(7, 0, 0, 32)
            
            let iconView:UIImageView = UIImageView(frame: CGRect(x: 10.0, y: 10.0, width: 18.0, height: 18.0))
            iconView.image = UIImage(named: iconImageName)
            
            rightBadgeButton?.insertSubview(setIcon(position: 0.0, imageName:"btn-navigation"), at: 0)
            rightBadgeButton?.insertSubview(iconView, at: 1)
            
            rightItem = UIBarButtonItem(customView: rightBadgeButton!)
        }
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func setRightButtonIcon(position: Double, name: String)->UIView{
        
        let backIconView: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 38.0, height: 38.0))
        let logoImageView:UIImageView = UIImageView(frame: CGRect(x: position, y: 0.0, width: 38.0, height: 38.0))
        logoImageView.image = UIImage(named: name)
        backIconView.addSubview(logoImageView)
        
        return backIconView
    }
}
