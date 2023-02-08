//
//  CleanCommand.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/8.
//

import Foundation
import UIKit

struct CleanCommand: AppCommand {
    func execute(in store: AppStore) {
        let token = SubscriptionToken()
        let token1 = SubscriptionToken()
        var isShowAD = false
        var duration = 16.0
        var progress = 0.0
        Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink { _ in
            let iv =  duration / 0.01
            progress = progress + 1 / iv
            if AppEnterbackground {
                token.unseal()
                store.state.root.isPresentClean = false
                return
            }
            if progress > 1.0 {
                token.unseal()
                if AppEnterbackground || store.state.root.state == .launching {
                    store.state.root.isPresentClean = false
                    return
                }
                store.dispatch(.adShow(.interstitial) { _ in
                    cleanDismissAction(in: store)
                    store.dispatch(.bindWebView)
                })
            }
            
            if store.state.ad.isLoaded(.interstitial), isShowAD {
                isShowAD = false
                duration = 0.1
            }
        }.seal(in: token)
        
        Timer.publish(every: 2, on: .main, in: .common).autoconnect().sink { _ in
            token1.unseal()
            isShowAD = true
        }.seal(in: token1)
        
        store.dispatch(.adLoad(.interstitial))
    }
    
    func cleanDismissAction(in store: AppStore) {
        store.state.root.isPresentClean = false
        
        store.state.root.isAlret = true
        store.state.root.alerMessage = "Cleaned Successfully."
        
        store.dispatch(.logEvent(.cleanAlertShow))
    }
}

struct DismissCommand: AppCommand {
    func execute(in store: AppStore) {
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let vc = window.rootViewController, let presentedVC = vc.presentedViewController {
            if let p = presentedVC.presentedViewController {
                p.dismiss(animated: true)
            } else {
                presentedVC.dismiss(animated: true)
            }
        }
    }
}


