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

class MainVC: UIViewController {
    
    @IBOutlet weak var BTCpriceLabel: UILabel!
    @IBOutlet weak var LTCpriceLabel: UILabel!
    @IBOutlet weak var TransactionTable: UITableView!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let baseUrl: String = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    
    var transactionList = [Transaction]()
    var priceData = [String:Double]() { // Last prices for currencies
        didSet {
            print("/// Price data updated: \(priceData)")
            updateHUD()
        }
    }
    
    override func viewDidLoad() {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//
        TransactionTable.delegate = self
        TransactionTable.dataSource = self

//        refresher.backgroundColor = UIColor.clear
//        refresher.addTarget(Any?.self, action: #selector(MainVC.refreshData), for: UIControl.Event.valueChanged)
//        loadRefresher()
//        self.view.addSubview(refresher)
        
        // Setup gradient background
        let gradient = MainGradient()
        let backgroundLayer = gradient.gl
        let sizeLength = self.view.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 96)
        backgroundLayer!.frame = defaultNavigationBarFrame
        self.navigationController?.navigationBar.setBackgroundImage(gradient.image(fromLayer: backgroundLayer!), for: .default)


        if checkConnection() {
            getPrice(for: "BTC")
            getPrice(for: "LTC")
        }

        loadTransactions()
    }
    
    // MARK: Handling API data
    func checkConnection() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }

    func getPrice(for currency: String) {
        let requestUrl: String = "\(baseUrl)\(currency)USD"

        Alamofire.request(requestUrl, method: .get).validate().responseJSON { response in
            if response.result.isSuccess {
                if let data = response.result.value {
                    let rawData = JSON(data)
                    self.unpackData(for: currency, from: rawData)
                }
//                if self.refresher.isRefreshing {
//                    self.refresher.endRefreshing()
//                }
            }
        }
    }

    func unpackData(for currency: String, from data: JSON) {
        priceData[currency] = data["bid"].doubleValue

        updateHUD()
        drawUpdate()
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
        return transactionList.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = transactionList[indexPath.row]
        let currency: String = transaction.currency!
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TransactionCell
        cell.delegate = self
        cell.setTransaction(transaction: transaction, currentPrice: priceData[currency] ?? 0)
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
    
    func drawUpdate() {
        let cells = TransactionTable.visibleCells as! Array<TransactionCell>
        
        for cell in cells {
            cell.updateData()
        }
    }
}
