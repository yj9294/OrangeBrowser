//
//  ContentView.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/2.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AppStore
    var root: AppState.RootState {
        store.state.root
    }
    
    var home: AppState.HomeState {
        store.state.home
    }
    
    var body: some View {
        if root.state == .launching {
            LaunchView()
        } else {
            GeometryReader { _ in
                ZStack{
                    HomeView()
                        .alert(title: root.alerMessage, isPresent: $store.state.root.isAlret)
                        .alert(isPresent: $store.state.root.isAlertClean, confirm: {
                            confirmCleanAction()
                            store.state.home.webviews = [.navigation]
                            store.dispatch(.bindWebView)
                        })
                        .sheet(isPresented: $store.state.root.isPresentShare) {
                            if let url = home.webview.webView.url?.absoluteString {
                                ShareView(url: url)
                            } else {
                                ShareView(url: "https://itunes.apple.com/cn/app/id6445936667")
                            }
                        }
                        .onAppear{
                            store.dispatch(.logEvent(.homeShow))
                        }
                    if root.isPresentTabView {
                        ListView()
                            .onAppear{
                                store.dispatch(.logEvent(.tabShow))
                            }
                            .onDisappear{
                                store.dispatch(.logEvent(.homeShow))
                            }
                    }
                    if root.isPresentSetting {
                        SettingView()
                    }
                    if root.isPresentPrivacy {
                        PrivacyView(item: root.PrivacyIndex) {
                            privacyDismissAction()
                        }
                        .onDisappear{
                            store.dispatch(.logEvent(.homeShow))
                        }
                    }
                    if root.isPresentClean {
                        CleanView {
                            cleanDismissAction()
                        }
                        .onDisappear{
                            store.dispatch(.logEvent(.homeShow))
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    AppEnterbackground = false
                    store.dispatch(.launching)
                    
                    store.dispatch(.logEvent(.openHot))
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    AppEnterbackground = true
                }
            }
        }
    }
}

extension ContentView {
    func confirmCleanAction() {
        store.state.root.isAlertClean = false
        store.state.root.isPresentClean = true
    }
    
    func privacyDismissAction() {
        store.state.root.isPresentPrivacy = false
    }
    
    func cleanDismissAction() {
        store.dispatch(.logEvent(.cleanAnimationCompletion))
        store.state.root.isPresentClean = false
        
        store.state.root.isAlret = true
        store.state.root.alerMessage = "Cleaned Successfully."
        
        store.dispatch(.logEvent(.cleanAlertShow))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppStore())
    }
}
