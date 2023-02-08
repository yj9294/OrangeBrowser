//
//  Store.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/2.
//

import Foundation
import Combine


class AppStore: ObservableObject {
    @Published var state = AppState()
    var disposeBag = [AnyCancellable]()
    init(){
        commonInit()
    }
    
    private func commonInit() {
        dispatch(.adRequestConfig)
        dispatch(.launching)
        dispatch(.bindWebView)
        
        dispatch(.logProperty(.local))
        dispatch(.logEvent(.open))
        dispatch(.logEvent(.openCold))
    }
    
    func dispatch(_ action: AppAction) {
        debugPrint("[ACTION]: \(action)")
        let result = AppStore.reduce(state: state, action: action)
        state = result.0
        if let command = result.1 {
            command.execute(in: self)
        }
    }
}

extension AppStore{
    private static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand? = nil
        switch action {
        case .launching:
            appState.root.state = .launching
            appCommand = LaunchCommand()
        case .launchUpdateProgress(let progress):
            appState.launch.progress = progress
        case .launched:
            appState.root.state = .launched
        case .bindWebView:
            appCommand = WebCommand()
        case .clean:
            appCommand = CleanCommand()
        case .dismiss:
            appCommand = DismissCommand()
        case .load(let url):
            appState.home.text = url
            appState.home.progress = 0.0
            appState.home.webview.load(url)
            
        case .logProperty(let property, let value):
            appCommand = FirebasePropertyCommand(property, value)
        case .logEvent(let event, let params):
            appCommand = FirebaseEvnetCommand(event, params)
            
            
        case .adRequestConfig:
            appCommand = GADRemoteConfigCommand()
        case .adUpdateConfig(let config):
            appState.ad.config = config
        case .adUpdateLimit(let state):
            appCommand = GADUpdateLimitCommand(state)
        case .adAppear(let position):
            appCommand = GADAppearCommand(position)
        case .adDisappear(let position):
            appCommand = GADDisappearCommand(position)
        case .adClean(let position):
            appCommand = GADCleanCommand(position)
        
        case .adLoad(let position, let p):
            appCommand = GADLoadCommand(position, p)
        case .adShow(let position, let p, let completion):
            appCommand = GADShowCommand(position, p, completion)
            
        case .adNativeImpressionDate(let p):
            appState.ad.impressionDate[p] = Date()
        case .adModel(let model):
            appState.root.adModel = model

        }
        
        return (appState, appCommand)
    }
}

