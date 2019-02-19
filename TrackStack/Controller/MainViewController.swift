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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var transactionData = [Transaction]()
    var api = APIWorker()
    var price: Double = 0
    
    override func viewDidLoad() {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        api.getPrice(for: "BTC")
        
        loadTransactions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    @IBAction func createTransaction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addTransaction", sender: self)
    }
    
    // MARK: Handling new transactions
    func addTransaction(_ transaction: Transaction) {
        transactionData.append(transaction)
        
        saveTransactions()
    }
    
    func saveTransactions () {
        do {
            try context.save()
        } catch {
                print("/// Error: unable to encode stack status,\(error)")
        }
    }
    
    func loadTransactions (with request: NSFetchRequest<Transaction> = Transaction.fetchRequest()) {
        do {
            transactionData = try context.fetch(request)
        } catch {
            print("/// Error: unable to load transactions, \(error)")
        }
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
    
    // MARK: Segue handling
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTransaction" {
            let destinationVC = segue.destination as! AddTransactionViewController
            destinationVC.api = api
            destinationVC.delegate = self
        }
    }
}
