//
//  MainCoordinatorProtocol.swift
//  meli assesment
//
//  Created by Sergio Gelves on 14/05/21.
//

import UIKit

protocol MainCoordinatorProtocol {

    var navController: UINavigationController { get }
    static var coordinator: MainCoordinatorProtocol! { get set }

    static func start() -> MainCoordinatorProtocol
}
