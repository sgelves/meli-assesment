//
//  EmptyVC.swift
//  meli assesment
//
//  Created by Sergio Gelves on 12/05/21.
//

import UIKit

class EmptyView: UIView, CustomUIViewProtocol {

    @IBOutlet weak var emptyLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
}
