//
//  InputPage.swift
//  ExpenseManager
//
//  Created by Yoshito Komiya on 2017/06/13.
//  Copyright © 2017 Hiroki Honda. All rights reserved.
//

import UIKit

class InputPage: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var segementedChange: UISegmentedControl!
    @IBOutlet weak var labPluAndMin: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    let categoryList = ["Salary","Food", "Social", "Utility", "House Rent","Transportation", "Cell Phone"]
    var selectedDate: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(tappedToolBarBtn(_:)))
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donePressed(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Select a due date"
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        dateTextField.inputAccessoryView = toolBar
        
        
        let pickerView: UIPickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbarCategory = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        toolbarCategory.setItems([cancelItem, doneItem], animated: true)
        
        categoryTextField.inputView = pickerView
        categoryTextField.inputAccessoryView = toolbarCategory
    
    }
    
    
    //set the method of changing the label(Plu and Min)
    @IBAction func changeSeg(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            labPluAndMin.text = "(-)"
        } else {
            labPluAndMin.text = "(+)"
        }
    }

    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func donePressed(_ sender: UIBarButtonItem) {
        
        dateTextField.resignFirstResponder()
    }
    
    func tappedToolBarBtn(_ sender: UIBarButtonItem) {
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.timeStyle = DateFormatter.Style.none
        dateTextField.text = dateformatter.string(from: Date())
        dateTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        selectedDate = sender.date
        dateTextField.text = dateFormatter.string(from: selectedDate!)
    }
    
    
    //the method which return the number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //the method which return the number of the data including to components
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    //the method which return the data as String
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row] as String
    }
    
    
    func cancel() {
        categoryTextField.text = ""
        categoryTextField.endEditing(true)
    }
    
    func done() {
        categoryTextField.endEditing(true)
    }
    
    //the method which set the chosen category to the text field
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTextField.text = categoryList[row]
    }
    
    
    
    //the method which input the expense of users
    @IBAction func inputSubmit(_ sender: UIButton) {
        
        //check all of the user input
        if dateTextField.text != nil && categoryTextField.text != nil && detailTextField.text != nil && priceTextField.text != nil {
            
            if let category = CategoryDao().findByName(name: categoryTextField.text!).first {
                let expenseDao = ExpenseDao()
                expenseDao.addExpense(
                    detail: detailTextField.text!,
                    amount: Double(priceTextField.text!)!,
                    category: category,
                    date: selectedDate ?? Date())
                self.navigationController?.popViewController(animated: true)
            } else {
                //if letのelseの場合を考える（notification etc）
            }
        }
        else {
            print("Please fill all of them!")
        }
    }
    
    

}
