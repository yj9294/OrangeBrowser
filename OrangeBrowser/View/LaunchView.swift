//
//  LaunchView.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/2.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var store: AppStore
    
    var launch: AppState.LaunchState {
        store.state.launch
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 16){
                HStack{
                    Spacer()
                    Image("launch_icon")
                    Spacer()
                }
                Image("launch_title")
            }
            .padding(.top, 140)
            Spacer()
            VStack{
                ProgressView("", value: launch.progress)
                    .accentColor(Color("FAB231"))
            }
            .padding(.horizontal, 90)
            .padding(.bottom, 80)
        }
        .background(Color("FAF3E1").ignoresSafeArea())
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView().environmentObject(AppStore())
    }
}
