//
//  ProductListViewMock.swift
//  meli assesmentTests
//
//  Created by Sergio Gelves on 10/04/21.
//

@testable import meli_assesment

class ProductListViewMock: ProductListViewProtocol {


    var currentState: ListViewState?
    var reloadViewCalled: Bool = false
    var listSate: ListViewState = .withData

    var presenter: ProductListPresProtocol?

    func reloadView(state: ListViewState) {

        currentState = state
        reloadViewCalled = true
    }
}
