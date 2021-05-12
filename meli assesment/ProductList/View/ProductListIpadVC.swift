//
//  ProductListIpadVC.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/05/21.
//

import UIKit

class ProductListIpadVC: UIViewController, ProductListViewProtocol {

    lazy var presenter: ProductListPresProtocol? = ProductListPresenter(view: self)

    let cvMargins = UIEdgeInsets.zero
    let cvCellAmount: CGFloat = 3
    let cvCellSpacing: CGFloat = 10
    let cvCellHeight: CGFloat = 300

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
        switch state {
        case .loading:
            // self.view.bringSubviewToFront(activityIndicator)
            break
        case .withData:
            // self.view.bringSubviewToFront(tableView)
            self.collectionView.reloadData()
        case .noMoreData:
            // self.view.bringSubviewToFront(tableView)
            break
        case .noData:
            // self.view.bringSubviewToFront(noResultView)
            break
        default:
            // self.view.bringSubviewToFront(emptyView)
            break
        }
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

            if indexPath.row < self.presenter?.products.count ?? 0
               , let model = self.presenter?.products[indexPath.row] {

                let pres = ProductPresenter(view: cell, data: model)
                cell.presenter = pres
                cell.setUp()
                return cell
            }
        }

        return ProductIpadCollectionViewCell()
    }
}

extension ProductListIpadVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let expectedWidth = collectionView.bounds.width / self.cvCellAmount - self.cvCellSpacing*(self.cvCellAmount - 1)
        return CGSize(width: expectedWidth, height: self.cvCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.cvMargins
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.cvCellSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.cvCellSpacing
    }
}
