//
//  ShareView.swift
//  OrangeBrowser
//
//  Created by yangjian on 2023/2/2.
//

import Foundation
import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    
    let url: String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
