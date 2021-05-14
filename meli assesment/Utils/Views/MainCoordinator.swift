//
//  MainCoordinator.swift
//  meli assesment
//
//  Created by Sergio Gelves on 13/05/21.
//

import UIKit

protocol MainCoordinatorProtocol {

    var navController: UINavigationController { get }
    static var coordinator: MainCoordinatorProtocol! { get set }

    static func start() -> MainCoordinatorProtocol
    static func navigateProductDetai(arg: Product)
}

class MainCoordinator: MainCoordinatorProtocol {

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
