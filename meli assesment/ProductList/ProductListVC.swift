//
//  ProductListVC.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/04/21.
//

import UIKit

class ProductListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.register(UINib(nibName: "ProductCellView", bundle: Bundle.main),
                                forCellReuseIdentifier: "productCell")

        ProductsServices.getProductsList(byQuery: "Motorola G5", limit: 10, andOffset: 0) { [weak self] result in
            switch result {
            case let .success(list):
                self?.products = list
                self?.tableView.reloadData()
            case let .failure(error):
                LogUtils.error(error) // DO something, log should not be here
            }
        }
    }
}

extension ProductListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductCellView
            ?? ProductCellView()
        cell.titleLabel.text = model.title
        cell.priceLabel.text = "\(model.price)"
        return cell
    }

}
