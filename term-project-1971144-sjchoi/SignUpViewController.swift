//
//  SignUpViewController.swift
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


class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func SignUpAction(_ sender: UIButton) {
        
        if(emailTextField.text != "" && passwordTextField.text != ""){
            if let email = emailTextField.text, let passwd = passwordTextField.text, let name = nameTextField.text{
               // let email = id + "@hansung.ac.kr"
    
                Auth.auth().createUser(withEmail: email, password: passwd) { Result, error in
    
                    if let error = error{
                        print("Register Error")
                        print(error)
                        return
                    }
                    if let _ = Result{
                        UserDefaults.standard.set(true, forKey: "logInStatus")
                        UserDefaults.standard.set(email, forKey: "email")
                        
                        let user = User(email: email, name: name, password: passwd, fields: [])
                        
                        let userGroup = UserGroup(userParentNotification: self.receivingNotification) // 변경이 생기면 해당 함수를 호출하도록..
                        userGroup.queryData()
                        
                        userGroup.saveChange(user: user, action: .Add)
                        
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                        
                        // This is to get the SceneDelegate object from your view controller
                        // then call the change root view controller function to change to main tab bar
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                    }
                    print("Register Success")
                }
            }
           
        }
    }
    
    
    func receivingNotification(user: User?, action: DbAction?){
      
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        emailTextField.layer.cornerRadius = 5

        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        nameTextField.layer.cornerRadius = 5

        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        passwordTextField.layer.cornerRadius = 5
    }
    
    
    

}
