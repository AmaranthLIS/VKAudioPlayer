//
//  UserDefaults.swift
//  VkAudio
//
//  Created by mac-224 on 22.06.16.
//  Copyright © 2016 y0rrrsh. All rights reserved.
//

import Foundation

class VKAPUserDefaults {
    
    private static let DEFAULTS_NAME_VKAP = "prefs_vkap_"
    
    private static let KEY_SHUFFLE_ENABLED = "shuffle_enabled"
    private static let KEY_REPEAT_ENABLED = "repeat_enabled"
    private static let KEY_LAST_UPDATE = "last_update_"
    
    static func isShuffleEnabled() -> Bool {
        return getUserDefaults().boolForKey(KEY_SHUFFLE_ENABLED)
    }
    
    static func setShuffleEnabled(enabled: Bool) {
        getUserDefaults().setBool(enabled, forKey: KEY_SHUFFLE_ENABLED)
    }
    
    static func isRepeatEnabled() -> Bool {
        return getUserDefaults().boolForKey(KEY_REPEAT_ENABLED)
    }
    
    static func setRepeatEnabled(enabled: Bool) {
        getUserDefaults().setBool(enabled, forKey: KEY_REPEAT_ENABLED)
    }

    static func getLastDataUpdate(dataTag: String) -> Double {
        return getUserDefaults().doubleForKey(KEY_LAST_UPDATE + dataTag)
    }
    
    static func setLastDataUpdate(time: Double, dataTag: String) {
        getUserDefaults().setDouble(time, forKey: KEY_LAST_UPDATE + dataTag)
    }
    
    private static func getUserDefaults() -> NSUserDefaults {
        let name = DEFAULTS_NAME_VKAP + VkApi.sharedInstance!.userId
        return NSUserDefaults(suiteName: name)!
    }
}