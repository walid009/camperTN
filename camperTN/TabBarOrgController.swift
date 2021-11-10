//
//  TabBarOrgController.swift
//  camperTN
//
//  Created by chekir walid on 7/11/2021.
//

import UIKit

class TabBarOrgController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            print("Selected item")
        }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("eee")
        viewController.viewDidLoad()
    }
}
