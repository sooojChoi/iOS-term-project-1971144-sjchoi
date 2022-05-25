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
    
    var user: User?
    
    @IBAction func LogOutAction(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "logInStatus")
        
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LogInViewController")

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var storedEmail = UserDefaults.standard.string(forKey: "email")
        self.emailLabel.text = storedEmail ?? ""
        user = User(withData: false)
        
        print(storedEmail)
        
        if let email = storedEmail{
            if(email != ""){
                let ref = Firestore.firestore().collection("users")
                let queryReference = ref.whereField("email", isEqualTo: email)
                let existQuery = queryReference.addSnapshotListener(){
                    (snapshot, error) in
                    
                    if let e = error{
                        print("query error: \(e)")
                        return
                    }
                    
                    for document in snapshot!.documents {
                        
                        //let key = documentChange.document.documentID
                        let data = document.data()
                        let userData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data["data"] as! Data) as? User
                        
                        self.nameLabe.text = userData?.name ?? ""
                    }
                }

            }
        }
     
    }
    

}
