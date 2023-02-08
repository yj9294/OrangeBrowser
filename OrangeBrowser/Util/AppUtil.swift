//
//  AppUtil.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/2.
//

import Foundation
import SwiftUI

var AppEnterbackground = false

extension String {
    var isUrl: Bool {
        let url = "[a-zA-z]+://.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", url)
        return predicate.evaluate(with: self)
    }
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension View {
    @MainActor
    func alert(title: String, isPresent: Binding<Bool>) -> some View {
        ZStack{
            self
            if isPresent.wrappedValue {
                Color.gray.opacity(0.4).ignoresSafeArea()
                Text(title).padding(.all, 16)
                    .background(Color.white.cornerRadius(8))
                    .foregroundColor(.black)
                    .onAppear{
                        Task{
                            if !Task.isCancelled {
                                try await Task.sleep(nanoseconds: 2_000_000_000)
                                isPresent.wrappedValue.toggle()
                            }
                        }
                    }
            }
        }
    }
    
    @MainActor
    func alert(isPresent: Binding<Bool>, confirm: (()->Void)? = nil) -> some View {
        ZStack{
            self
            if isPresent.wrappedValue {
                Color.gray.opacity(0.4).ignoresSafeArea()
                    .onTapGesture {
                        isPresent.wrappedValue.toggle()
                    }
                VStack(spacing: 16){
                    HStack {
                        Spacer()
                        Image("clean_alert")
                        Spacer()
                    }
                    .padding(.top, 16)
                    
                    Text("Close Tabs and Clear Data")
                        .font(.system(size: 15))
                    
                    Button(action: {
                        confirm?()
                    }, label:  {
                        Text("Confirm")
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 70)
                            .background(Color("FFB62B").cornerRadius(22))
                    })
                    .padding(.top, 4)
                    .padding(.bottom, 20)
                }
                .background(Color.white.cornerRadius(12))
                .padding(.horizontal, 34)
            }
        }
    }
}
