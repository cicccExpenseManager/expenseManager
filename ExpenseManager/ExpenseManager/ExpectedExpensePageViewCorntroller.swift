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
        
        
        //print("\(ExpectedAmountDao().getTotalAmount())")
        //ExpenseDao().getTotalAmount()
        
        setupTextField()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    
    func setupTextField(){
        
        titleTextField.placeholder = "TITLE"
        amountTextField.placeholder = "AMOUNT"
        
        view.addSubview(titleTextField)
        view.addSubview(amountTextField)
       
        /* Total of Expected Amount */
        let totalLabel = ExpectedAmountDao().getTotalAmount()
        self.totalAmount.text = String(totalLabel)
        
        
        let totalFromExpense = ExpenseDao().getTotalAmount()
        expectedAmount.text = String("$ \(totalFromExpense - totalLabel)")
            expectedAmount.font = UIFont.boldSystemFont(ofSize: 40)
        //expectedAmount.font = expectedAmount.font.withSize(40)
        

        
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
        let expectedName = ArrayList[indexPath.row].name
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifer,
            for: indexPath) as! ExpectedExpenseCell
        
        cell.amountLabel.text = String(expectedAmount)
        cell.titleLabel.text = expectedName
        cell.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)

        
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
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

}
