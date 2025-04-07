//
//  NavigationController.swift
//  FoodPin
//
//  Created by Ken on 2025/4/2.
//

import UIKit

class NavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
