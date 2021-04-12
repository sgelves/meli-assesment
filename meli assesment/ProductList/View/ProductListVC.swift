//
//  ProductListVC.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/04/21.
//

import UIKit

protocol ProductListViewProtocol: AnyObject {

    var presenter: ProductListPresProtocol? { get }

    var listSate: ListViewState { get }

    func reloadView(state: ListViewState)
}

class ProductListVC: UIViewController {

    var presenter: ProductListPresProtocol?

    var listSate: ListViewState = .empty

    lazy var searchController: SearchControllerProtocol = SearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var noResultView: UIView!
    @IBOutlet weak var activityIndicator: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter = ProductListPresenter(view: self)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self

        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))

        self.tableView.register(UINib(nibName: "ProductCellView", bundle: Bundle.main),
                                forCellReuseIdentifier: ProductCellView.identifier)

        self.searchController.resultDelegate = self

        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.titleView = searchController.searchBar

        self.definesPresentationContext = true

        self.reloadView(state: .empty)
    }
}

extension ProductListVC: ProductListViewProtocol {

    func reloadView(state: ListViewState) {

        switch state {
        case .loading:
            self.view.bringSubviewToFront(activityIndicator)
        case .withData:
            self.view.bringSubviewToFront(tableView)
            self.tableView.reloadData()
        case .noMoreData:
            break
        case .noData:
            self.view.bringSubviewToFront(noResultView)
        default:
            self.view.bringSubviewToFront(emptyView)
        }
    }
}

extension ProductListVC: SearchResultDelegateProtocol {

    func souldUpdateResult(withSearchValue searchValue: String) {

        presenter?.setQuery(searchValue)
        presenter?.searchProducts()
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

        if indexPath.row < self.presenter?.products.count ?? 0
           , let model = self.presenter?.products[indexPath.row] {
            cell.titleLabel.text = model.title
            cell.priceLabel.text = "\(model.price)"
        }
        return cell
    }
}
