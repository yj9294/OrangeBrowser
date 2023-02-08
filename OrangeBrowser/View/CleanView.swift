//
//  CleanView.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/3.
//

import SwiftUI

struct CleanView: View {
    @State var degrees:Double = 0.0
    var body: some View {
        VStack(spacing: 150){
            Spacer()
            HStack{
                Spacer()
                ZStack{
                    Image("clean_animation")
                        .rotationEffect(.degrees(degrees))
                        .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false))
                        .onAppear {
                            self.degrees = 360
                        }
                    Image("clean_icon")
                }
                Spacer()
            }
            Text("Cleaning")
            Spacer()
        }
        .background(Color.white)
    }
}

struct CleanView_Previews: PreviewProvider {
    static var previews: some View {
        CleanView()
    }
}
