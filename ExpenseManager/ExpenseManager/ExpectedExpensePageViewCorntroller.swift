//
//  ExpectedExpensePage.swift
//  ExpenseManager
//
//  Created by KimSoo Ha on 2017-06-17.
//  Copyright © 2017 Hiroki Honda. All rights reserved.
//

import UIKit
import RealmSwift

class ExpectedExpensePageViewControler: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var expectedAmount: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmount: UILabel!

 
    
    var ArrayList = Array(ExpectedAmountDao().findAllExpectedAcounts())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        tableView.dataSource = self
        tableView.delegate = self
    
        setupTextField()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    

    func getExpectedAmount() -> Double {
        let totalLabel = ExpectedAmountDao().getTotalAmount()
        let totalFromExpense = ExpenseDao().getTotalAmount()
        let getAmount = totalFromExpense - totalLabel
        return getAmount
    }
    
    func setupTextField(){
        
        titleTextField.placeholder = "TITLE"
        amountTextField.placeholder = "AMOUNT"
        
        view.addSubview(titleTextField)
        view.addSubview(amountTextField)
       
        /* Total of Expected Amount */
        let totalString = "Expected Expense "
        let totalLabel = ExpectedAmountDao().getTotalAmount()
        self.totalAmount.text = totalString + String(totalLabel)
        totalAmount.font = UIFont.boldSystemFont(ofSize: 17)
        
        expectedAmount.text = String("$\(getExpectedAmount())")
//        expectedAmount.text = String("$ \( GetExpectedAmount())")
        expectedAmount.font = UIFont.boldSystemFont(ofSize: 40)
        
        
        
        /* TextField Underline */
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: titleTextField.frame.size.height - width, width:  titleTextField.frame.size.width, height: titleTextField.frame.size.height)
        
        border.borderWidth = width
        titleTextField.layer.addSublayer(border)
        titleTextField.layer.masksToBounds = true
        
        
        let borderAmount = CALayer()
        let widthAmout = CGFloat(2.0)
        borderAmount.borderColor = UIColor.gray.cgColor
        borderAmount.frame = CGRect(x: 0, y: amountTextField.frame.size.height - width, width:  amountTextField.frame.size.width, height: amountTextField.frame.size.height)
        
        
        borderAmount.borderWidth = widthAmout
        amountTextField.layer.addSublayer(borderAmount)
        amountTextField.layer.masksToBounds = true
        
        
    }
    
    func doneAction()  {
        
        let putValue = ExpectedAmount()
        if let title = titleTextField.text {
            if let amount = amountTextField.text, let doubleAmount = Double(amount) {
                // put to table
                putValue.setAmount(newAmount: doubleAmount, newName: title)
                ArrayList.append(putValue)
                
                // put data to database
                ExpectedAmountDao().insert(expectedAmount: putValue)
            }
        }
        titleTextField.text = ""
        amountTextField.text = ""
        tableView.reloadData()
        // add data to the db
        
        setupTextField()
    
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        doneAction()
        textField.resignFirstResponder()
        return true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "cell"
        let expectedAmount = ArrayList[indexPath.row].amount
        var expectedName = ArrayList[indexPath.row].name
        
        /* Make title to uppercase */
        expectedName = expectedName.uppercased()
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifer,
            for: indexPath) as! ExpectedExpenseCell
        
        cell.amountLabel.text = String("$\(expectedAmount)")
        cell.titleLabel.text = expectedName
        cell.titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
   
        return cell
    }
    
    
    
    /* Deleting cells - delete it on array and cell */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteData = ArrayList[indexPath.row]
            
            // remove data from current data
            ArrayList.remove(at: indexPath.row)
            
            // remove row view from table view
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // delete from the db as well
            ExpectedAmountDao().delete(expectedAmount: deleteData)
            
            setupTextField()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

}
