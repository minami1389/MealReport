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
            switch indexPath.row {
            case 0:
            cell.textField.keyboardType = UIKeyboardType.ASCIICapable
            cell.textField.secureTextEntry = true
            cell.textField.tag = TextFieldTag.password.rawValue
            cell.textField.placeholder = "6~20文字の半角英数字"
            case 1:
            cell.textField.keyboardType = UIKeyboardType.ASCIICapable
            cell.textField.secureTextEntry = true
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func didSelectTextField(sender: UITextField) {
        self.tableViewHeight.constant = 240
        UIView.animateWithDuration(0.3,
            delay: 0.3,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: { (Bool) -> Void in
                self.tableView.scrollToRowAtIndexPath(self.indexPathWithTextField(sender), atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        })
    }
   
    func indexPathWithTextField(textField: UITextField) -> NSIndexPath {
        switch textField.tag {
        case TextFieldTag.userName.rawValue:
            return NSIndexPath(forRow: 0, inSection: 0)
        case TextFieldTag.email.rawValue:
            return NSIndexPath(forRow: 0, inSection: 1)
        case TextFieldTag.password.rawValue:
            return NSIndexPath(forRow: 0, inSection: 2)
        case TextFieldTag.password2.rawValue:
            return NSIndexPath(forRow: 1, inSection: 2)
        default:
            return NSIndexPath(forRow: 0, inSection: 0)
        }
    }
    
    
    func didDeSelectTextField(sender: UITextField) {
        self.getDataBasePropertyFromTextField(sender)
    }
    
    func getDataBasePropertyFromTextField(textField: UITextField) {
        switch textField.tag {
        case TextFieldTag.userName.rawValue:
            userName = textField.text
        case TextFieldTag.email.rawValue:
            email = textField.text
        case TextFieldTag.password.rawValue:
            password = textField.text
        case TextFieldTag.password2.rawValue:
            password2 = textField.text
        default:
            break
        }

    }
    
    
    @IBAction func didTapScreen(sender: AnyObject) {
        self.view.endEditing(true)
        self.tableViewHeight.constant = 320
        UIView.animateWithDuration(0.3,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil)
    }

   
    
//MARK: - Register
    @IBAction func didPushRegisterButton(sender: AnyObject) {
        self.view.endEditing(true)
        if self.isNotInput() {
            var alert = UIAlertView(title: "エラー", message: "未入力項目があります", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        
        //パスワードが正しいか(6~20文字の英数字、一致)
    }
    
    func isNotInput() -> Bool {
        for (var i = TextFieldTag.userName.rawValue; i < TextFieldTag.password2.rawValue; i++) {
            let textFieldString = (self.view.viewWithTag(i) as? UITextField)?.text
            if self.stringToRemoveBlank(textFieldString!) == "" { return true }
        }
        return false
    }
    
    func stringToRemoveBlank(string: String) -> String {
        return string.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
    }
    
}
