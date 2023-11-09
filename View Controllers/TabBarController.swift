//
//  TabBarController.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 9/22/23.
//

import UIKit

class TabBarController: UITabBarController {
    
    static var currentlySelectedTab = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TabBarController.currentlySelectedTab = 1
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if !BaseViewController.infoListViewDisplayed {
            TabBarController.currentlySelectedTab = item.tag
        }
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
