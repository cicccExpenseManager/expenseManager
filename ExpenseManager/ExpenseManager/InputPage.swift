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
    @IBOutlet weak var categoryColor: UIView!
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var pluAndMinLabel: UILabel!
    @IBOutlet weak var dollerLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var sc: UIScrollView!
    
    let categoryList = Array(CategoryDao().findAllCategories())
    var selectedDate: Date? = nil
//    let sc = UIScrollView()
    var txtActiveField = UITextView()
    
    
    
    
    //set the method of changing the label(Plu and Min)
    @IBAction func changeSeg(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pluAndMinLabel.text = "(-)"
        } else {
            pluAndMinLabel.text = "(+)"
        }
    }
    
    
    //show the datePickerView when clicking the dateTextField
    @IBAction func textFieldEditing(_ sender: UITextField) {
        
        let datePickerView: UIDatePicker = UIDatePicker()
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.timeStyle = DateFormatter.Style.none
        let displayDate = dateformatter.date(from: dateTextField.text!)
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.date = displayDate!
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
        
        //make a toolBar in the datePickerView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        //make two buttons of 'Today' and 'Done' in the toolBar of datePickerView
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(tappedToolBarBtn(_:)))
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donePressed(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Select a due date"
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,doneBtn], animated: true)
        dateTextField.inputAccessoryView = toolBar
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
        categoryTextField.text = categoryList[row].name
        return categoryList[row].name
    }
    
    //the method of 'CANCEL' button in the pickerView
    func cancel() {
        categoryTextField.endEditing(true)
    }
    
    //the method of 'OK' button in the pickerView
    func done() {
        categoryTextField.endEditing(true)
    }
    
    //the method which set the chosen category to the text field
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTextField.text = categoryList[row].name
        self.categoryColor.backgroundColor = categoryList[row].getColor()
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        super.viewWillAppear(animated)
////        self.configureObserver()
//        
//    }
//    
    //改行ボタンが押された際に呼ばれる.
    func textFieldShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        
        return true
    }
    
    //UITextFieldが編集された直後に呼ばれる.
    func textFieldShouldBeginEditing(_ textView: UITextView) -> Bool {
        txtActiveField = textView
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShowNotification(_ notification: Notification) {
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        let txtLimit = txtActiveField.frame.origin.y + txtActiveField.frame.height + 8.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        print("テキストフィールドの下辺：(\(txtLimit))")
        print("キーボードの上辺：(\(kbdLimit))")
        
        if txtLimit >= kbdLimit {
            sc.contentOffset.y = txtLimit - kbdLimit
        }
    }
    
    func handleKeyboardWillHideNotification(_ notification: Notification) {
        sc.contentOffset.y = 0
    }
    
    //the method which input the expense of users
    @IBAction func inputSubmit(_ sender: UIButton) {

        //check all of the user input
        if dateTextField.text != "" && categoryTextField.text != "" && detailTextField.text != "" && priceTextField.text != "" {
            
            if let category = CategoryDao().findByName(name: categoryTextField.text!).first {
                
                let alert = UIAlertController(title: "Confirmation", message: "Do you want to add this item?", preferredStyle: UIAlertControllerStyle.alert)
                
                //set the button of 'OK' in the Alert
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    // OK button action
                    // insert data to database
                    if let price = self.priceTextField.text, let doublePrice = Double(price) {
                        let expenseDao = ExpenseDao()
                        expenseDao.addExpense(
                            detail: self.detailTextField.text!,
                            amount: self.segementedChange.selectedSegmentIndex == 0
                                ? -doublePrice : doublePrice,
                            category: category,
                            date: self.selectedDate ?? Date())
                    }
                    
                    // show toast message
                    // self.showToast(message: "successfully added!!")
                    
                    NotificationCenter.default.post(name: Notification.Name("Toast"), object: nil)
                    
                    
                    // move back to previous page
                    self.navigationController?.popViewController(animated: true)
                }))
                
                //set the button of 'CANCEL' in the Alert
                alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                //if letのelseの場合を考える（notification etc）
                let alert1 = UIAlertController(title: "Warning...", message: "can not find category name \(categoryTextField.text!)", preferredStyle: UIAlertControllerStyle.alert)
                alert1.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                print("can not find category name \(categoryTextField.text!)")
//                for cat in CategoryDao().findAllCategories() {
//                    print("\(cat.id) / \(cat.name)")
//                }
            }
        }
        else {
            let alert2 = UIAlertController(title: "Warning...", message: "Please fill all of the information!", preferredStyle: UIAlertControllerStyle.alert)
            alert2.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert2, animated: true, completion: nil)
        }
    }
}

extension InputPage {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Note : All delegates are set in view controller
        
        self.navigationController!.navigationBar.apply {
            // Status bar white font
            $0.barStyle = UIBarStyle.black
            $0.tintColor = UIColor.white
            
            // Navigation bar to alpha zero
            $0.setBackgroundImage(UIImage(), for: .default)
            $0.shadowImage = UIImage()
        }
        
        
        //make the category picker
        let pickerView: UIPickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbarCategory = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label2.font = UIFont(name: "Helvetica", size: 12)
        label2.backgroundColor = UIColor.clear
        label2.textColor = UIColor.white
        label2.text = "Select a category"
        
        let textBtn2 = UIBarButtonItem(customView: label2)

        
        label2.textAlignment = NSTextAlignment.center
        toolbarCategory.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolbarCategory.barStyle = UIBarStyle.blackTranslucent
        toolbarCategory.tintColor = UIColor.white
        toolbarCategory.backgroundColor = UIColor.black

        toolbarCategory.setItems([cancelBtn, flexSpace, textBtn2, flexSpace, doneBtn], animated: true)
        toolbarCategory.backgroundColor = UIColor.black
        
        categoryTextField.inputView = pickerView
        categoryTextField.inputAccessoryView = toolbarCategory
        
        
        //set the under line of dateLabel and dateTextField
        let borderDateTextField = CALayer()
        let widthDateTextField = CGFloat(0.5)
        borderDateTextField.borderColor = UIColor.lightGray.cgColor
        borderDateTextField.frame = CGRect(x: 0, y: dateTextField.frame.size.height - widthDateTextField, width:  dateTextField.frame.size.width, height: dateTextField.frame.size.height)
        
        borderDateTextField.borderWidth = widthDateTextField
        dateTextField.layer.addSublayer(borderDateTextField)
        dateTextField.layer.masksToBounds = true
        
        let borderDateLabel = CALayer()
        let widthDateLabel = CGFloat(0.5)
        borderDateLabel.borderColor = UIColor.lightGray.cgColor
        borderDateLabel.frame = CGRect(x: 0, y: dateLabel.frame.size.height - widthDateLabel, width:  dateLabel.frame.size.width, height: dateLabel.frame.size.height)
        
        borderDateLabel.borderWidth = widthDateLabel
        dateLabel.layer.addSublayer(borderDateLabel)
        dateLabel.layer.masksToBounds = true
        
        
        //set the under line of categoryLabel and categoryTextField
        let borderCategoryTextField = CALayer()
        let widthCategoryTextField = CGFloat(0.5)
        borderCategoryTextField.borderColor = UIColor.lightGray.cgColor
        borderCategoryTextField.frame = CGRect(x: 0, y: categoryTextField.frame.size.height - widthCategoryTextField, width:  categoryTextField.frame.size.width, height: dateTextField.frame.size.height)
        
        borderCategoryTextField.borderWidth = widthCategoryTextField
        categoryTextField.layer.addSublayer(borderCategoryTextField)
        categoryTextField.layer.masksToBounds = true
        
        let borderCategoryLabel = CALayer()
        let widthCategoryLabel = CGFloat(0.5)
        borderCategoryLabel.borderColor = UIColor.lightGray.cgColor
        borderCategoryLabel.frame = CGRect(x: 0, y: categoryLabel.frame.size.height - widthCategoryLabel, width:  categoryLabel.frame.size.width, height: categoryLabel.frame.size.height)
        
        borderCategoryLabel.borderWidth = widthCategoryLabel
        categoryLabel.layer.addSublayer(borderCategoryLabel)
        categoryLabel.layer.masksToBounds = true

        
        
        //set the under line of detailLabel and detailTextField
        let borderDetailTextField = CALayer()
        let widthDetailTextField = CGFloat(0.5)
        borderDetailTextField.borderColor = UIColor.lightGray.cgColor
        borderDetailTextField.frame = CGRect(x: 0, y: detailTextField.frame.size.height - widthDetailTextField, width:  detailTextField.frame.size.width, height: detailTextField.frame.size.height)
        
        borderDetailTextField.borderWidth = widthDetailTextField
        detailTextField.layer.addSublayer(borderDetailTextField)
        detailTextField.layer.masksToBounds = true
        
        let borderDetailLabel = CALayer()
        let widthDetailLabel = CGFloat(0.5)
        borderDetailLabel.borderColor = UIColor.lightGray.cgColor
        borderDetailLabel.frame = CGRect(x: 0, y: detailLabel.frame.size.height - widthDetailLabel, width:  detailLabel.frame.size.width, height: detailLabel.frame.size.height)
        
        borderDetailLabel.borderWidth = widthDetailLabel
        detailLabel.layer.addSublayer(borderDetailLabel)
        detailLabel.layer.masksToBounds = true
        
        
        //set the under line of priceLAbel, priceTextField and limit the textField only writing a number
        let borderPriceTextField = CALayer()
        let widthPriceTextField = CGFloat(0.5)
        borderPriceTextField.borderColor = UIColor.lightGray.cgColor
        borderPriceTextField.frame = CGRect(x: 0, y: priceTextField.frame.size.height - widthPriceTextField, width:  priceTextField.frame.size.width, height: priceTextField.frame.size.height)
        
        borderPriceTextField.borderWidth = widthPriceTextField
        priceTextField.layer.addSublayer(borderPriceTextField)
        priceTextField.layer.masksToBounds = true
        
        let borderPriceLabel = CALayer()
        let widthPriceLabel = CGFloat(0.5)
        borderPriceLabel.borderColor = UIColor.lightGray.cgColor
        borderPriceLabel.frame = CGRect(x: 0, y: priceLabel.frame.size.height - widthPriceLabel, width:  priceLabel.frame.size.width, height: priceLabel.frame.size.height)
        
        borderPriceLabel.borderWidth = widthPriceLabel
        priceLabel.layer.addSublayer(borderPriceLabel)
        priceLabel.layer.masksToBounds = true
        
        self.priceTextField.keyboardType = UIKeyboardType.numberPad
        priceTextField.resignFirstResponder()

        
        
        //set the under line of commentLabel and commentTextView
        self.commentTextView.layer.borderWidth = 0.5;
        self.commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        // initialize views
        //for datePickerView
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.timeStyle = DateFormatter.Style.none
        dateTextField.text = dateformatter.string(from: Date())
        
        //for categoryPickerView
        let firstCategory = categoryList[0]
        categoryTextField.text = firstCategory.name
        categoryColor.backgroundColor = firstCategory.getColor()
        categoryColor.layer.cornerRadius = categoryColor.bounds.width / 2.0
        
    }
}
