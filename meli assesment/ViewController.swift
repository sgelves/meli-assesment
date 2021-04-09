//
//  ViewController.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/04/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        ProductsServices.getProductsList(byQuery: "Motorola G5", limit: 10, andOffset: 0) { result in
            switch result {
            case let .success(list):
                LogUtils.debug(withMessage: "Querying info", andData: list)
            case let .failure(error):
                LogUtils.error(error) // DO something, log should not be here
            }
        }
    }
}

