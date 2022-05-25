//
//  User.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/25.
//

import Foundation
import Firebase

class User: NSObject, NSCoding{

    var email: String;
    var name: String?;
    var password: String;
    var fields: [String]?
   
    var database: UserDatabase!
    var userParentNotification: ((User?, DbAction?) -> Void)?

    
    init(email:String, name:String, password:String,fields:[String]?, userParentNotification: ((User?, DbAction?) -> Void)?){
        self.email = email
        self.name = name
        self.password = password
        self.fields = fields
        
        super.init()
        
        self.userParentNotification = userParentNotification
      //  database = PostFieldDbMemory(postFieldParentNotification: receivingNotification) // 데이터베이스 생성
        database = UserFirebase(userParentNotification: receivingNotification)
       
    }
    func receivingNotification(user: User?, action: DbAction?){
        // 데이터베이스로부터 메시지를 받고 이를 부모에게 전달한다
        if let user = user{
            switch(action){    // 액션에 따라 적절히     plans에 적용한다
                case .Add: addUser(user: user)
                case .Modify: modifyUser(modifiedUser: user)
                case .Delete: removeUser(removeUser: user)
                default: break
            }
        }
        if let userParentNotification = userParentNotification{
            userParentNotification(user, action) // 역시 부모에게 알림내용을 전달한다.
        }
    }
    // archiving할때 호출된다
    func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey: "email")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(fields, forKey: "fields")
    }
    // unarchiving할때 호출된다
    required init(coder aDecoder: NSCoder) {
        email = aDecoder.decodeObject(forKey: "email") as! String? ?? ""
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        password = aDecoder.decodeObject(forKey: "password") as! String
        fields = aDecoder.decodeObject(forKey: "fields") as? [String]
        
        super.init()
    }

}

extension User{    // PlanGroup.swift
    
    func queryData(){
        email = ""
        name = ""
        password = ""
        fields = []
        
        database.queryUser()
    }
    
    func queryDataByEmail(email: String){
        self.email = ""
        name = ""
        password = ""
        fields = []
        
        database.queryUserByEmail(email: email)
    }
    
    func saveChange(user: User, action: DbAction){
        // 단순히 데이터베이스에 변경요청을 하고 plans에 대해서는
        // 데이터베이스가 변경알림을 호출하는 receivingNotification에서 적용한다
        database.saveUserChange(user: user, action: action)
    }
}

extension User{
    convenience init(withData: Bool = false){
        if withData == true{
            let emails = ["soojin@naver.com", "minsoo@hansung.ac.kr"]
            var index = Int(arc4random_uniform(UInt32(emails.count)))
            let email = emails[index]
            
            let passwords = ["123456", "1111"]
            index = Int(arc4random_uniform(UInt32(passwords.count)))
            let password = passwords[index]
        
            
            let names = ["홍길동", "이름 뭘로하지", "고양이 집사", "공대생1","미대생3","성북구 주민"]
            index = Int(arc4random_uniform(UInt32(names.count)))
            let name = names[index]
            
            self.init(email: email, name: name, password: password,      fields: ["자유 게시판"], userParentNotification:nil)
            
        }else{
            self.init(email: "", name: "", password: "",fields: [], userParentNotification:nil)

        }
    }
}

extension User{        // Plan.swift
    func clone() -> User {
        let clonee = User()

        clonee.email = self.email
        clonee.name = self.name
        clonee.password = self.password
        clonee.fields = self.fields
        
        return clonee
    }
}

extension User{
    private func addUser(user:User){
        
    }
    private func modifyUser(modifiedUser: User){
        
        
    }
    private func removeUser(removeUser: User){
       
        
    }
    
}

