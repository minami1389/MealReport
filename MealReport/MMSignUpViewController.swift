//
//  MMSignUpViewController.swift
//  MealReport
//
//  Created by minami on 6/28/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

import UIKit

enum TextFieldTag: Int {
    case userName  = 1
    case email     = 2
    case password  = 3
    case password2 = 4
}

class MMSignUpViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
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
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 { return 2 }
        else { return 1 }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("signUpCell", forIndexPath: indexPath) as! MMSignupTableViewCell
        cell.textField.addTarget(self, action: "didSelectTextField:", forControlEvents: UIControlEvents.EditingDidBegin)
        cell.textField.addTarget(self, action: "didDeSelectTextField:", forControlEvents: UIControlEvents.EditingDidEnd)
       
        switch indexPath.section {
        case 0:
            cell.textField.keyboardType = UIKeyboardType.Default
            cell.textField.tag = TextFieldTag.userName.rawValue
            
        case 1:
            cell.textField.keyboardType = UIKeyboardType.EmailAddress
            cell.textField.tag = TextFieldTag.email.rawValue
            
        case 2:
            cell.textField.keyboardType = UIKeyboardType.ASCIICapable
            cell.textField.secureTextEntry = true
            switch indexPath.row {
            case 0:
                cell.textField.tag = TextFieldTag.password.rawValue
                cell.textField.placeholder = "6~20文字の半角英数字"
            case 1:
                cell.textField.tag = TextFieldTag.password2.rawValue
                cell.textField.placeholder = "もう一度入力してください"
            default:
                break
            }
            
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
        default:
            return ""
        }
    }

    
//MARK: - UITextField
    func didSelectTextField(sender: UITextField) {
        self.tableViewHeight.constant = 260
        UIView.animateWithDuration(0,
            delay: 0.3,
            options: nil,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion:nil)
    }
   
    func didDeSelectTextField(sender: UITextField) {
        self.view.layoutIfNeeded()
    }
   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.keyboardShouldClose()
        return true
    }
    
    @IBAction func didTapScreen(sender: AnyObject) {
        self.keyboardShouldClose()
    }
    
    func keyboardShouldClose() {
        self.view.endEditing(true)
        self.view.layoutIfNeeded()
        self.tableViewHeight.constant = 320
        UIView.animateWithDuration(0.3,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion:nil)
    }
    

    
//MARK: - Register
    @IBAction func didPushRegisterButton(sender: AnyObject) {
        self.getDataBasePropertyFromTextField()
        if self.isNotInput() {
            self.showErrorAlert("未入力の項目があります")
        } else if self.isMisMatchPassword() {
            self.showErrorAlert("パスワードが一致しません")
        } else if self.isMisMatchPasswordLength() {
            self.showErrorAlert("パスワードは6~20文字の\n半角英数字で入力してください")
        }
    }
    
    func showErrorAlert(message: String) {
        var alert = UIAlertView(title: "エラー", message: message, delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func getDataBasePropertyFromTextField() {
        if let textField = self.view.viewWithTag(TextFieldTag.userName.rawValue) as? UITextField {
            userName = self.stringToRemoveBlank(textField.text)
        }
        if let textField = self.view.viewWithTag(TextFieldTag.email.rawValue) as? UITextField {
            email = self.stringToRemoveBlank(textField.text)
        }
        if let textField = self.view.viewWithTag(TextFieldTag.password.rawValue) as? UITextField {
            password = self.stringToRemoveBlank(textField.text)
        }
        if let textField = self.view.viewWithTag(TextFieldTag.password2.rawValue) as? UITextField {
            password2 = self.stringToRemoveBlank(textField.text)
        }
    }
    
    func isNotInput() -> Bool {
        if userName == "" || email == "" || password == "" || password2 == "" { return true }
        return false
    }
    
    func isMisMatchPassword() -> Bool {
        return !(password == password2)
    }
    
    func isMisMatchPasswordLength() -> Bool {
        return count(password) < 6 || count(password) > 20
    }
    
    func stringToRemoveBlank(string: String) -> String {
        return string.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
    }
    
}
