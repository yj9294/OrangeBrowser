//
//  RootView.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/8.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var store: AppStore
    var body: some View {
        ContentView()
            .environmentObject(store)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                AppEnterbackground = false
                store.dispatch(.dismiss)
                store.dispatch(.launching)
                
                store.dispatch(.logEvent(.openHot))
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                AppEnterbackground = true
            }
            .onReceive(NotificationCenter.default.publisher(for: .nativeAdLoadCompletion), perform: { ad in
                if let ad = ad.object as? NativeViewModel {
                    store.dispatch(.adModel(ad))
                }
            })
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(AppStore())
    }
}
