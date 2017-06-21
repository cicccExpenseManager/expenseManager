//
//  WishList.swift
//  ExpenseManager
//
//  Created by KimSoo Ha on 2017-06-17.
//  Copyright © 2017 Hiroki Honda. All rights reserved.
//

import UIKit
import RealmSwift

class WishListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var wishListLabel: UILabel!
    @IBOutlet weak var wishListTitle: UITextField!
    @IBOutlet weak var wishListAmount: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var totalWishList: UILabel!
    @IBOutlet weak var wishListTableView: UITableView!
    @IBOutlet weak var noticeTextField: UILabel!
    
    var WishListArray = Array(WishListDao().findAllWishListAcounts())
    var current: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        wishListTableView.dataSource = self
        wishListTableView.delegate = self
        
        
        setupTextField()
        moveProgressBar(sender: progressBar)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wishListTitle.becomeFirstResponder()
    }
    
    func setupTextField() {
        
        wishListTitle.placeholder = "TITLE"
        wishListAmount.placeholder = "AMOUNT"
        
        view.addSubview(wishListTitle)
        view.addSubview(wishListAmount)
        view.addSubview(noticeTextField)
        
        let totalLabel = WishListDao().getTotalAmount()
        self.totalWishList.text = String(totalLabel)
        
        let totalFromExpectedAmount = ExpectedExpensePageViewControler().getExpectedAmount()
        
        wishListLabel.text = String("$\(abs(totalLabel - totalFromExpectedAmount))")
        wishListLabel.font = UIFont.boldSystemFont(ofSize: 40)
        
        /* Progress Bar */
        let forCurrentValue = totalLabel / 100
        let valueOfCurrent = totalFromExpectedAmount / forCurrentValue
        
        if totalLabel >= totalFromExpectedAmount{
            
            current = Int(valueOfCurrent)
            noticeTextField.text = "You need "
        } else {
            current = 100
            noticeTextField.text = "You have enough money!!"
        }
        
        /* TextField Underline */
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: wishListTitle.frame.size.height - width, width:  wishListTitle.frame.size.width, height: wishListTitle.frame.size.height)
        
        border.borderWidth = width
        wishListTitle.layer.addSublayer(border)
        wishListTitle.layer.masksToBounds = true
        
        
        let borderAmount = CALayer()
        let widthAmout = CGFloat(2.0)
        borderAmount.borderColor = UIColor.gray.cgColor
        borderAmount.frame = CGRect(x: 0, y: wishListAmount.frame.size.height - width, width:  wishListAmount.frame.size.width, height: wishListAmount.frame.size.height)
        
        borderAmount.borderWidth = widthAmout
        wishListAmount.layer.addSublayer(borderAmount)
        wishListAmount.layer.masksToBounds = true
    }
    
    /* get current value for main page progress bar */
    func getCurrentValue() -> Double {
        let totalLabel = WishListDao().getTotalAmount()
        let totalFromExpectedAmount = ExpectedExpensePageViewControler().getExpectedAmount()
        let forCurrentValue = totalLabel / 100
        let percentage = totalFromExpectedAmount / forCurrentValue
        return percentage
        
    }
    
    func moveProgressBar(sender:AnyObject) {
        
        let i = getCurrentValue()
        let max = 100.0
        
        if i <= max {
            let ratio = Float(i) / Float(max)
            progressBar.progress = Float(ratio)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WishListArray.count
    }
    
    func doneAction() {
        let putValue = WishList()
        if let title = wishListTitle.text {
            if let amount = wishListAmount.text, let doubleAmount = Double(amount) {
                putValue.setAmount(newAmount: doubleAmount, newName: title)
                WishListArray.append(putValue)
                
                //put data to database
                WishListDao().insert(wishList: putValue)
            }
        }
        moveProgressBar(sender: progressBar)
        wishListTitle.text = ""
        wishListAmount.text = ""
        wishListTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "cell"
        let wishListAmount = WishListArray[indexPath.row].amount
        var wishListName = WishListArray[indexPath.row].name
        
        /* Make title to uppercase */
        wishListName = wishListName.uppercased()
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifer,
            for: indexPath) as! WishListCell
        
        cell.titleAmount.text = String("$\(wishListAmount)")
        cell.titleLable.text = wishListName
        cell.titleLable.font = UIFont.boldSystemFont(ofSize: 14)
        
        return cell
    }
    
    /* Deleting cells - delete it on array and cell */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteData = WishListArray[indexPath.row]
            
            // remove data from current data
            WishListArray.remove(at: indexPath.row)
            
            // remove row view from table view
            tableView.deleteRows(at: [indexPath], with: .fade)
            moveProgressBar(sender: progressBar)
            // delete from the db as well
            WishListDao().delete(wishListAmount: deleteData)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        doneAction()
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wishListTableView.reloadData()
    }
}
