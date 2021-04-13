//
//  NavigationController.swift
//  meli assesment
//
//  Created by Sergio Gelves on 11/04/21.
//

import UIKit

protocol SearchResultDelegateProtocol: AnyObject {
    func souldUpdateResult(withSearchValue searchValue: String)
}

protocol SearchControllerProtocol: UISearchBarDelegate {

    var searchBar: UISearchBar { get }
    var resultDelegate: SearchResultDelegateProtocol? { get set }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
}

class SearchController: UISearchController, SearchControllerProtocol {

    weak var resultDelegate: SearchResultDelegateProtocol?
    var searchValue = ""
    var hasDoneQuery = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hidesNavigationBarDuringPresentation = false
        self.searchBar.delegate = self
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hasDoneQuery = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hasDoneQuery = true
        searchValue = searchBar.text ?? ""
        searchBar.text = searchValue
        dismiss(animated: true, completion: nil)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty && !searchValue.isEmpty {
            hasDoneQuery = true
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // flag to identifty search operation
        guard hasDoneQuery else {
            searchBar.text = searchValue
            return
        }

        if searchBar.text?.isEmpty ?? false {
            // Empty the search bar
            searchValue = ""
            self.resultDelegate?.souldUpdateResult(withSearchValue: "")

        } else if searchValue == searchBar.text {
            // keep the search bar value
            searchBar.text = searchValue
            self.resultDelegate?.souldUpdateResult(withSearchValue: searchValue)
        }

        hasDoneQuery = false
    }
}
