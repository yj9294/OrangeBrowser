//
//  ListView.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/2.
//

import SwiftUI
import WebKit

struct ListView: View {
    @EnvironmentObject var store: AppStore
    
    var home: AppState.HomeState {
        store.state.home
    }
    
    var root: AppState.RootState {
        store.state.root
    }
    
    let colums:[GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        GeometryReader { proxy in
            VStack{
                
                HStack{
                    NativeView(model: root.adModel)
                        .frame(height: 76)
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
                
                ScrollView{
                    LazyVGrid(columns: colums) {
                        ForEach(home.webviews, id: \.self) { webview in
                            VStack{
                                HStack{
                                    Spacer()
                                    Image("tab_close")
                                        .padding(.trailing, 10)
                                        .padding(.top, 5)
                                        .opacity(home.webviews.count == 1 ? 0 : 1)
                                        .onTapGesture {
                                            delteAction(webview)
                                        }
                                }
                                Image("home_icon")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                if webview.isNavigation {
                                    Text("Navigation")
                                        .font(.system(size: 14))
                                } else {
                                    let url = webview.webView.url?.absoluteString ?? ""
                                    Text(url)
                                        .frame(width: 150, height: 20)
                                        .font(.system(size: 14))
                                }
                                
                                HStack {
                                    Spacer()
                                }
                            }
                            .padding(.bottom,20)
                            .background(
                                Color(webview.isSelect ? "FFB62B" : "FAF3E1").cornerRadius(8)
                            )
                            .onTapGesture {
                                selectAction(webview)
                            }
                        }
                    }
                    .padding(.all, 16)
                }
                .frame(height: proxy.size.height - proxy.safeAreaInsets.top - proxy.safeAreaInsets.bottom - 60)

                VStack{
                    ZStack {
                        HStack{
                            Spacer()
                            Text("Back")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .onTapGesture {
                                    backAction()
                                }
                        }
                        .padding(.horizontal, 24)
                        Image("tab_add")
                            .onTapGesture {
                                addAction()
                            }
                    }
                }
                .frame(height: 56)
            }
            .frame(height: proxy.size.height)
            .background(Color.white)
        }
    }
}

extension ListView {
    func delteAction(_ model: AppState.HomeState.Browser) {
        if model.isSelect {
            store.state.home.webviews = store.state.home.webviews.filter({
                !$0.isSelect
            })
            store.state.home.webviews.first?.isSelect = true
        } else {
            store.state.home.webviews = store.state.home.webviews.filter({
                $0.webView != model.webView
            })
        }
    }
    
    func selectAction(_ model: AppState.HomeState.Browser) {
        store.state.home.webviews.forEach {
            $0.isSelect = false
        }
        model.isSelect = true
        
        backAction()
    }
    
    func backAction() {
        store.dispatch(.adDisappear(.native))
        store.dispatch(.bindWebView)
        store.state.root.isPresentTabView = false

    }
    
    func addAction() {
        store.state.home.webviews.forEach {
            $0.isSelect = false
        }
        store.state.home.webviews.insert(.navigation, at: 0)
        backAction()
        store.dispatch(.logEvent(.webNew, ["bro": "tab"]))
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView().environmentObject(AppStore())
    }
}
