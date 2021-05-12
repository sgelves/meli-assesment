//
//  ProductCellView.swift
//  meli assesment
//
//  Created by Sergio Gelves on 9/04/21.
//

import UIKit

class ProductCellView: UITableViewCell, ProductViewProtocol {

    var presenter: ProductPresenterProtocol?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var segmentedLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!

    static let identifier = "productCell"

    func setUp() {
        self.titleLabel.text = presenter?.title
        self.priceLabel.text = presenter?.price
        self.discountLabel.text = presenter?.discount
        self.thumbnailView.kf.setImage(with: presenter?.imageUrl)
        self.segmentedLabel.text = presenter?.segmentedPayments
        self.shippingLabel.text = presenter?.freeShipping

        setAccesibilityIds()
    }

    private func setAccesibilityIds () {
        self.accessibilityIdentifier = AccesibilityIds.ProductCell.cell
        self.titleLabel.accessibilityIdentifier = AccesibilityIds.ProductCell.title
        self.priceLabel.accessibilityIdentifier = AccesibilityIds.ProductCell.price
        self.discountLabel.accessibilityIdentifier = AccesibilityIds.ProductCell.discount
        self.shippingLabel.accessibilityIdentifier = AccesibilityIds.ProductCell.shipping
        self.thumbnailView.accessibilityIdentifier = AccesibilityIds.ProductCell.image

        self.thumbnailView.accessibilityLabel = AccesibilityIds.ProductCell.image
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
