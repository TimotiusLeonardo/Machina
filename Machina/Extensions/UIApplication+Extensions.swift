//
//  UIApplication+Extensions.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 25/12/22.
//

import UIKit

extension UIApplication {
    static var statusBarHeight: CGFloat {
        let window = shared.windows.filter { $0.isKeyWindow }.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
}
