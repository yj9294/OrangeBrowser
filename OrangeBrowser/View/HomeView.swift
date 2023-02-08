//
//  HomeView.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/2.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var store: AppStore
    
    var home: AppState.HomeState {
        store.state.home
    }
    
    var root: AppState.RootState {
        store.state.root
    }
    
    let columns:[GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    TextField("", text: $store.state.home.text)
                        .foregroundColor(.white)
                        .placeholder(when: home.text.count == 0) {
                            Text("Seaech or enter address")
                                .foregroundColor(Color.white.opacity(0.6))
                        }
                    Spacer()
                    if home.isLoading {
                        Image("home_close")
                            .onTapGesture {
                                stopSearch()
                            }
                    } else {
                        Image("home_search")
                            .onTapGesture {
                                searchAction()
                            }
                    }
                }
                .padding(.all, 16)
                .background(Color("FFB62B").cornerRadius(4))
                
                if home.isLoading{
                    ProgressView("",value: home.progress)
                        .accentColor(Color("FFB62B"))
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 16)
            
            if !home.isNavigation, !root.isPresentTabView {
                WebView(webView: home.webview.webView)
            } else if home.isNavigation {
                VStack{
                    Spacer()
                    Image("home_icon")
                    Spacer()
                    
                    LazyVGrid(columns: columns, spacing: 20){
                        ForEach(AppState.HomeState.Item.allCases, id: \.self) { item in
                            VStack{
                                Image(item.icon)
                                Text(item.title)
                                    .foregroundColor(Color("333333"))
                                    .font(.system(size: 13.0))
                            }
                            .onTapGesture {
                                itemAction(item)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                    if !root.isPresentTabView && !root.isPresentClean && !root.isPresentPrivacy {
                        HStack{
                            NativeView(model: root.adModel)
                                .frame(height: 76)
                        }
                        .padding(.horizontal, 16)
                        .onAppear{
                            nativeViewWillAppear()
                        }
                    }
                }
                .padding(.vertical,20)
            }
            
            HStack{
                Image(home.canGoBack ? "home_last" : "home_last_1")
                    .onTapGesture {
                        lastAction()
                    }
                Spacer()
                Image(home.canGoForword ? "home_next" : "home_next_1")
                    .onTapGesture {
                        nextAction()
                    }
                Spacer()
                Image("home_clean")
                    .onTapGesture {
                        cleanAction()
                    }
                Spacer()

                ZStack {
                    Image("home_tab")
                        .onTapGesture {
                            tabAction()
                    }
                    Text("\(home.webviews.count)")
                        .font(.system(size: 12))
                }
                Spacer()
                Image("home_setting")
                    .onTapGesture {
                        settingAction()
                    }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .background(Color("FFFEF8"))
    }
}

extension HomeView {
    func lastAction() {
        home.webview.goBack()
    }
    
    func nextAction() {
        home.webview.goForword()
    }
    
    func cleanAction() {
        store.state.root.isAlertClean = true
        store.dispatch(.logEvent(.homeClean))
    }
    
    func tabAction() {
        store.state.root.isPresentTabView = true
        store.dispatch(.adDisappear(.native))
    }
    
    func settingAction() {
        store.state.root.isPresentSetting = true
    }
    
    func searchAction() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        if home.text == "" {
            store.state.root.isAlret = true
            store.state.root.alerMessage = "Please enter your search content."
            return
        }
        store.state.home.isLoading = true
        store.dispatch(.load(home.text))
        store.dispatch(.bindWebView)
        store.dispatch(.logEvent(.homeSearch, ["bro": home.text]))
    }
    
    func stopSearch() {
        store.state.home.text = ""
        store.state.home.isLoading = false
        home.webview.stopLoad()
    }
    
    func itemAction(_ model: AppState.HomeState.Item) {
        store.dispatch(.logEvent(.homeClick, ["bro": model.url]))
        store.state.home.isLoading = true
        store.dispatch(.load(model.url))
        store.dispatch(.bindWebView)
    }
    
    func nativeViewWillAppear() {
        store.dispatch(.adLoad(.native, .home))
        store.dispatch(.adLoad(.interstitial))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AppStore())
    }
}
