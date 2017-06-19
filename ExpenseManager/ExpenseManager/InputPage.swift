//
//  InputPage.swift
//  ExpenseManager
//
//  Created by Yoshito Komiya on 2017/06/13.
//  Copyright © 2017 Hiroki Honda. All rights reserved.
//

import UIKit

class InputPage: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var segementedChange: UISegmentedControl!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    
    
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var pluAndMinLabel: UILabel!
    @IBOutlet weak var dollerLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    let categoryList = ["Salary","Food", "Social", "Utility", "House Rent","Transportation", "Cell Phone"]
    var selectedDate: Date? = nil
    
    //set the method of changing the label(Plu and Min)
    @IBAction func changeSeg(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pluAndMinLabel.text = "(-)"
        } else {
            pluAndMinLabel.text = "(+)"
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
        print("test")
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
                print("can not find category name \(categoryTextField.text!)")
                for cat in CategoryDao().findAllCategories() {
                    print("\(cat.id) / \(cat.name)")
                }
            }
        }
        else {
            print("Please fill all of them!")
        }
    }

}

extension InputPage {
    
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
        
        
        
        //set the under line of dateLabel and dateTextField
        let borderDateTextField = CALayer()
        let widthDateTextField = CGFloat(1.5)
        borderDateTextField.borderColor = UIColor.lightGray.cgColor
        borderDateTextField.frame = CGRect(x: 0, y: dateTextField.frame.size.height - widthDateTextField, width:  dateTextField.frame.size.width, height: dateTextField.frame.size.height)
        
        borderDateTextField.borderWidth = widthDateTextField
        dateTextField.layer.addSublayer(borderDateTextField)
        dateTextField.layer.masksToBounds = true
        
        let borderDateLabel = CALayer()
        let widthDateLabel = CGFloat(1.5)
        borderDateLabel.borderColor = UIColor.lightGray.cgColor
        borderDateLabel.frame = CGRect(x: 0, y: dateLabel.frame.size.height - widthDateLabel, width:  dateLabel.frame.size.width, height: dateLabel.frame.size.height)
        
        borderDateLabel.borderWidth = widthDateLabel
        dateLabel.layer.addSublayer(borderDateLabel)
        dateLabel.layer.masksToBounds = true
        
        
        //set the under line of categoryLabel and categoryTextField
        let borderCategoryTextField = CALayer()
        let widthCategoryTextField = CGFloat(1.5)
        borderCategoryTextField.borderColor = UIColor.lightGray.cgColor
        borderCategoryTextField.frame = CGRect(x: 0, y: categoryTextField.frame.size.height - widthCategoryTextField, width:  categoryTextField.frame.size.width, height: dateTextField.frame.size.height)
        
        borderCategoryTextField.borderWidth = widthCategoryTextField
        categoryTextField.layer.addSublayer(borderCategoryTextField)
        categoryTextField.layer.masksToBounds = true
        
        let borderCategoryLabel = CALayer()
        let widthCategoryLabel = CGFloat(1.5)
        borderCategoryLabel.borderColor = UIColor.lightGray.cgColor
        borderCategoryLabel.frame = CGRect(x: 0, y: categoryLabel.frame.size.height - widthCategoryLabel, width:  categoryLabel.frame.size.width, height: categoryLabel.frame.size.height)
        
        borderCategoryLabel.borderWidth = widthCategoryLabel
        categoryLabel.layer.addSublayer(borderCategoryLabel)
        categoryLabel.layer.masksToBounds = true

        
        
        //set the under line of detailLabel and detailTextField
        let borderDetailTextField = CALayer()
        let widthDetailTextField = CGFloat(1.5)
        borderDetailTextField.borderColor = UIColor.lightGray.cgColor
        borderDetailTextField.frame = CGRect(x: 0, y: detailTextField.frame.size.height - widthDetailTextField, width:  detailTextField.frame.size.width, height: detailTextField.frame.size.height)
        
        borderDetailTextField.borderWidth = widthDetailTextField
        detailTextField.layer.addSublayer(borderDetailTextField)
        detailTextField.layer.masksToBounds = true
        
        let borderDetailLabel = CALayer()
        let widthDetailLabel = CGFloat(1.5)
        borderDetailLabel.borderColor = UIColor.lightGray.cgColor
        borderDetailLabel.frame = CGRect(x: 0, y: detailLabel.frame.size.height - widthDetailLabel, width:  detailLabel.frame.size.width, height: detailLabel.frame.size.height)
        
        borderDetailLabel.borderWidth = widthDetailLabel
        detailLabel.layer.addSublayer(borderDetailLabel)
        detailLabel.layer.masksToBounds = true
        
        
        //set the under line of priceLAbel, priceTextField
        let borderPriceTextField = CALayer()
        let widthPriceTextField = CGFloat(1.5)
        borderPriceTextField.borderColor = UIColor.lightGray.cgColor
        borderPriceTextField.frame = CGRect(x: 0, y: priceTextField.frame.size.height - widthPriceTextField, width:  priceTextField.frame.size.width, height: priceTextField.frame.size.height)
        
        borderPriceTextField.borderWidth = widthPriceTextField
        priceTextField.layer.addSublayer(borderPriceTextField)
        priceTextField.layer.masksToBounds = true
        
        let borderPriceLabel = CALayer()
        let widthPriceLabel = CGFloat(1.5)
        borderPriceLabel.borderColor = UIColor.lightGray.cgColor
        borderPriceLabel.frame = CGRect(x: 0, y: priceLabel.frame.size.height - widthPriceLabel, width:  priceLabel.frame.size.width, height: priceLabel.frame.size.height)
        
        borderPriceLabel.borderWidth = widthPriceLabel
        priceLabel.layer.addSublayer(borderPriceLabel)
        priceLabel.layer.masksToBounds = true
        
        let borderPluAndMinLabel = CALayer()
        let widthPluAndMinLabel = CGFloat(1.5)
        borderPluAndMinLabel.borderColor = UIColor.lightGray.cgColor
        borderPluAndMinLabel.frame = CGRect(x: 0, y: pluAndMinLabel.frame.size.height - widthPluAndMinLabel, width:  pluAndMinLabel.frame.size.width, height: pluAndMinLabel.frame.size.height)
        
        borderPluAndMinLabel.borderWidth = widthPluAndMinLabel
        pluAndMinLabel.layer.addSublayer(borderPluAndMinLabel)
        pluAndMinLabel.layer.masksToBounds = true
        
        
        let borderDollerLabel = CALayer()
        let widthDollerLabel = CGFloat(1.5)
        borderDollerLabel.borderColor = UIColor.lightGray.cgColor
        borderDollerLabel.frame = CGRect(x: 0, y: dollerLabel.frame.size.height - widthDollerLabel, width:  dollerLabel.frame.size.width, height: pluAndMinLabel.frame.size.height)
        
        borderDollerLabel.borderWidth = widthDollerLabel
        dollerLabel.layer.addSublayer(borderDollerLabel)
        dollerLabel.layer.masksToBounds = true
        
        
        //set the under line of commentLabel and commentTextView
        
//        let borderCommentTextView = CALayer()
//        let widthCommentTextView = CGFloat(1.5)
//        borderCommentTextView.borderColor = UIColor.lightGray.cgColor
//        borderCommentTextView.frame = CGRect(x: 0, y: commentTextView.frame.size.height - widthCommentTextView, width:  commentTextView.frame.size.width, height: commentTextView.frame.size.height)
//        
//        borderCommentTextView.borderWidth = widthCommentTextView
//        commentTextView.layer.addSublayer(borderCommentTextView)
//        commentTextView.layer.masksToBounds = true
        
        let borderCommentLabel = CALayer()
        let widthCommentLabel = CGFloat(1.5)
        borderCommentLabel.borderColor = UIColor.lightGray.cgColor
        borderCommentLabel.frame = CGRect(x: 0, y: commentLabel.frame.size.height - widthCommentLabel, width:  commentLabel.frame.size.width, height: commentLabel.frame.size.height)
        
        borderCommentLabel.borderWidth = widthCommentLabel
        commentLabel.layer.addSublayer(borderCommentLabel)
        commentLabel.layer.masksToBounds = true
        
    }
    
}
