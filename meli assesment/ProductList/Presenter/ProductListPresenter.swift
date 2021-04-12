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
    var isLoading: Bool { get }
    var limit: Int { get }
    var service: ProductsServiceProtocol.Type { get }

    func setQuery (_ query: String)

    func searchProducts()
}

class ProductListPresenter: ProductListPresProtocol {

    var service: ProductsServiceProtocol.Type

    weak var view: ProductListViewProtocol?

    var limit: Int
    var query: String
    var products: [Product]
    var isLoading: Bool = false

    init(view: ProductListViewProtocol,
         limit: Int = 15,
         query: String = "",
         products: [Product] = [],
         service: ProductsServiceProtocol.Type = ProductsServices.self) {
        self.view = view
        self.limit = limit
        self.query = query
        self.products = products
        self.service = service
    }

    func setQuery (_ query: String) {
        self.query = query
        self.products = []
    }

    func searchProducts() {

        guard !isLoading else {
            LogUtils.debug(withMessage: "QueryProductList is still loading")
            return
        }

        guard !self.query.isEmpty else {
            view?.reloadView(state: .empty)
            return
        }

        isLoading = true

        view?.reloadView(state: .loading)

        service.getProductsList(byQuery: self.query,
                                         limit: limit,
                                         andOffset: self.products.count) { [weak self] result in
            // guard for this process still needed
            guard self != nil && self!.isLoading else {
                return
            }

            let currenctProductsCount = self?.products.count ?? 0

            switch result {
            case let .success(list):

                if !list.isEmpty {
                    self?.products.append(contentsOf: list)
                    self?.view?.reloadView(state: .withData)
                } else if currenctProductsCount == 0 {
                    self?.view?.reloadView(state: .noData)
                } else {
                    self?.view?.reloadView(state: .noMoreData)
                }

            case let .failure(error):

                LogUtils.error(error) // DO something, log should not be here
                if currenctProductsCount > 0 {
                    self?.view?.reloadView(state: .noMoreData)
                } else {
                    self?.view?.reloadView(state: .noData)
                }

            }

            self?.isLoading = false
        }
    }
}
