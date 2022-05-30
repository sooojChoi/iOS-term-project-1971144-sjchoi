//
//  MakeFieldViewController.swift
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

class MakeFieldViewController: UIViewController {

    @IBAction func searchFieldButton(_ sender: UIButton) {
        if(searchFieldTextField.text != "" && searchFieldTextField.text != nil){
            fieldGroup.queryDataByName(name: searchFieldTextField.text ?? "")
        }
        
    }
    @IBOutlet weak var searchFieldTextField: UITextField!
    @IBOutlet weak var fieldTableView: UITableView!
    
    var fieldGroup: PostFieldGroup!
    
    var user:User?
    var userGroup: UserGroup?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchFieldTextField.layer.cornerRadius = 5
        searchFieldTextField.layer.borderWidth = 1.0
        searchFieldTextField.layer.borderColor = CGColor.init(red: 0.50, green: 0.50, blue: 0.50, alpha: 1)
        
        fieldTableView.dataSource = self        // 테이블뷰의 데이터 소스로 등록
        fieldTableView.delegate = self        // 딜리게이터로 등록
        
        fieldTableView.isEditing = false
        
        // 단순히 planGroup객체만 생성한다
        fieldGroup = PostFieldGroup(postFieldParentNotification: receivingNotification) // 변경이 생기면 해당 함수를 호출하도록..
        fieldGroup.queryData()       // 이달의 데이터를 가져온다. 데이터가 오면 planGroupListener가 호출된다.
        
        let storedEmail = UserDefaults.standard.string(forKey: "email")
        userGroup = UserGroup(userParentNotification: receivingUserNotification) // 변경이 생기면 해당 함수를 호출하도록..
        userGroup?.queryDataByEmail(email: storedEmail ?? "")
        user = userGroup?.getUser(email: storedEmail)
        print(storedEmail ?? "there is no email")
        print(user?.name)
       
    }
    
    func receivingNotification(postField: PostField?, action: DbAction?){
        // 데이터가 올때마다 이 함수가 호출되는데 맨 처음에는 기본적으로 add라는 액션으로 데이터가 온다.
        self.fieldTableView.reloadData()  // 속도를 증가시키기 위해 action에 따라 개별적 코딩도 가능하다.
    }
    
    func receivingUserNotification(user: User?, action: DbAction?){
        self.user = user
        self.fieldTableView.reloadData()
    }
    
    
    
}

extension MakeFieldViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let fieldGroup = fieldGroup{
            return fieldGroup.getPostFields().count
        }
        return 0    // planGroup가 생성되기전에 호출될 수도 있다
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modifyUser = user?.clone()

      //  let cell = UITableViewCell(style: .value1, reuseIdentifier: "") // TableViewCell을 생성한다
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFieldTableViewCell")
        // planGroup는 대략 1개월의 플랜을 가지고 있다.
        let field = fieldGroup.getPostFields()[indexPath.row] // Date를 주지않으면 전체 plan을 가지고 온다

        let btn = (cell?.contentView.subviews[0] as! UIButton)
        (cell?.contentView.subviews[1] as! UILabel).text = field.name
        (cell?.contentView.subviews[2] as! UILabel).text = field.des
        
        
        let favoriteFields = modifyUser?.fields

        if((favoriteFields?.contains(field.key)) == false){
            print("is not contain")
            let image = UIImage(systemName: "star")
            btn.setImage(image, for: .normal)
        }else{
            print("is contain")
            let image = UIImage(systemName: "star.fill")
            btn.setImage(image, for: .normal)
        }

        return cell!
    }
}
extension MakeFieldViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFieldTableViewCell")
        let label = (cell?.contentView.subviews[2] as! UILabel)
        var lines = label.calculateMaxLines()
        var labelHeight = ("1" as! NSString).size(withAttributes: [NSAttributedString.Key.font : label.font]).height
        print(lines)
        return CGFloat(90 + Int(labelHeight)*lines)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        let field = fieldGroup.getPostFields()[indexPath.row]
        var modifyUer = user?.clone()

        var favoriteFields = modifyUer?.fields

        if((favoriteFields?.contains(field.key)) == false){
//            let alert = UIAlertController(title: "게시판을 즐겨찾기에 추가하시겠습니까?", message: field.name, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "추가", style: .default) { [self] action in
//                favoriteFields?.append(field.key)
//                print(modifyUser?.fields)
//
//                modifyUser?.fields = favoriteFields
//                print(modifyUser?.fields)
//                userGroup?.saveChange(user: modifyUser!, action: .Modify)
//
//            })
//            alert.addAction(UIAlertAction(title: "취소", style: .cancel){_ in })
//            self.present(alert, animated: true, completion: nil)
            print("즐겨찾기에 추가하시겠습니까?")
            favoriteFields?.append(field.key)
    //        print(modifyUser?.fields)

            modifyUer?.fields = favoriteFields
            userGroup?.saveChange(user: modifyUer!, action: .Modify)
            
        }else{
            print("즐겨찾기에서 해제하시겠습니까?")
            if let index = favoriteFields?.firstIndex(of: field.key){
                favoriteFields?.remove(at: index)
            }

            modifyUer?.fields = favoriteFields
            userGroup?.saveChange(user: modifyUer!, action: .Modify)
//            let alert = UIAlertController(title: "게시판을 즐겨찾기에서 해제하시겠습니까?", message: field.name, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "해제", style: .default) { [self] action in
//                if let index = favoriteFields?.firstIndex(of: field.key){
//                    favoriteFields?.remove(at: index)
//                }
//
//                modifyUser?.fields = favoriteFields
//                userGroup?.saveChange(user: modifyUser!, action: .Modify)
//            })
//            alert.addAction(UIAlertAction(title: "취소", style: .cancel){_ in  })
//            self.present(alert, animated: true, completion: nil)

        }
    }

}

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}

extension MakeFieldViewController{
    @IBAction func makeFieldAction(_ sender: UIBarButtonItem) {
        let svc = self.storyboard?.instantiateViewController(withIdentifier: "AddFieldViewController") as! AddFieldViewController
        svc.saveChangeDelegate = saveChange
        svc.postField = PostField(withData: false)

        navigationController?.pushViewController(svc, animated: true)
    }
}

extension MakeFieldViewController{
    func saveChange(postField: PostField?){
        if fieldTableView.indexPathForSelectedRow != nil {
            fieldGroup.saveChange(postField: postField!, action: .Modify)
        }else{
            fieldGroup.saveChange(postField: postField!, action: .Add)
        }
    }
}


