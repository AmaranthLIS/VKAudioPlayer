//
//  AppDelegate.swift
//  VkAudio
//
//  Created by mac-224 on 26.04.16.
//  Copyright © 2016 y0rrrsh. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        if url.absoluteString.hasSuffix("context-widget") {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabsVC = storyboard.instantiateViewControllerWithIdentifier("controller_tabs") as! VkTabsController
            tabsVC.selectedIndex = 0
            self.window?.rootViewController = tabsVC
            
            let selectedTabVC = tabsVC.selectedViewController as! UINavigationController
            let userAudiosVC = selectedTabVC.visibleViewController as! UserAudiosViewController
            
            let player = AudioPlayer.sharedInstance
            if !player.isPlaying() {
                VkSDK.Audios.getAudios(onResult: { (result) in
                    userAudiosVC.userAudios = result
                    userAudiosVC.performSegueWithIdentifier("audioToAudioPlayer", sender: userAudiosVC)
                })
            }
            else {
                userAudiosVC.performSegueWithIdentifier("audioToAudioPlayer", sender: userAudiosVC)
            }
        }
        
        return true
    }
}

