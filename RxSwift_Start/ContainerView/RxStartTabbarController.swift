//
//  RxStartTabbarController.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/2/24.
//

import UIKit

final class RxStartTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signUpVC = RxStartNavigationController(
            rootViewController: PasswordViewController())
        
        let shoppingListVC = RxStartNavigationController(
            rootViewController: ShoppingListViewController())

        setViewControllers([signUpVC, shoppingListVC], animated: true)
        
        if let items = tabBar.items {
            items[0].image = UIImage(systemName: "pencil.line")
            items[0].title = "signUp"
            items[1].image = UIImage(systemName: "bag.fill")
            items[1].title = "Shopping List"
        }
    }
}

