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
        
        let backgroundFrame: CGRect = CGRect(x: 0, y: 0, width: view.frame.width, height: (UIApplication.shared.statusBarFrame.height + HUDView.frame.height + TransactionTable.rowHeight))
        let background = UIView(frame: backgroundFrame)
        background.backgroundColor = UIColor.flatPurpleColorDark()
        view.addSubview(background)
        view.sendSubviewToBack(background)
        
//        navigationController?.navigationBar.barTintColor = UIColor.flatPurpleColorDark()

//        refresher.backgroundColor = UIColor.clear
//        refresher.addTarget(Any?.self, action: #selector(MainVC.refreshData), for: UIControl.Event.valueChanged)
//        loadRefresher()
//        self.view.addSubview(refresher)
        
        if apiWorker.checkConnection() {
            apiWorker.update(for: cryptoCurrencyList)
        }
        
        loadTransactions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: Handling API data
    func receiveUpdate(data: [String:Double]) {
        priceData = priceData.merging(data) { (_, new) in new }
    }
    
    func failedUpdate(reason: String) {
        let alertController = UIAlertController(title: "All radio is dead", message: reason, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
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
            BTCpriceLabel.text = "BTC: \(fiatGlyph)\(BTCprice)"
        } else {
            BTCpriceLabel.text = "BTC: no data"
        }
        if let LTCprice = priceData[ltcTicker] {
            LTCpriceLabel.text = "LTC: \(fiatGlyph)\(LTCprice)"
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

extension MainVC: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, SwipeActionTransitioning {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = transactionList[indexPath.row]
        let currency: String = "\(transaction.currency!)-\(pickedFiatCurrency.rawValue)"
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TransactionCell
        cell.delegate = self
        cell.tuneView()
        cell.setTransaction(transaction: transaction, currentPrice: priceData[currency] ?? 0, fiat: pickedFiatCurrency, glyph: pickedFiatGlyph)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
            self.deleteTransaction(at: indexPath)
            self.TransactionTable.reloadData()
            self.updateHUD()
        }
        deleteAction.transitionDelegate = self
        deleteAction.image = UIImage(named: "delete_icon")

        return [deleteAction]
    }
    
    // Custom swipe action appearance
    func didTransition(with context: SwipeActionTransitioningContext) {
        let cellSize = self.TransactionTable.rowHeight
        let buttonSize = cellSize / 4 * 2.5
        let marginSize = (cellSize - buttonSize) / 2
        let startX: CGFloat = 5.0
        let initialScale: CGFloat = 0.8
        let threshold: CGFloat = 0.2
        let duration: TimeInterval = 0.3
        let button = context.button
        button.transform = .init(scaleX: 0.8, y: 0.8)
        button.layer.frame = CGRect(x: startX, y: marginSize, width: buttonSize, height: buttonSize)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = false
        button.backgroundColor = UIColor.flatRedColorDark()

        if context.oldPercentVisible == 0 {
            context.button.transform = .init(scaleX: initialScale, y: initialScale)
        }

        if context.oldPercentVisible < threshold && context.newPercentVisible >= threshold {
            UIView.animate(withDuration: duration) {
                context.button.transform = .identity
            }
        } else if context.oldPercentVisible >= threshold && context.newPercentVisible < threshold {
            UIView.animate(withDuration: duration) {
                context.button.transform = .init(scaleX: initialScale, y: initialScale)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .drag
        options.buttonVerticalAlignment = .center
        options.minimumButtonWidth = 90
        return options
    }
    
    func drawUpdate() {
        let cells = TransactionTable.visibleCells as! Array<TransactionCell>
        
        for (index, cell) in cells.enumerated() {
            cell.updateData(index: index)
        }
    }
}
