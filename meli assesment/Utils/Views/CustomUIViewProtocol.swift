//
//  CustomUIView.swift
//  meli assesment
//
//  Created by Sergio Gelves on 12/05/21.
//

import UIKit

protocol CustomUIViewProtocol {

    func commonInit()

    func loadViewFromNib() -> UIView?
}

extension CustomUIViewProtocol where Self: UIView {

    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Adding nibView on the top of our view
        addSubview(view)
    }

    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
