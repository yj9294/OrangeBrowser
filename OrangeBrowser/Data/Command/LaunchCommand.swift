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
        store.dispatch(.launchUpdateProgress(0))
        Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink { _ in
            let iv =  store.state.launch.duration / 0.01
            let progress = store.state.launch.progress + 1 / iv
            if progress < 1.0 {
                store.dispatch(.launchUpdateProgress(progress))
            }
            if progress >= 1.0 {
                token.unseal()
                store.dispatch(.launched)
            }
        }.seal(in: token)
    }
}
