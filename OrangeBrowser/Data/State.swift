//
//  State.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/2.
//

import Foundation
import WebKit

struct AppState {
    var root = RootState()
    var launch = LaunchState()
    var home = HomeState()
}

extension AppState {
    struct RootState {
        enum State{
            case launching
            case launched
        }
        var state: State = .launching
        var isPresentTabView: Bool = false
        var isPresentSetting: Bool = false
        var isPresentShare: Bool = false
        var isPresentPrivacy: Bool = false
        var PrivacyIndex: PrivacyView.Index = .privacy
        var isAlret: Bool = false
        var alerMessage: String = ""
        var isAlertClean: Bool = false
        var isPresentClean: Bool = false
    }
}

extension AppState {
    struct LaunchState {
        var progress = 0.0
        var duration = 2.0
    }
}

extension AppState {
    struct HomeState {
        enum Item: String, CaseIterable {
            case facebook, google, youtube, twitter, instagram, amazon, gmail, yahoo
            var title: String {
                return "\(self)".capitalized
            }
            var url: String {
                return "https://www.\(self).com"
            }
            var icon: String {
                return "\(self)"
            }
        }
        
        class Browser: NSObject, ObservableObject {
            init(webView: WKWebView, isSelect: Bool) {
                self.webView = webView
                self.isSelect = isSelect
            }
            @Published var webView: WKWebView
            @Published var isSelect: Bool
            var isNavigation: Bool {
                return webView.url == nil
            }
            
            static func == (lhs: Browser, rhs: Browser) -> Bool {
                return lhs.webView == rhs.webView
            }
            
            static var navigation: Browser {
                let webView = WKWebView()
                webView.backgroundColor = .clear
                webView.isOpaque = false
                return Browser(webView: webView, isSelect: true)
            }
            
            func load(_ url: String) {
                webView.navigationDelegate = self
                if url.isUrl, let Url = URL(string: url) {
                    let request = URLRequest(url: Url)
                    webView.load(request)
                } else {
                    let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    let reqString = "https://www.google.com/search?q=" + urlString
                    self.load(reqString)
                }
            }
            
            func stopLoad() {
                webView.stopLoading()
            }
            
            func goBack() {
                webView.goBack()
            }
            
            func goForword() {
                webView.goForward()
            }
        }
        
        
        var text: String = ""
        
        var isLoading: Bool = false
        var progress: Double = 0.0
        var canGoBack: Bool = false
        var canGoForword: Bool = false
        var isNavigation: Bool = false
        
        var webviews: [Browser] = [.navigation] 
        var webview: Browser {
            webviews.filter {
                $0.isSelect
            }.first ?? .navigation
        }
    }
}

extension AppState {
    struct Firebase {
        
        enum FirebaseProperty: String {
            /// 設備
            case local = "ay_or"
            
            var first: Bool {
                switch self {
                case .local:
                    return true
                }
            }
        }
        
        enum FirebaseEvent: String {
            
            var first: Bool {
                switch self {
                case .open:
                    return true
                default:
                    return false
                }
            }
            
            /// 首次打開
            case open = "lun_or"
            /// 冷啟動
            case openCold = "er_or"
            /// 熱起動
            case openHot = "ew_or"
            
            case homeShow = "eq_or"
            
//            case navigationShow = "ws_or"
            
            /// lig（点击的网站）：facebook / google / youtube / twitter / instagram / amazon / gmail / yahoo
            case homeClick = "ws_or"
            
            // li g（用户输入的内容）：具体的内容直接打印出
            case homeSearch = "wa_or"
            
            case homeClean = "bu_or"
            
            case cleanAnimationCompletion = "xian_or"
            
            case cleanAlertShow = "dd_or"
            
            case tabShow = "dl_or"
            
            // lig（点击开启新 tab 按钮的位置）：tab（tab 管理页）/ setting（设置弹窗）
            case webNew = "acv_or"
            
            case shareClick = "xmo_or"
            
            case copyClick = "qws_or"
            
            case searchBegian = "zxc_or"
            
            // lig（开始请求～加载成功的时间）：秒，时间向上取整，不足 1 计 1
            case searchSuccess = "bnm_or"
        }

    }
}


extension AppState.HomeState.Browser:  WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.load(navigationAction.request)
        return nil
    }
}
