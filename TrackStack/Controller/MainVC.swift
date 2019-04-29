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

protocol ContentShareable {
    func receiveUpdate(data: [String:Double])
    func failedUpdate(reason: String)
}

public enum FiatCurrency: String {
    case USD = "USD"
}

public enum FiatGlyph: String {
    case USD = "$"
}

class MainVC: UIViewController, ContentShareable {
    
    @IBOutlet weak var HUDView: UIView!
    @IBOutlet weak var BTCpriceLabel: UILabel!
    @IBOutlet weak var LTCpriceLabel: UILabel!
    @IBOutlet weak var BalanceAmountLabel: UILabel!
    @IBOutlet weak var TransactionTable: UITableView!
    
    let settings = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let baseUrl: String = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    let apiWorker = APIWorker()
    let cryptoCurrencyList = [Bitcoinaverage.BTC, Bitcoinaverage.LTC]
    var pickedFiatCurrency: FiatCurrency = .USD
    var pickedFiatGlyph: FiatGlyph = .USD
    var transactionList = [Transaction]()
    var priceData = [String:Double]() { // Last prices for currencies
        didSet {
            print("/// Price data updated: \(priceData)")
            processUpdate()
            updateHUD()
            TransactionTable.reloadData()
            drawUpdate()
        }
    }
    
    override func viewDidLoad() {
        TransactionTable.delegate = self
        TransactionTable.dataSource = self
        apiWorker.delegate = self
        
        let backgroundFrame: CGRect = CGRect(x: 0, y: 0, width: view.frame.width, height: (UIApplication.shared.statusBarFrame.height + HUDView.frame.height + TransactionTable.rowHeight / 2))
        let background = UIView(frame: backgroundFrame)
        background.backgroundColor = UIColor.flatPurpleColorDark()
        view.addSubview(background)
        view.sendSubviewToBack(background)
        
        let refreshController = UIRefreshControl()
        refreshController.tintColor = UIColor.white
//        refreshController.attributedTitle = NSAttributedString(string: "Retrieving new prices")
        refreshController.addTarget(self, action: #selector(startUpdate), for: .valueChanged)
        TransactionTable.refreshControl = refreshController
        
        startUpdate()
        loadTransactions()
        updateHUD()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: Handling API data
    @objc func startUpdate() {
        if apiWorker.checkConnection() {
            apiWorker.update(for: cryptoCurrencyList)
        } else {
            failedUpdate(reason: "Unable to reach out data source. Check your connection.")
        }
    }
    
    func receiveUpdate(data: [String:Double]) {
        priceData = priceData.merging(data) { (_, new) in new }
        TransactionTable.refreshControl?.endRefreshing()
    }
    
    func failedUpdate(reason: String) {
        let alertController = UIAlertController(title: "All radio is dead", message: reason, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
        TransactionTable.refreshControl?.endRefreshing()
    }
    
    func processUpdate() {
        for transaction in transactionList {
            transaction.priceLast = priceData["\(transaction.currency!)-\(pickedFiatCurrency)"]!
            transaction.countDiff()
        }
    }
    

    // MARK: Handling transaction and CoreData
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
        performSegue(withIdentifier: "addScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addScreen" {
            let destinationVC = segue.destination as! AddTransactionViewController
            destinationVC.delegate = self
        }
    }
    
    @IBAction func settingsSegue(_ sender: Any) {
        performSegue(withIdentifier: "settingsScreen", sender: self)
    }
    
    
    // MARK: HUD-related
    func updateHUD() {
        let btcTicker: String = "BTC-\(pickedFiatCurrency.rawValue)"
        let ltcTicker: String = "LTC-\(pickedFiatCurrency.rawValue)"
        let fiatGlyph: String = pickedFiatGlyph.rawValue
        let balance: String = String(format: "\(fiatGlyph)%.2f", countBalance())
        BalanceAmountLabel.text = balance
        
        if let BTCprice = priceData[btcTicker] {
            let formattedPrice = String(format: "%.2f", BTCprice)
            BTCpriceLabel.text = String(format: "BTC: \(fiatGlyph)\(formattedPrice)")
        } else {
            BTCpriceLabel.text = "BTC: no data"
        }
        if let LTCprice = priceData[ltcTicker] {
            let formattedPrice = String(format: "%.2f", LTCprice)
            LTCpriceLabel.text = String(format: "LTC: \(fiatGlyph)\(formattedPrice)")
        } else {
            LTCpriceLabel.text = "LTC: no data"
        }
    }
    
    func countBalance() -> Double {
        var balance: Double = 0
        for item in transactionList {
            balance += item.amount * item.priceLast
        }
        
        return balance
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = transactionList[indexPath.row]
        let currency: String = "\(transaction.currency!)-\(pickedFiatCurrency.rawValue)"
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TransactionCell
        cell.tuneView()
        cell.setTransaction(transaction: transaction, currentPrice: priceData[currency] ?? 0, fiat: pickedFiatCurrency, glyph: pickedFiatGlyph)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteTransaction(at: indexPath)
            self.TransactionTable.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func drawUpdate() {
        let cells = TransactionTable.visibleCells as! Array<TransactionCell>
        
        for (index, cell) in cells.enumerated() {
            cell.updateData(index: index)
        }
    }
    
    
}
