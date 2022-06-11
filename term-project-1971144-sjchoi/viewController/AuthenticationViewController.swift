//
//  AuthenticationViewController.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/25.
//
/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/

import UIKit
import Firebase
import FirebaseAuth


class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    @IBAction func LoginButtonAction(_ sender: UIButton) {
        if(emailTextField.text != "" && passwordTextField.text != ""){
            if let email = emailTextField.text, let passwd = passwordTextField.text{
                //let email = id + "@hansung.ac.kr"
    
                Auth.auth().signIn(withEmail: email, password: passwd) { result, error in
                    if let error = error{
                        print("Login Error: \(error)")
                        return
                    }
                    if let _ = result{
                        UserDefaults.standard.set(true, forKey: "logInStatus")
                        UserDefaults.standard.set(email, forKey: "email")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                        
                        // This is to get the SceneDelegate object from your view controller
                        // then call the change root view controller function to change to main tab bar
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                    }
                    print("Login Success")
                }
            }
           
        }
        
    }
    @IBAction func SignUpButtonAction(_ sender: UIButton) {
       print("clicked")
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let svc = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        print(svc)
        navigationController?.pushViewController(svc, animated: true)
        print("something")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        emailTextField.layer.cornerRadius = 5
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        passwordTextField.layer.cornerRadius = 5
    }
    



}

