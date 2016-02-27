//
//  ViewController.swift
//  Dingcan
//
//  Created by ligulfzhou on 2/18/16.
//  Copyright © 2016 ligulfzhou. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {

    let userLoginKey:String = "loginKey"
    var welcomeLable:UILabel?
    var mobileLable:UILabel?
    var passwordLable:UILabel?
    var mobileTextField: UITextField?
    var passwordTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userLogined = checkUserLogin()
        if userLogined != nil {
            NSLog("已登录dddddddddddddddd")
            print(NSUserDefaults.standardUserDefaults().stringForKey("token"))
//            goToDingcanController()
            layoutView()
        }else{
            NSLog("未登陆ddddddddddddddddd")
            layoutView()
//            login()
        }
    }

    func layoutView(){
        NSLog("\(view.frame.size.width / 2 - 50)")
        welcomeLable = UILabel(frame: CGRect(origin: CGPoint(x: view.frame.size.width / 2 - 50, y: view.frame.size.height / 3), size: CGSize(width: 200, height: 50)))
        welcomeLable?.text = "Welcome"
        view.addSubview(welcomeLable!)
        
        mobileTextField = UITextField(frame: CGRect(origin: CGPoint(x: view.frame.size.width / 2 - 50, y: view.frame.size.height / 3 + 100), size: CGSize(width: 200, height: 50)))
        mobileTextField?.borderStyle = .RoundedRect
        mobileTextField?.delegate = self
        mobileTextField?.addTarget(self, action: "mobileTextFieldEditting:", forControlEvents: .EditingDidEnd)
        view.addSubview(mobileTextField!)
        
        passwordTextField = UITextField(frame: CGRect(origin: CGPoint(x: view.frame.size.width / 2 - 50, y: view.frame.size.height / 3 + 200), size: CGSize(width: 200, height: 50)))
        passwordTextField?.borderStyle = .RoundedRect
        passwordTextField?.delegate = self
        view.addSubview(passwordTextField!)
    }
    
    func goToDingcanController(){
        let navigationController = UINavigationController(rootViewController: DingcanViewController())
//        let dingcanController = DingcanViewController()
        
        presentViewController(navigationController, animated: true, completion: nil)
        UIApplication.sharedApplication().delegate?.window??.rootViewController = navigationController
    }

    func checkUserLogin() -> String?{
        let userLogin = NSUserDefaults.standardUserDefaults().valueForKey("token") as? String
        return userLogin
    }
    
    func login(){
        Alamofire.request(.POST, "http://localhost:8888/api/login", parameters: ["mobile": "15990187931", "password": "187931"], encoding: .URL, headers: nil).validate().responseJSON { [unowned self]response in
            switch response.result {
            case .Success:
                print("登陆成功")
                print(response.result.value?["user"])
                NSUserDefaults.standardUserDefaults().setValue(response.result.value?["user"]?!["token"], forKey: "token")
                self.goToDingcanController()
                
            case .Failure(let error):
                print("登陆失败\(error)， 请稍后重试")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
