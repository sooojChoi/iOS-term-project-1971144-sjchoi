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
    
    var tableViewData:[String]?
    @IBOutlet weak var myTableView: UITableView!
    
   
    // 내 정보 수정하기 버튼 눌림
    @IBAction func modifyMyInfoAction(_ sender: UIButton) {
        let svc = self.storyboard?.instantiateViewController(withIdentifier: "ModifyMyInfoViewController") as! ModifyMyInfoViewController
   
        svc.title = "내 정보 수정"
        svc.user = user?.clone()
        svc.saveChangeDelegate = saveMyInfoChange
        
        navigationController?.pushViewController(svc, animated: true)
        
    }
    
    // 로그아웃 버튼 눌림
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
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        tableViewData = ["내가 작성한 게시글"]
     
    }
    
    func receivingNotification(user: User?, action: DbAction?){
        if(user?.email == storedEmail){
            self.user = user
            nameLabe.text = user?.name
        }
    }
    
}

extension MyPageViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell")
        
        let cellData = tableViewData?[indexPath.row]
        (cell?.contentView.subviews[0] as! UILabel).text = cellData
        
        return cell!
    }
    
    
}
extension MyPageViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        let svc = self.storyboard?.instantiateViewController(withIdentifier: "MyPostGroupViewController") as! MyPostGroupViewController
        svc.myEmail = storedEmail
        navigationController?.pushViewController(svc, animated: true)

    }
    
}

extension MyPageViewController{
    func saveMyInfoChange(user: User?, action:String){
        userGroup?.saveChange(user: user!, action: .Modify)
    }
}
