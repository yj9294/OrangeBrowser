//
//  SettingView.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/2.
//

import SwiftUI
import MobileCoreServices

struct SettingView: View {
    @Environment(\.openURL) private var openURL
    @EnvironmentObject var store: AppStore
    var body: some View {
        VStack{
            Spacer()
            VStack(spacing: 16){
                VStack{
                    HStack{
                        VStack{
                            Image("setting_add")
                            Text("New")
                                .font(.system(size: 14))
                        }
                        .onTapGesture {
                            newAction()
                        }
                        Spacer()
                        VStack{
                            Image("setting_share")
                            Text("Share")
                                .font(.system(size: 14))
                        }
                        .onTapGesture {
                            shareAction()
                        }
                        Spacer()
                        VStack{
                            Image("setting_copy")
                            Text("Copy")
                                .font(.system(size: 14))
                        }
                        .onTapGesture {
                            copyAction()
                        }
                    }
                }
                .padding(.horizontal, 12)
                
                HStack{
                    Text("Rate us")
                        .font(.system(size: 14))
                        .padding(.all, 12)
                    Spacer()
                }
                .background(Color("FFFEF8").cornerRadius(4))
                .onTapGesture {
                    rateAction()
                }
                HStack{
                    Text("Terms of Users")
                        .font(.system(size: 14))
                        .padding(.all, 12)
                    Spacer()
                }
                .background(Color("FFFEF8").cornerRadius(4))
                .onTapGesture {
                    privacyAction()
                }
                HStack{
                    Text("Privacy Policy")
                        .font(.system(size: 14))
                        .padding(.all, 12)
                    Spacer()
                }
                .background(Color("FFFEF8").cornerRadius(4))
                .onTapGesture {
                    privacyAction()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 28)
            .background(Color.white.cornerRadius(16))
        }
        .background(Color.black.opacity(0.6).ignoresSafeArea().onTapGesture {
            backAction()
        })
    }
}

extension SettingView {
    
    func backAction() {
        store.state.root.isPresentSetting = false
    }
    
    func newAction() {
        store.state.home.webviews.forEach {
            $0.isSelect = false
        }
        store.state.home.webviews.insert(.navigation, at: 0)
        store.dispatch(.bindWebView)
        backAction()
        store.dispatch(.logEvent(.webNew, ["bro": "setting"]))
    }
    
    func shareAction() {
        backAction()
        store.state.root.isPresentShare = true
        store.dispatch(.logEvent(.shareClick))
    }
    
    func copyAction() {
        backAction()
        if store.state.home.webview.isNavigation {
            UIPasteboard.general.setValue("", forPasteboardType: kUTTypePlainText as String)
        } else {
            UIPasteboard.general.setValue(store.state.home.text, forPasteboardType: kUTTypePlainText as String)
        }
        store.state.root.alerMessage = "Copy Successfully"
        store.state.root.isAlret = true
        store.dispatch(.logEvent(.copyClick))
    }
    
    func rateAction() {
        backAction()
        if let url = URL(string: "https://itunes.apple.com/cn/app/id") {
            openURL(url)
        }
    }
    
    func termsAction() {
        backAction()
        store.state.root.isPresentPrivacy = true
        store.state.root.PrivacyIndex = .terms
    }
    
    func privacyAction() {
        backAction()
        store.state.root.isPresentPrivacy = true
        store.state.root.PrivacyIndex = .privacy
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
