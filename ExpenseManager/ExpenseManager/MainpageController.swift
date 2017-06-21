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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//        print("totalAmount \()")
        let totalAmount = ExpenseDao().getTotalAmount()
        let userInput = NSDecimalNumber(value: totalAmount) //Input from Input page. It's temporary value
        let expectedBalanceValue = NSDecimalNumber(decimal: 543.21)
        
        
        /* Total balance with currency */
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
//        numberFormatter.locale = Locale.current // With $ sign
        numberFormatter.locale = Locale(identifier: "en_US") //Change the currency with identifier
        
        
        let currency1 = numberFormatter.string(from: userInput)
        let currency2 = numberFormatter.string(from: expectedBalanceValue)
        
        self.totalBalance.text = currency1
        self.expectedBalance.text = currency2
        
        
        
        //totalBalance.font = UIFont(name: totalBalance.font.fontName, size: 40)
        totalBalance.font = totalBalance.font.withSize(40)
        expectedBalance.font = expectedBalance.font.withSize(20)
        
        
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
//        settingButton.addTarget(self, action: #selector(goToSettingPage), for: .touchUpInside)
        
        
        /* Make UIlabel clickable */
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        totalBalance.isUserInteractionEnabled = true
        totalBalance.addGestureRecognizer(tap)
        
        
        /* Adding buttons to menuImageView */
        let menuButtons = [calendarButton,expectedBalanceButton, targetListButton, settingButton]
        for button in menuButtons {
            menuImageView.addSubview(button!)
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
    
    
//    func goToSettingPage() {
//        let storyboard = UIStoryboard(name: "NAME OF STORYBOARD FILE", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "NAME OF STROYBOARD'S ID")
//        self.navigationController!.pushViewController(vc, animated: true)
//    }

    
    func tapFunction(sender:UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "InputPage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "inputPage")
        self.navigationController!.pushViewController(vc, animated: true)
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
