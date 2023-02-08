//
//  PrivacyView.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/3.
//

import SwiftUI

struct PrivacyView: View {
    
    var item: Index
    var onDisimiss: (()->Void)? = nil
    
    enum Index {
        case privacy, terms
        var title: String {
            switch self {
            case .privacy:
                return "Privacy Policy"
            case .terms:
                return "Terms of Use"
            }
        }
        var content:String {
            switch self {
            case .privacy:
                return """
The following terms and conditions (the “Terms”) govern your use of the VPN services we provide (the “Service”) and their associated website domains (the “Site”). These Terms constitute a legally binding agreement (the “Agreement”) between you and Tap VPN. (the “Tap VPN”).

Activation of your account constitutes your agreement to be bound by the Terms and a representation that you are at least eighteen (18) years of age, and that the registration information you have provided is accurate and complete.

Tap VPN may update the Terms from time to time without notice. Any changes in the Terms will be incorporated into a revised Agreement that we will post on the Site. Unless otherwise specified, such changes shall be effective when they are posted. If we make material changes to these Terms, we will aim to notify you via email or when you log in at our Site.

By using Tap VPN
You agree to comply with all applicable laws and regulations in connection with your use of this service.regulations in connection with your use of this service.
"""
            case .terms:
                return """
The following terms and conditions (the “Terms”) govern your use of the VPN services we provide (the “Service”) and their associated website domains (the “Site”). These Terms constitute a legally binding agreement (the “Agreement”) between you and Tap VPN. (the “Tap VPN”).

Activation of your account constitutes your agreement to be bound by the Terms and a representation that you are at least eighteen (18) years of age, and that the registration information you have provided is accurate and complete.

Tap VPN may update the Terms from time to time without notice. Any changes in the Terms will be incorporated into a revised Agreement that we will post on the Site. Unless otherwise specified, such changes shall be effective when they are posted. If we make material changes to these Terms, we will aim to notify you via email or when you log in at our Site.

By using Tap VPN
You agree to comply with all applicable laws and regulations in connection with your use of this service.regulations in connection with your use of this service.
"""
            }
        }
    }
    
    var body: some View {
        VStack{
            ZStack {
                HStack{
                    Image("setting_back")
                        .onTapGesture {
                            backAction()
                        }
                    Spacer()
                }
                .padding(.all, 20)
                Text(item.title)
                    .font(.system(size: 14))
            }
            Spacer()
            ScrollView{
                Text(item.content)
                    .font(.system(size: 13))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
            }
        }
        .background(Color("FFFEF8").ignoresSafeArea())
    }
}

extension PrivacyView {
    func backAction() {
        onDisimiss?()
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView(item: .privacy)
    }
}
