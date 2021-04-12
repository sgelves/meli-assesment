//
//  ProductPresenter.swift
//  meli assesment
//
//  Created by Sergio Gelves on 12/04/21.
//

import Foundation

protocol ProductPresenterProtocol {

    var view: ProductViewProtocol? { get }
    var product: Product { get }

    var service: ProductsServiceProtocol.Type { get }

    var id: String { get }
    var title: String { get }
    var price: String? { get }
    var imageUrl: URL? { get }
    var discount: String? { get }
    var segmentedPayments: String? { get }
    var freeShipping: String? { get }

    func getProductDescription(completion: @escaping(String) -> Void)
}

class ProductPresenter: ProductPresenterProtocol {

    weak var view: ProductViewProtocol?

    var product: Product

    var service: ProductsServiceProtocol.Type

    private var productDescription: String?

    init(view: ProductViewProtocol, data: Product, service: ProductsServiceProtocol.Type = ProductsServices.self) {
        self.view = view
        self.product = data
        self.service = service
    }

    var id: String {
        return product.id
    }

    var title: String {
        return product.title
    }

    var price: String? {
        return PriceFormaterUtils.formatPrice(fromFloat: product.price)
    }

    var imageUrl: URL? {
        return URL(string: product.thumbnail)
    }

    var discount: String? {
        if let price = product.prices?.prices?.first(where: { price in
            price.type != ProductPriceType.standard.rawValue
        }), let regularPrice = price.regularAmount {

            let discountPerc = PriceFormaterUtils.getDiscountFrom(originialPrice: regularPrice,
                                                                  andWithDiscount: price.amount)

            return Localized.discountPrice.toLocalized(andArg: discountPerc)
        }

        return nil
    }

    var segmentedPayments: String? {
        if let priceString = PriceFormaterUtils.getSegmentedPayment(for: product.price, intoMonths: 36) {
            return Localized.segmentedPrice.toLocalized(andArg: priceString)
        }
        return nil
    }

    var freeShipping: String? {
        if product.shipping.freeShipping {
            return  Localized.freeShipping.toLocalized()
        }
        return nil
    }

    func getProductDescription(completion: @escaping(String) -> Void) {
        guard self.productDescription?.isEmpty ?? true else {
            completion(self.productDescription!)
            return
        }

        service.getProductDescription(byId: self.product.id) { [weak self] result in
            switch result {
            case let .success(prodDesc):
                self?.productDescription = prodDesc.plainText
                completion(prodDesc.plainText)
            case .failure:
                self?.productDescription = " "
                completion(" ")
            }
        }
    }
}
