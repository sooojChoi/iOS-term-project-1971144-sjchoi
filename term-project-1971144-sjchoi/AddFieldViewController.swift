//
//  AddFieldViewController.swift
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

class AddFieldViewController: UIViewController {

    @IBOutlet weak var fieldDesTextView: UITextView!
    @IBOutlet weak var fieldTitleTextField: UITextField!
    
    var saveChangeDelegate: ((PostField)->Void)?
    var postField:PostField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        fieldTitleTextField.layer.borderWidth = 1.0
        fieldTitleTextField.layer.borderColor = CGColor.init(red: 0.70, green: 0.70, blue: 0.70, alpha: 1)
        fieldTitleTextField.layer.cornerRadius = 10
        
        fieldDesTextView.layer.borderWidth = 1.0
        fieldDesTextView.layer.borderColor = CGColor.init(red: 0.70, green: 0.70, blue: 0.70, alpha: 1)
        fieldDesTextView.layer.cornerRadius = 10
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer){
        fieldDesTextView.resignFirstResponder()
    }
    

}

extension AddFieldViewController{
    @IBAction func addFieldAction(_ sender: UIBarButtonItem) {
        if(fieldTitleTextField.text == nil){
            return
        }
        postField!.name = fieldTitleTextField.text ?? ""
        postField!.des = fieldDesTextView.text ?? ""
        
        let storedEmail = UserDefaults.standard.string(forKey: "email")
        postField!.userId = storedEmail ?? ""
        
        
        saveChangeDelegate?(postField!)
        navigationController?.popViewController(animated: true)
    }
}
