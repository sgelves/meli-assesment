//
//  ProductListViewProtocol.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/05/21.
//

import Foundation

protocol ProductListViewProtocol: AnyObject {

    var presenter: ProductListPresProtocol? { get }

    func reloadView(state: ListViewState)
}
