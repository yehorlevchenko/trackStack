//
//  ViewController.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 1/29/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: SwipeTableViewController {
    
    var transactionData = [Transaction]()
    var api = APIWorker()
    var price: Double = 0
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        api.getPrice(for: "BTC")
        
        loadTransactions()
    }
    
    
    // MARK: Swipe Table View delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = transactionData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TransactionCell
        cell.delegate = self
        cell.setTransaction(data: transaction)
        return cell
    }
}
