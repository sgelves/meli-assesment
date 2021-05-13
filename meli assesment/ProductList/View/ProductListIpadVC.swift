//
//  ProductListIpadVC.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/05/21.
//

import UIKit

class ProductListIpadVC: UIViewController, ProductListViewProtocol {

    lazy var presenter: ProductListPresProtocol? = ProductListPresenter(view: self)

    lazy var searchController: SearchControllerProtocol = SearchController(searchResultsController: nil)

    let cvMargins = UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
    let cvCellAmount: CGFloat = 3
    let cvCellSpacing: CGFloat = 10
    let cvCellHeight: CGFloat = 250

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var noResultView: UIView!
    @IBOutlet weak var activityIndicator: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.prefetchDataSource = self

        self.collectionView.register(UINib.init(nibName: "ProductIpadCollectionViewCell", bundle:  Bundle.main),
                                     forCellWithReuseIdentifier: ProductIpadCollectionViewCell.identifier)

        self.searchController.resultDelegate = self

        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.titleView = searchController.searchBar

        self.definesPresentationContext = true

        self.reloadView(state: .empty)
    }

    func reloadView(state: ListViewState) {
        switch state {
        case .loading:
            self.view.bringSubviewToFront(activityIndicator)
        case .withData:
            self.view.bringSubviewToFront(collectionView)
            self.collectionView.reloadData()
        case .noMoreData:
            self.view.bringSubviewToFront(collectionView)
        case .noData:
            self.view.bringSubviewToFront(noResultView)
        default:
            self.view.bringSubviewToFront(emptyView)
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

extension ProductListIpadVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.row < self.presenter?.products.count ?? 0
           , let model = presenter?.products[indexPath.row] {

            MainCoordinator.navigateProductDetai(arg: model)
        }
    }
}

extension ProductListIpadVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let expectedWidth = collectionView.frame.width / self.cvCellAmount - self.cvCellSpacing*(self.cvCellAmount - 1)

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

extension ProductListIpadVC: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let scrolledIndex = indexPaths.last?.row ?? 0
        let antepenultimateIndex = (self.presenter?.products.count ?? 0) - 3
        guard scrolledIndex >= antepenultimateIndex else {
            return
        }

        self.presenter?.searchProducts()
    }
}
