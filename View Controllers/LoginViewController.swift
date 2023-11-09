//
//  LoginViewController.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 5/20/23.
//

import UIKit

class LoginViewController: BaseViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var signUpInLabel: UILabel!
    @IBOutlet weak var nextSignInUp: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orgMbrCallingViewModel = OrgMbrCallingViewModel.shared
    }
    
    @IBAction func nextSignInUpButtonPressedAction(_ sender: UIButton) {
//        if sender.titleLabel?.text == "Sign Up" {
//            createAccountAction()
//        } else {
//            loginAction()
//        }
          showTabBarController()

    }
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func createAccountButtonAction(_ sender: UIButton) {
      //  showTabBarController()
    }
    
    private func showTabBarController() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            
         let tabBarViewController = self.storyboard!.instantiateViewController(withIdentifier: "TabBarControllerID")
         appDelegate.window?.rootViewController = tabBarViewController
         appDelegate.window?.makeKeyAndVisible()
        
        self.navigationController?.pushViewController(tabBarViewController, animated: true)
    }
    
    func createAccountAction() {
      
//        if userNameTextField.text == "" {
//            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
//
//            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alertController.addAction(defaultAction)
//
//            present(alertController, animated: true, completion: nil)
//
//        } else {
//            Auth.auth().createUser(withEmail: userNameTextField.text!, password: passwordTextField.text!) { (user, error) in
//
//                if error == nil {
//                    print("You have successfully signed up")
//                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
//
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
//                    self.present(vc!, animated: true, completion: nil)
//
//                } else {
//                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//
//                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(defaultAction)
//
//                    self.present(alertController, animated: true, completion: nil)
//                }
//            }
//        }
    }
    
    func loginAction() {
//        if self.userNameTextField.text == "" || self.passwordTextField.text == "" {
//            
//            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
//            
//            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
//            
//            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alertController.addAction(defaultAction)
//            
//            self.present(alertController, animated: true, completion: nil)
//        
//        } else {
//            
//            Auth.auth().signIn(withEmail: self.userNameTextField.text!, password: self.passwordTextField.text!) { (user, error) in
//                
//                if error == nil {
//                    
//                    //Print into the console if successfully logged in
//                    print("You have successfully logged in")
//                    
//                    //Go to the HomeViewController if the login is sucessful
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
//                    self.present(vc!, animated: true, completion: nil)
//                    
//                } else {
//                    
//                    //Tells the user that there is an error and then gets firebase to tell them the error
//                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//                    
//                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(defaultAction)
//                    
//                    self.present(alertController, animated: true, completion: nil)
//                }
//            }
//        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
}
