//
//  FieldViewController.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/18.
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

class FieldViewController: UIViewController {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var fieldTableView: UITableView!
    var fieldGroup: PostFieldGroup!
    
    var user: User?
    var userGroup:UserGroup?
    
    var isFireTime = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldTableView.dataSource = self        // 테이블뷰의 데이터 소스로 등록
        fieldTableView.delegate = self        // 딜리게이터로 등록
        
        fieldTableView.isEditing = false
        
        let storedEmail = UserDefaults.standard.string(forKey: "email")
        userGroup = UserGroup(userParentNotification: userReceivingNotification) // 변경이 생기면 해당 함수를 호출하도록..
        userGroup?.queryDataByEmail(email: storedEmail ?? "")
        user = userGroup?.getUser(email: storedEmail)
        
        
        fieldGroup = PostFieldGroup(postFieldParentNotification: receivingNotification) // 변경이 생기면 해당 함수를 호출하도록..
        fieldGroup.queryDataByUser(fieldArray: user?.fields ?? [])
        TitleLabel.text = "즐겨찾기 게시판"
        
    }
    
    func receivingNotification(postField: PostField?, action: DbAction?){
        // 데이터가 올때마다 이 함수가 호출되는데 맨 처음에는 기본적으로 add라는 액션으로 데이터가 온다.
        self.fieldTableView.reloadData()  // 속도를 증가시키기 위해 action에 따라 개별적 코딩도 가능하다.
    }
    
    func userReceivingNotification(user: User?, action: DbAction?){
        self.user = user
        fieldGroup.queryDataByUser(fieldArray: user?.fields ?? [])
        self.fieldTableView.reloadData()
     
    }

}

extension FieldViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let fieldGroup = fieldGroup{
            return fieldGroup.getPostFields().count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FieldTableViewCell")

        let field = fieldGroup.getPostFields()[indexPath.row]

        (cell?.contentView.subviews[0] as! UILabel).text = field.name
        (cell?.contentView.subviews[1] as! UILabel).text = field.des

        return cell!
    }
}
extension FieldViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        let field = fieldGroup.getPostFields()[indexPath.row]
        let svc = self.storyboard?.instantiateViewController(withIdentifier: "PostGroupViewController") as! PostGroupViewController
        svc.appTitleString = field.name
//        svc.post = postGroup.getPosts()[postGroupTableView.indexPathForSelectedRow!.row].clone()
        
        navigationController?.pushViewController(svc, animated: true)

    }

}
extension FieldViewController{
    func saveChange(postField: PostField?){
        if fieldTableView.indexPathForSelectedRow != nil {
            fieldGroup.saveChange(postField: postField!, action: .Modify)
        }else{
            fieldGroup.saveChange(postField: postField!, action: .Add)
        }
    }
    
}

extension FieldViewController{
    
}

