//
//  ViewController.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 1/29/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    var transactionData = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionData = [Transaction.init(currency: .Bitcoin, amount: 1.0, price: 3200),Transaction.init(currency: .Bitcoin, amount: 1.0, price: 3200),Transaction.init(currency: .Bitcoin, amount: 1.0, price: 3200),Transaction.init(currency: .Bitcoin, amount: 1.0, price: 3200),Transaction.init(currency: .Bitcoin, amount: 1.0, price: 3200)]
        
//        self.tableView.register(TransactionCell.self, forCellReuseIdentifier: "custom")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        return cell
    }

}

