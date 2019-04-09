//
//  MainVC.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 4/1/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import SwipeCellKit

class MainVC: UIViewController, Storyboarded {
    
    @IBOutlet weak var BTCpriceLabel: UILabel!
    @IBOutlet weak var LTCpriceLabel: UILabel!
    @IBOutlet weak var TransactionTable: UITableView!
    
    weak var coordinator: MainCoordinator?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let baseUrl: String = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    let apiWorker = APIWorker()
    
    var transactionList = [Transaction]()
    var priceData = [String:Double]() {
        didSet {
            print("/// Price data updated: \(priceData)")
            updateHUD()
        }
    }
    
    override func viewDidLoad() {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        TransactionTable.delegate = self
        TransactionTable.dataSource = self

        if apiWorker.state == .idle {
            if apiWorker.checkConnection() {
                apiWorker.update(for: ["BTC", "LTC"])
            }
        }

        // Setup gradient background
        let gradient = MainGradient()
        let backgroundLayer = gradient.gl
        backgroundLayer!.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        let backgroundImage = gradient.image(fromLayer: backgroundLayer!)
        self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .top, barMetrics: .default)
        
        
        loadTransactions()
    }
    
    // MARK: Handling API data
    func checkConnection() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }

    func getPrice(for currencyList: [String]) {
        for currency in currencyList {
            let requestUrl: String = baseUrl + currency + "USD"

            Alamofire.request(requestUrl, method: .get).validate().responseJSON { response in
                if response.result.isSuccess {
                    if let data = response.result.value {
                        let rawData = JSON(data)
                        self.unpackData(for: currency, from: rawData)
                    }
                }
            }
        }
    }

    func unpackData(for currency: String, from data: JSON) {
        priceData[currency] = data["bid"].doubleValue

        updateHUD()
        
        TransactionTable.reloadData()
    }
    
    func updateHUD() {
        if let BTCprice = priceData["BTC"] {
            BTCpriceLabel.text = "BTC: \(BTCprice)"
        } else {
            BTCpriceLabel.text = "BTC: no data"
        }

        if let LTCprice = priceData["LTC"] {
            LTCpriceLabel.text = "LTC: \(LTCprice)"
        } else {
            LTCpriceLabel.text = "LTC: no data"
        }
    }

    // MARK: Handling transaction data
    func addTransaction(_ transaction: Transaction) {
        transactionList.append(transaction)

        saveTransactions()
    }

    func saveTransactions() {
        do {
            try context.save()
        } catch {
            print("/// Error: unable to save transactions,\(error)")
        }
    }

    func loadTransactions (with request: NSFetchRequest<Transaction> = Transaction.fetchRequest()) {
        do {
            transactionList = try context.fetch(request)
        } catch {
            print("/// Error: unable to load transactions, \(error)")
        }
    }
    
    func deleteTransaction(at indexPath: IndexPath) {
        let transactionForDeletion = transactionList[indexPath.row]
        transactionList.remove(at: indexPath.row)
        context.delete(transactionForDeletion)

        saveTransactions()
    }
    
 // MARK: Segue handling
    @IBAction func createTransaction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addTransaction", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTransaction" {
            let destinationVC = segue.destination as! AddTransactionViewController
            destinationVC.delegate = self
        }
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = transactionList[indexPath.row]
        let currency: String = transaction.currency!
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TransactionCell
        cell.delegate = self
        cell.setTransaction(transaction: transaction, currentPrice: priceData[currency] ?? 0)
        cell.index = indexPath.row
        cell.updateData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteTransaction(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.setSelected(false, animated: true)
        }
    }
}
