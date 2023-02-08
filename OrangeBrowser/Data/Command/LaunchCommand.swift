//
//  LaunchCommand.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/2.
//

import Foundation

struct LaunchCommand: AppCommand {
    func execute(in store: AppStore) {
        let token = SubscriptionToken()
        store.dispatch(.launchUpdateProgress(0.0))
        var isShowAD = false
        store.state.launch.duration = 2.5 / 0.6
        Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink { _ in
            let iv =  store.state.launch.duration / 0.01
            let progress = store.state.launch.progress + 1 / iv
            store.dispatch(.launchUpdateProgress(progress))
            if progress > 1.0 {
                token.unseal()
                store.dispatch(.adShow(.interstitial) { _ in
                    if store.state.launch.progress >= 1.0 {
                        store.dispatch(.launched)
                        store.dispatch(.adLoad(.interstitial))
                    }
                })
            }
            
            if store.state.ad.isLoaded(.interstitial), isShowAD {
                isShowAD = false
                store.state.launch.duration = 0.1
            }
        }.seal(in: token)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            isShowAD = true
            store.state.launch.duration = 16
        }
        
        store.dispatch(.adLoad(.interstitial))
        store.dispatch(.adLoad(.native))
    }
}
