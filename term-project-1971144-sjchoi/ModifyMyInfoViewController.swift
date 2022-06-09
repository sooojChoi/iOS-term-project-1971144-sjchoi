//
//  ModifyMyInfoViewController.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/06/09.
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

class ModifyMyInfoViewController: UIViewController {
    var user: User?
    var saveChangeDelegate: ((User, String)->Void)?
    @IBOutlet weak var idTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.text = user?.name
        
        idTextField.layer.borderWidth = 1.0
        idTextField.layer.borderColor = CGColor.init(red: 0.70, green: 0.70, blue: 0.70, alpha: 1)
        idTextField.layer.cornerRadius = 10
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer){
        idTextField.resignFirstResponder()
    }
    

}

extension ModifyMyInfoViewController{
    @IBAction func ChangeUserInfo(_ sender: UIButton) {
        user!.name = idTextField.text ?? "익명"
        saveChangeDelegate?(user!, "Modify")
        
        navigationController?.popViewController(animated: true)
    }
}
