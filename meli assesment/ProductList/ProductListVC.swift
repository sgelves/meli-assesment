//
//  ProductListVC.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/04/21.
//

import UIKit

class ProductListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.register(UINib(nibName: "ProductCellView", bundle: Bundle.main),
                                forCellReuseIdentifier: "productCell")

        ProductsServices.getProductsList(byQuery: "Motorola G5", limit: 10, andOffset: 0) { [weak self] result in
            switch result {
            case let .success(list):
                self?.products = list
                self?.tableView.reloadData()
            case let .failure(error):
                LogUtils.error(error) // DO something, log should not be here
            }
        }
    }
}

extension ProductListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductCellView
            ?? ProductCellView()
        cell.titleLabel.text = model.title
        cell.priceLabel.text = "\(model.price)"
        return cell
    }

    /*

     // MARK: - Table view data source

     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 0
     }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
