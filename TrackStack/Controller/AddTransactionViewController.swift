//
//  AddTransactionViewController.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 2/13/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit
import CoreData

class AddTransactionViewController: UIViewController {

    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var currencyField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var addTransactionButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let newTransaction = Transaction()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addTransaction(_ sender: Any) {
        newTransaction.priceDiff = newTransaction.getPriceDiff()
        print("/// New transaction: \(newTransaction)")
        do {
            try context.save()
        } catch {
            print("error")
        }
    }
}

extension AddTransactionViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("DID BEGIN EDITING")
//        switch textField {
//        case amountField:
//        case currencyField:
//        case priceField:
//        default:
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountField {
            if let amount = Double(textField.text!) {
                newTransaction.amount = amount
                print("amountField: \(newTransaction)")
            }
        }
        else if textField == currencyField {
            newTransaction.currency = textField.text
            print("currencyField: \(newTransaction)")
        }
        else if textField == priceField {
            if let priceOrigin = Double(textField.text!) {
                newTransaction.priceOrigin = priceOrigin
                print("priceOrigin: \(newTransaction)")
            }
        }
    }
}

extension AddTransactionViewController: UIPickerViewDelegate {
    
}
