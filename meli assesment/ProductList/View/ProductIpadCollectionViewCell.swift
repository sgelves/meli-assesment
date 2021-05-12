//
//  ProductIpadCollectionViewCell.swift
//  meli assesment
//
//  Created by Sergio Gelves on 12/05/21.
//

import UIKit

class ProductIpadCollectionViewCell: UICollectionViewCell {

    static let identifier = "productIpadCollectionViewCell"

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func prepareForReuse(product: Product?) {
        self.titleLabel.text = product?.title
    }
}
