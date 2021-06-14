//
//  MainCoordinator.swift
//  meli assesment
//
//  Created by Sergio Gelves on 13/05/21.
//

import UIKit

protocol ProductCoordinatorProtocol {
    static func navigateProductDetai(arg: Product)
}

class MainCoordinator: MainCoordinatorProtocol, ProductCoordinatorProtocol {

    var navController = UINavigationController()

    static var coordinator: MainCoordinatorProtocol!

    static func start() -> MainCoordinatorProtocol {
        guard coordinator == nil else {
            return coordinator
        }

        coordinator = MainCoordinator()

        let viewController: UIViewController

        if isIphone() {
            viewController = ProductListVC()
        } else {
            viewController = ProductListIpadVC()
        }

        coordinator.navController.pushViewController(viewController, animated: false)

        return coordinator
    }

    static private func isIphone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    static func navigateProductDetai(arg: Product) {
        let viewController = ProductVC(with: arg)
        coordinator.navController.pushViewController(viewController, animated: true)
    }
}
