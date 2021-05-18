//
//  MainCoordinator.swift
//  57blocks assesment
//
//  Created by Sergio Gelves on 14/05/21.
//

import UIKit

protocol TabBarCoordinatorProtocol {

    var tabController: UITabBarController! { get }
    var navController: [UINavigationController] { get }

    static var coordinator: TabBarCoordinatorProtocol! { get set }
}

class MainCoordinator: MainCoordinatorProtocol {

    var navController = UINavigationController()

    static var coordinator: MainCoordinatorProtocol!

    static func start() -> MainCoordinatorProtocol {
        guard coordinator == nil else {
            return coordinator
        }

        coordinator = MainCoordinator()

        let viewController = LoginVC()

        coordinator.navController.pushViewController(viewController, animated: false)

        return coordinator
    }
}
