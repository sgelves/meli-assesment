//
//  String+Localized.swift
//  meli assesment
//
//  Created by Sergio Gelves on 12/04/21.
//
import Foundation

extension String {
    func toLocalized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }

    func toLocalized(withComment comment: String? = nil, andArg arg: CVarArg) -> String {
        return String(format: toLocalized(withComment: comment), arg)
    }
}
