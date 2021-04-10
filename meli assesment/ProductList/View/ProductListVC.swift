//
//  ProductListVC.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/04/21.
//

import UIKit

protocol ProductListViewProtocol: AnyObject {

    var presenter: ProductListPresProtocol? { get }

    func reloadView(state: ListViewState)
}

class ProductListVC: UIViewController, ProductListViewProtocol {

    var presenter: ProductListPresProtocol?

    var listSate: ListViewState = .empty

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter = ProductListPresenter(view: self)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self

        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))

        self.tableView.register(UINib(nibName: "ProductCellView", bundle: Bundle.main),
                                forCellReuseIdentifier: ProductCellView.identifier)

        self.presenter?.setQuery("Motorola")
        self.presenter?.searchProducts()
    }

    func reloadView(state: ListViewState) {
        self.tableView.reloadData()
    }
}

extension ProductListVC: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let scrolledIndex = indexPaths.last?.row ?? 0
        let antepenultimateIndex = (self.presenter?.products.count ?? 0) - 3
        guard scrolledIndex >= antepenultimateIndex else {
            return
        }

        self.presenter?.searchProducts()
    }
}

extension ProductListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.products.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView
            .dequeueReusableCell(withIdentifier: ProductCellView.identifier, for: indexPath) as? ProductCellView
            ?? ProductCellView()

        if let model = self.presenter?.products[indexPath.row] {
            cell.titleLabel.text = model.title
            cell.priceLabel.text = "\(model.price)"
        }
        return cell
    }
}
