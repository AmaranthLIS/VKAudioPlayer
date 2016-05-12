//
//  VkTabsController.swift
//  VkAudio
//
//  Created by mac-224 on 04.05.16.
//  Copyright © 2016 y0rrrsh. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class VkTabsController: UITabBarController {
    
    let BG_FILE_NAME = "bg_image.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgImagePath = LocalStorage.buildFilePath(.DocumentDirectory, fileName: BG_FILE_NAME)
        
        if let background = UIImage(contentsOfFile: bgImagePath){
            setBackgroundImage(background)
            return
        }
        
        //todo: api-related stuff on UI. should be encapsulated into service level
        VkSDK.Users.getUserInfo(["fields": "photo_big"], onResult: {
            (result) in
            if let url = NSURL(string: result["photo_big"] as! String) {
                
                Alamofire.download(.GET, url,
                    destination: { (temporaryURL, response) in
                        return NSURL(string: "file://\(bgImagePath)")!
                        
                }).response(completionHandler: { (request, response, data, error) in
                    print("onResponse:")
                    let background = UIImage(contentsOfFile: bgImagePath)
                    
                    self.setBackgroundImage(background!)
                })
            }
        })
    }
    
    private func setBackgroundImage(image: UIImage) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        image.drawInRect(self.view.bounds)
        let contextImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //todo: set blur once here instead of embedded conrollers

        self.view.backgroundColor = UIColor(patternImage: contextImage)
    }
}

extension UIViewController{
    
    func setupBlurView(style: UIBlurEffectStyle = .ExtraLight, onBlurCreated: (blurView: UIVisualEffectView) -> Void){
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        onBlurCreated(blurView: blurEffectView)
    }
}