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
import Firebase

class AddPostViewController: UIViewController {
    var appOwner = "홍길동"

    @IBOutlet weak var titleTextField: UITextField!
    
    
    var fieldName:String?
    var saveChangeDelegate: ((Post)->Void)?
    
    var post:Post?
    var user:User?
    var userGroup: UserGroup?
    
    @IBOutlet weak var contentsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.borderColor = CGColor.init(red: 0.70, green: 0.70, blue: 0.70, alpha: 1)
        titleTextField.layer.cornerRadius = 10
        
        contentsTextView.layer.borderWidth = 1.0
        contentsTextView.layer.borderColor = CGColor.init(red: 0.70, green: 0.70, blue: 0.70, alpha: 1)
        contentsTextView.layer.cornerRadius = 10
        
        let storedEmail = UserDefaults.standard.string(forKey: "email")
        userGroup = UserGroup(userParentNotification: self.receivingNotification) // 변경이 생기면 해당 함수를 호출하도록..
        userGroup?.queryDataByEmail(email: storedEmail ?? "")
        
        user = userGroup?.getUser(email: storedEmail)
        
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer){
        contentsTextView.resignFirstResponder()
        titleTextField.resignFirstResponder()
    }
    

    @IBAction func SaveAndBackButton(_ sender: UIBarButtonItem) {
        post!.date = Date()
        post!.kind = fieldName ?? "동물 게시판"
        post!.content = contentsTextView.text ?? ""
        post!.title = titleTextField.text ?? ""
        post?.owner = user?.name
        
        post!.userId = user?.email ?? ""
        
        saveChangeDelegate?(post!)
      //  dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    
        
//        let ref = Firestore.firestore().collection("users")
//        let queryReference = ref.whereField("email", isEqualTo: storedEmail ?? "")
//        let _ = queryReference.addSnapshotListener(){ [self]
//            (snapshot, error) in
//
//            if let e = error{
//                print("query error: \(e)")
//                return
//            }
//
//            for document in snapshot!.documents {
//
//                //let key = documentChange.document.documentID
//                let data = document.data()
//                let userData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data["data"] as! Data) as? User
//
//                self.post!.owner = userData?.name ?? "익명"
//            }
//
//
//
//            saveChangeDelegate?(post!)
//          //  dismiss(animated: true, completion: nil)
//            navigationController?.popViewController(animated: true)
//
//        }
            
    }
    
    func receivingNotification(user: User?, action: DbAction?){
        self.user = user
    }
    
    
}
