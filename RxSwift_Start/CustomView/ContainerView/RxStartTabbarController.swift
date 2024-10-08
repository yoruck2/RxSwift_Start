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
            rootViewController: SignInViewController())
        
        let shoppingListVC = RxStartNavigationController(
            rootViewController: ShoppingListViewController())  
        let boxOfficeVC = RxStartNavigationController(
            rootViewController: BoxOfficeViewContoller())
        let jokeVC = RxStartNavigationController(
            rootViewController: JokeViewController())

        setViewControllers([signUpVC, shoppingListVC, boxOfficeVC, jokeVC], animated: true)
        
        if let items = tabBar.items {
            items[0].image = UIImage(systemName: "pencil.line")
            items[0].title = "LogIn"
            items[1].image = UIImage(systemName: "bag.fill")
            items[1].title = "Shopping List"
            items[2].image = UIImage(systemName: "movieclapper")
            items[2].title = "Box Office"
            items[3].image = UIImage(systemName: "theatermasks")
            items[3].title = "Joke"
        }
    }
}

extension RxStartTabBarController {
    func replaceViewController(at index: Int, with newViewController: UIViewController) {
            guard index >= 0 && index < (viewControllers?.count ?? 0) else {
                return
            }
            
            var updatedViewControllers = viewControllers ?? []
            let newNavigationController = RxStartNavigationController(rootViewController: newViewController)
            updatedViewControllers[index] = newNavigationController
            
            setViewControllers(updatedViewControllers, animated: false)
        }
}
