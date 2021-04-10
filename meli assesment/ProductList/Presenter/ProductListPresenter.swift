//
//  ProductListPresenter.swift
//  meli assesment
//
//  Created by Sergio Gelves on 10/04/21.
//

protocol ProductListPresProtocol: AnyObject {

    var view: ProductListViewProtocol? { get }

    var products: [Product] { get }
    var query: String { get }
    var isLoading: Bool { get set }
    var limit: Int { get }

    func setQuery (_ query: String)

    func getProuct(byIndex index: Int) -> Product
    func searchProducts()
}

class ProductListPresenter: ProductListPresProtocol {

    weak var view: ProductListViewProtocol?

    var products: [Product] = []
    var query: String = ""
    var isLoading: Bool = false
    var limit: Int = 15

    init(view: ProductListViewProtocol) {
        self.view = view
    }

    func getProuct(byIndex index: Int) -> Product {
        return products[index]
    }

    func setQuery (_ query: String) {
        self.query = query
        self.products = []
    }

    func searchProducts() {

        guard !isLoading && !self.query.isEmpty else {
            LogUtils.debug(withMessage: "QueryProductList is still loading or query is empty")
            return
        }

        isLoading = true

        ProductsServices.getProductsList(byQuery: self.query,
                                         limit: limit,
                                         andOffset: self.products.count) { [weak self] result in

            let currenctProductsCount = self?.products.count ?? 0

            switch result {
            case let .success(list):
                if !list.isEmpty {
                    self?.products.append(contentsOf: list)
                    self?.view?.reloadView(state: .withData)
                } else if currenctProductsCount > 0 {
                    self?.view?.reloadView(state: .noData)
                } else if currenctProductsCount == 0 {
                    self?.view?.reloadView(state: .empty)
                }
            case let .failure(error):
                LogUtils.error(error) // DO something, log should not be here
                if currenctProductsCount > 0 {
                    self?.view?.reloadView(state: .noData)
                } else if currenctProductsCount == 0 {
                    self?.view?.reloadView(state: .empty)
                }
            }

            self?.isLoading = false
        }
    }
}
