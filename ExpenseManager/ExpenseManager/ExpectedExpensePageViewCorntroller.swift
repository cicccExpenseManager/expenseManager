//
//  ExpectedExpensePage.swift
//  ExpenseManager
//
//  Created by KimSoo Ha on 2017-06-17.
//  Copyright © 2017 Hiroki Honda. All rights reserved.
//

import UIKit

class ExpectedExpensePageViewControler: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var expectedAmount: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var ArrayList = ["Rent","Food","Utility","Monthly pass","Phone bill"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.placeholder = "Title"
        amountTextField.placeholder = "Amount"
        
        addButton.setImage(UIImage(named:"addButton"), for: .normal)
        view.addSubview(addButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }

    @IBAction func AddValues(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "cell"
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifer,
            for: indexPath) as! ExpectedExpenseCell
        cell.putValue(row: indexPath.row)
        return cell
        
//        let cell = UITableViewCell()
//        cell.textLabel?.text = ArrayList[indexPath.row]  //Store array values to the cell
//        return cell
    }
    
    /* Deleting cells - delete it on array and cell */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ArrayList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
