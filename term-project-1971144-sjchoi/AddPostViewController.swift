//
//  AddPostViewController.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/24.
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

class AddPostViewController: UIViewController {
    var appOwner = "홍길동"

    @IBOutlet weak var titleTextField: UITextField!
    
    
    var fieldName:String?
    var saveChangeDelegate: ((Post)->Void)?
    
    var post:Post?
    
    @IBOutlet weak var contentsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        contentsTextView.layer.borderWidth = 1.0
        contentsTextView.layer.borderColor = CGColor.init(red: 0.70, green: 0.70, blue: 0.70, alpha: 1)
        contentsTextView.layer.cornerRadius = 10
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer){
        contentsTextView.resignFirstResponder()
        titleTextField.resignFirstResponder()
    }
    

    @IBAction func SaveAndBackButton(_ sender: UIBarButtonItem) {
        post!.date = Date()
        post!.owner = "홍길동"
        post!.kind = fieldName ?? "동물 게시판"
        post!.content = contentsTextView.text ?? ""
        post!.title = titleTextField.text ?? ""

        saveChangeDelegate?(post!)
      //  dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
        
    }
    
    
}
