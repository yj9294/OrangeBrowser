//
//  Action.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/2.
//

import Foundation

enum AppAction {

    case launching
    case launchUpdateProgress(Double)
    case launched
    
    case bindWebView
    case load(String)
    
    // MARK: firebase
    case logEvent(AppState.Firebase.FirebaseEvent,[String:String]? = nil)
    case logProperty(AppState.Firebase.FirebaseProperty, String? = nil)
    
    // MARK: GADMob
    case adRequestConfig
    case adUpdateConfig(GADConfig)
    case adUpdateLimit(GADLimit.Status)
    
    case adAppear(GADPosition)
    case adDisappear(GADPosition)
    
    case adClean(GADPosition)
    
    case adLoad(GADPosition, GADPosition.Position = .home)
    case adShow(GADPosition, GADPosition.Position = .home, ((NativeViewModel)->Void)? = nil)
    
    case adNativeImpressionDate(GADPosition.Position = .home)
    
    case adModel(NativeViewModel)
    
    case clean
    case dismiss
}
