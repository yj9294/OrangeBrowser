//
//  Command.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/2.
//

import Foundation
import Combine

protocol AppCommand {
    func execute(in store: AppStore)
}

class SubscriptionToken {
    var cancelable: AnyCancellable?
    func unseal() { cancelable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancelable = self
    }
}
