//
//  ProductListIpadVC.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/05/21.
//

import UIKit

class ProductListIpadVC: UIViewController, ProductListViewProtocol {

    lazy var presenter: ProductListPresProtocol? = ProductListPresenter(view: self)

    var listSate: ListViewState  = .empty

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        self.collectionView.register(UINib.init(nibName: "ProductIpadCollectionViewCell", bundle:  Bundle.main),
                                     forCellWithReuseIdentifier: ProductIpadCollectionViewCell.identifier)
    }

    func reloadView(state: ListViewState) {
        self.collectionView.reloadData()
    }
}

extension ProductListIpadVC: SearchResultDelegateProtocol {

    func souldUpdateResult(withSearchValue searchValue: String) {
        presenter?.setQuery(searchValue)
        presenter?.searchProducts()
    }
}

extension ProductListIpadVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return presenter?.products.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductIpadCollectionViewCell.identifier,
                                                         for: indexPath) as? ProductIpadCollectionViewCell {

            cell.prepareForReuse(product: self.presenter?.products[indexPath.row])
            return cell
        }

        return ProductIpadCollectionViewCell()
    }
}

extension ProductListIpadVC: UICollectionViewDelegate {

}
