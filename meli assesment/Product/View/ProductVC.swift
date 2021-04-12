//
//  ProductVC.swift
//  meli assesment
//
//  Created by Sergio Gelves on 11/04/21.
//

import UIKit

protocol ProductViewProtocol: AnyObject {

    var presenter: ProductPresenterProtocol? { get set }

}

class ProductVC: UIViewController, ProductViewProtocol {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var presenter: ProductPresenterProtocol?

    init(with data: Product) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = ProductPresenter(view: self, data: data)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = presenter?.title
        self.priceLabel.text = presenter?.price
        self.discountLabel.text = presenter?.discount
        presenter?.getProductDescription(completion: { [weak self] description in
            self?.descriptionLabel.text = description
        })

        let url = presenter?.imageUrl
        self.imageView.kf.setImage(with: url)
    }
}
