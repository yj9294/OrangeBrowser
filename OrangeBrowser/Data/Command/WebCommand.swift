//
//  WebCommand.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/2.
//

import Foundation

struct WebCommand: AppCommand {
    func execute(in store: AppStore) {
        store.state.home.text = ""
        
        let webView = store.state.home.webview.webView

        let goback = webView.publisher(for: \.canGoBack).sink { canGoBack in
            store.state.home.canGoBack = canGoBack
        }
        
        let goForword = webView.publisher(for: \.canGoForward).sink { canGoForword in
            store.state.home.canGoForword = canGoForword
        }
        
        let isLoading = webView.publisher(for: \.isLoading).sink { isLoading in
            debugPrint("isloading \(isLoading)")
            store.state.home.isLoading = isLoading
        }
        
        var start = Date()
        let progress = webView.publisher(for: \.estimatedProgress).sink { progress in
            debugPrint("progress \(progress)")
            if progress == 0.1 {
                start = Date()
                store.dispatch(.logEvent(.searchBegian))
            }
            if progress == 1.0 {
                let time = Date().timeIntervalSince1970 - start.timeIntervalSince1970
                store.dispatch(.logEvent(.searchSuccess, ["bro": "\(ceil(time))"]))
            }
            store.state.home.progress = progress
        }
        
        let isNavigation = webView.publisher(for: \.url).map{$0 == nil}.sink { isNavigation in
            store.state.home.isNavigation = isNavigation
        }
        
        let url = webView.publisher(for: \.url).compactMap{$0}.sink { url in
            store.state.home.text = url.absoluteString
        }
        
        store.disposeBag = [goback, goForword, isLoading, progress, isNavigation, url]
    }
}
