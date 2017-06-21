//
//  MainpageController.swift
//  ExpenseManager
//
//  Created by KimSoo Ha on 2017-06-06.
//  Copyright © 2017 Hiroki Honda. All rights reserved.
//

import UIKit

class MainpageController: UIViewController {

    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var expectedBalance: UILabel!
    
    var menuImageView: UIView!
    var calendarButton: UIButton!
    var expectedBalanceButton: UIButton!
    var targetListButton: UIButton!
    var settingButton: UIButton!
    
    
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var calendarLable: UILabel!
    var expextedExpenseLabel: UILabel!
    var wishListLable: UILabel!
    var settingLabel: UILabel!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for receive message from InputPageViewController
        NotificationCenter.default.addObserver(self, selector: #selector(addedRecord), name: NSNotification.Name(rawValue: "Toast"), object: nil)

        /* Hide navigation bar */
        self.navigationController!.navigationBar.apply {
            // Status bar white font
            $0.barStyle = UIBarStyle.black
            $0.tintColor = UIColor.white
            
            // Navigation bar to alpha zero
            $0.setBackgroundImage(UIImage(), for: .default)
            $0.shadowImage = UIImage()
        }
        
        let array = Array(ExpenseDao().findAllExpenses())
        for ex in array {
            print("\(ex.id) : \(ex.amount)")
        }
        let totalAmount = ExpenseDao().getTotalAmount()
        let userInput = NSDecimalNumber(value: totalAmount) //Input from Input page. It's temporary value
        let expectedBalanceValue = NSDecimalNumber(decimal: 543.21)
        
        
        /* Total balance with currency */
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US") //Change the currency with identifier
        
        let currency1 = numberFormatter.string(from: userInput)
        let currency2 = numberFormatter.string(from: expectedBalanceValue)
        
        self.totalBalance.text = currency1
        self.expectedBalance.text = currency2

        //totalBalance.font = UIFont(name: totalBalance.font.fontName, size: 40)
        totalBalance.font = UIFont.boldSystemFont(ofSize: 40)
        expectedBalance.font = UIFont.boldSystemFont(ofSize: 20)
        
        view.addSubview(totalBalance)
        totalBalance.addSubview(expectedBalance)
        
        /* Put the menuImage to center of the View */
        let midX = self.view.bounds.midX
        let midY = self.view.bounds.midY
        
        menuImageView = UIView(frame: CGRect(x: midX - 150.0, y: midY - 80.0, width: 300, height: 300))
        //menuImageView.backgroundColor = UIColor.gray
        
        view.addSubview(menuImageView)
        
        calendarButton = UIButton(frame: CGRect(x: 33, y: 33, width: 100, height: 100))
        expectedBalanceButton = UIButton(frame: CGRect(x: 166, y: 33, width: 100, height: 100))
        targetListButton = UIButton(frame: CGRect(x: 33, y: 166, width: 100, height: 100))
        settingButton = UIButton(frame: CGRect(x: 166, y: 166, width: 100, height: 100))
        
        calendarButton.setImage(UIImage(named: "calendarIcon"), for: .normal)
        expectedBalanceButton.setImage(UIImage(named: "TargetIcon"), for: .normal)
        targetListButton.setImage(UIImage(named: "TargetIcon"), for: .normal)
        settingButton.setImage(UIImage(named: "settingIcon"), for: .normal)
        
        /* Add functions to each buttons to move to next page */
        calendarButton.addTarget(self, action: #selector(goToNextCalendarPage), for: .touchUpInside)
        expectedBalanceButton.addTarget(self, action: #selector(goToNextExpectedPage), for: .touchUpInside)
        targetListButton.addTarget(self, action: #selector(goToNextTargetPage), for: .touchUpInside)
        
        /* Make UIlabel clickable */
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        totalBalance.isUserInteractionEnabled = true
        totalBalance.addGestureRecognizer(tap)
        
        /* Adding buttons to menuImageView */
        let menuButtons = [calendarButton,expectedBalanceButton, targetListButton, settingButton]
        for button in menuButtons {
            menuImageView.addSubview(button!)
            
            
            
            
//        calendarLable = UILabel(frame:CGRect(x:0, y:0, width:100, height:30))
//        expextedExpenseLabel = UILabel(frame:CGRect(x:0, y:0, width:100, height:30))
//        wishListLable = UILabel(frame:CGRect(x:0, y:0, width:100, height:30))
//        settingLabel = UILabel(frame:CGRect(x:0, y:0, width:100, height:30))
//            
//        calendarLable.text = "CALENDAR"
//        menuImageView.addSubview(calendarLable)
//            
//            
        }
        
        /* Progress Bar */
        moveProgressBar(sender: progressBar)
    }
    
    
    /* Progress Bar Function */
    func moveProgressBar(sender:AnyObject) {
        
        let current = WishListViewController().getCurrentValue()
        print("Current ------ > \(current)")
        
        let i = current 
        let max = 100.0
        
        if i <= max {
            let ratio = Float(i) / Float(max)
            progressBar.progress = Float(ratio)
        } else {
            progressBar.progress = Float(1.0)
        }
    }

    var added = false
    
    func addedRecord() {
        added = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        moveProgressBar(sender: progressBar)
        if added {
            showToast(message: "Successfully added!!")
            added = false
        }
    }


    
    /* Functions for moving next pages */
    func goToNextCalendarPage() {
        let storyboard = UIStoryboard(name: "ListUpRecords", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ListUpRecordsViewController")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func goToNextExpectedPage() {
        let storyboard = UIStoryboard(name: "ExpectedExpensePage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "expectedExpensePage")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func goToNextTargetPage() {
        let storyboard = UIStoryboard(name: "WishList", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "wishListStoryboard")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "InputPage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "inputPage")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Helvetica", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}
