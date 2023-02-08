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

@propertyWrapper
struct UserDefault<T: Codable> {
    var value: T?
    let key: String
    init(key: String) {
        self.key = key
        self.value = UserDefaults.standard.getObject(T.self, forKey: key)
    }
    
    var wrappedValue: T? {
        set  {
            value = newValue
            UserDefaults.standard.setObject(value, forKey: key)
            UserDefaults.standard.synchronize()
        }
        
        get { value }
    }
}


extension UserDefaults {
    func setObject<T: Codable>(_ object: T?, forKey key: String) {
        let encoder = JSONEncoder()
        guard let object = object else {
            debugPrint("[US] object is nil.")
            self.removeObject(forKey: key)
            return
        }
        guard let encoded = try? encoder.encode(object) else {
            debugPrint("[US] encoding error.")
            return
        }
        self.setValue(encoded, forKey: key)
    }
    
    func getObject<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = self.data(forKey: key) else {
            debugPrint("[US] data is nil for \(key).")
            return nil
        }
        guard let object = try? JSONDecoder().decode(type, from: data) else {
            debugPrint("[US] decoding error.")
            return nil
        }
        return object
    }
}
