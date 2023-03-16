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
What information will we collect
Beta Browser collects the following information about you.
Orange Browser collects the following information about you.
Contact information: We collect information you provide when you contact us when you send us feedback
Browsing Data: When you visit our website, we collect information about your visit, including but not limited to the IP address at the time of visit, the time spent on the page.
Usage Data: When you download and use our software, we collect usage data about you, including but not limited to crash logs, diagnostic data and other diagnostic data.
Device ID.
You can choose whether or not to allow tracking.
How will we use this information
For obligations under the law.
For understanding how our applications are used.
For product and service improvements
For advertising and marketing purposes.
Disclosure of information about
We have third party partners and service providers who will collect your information as set forth in their privacy policies. If you need to, please visit the privacy policies of these third parties yourself
Third Party Partners
Google Play Services, AdMob, Google Analytics for Firebase, Firebase Crashlytics, Facebook.
Children's Privacy
Our services are not directed to persons under the age of 18. We do not knowingly collect personally identifiable information from people under the age of 18. If you are a parent or guardian and you are aware that your child has provided personal data to us, please contact us. If we become aware that we have collected personal data from a child without verifying parental consent, we will take steps to remove that information from our servers.
Update
We may update our privacy policy, and you can learn about the updates on this page
Contact us
If you have any questions about this Privacy Policy, please contact us  ::Zy9764523@outlook.com
"""
            case .terms:
                return """
Use of the application
Do not use this application for illegal purposes
Do not use the application for unauthorized commercial purposes
We may discontinue the application without prior notice to you
Update
We may update our Terms of Use from time to time.
Contact us
If you have any questions about these Terms of Use, please contact us :Zy9764523@outlook.com
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
