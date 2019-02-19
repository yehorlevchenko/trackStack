//
//  AddTransactionViewController.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 2/13/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit
import CoreData

enum ValidationError {
    case emptyField
    case notDouble
    case notPicked
}

struct ValidData {
    var price: Double?
    var priceValid: Bool = false
    var currency: String?
    var currencyValid: Bool = false
    var amount: Double?
    var amountValid: Bool = false
}

class AddTransactionViewController: UIViewController {

    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var currencyField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var addTransactionButton: UIButton!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    weak var delegate: MainViewController!
    var newTransaction: Transaction?
    var inputData: ValidData = ValidData()
    var api: APIWorker?
    let currencyList: [String] = ["BTC", "LTC"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceField.delegate = self
        currencyField.delegate = self
        amountField.delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    // MARK: Keyboard handler
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func showCurrencyPicker() {
        let myAlertController: UIAlertController = UIAlertController(title: "Choose currency", message: "", preferredStyle: .actionSheet)

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        myAlertController.addAction(cancelAction)
        
        let currencyBTC: UIAlertAction = UIAlertAction(title: "BTC", style: .default) { action -> Void in
            self.currencyField.text = "BTC"
            self.validateField(self.currencyField)
        }
        myAlertController.addAction(currencyBTC)
        
        let currencyLTC: UIAlertAction = UIAlertAction(title: "LTC", style: .default) { action -> Void in
            self.currencyField.text = "LTC"
            self.validateField(self.currencyField)
        }
        myAlertController.addAction(currencyLTC)

        view.endEditing(true)
        currencyField.inputView = myAlertController.view
        self.present(myAlertController, animated: true, completion: nil)
    }
    
    func validateField(_ textField: UITextField) {
        if let data = textField.text {
            // Fields with Double values
            if textField == amountField || textField == priceField {
                if let value = Double(data) {
                    fieldValid(field: textField)
                }
                else {
                    fieldInvalid(field: textField, reason: .notDouble)
                }
            }
            // Fields with picked values
            else if textField == currencyField {
                if currencyList.contains(data) {
                    fieldValid(field: textField)
                }
                else {
                    fieldInvalid(field: textField, reason: .notPicked)
                }
            }
        }
        else {
            fieldInvalid(field: textField, reason: .emptyField)
        }
    }
    
    func validateForm() {
        if inputData.priceValid && inputData.currencyValid && inputData.amountValid {
            addTransactionButton.isEnabled = true
        }
        else {
            addTransactionButton.isEnabled = false
        }
    }
    
    func fieldInvalid(field: UITextField, reason: ValidationError) {
        field.backgroundColor = UIColor.flatWatermelonColorDark()
        switch reason {
        case .emptyField:
            field.placeholder = "Can't be empty"
        case .notDouble:
            field.placeholder = "Wrong format"
        case .notPicked:
            field.placeholder = "Unknown value"
        }
    }
    
    func fieldValid(field: UITextField) {
        field.backgroundColor = UIColor.flatGreenColorDark()
        
        switch field {
        case priceField:
            inputData.priceValid = true
        case currencyField:
            inputData.currencyValid = true
        case amountField:
            inputData.amountValid = true
        default:
            break
        }
        
        validateForm()
    }
    
    @IBAction func createTransaction(_ sender: Any) {
        newTransaction = Transaction(context: context)
        newTransaction!.amount = Double(amountField.text!)!
        newTransaction!.currency = currencyField.text!
        newTransaction!.priceOrigin = Double(priceField.text!)!
        
        delegate.addTransaction(newTransaction!)
        delegate.tableView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTransaction(_ sender: Any) {
        delegate.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddTransactionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == currencyField {
            view.endEditing(true)
            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.inputAccessoryView = createToolbar()
        
        if textField == currencyField {
            showCurrencyPicker()
            return false
        }
        else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateField(textField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func createToolbar() -> UIToolbar {
        let bar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(AddTransactionViewController.keyboardDonePressed))
        bar.setItems([flexSpace, doneButton], animated: true)
        bar.sizeToFit()
        
        return bar
    }
    
    @objc func keyboardDonePressed() {
        view.endEditing(true)
    }
}
