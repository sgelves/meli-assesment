//
//  ActivityIndicatorView.swift
//  meli assesment
//
//  Created by Sergio Gelves on 12/05/21.
//

import UIKit

class ActivityIndicatorView: UIView, CustomUIViewProtocol {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
}
