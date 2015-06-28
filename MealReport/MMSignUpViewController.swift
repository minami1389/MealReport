//
//  MMSignUpViewController.swift
//  MealReport
//
//  Created by minami on 6/28/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

import UIKit

enum textFieldTag: Int {
    case userName  = 1
    case email     = 2
    case password  = 3
    case password2 = 4
}

class MMSignUpViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopMargin: NSLayoutConstraint!
    
    var userName  = ""
    var email     = ""
    var password  = ""
    var password2 = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - UITableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("signUpCell", forIndexPath: indexPath) as! MMSignupTableViewCell
        cell.textField.addTarget(self, action: "didSelectTextField:", forControlEvents: UIControlEvents.EditingDidBegin)
        cell.textField.addTarget(self, action: "didDeSelectTextField:", forControlEvents: UIControlEvents.EditingDidEnd)
        switch indexPath.section {
        case 0:
            cell.textField.keyboardType = UIKeyboardType.Default
            cell.textField.tag = textFieldTag.userName.rawValue
        case 1:
            cell.textField.keyboardType = UIKeyboardType.EmailAddress
            cell.textField.tag = textFieldTag.email.rawValue
        case 2:
            cell.textField.keyboardType = UIKeyboardType.ASCIICapable
            cell.textField.secureTextEntry = true
            cell.textField.tag = textFieldTag.password.rawValue
        case 3:
            cell.textField.keyboardType = UIKeyboardType.ASCIICapable
            cell.textField.secureTextEntry = true
            cell.textField.tag = textFieldTag.password2.rawValue
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ユーザー名"
        case 1:
            return "メールアドレス"
        case 2:
            return "パスワード"
        case 3:
            return "パスワードの確認"
        default:
            return ""
        }
    }

//MARK: - UITextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func didSelectTextField(sender: UITextField) {
        var tableViewTopMargin:CGFloat
        switch sender.tag {
        case textFieldTag.userName.rawValue:
            tableViewTopMargin = 30
        case textFieldTag.email.rawValue:
            tableViewTopMargin = -20
        case textFieldTag.password.rawValue:
            tableViewTopMargin = -70
        case textFieldTag.password2.rawValue:
            tableViewTopMargin = -120
        default:
            tableViewTopMargin = 30
        }
        self.tableViewTopMargin.constant = tableViewTopMargin
        self.changeConstraintWithAnimation()
    }
    
    func didDeSelectTextField(sender: UITextField) {
        self.tableViewTopMargin.constant = 30
        self.changeConstraintWithAnimation()
        
        switch sender.tag {
        case textFieldTag.userName.rawValue:
            userName = sender.text
        case textFieldTag.email.rawValue:
            email = sender.text
        case textFieldTag.password.rawValue:
            password = sender.text
        case textFieldTag.password2.rawValue:
            password2 = sender.text
        default:
            break
        }
    }
    
    func changeConstraintWithAnimation() {
        UIView.animateWithDuration(0.3,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil)
    }

   
    
//MARK: - IBAction
    @IBAction func didPushRegisterButton(sender: AnyObject) {
        self.view.endEditing(true)
      
    }
    
    @IBAction func didTapScreen(sender: AnyObject) {
        self.view.endEditing(true)
    }
}
