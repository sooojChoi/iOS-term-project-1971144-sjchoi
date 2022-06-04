//
//  MyPageViewController.swift
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

class MyPageViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabe: UILabel!
    
    var userGroup:UserGroup?
    var user: User?
    var storedEmail: String?
    
    @IBAction func LogOutAction(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "logInStatus")
        
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LogInViewController")

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storedEmail = UserDefaults.standard.string(forKey: "email")
        self.emailLabel.text = storedEmail ?? ""
        
        userGroup = UserGroup(userParentNotification: self.receivingNotification) // 변경이 생기면 해당 함수를 호출하도록..
        userGroup?.queryDataByEmail(email: storedEmail ?? "")
        
        user = userGroup?.getUser(email: storedEmail)
        nameLabe.text = user?.name
        
        print(user?.name)
        
//        if let email = storedEmail{
//            if(email != ""){
//                let ref = Firestore.firestore().collection("users")
//                let queryReference = ref.whereField("email", isEqualTo: email)
//                let existQuery = queryReference.addSnapshotListener(){
//                    (snapshot, error) in
//
//                    if let e = error{
//                        print("query error: \(e)")
//                        return
//                    }
//
//
//                    for document in snapshot!.documents {
//
//                        //let key = documentChange.document.documentID
//                        let data = document.data()
//                        let userData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data["data"] as! Data) as? User
//
//                        self.nameLabe.text = userData?.name ?? ""
//                    }
//                }
//
//            }
//        }
     
    }
    
    
    func receivingNotification(user: User?, action: DbAction?){
        if(user?.email == storedEmail){
            nameLabe.text = user?.name
        }
    }
    
}
