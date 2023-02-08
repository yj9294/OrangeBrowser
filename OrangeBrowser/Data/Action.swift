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
}
