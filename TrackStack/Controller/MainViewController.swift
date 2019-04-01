//
//  ViewController.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 1/29/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class MainViewController {
    
    @IBOutlet weak var BTCpriceLabel: UILabel!
    @IBOutlet weak var LTCpriceLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let baseUrl: String = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"

    var refresher = UIRefreshControl()
    var transactionList = [Transaction]()
//    var priceData = [String:Double]() { // Last prices for currencies
//        didSet {
//            print("/// Price data updated: \(priceData)")
//            updateHUD()
//        }
//    }
    
    
//    override func viewDidLoad() {
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//
////        navigationController?.navigationBar.prefersLargeTitles = true
//
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        refresher.backgroundColor = UIColor.clear
//        refresher.addTarget(Any?.self, action: #selector(MainViewController.refreshData), for: UIControl.Event.valueChanged)
//        loadRefresher()
//        self.tableView.addSubview(refresher)
//
//        if checkConnection() {
//            getPrice(for: "BTC")
//            getPrice(for: "LTC")
//        }
//
//        loadTransactions()
//    }
//
//    @objc func refreshData() {
//        if checkConnection() {
//            getPrice(for: "BTC")
//            getPrice(for: "LTC")
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.tableView.reloadData()
//    }
//
//    func loadRefresher() {
//        let refreshContent = Bundle.main.loadNibNamed("Refresher", owner: self, options: nil)
//        let customView = refreshContent![0] as! UIView
//        customView.frame = refresher.bounds
//        customView.backgroundColor = UIColor.flatBlueColorDark()
//        let customLabel = customView.viewWithTag(1) as! UILabel
//
//        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .curveEaseOut, .repeat], animations: {
//            customView.backgroundColor = UIColor.flatBlue()
//            customView.backgroundColor = UIColor.flatBlueColorDark()
//        }, completion: nil)
//
//        self.refresher.addSubview(customView)
//    }
//
//
//    // MARK: Handling API data
//    func checkConnection() -> Bool {
//        return NetworkReachabilityManager()!.isReachable
//    }
//
//    func getPrice(for currency: String) {
//        let requestUrl: String = "\(baseUrl)\(currency)USD"
//
//        Alamofire.request(requestUrl, method: .get).validate().responseJSON { response in
//            if response.result.isSuccess {
//                if let data = response.result.value {
//                    let rawData = JSON(data)
//                    self.unpackData(for: currency, from: rawData)
//                }
//                if self.refresher.isRefreshing {
//                    self.refresher.endRefreshing()
//                }
//            }
//        }
//    }
//
//    func unpackData(for currency: String, from data: JSON) {
//        priceData[currency] = data["bid"].doubleValue
//
//        updateHUD()
//        tableView.reloadData()
//    }
//
//    func updateHUD() {
//        if let BTCprice = priceData["BTC"] {
//            BTCpriceLabel.text = "BTC: \(BTCprice)"
//        } else {
//            BTCpriceLabel.text = "BTC: no data"
//        }
//
//        if let LTCprice = priceData["LTC"] {
//            LTCpriceLabel.text = "LTC: \(LTCprice)"
//        } else {
//            LTCpriceLabel.text = "LTC: no data"
//        }
//    }
//
//
//    // MARK: Handling transaction data
//    func addTransaction(_ transaction: Transaction) {
//        transactionList.append(transaction)
//
//        saveTransactions()
//    }
//
//    func saveTransactions() {
//        do {
//            try context.save()
//        } catch {
//            print("/// Error: unable to save transactions,\(error)")
//        }
//    }
//
//    func loadTransactions (with request: NSFetchRequest<Transaction> = Transaction.fetchRequest()) {
//        do {
//            transactionList = try context.fetch(request)
//        } catch {
//            print("/// Error: unable to load transactions, \(error)")
//        }
//    }
//
//    override func deleteTransaction(at indexPath: IndexPath) {
//        let transactionForDeletion = transactionList[indexPath.row]
//        transactionList.remove(at: indexPath.row)
//        context.delete(transactionForDeletion)
//
//        saveTransactions()
//    }
//
//    // MARK: Swipe Cell Table View delegate methods
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return transactionList.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let transaction = transactionList[indexPath.row]
//        let currency: String = transaction.currency!
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TransactionCell
//        cell.delegate = self
//        cell.setTransaction(transaction: transaction, currentPrice: priceData[currency] ?? 0)
//        return cell
//    }
//
//
//    // MARK: Segue handling
//    @IBAction func createTransaction(_ sender: UIBarButtonItem) {
//        performSegue(withIdentifier: "addTransaction", sender: self)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "addTransaction" {
//            let destinationVC = segue.destination as! AddTransactionViewController
////            destinationVC.api = api
//            destinationVC.delegate = self
//        }
//    }
}
