//
//  User.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/25.
//

import Foundation


class User: NSObject, NSCoding{
    var key: String;
    var email: String;
    var name: String?;
    var password: String;
    var fields: [String]?
   
    init(email:String, name:String, password:String,fields:[String]?){
        self.key = UUID().uuidString   // 거의 unique한 id를 만들어 낸다.
        self.email = email
        self.name = name
        self.password = password
        self.fields = fields
        
        super.init() 
    }
    
    // archiving할때 호출된다
    func encode(with aCoder: NSCoder) {
        aCoder.encode(key, forKey: "key")       // 내부적으로 String의 encode가 호출된다
        aCoder.encode(email, forKey: "email")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(fields, forKey: "fields")
    }
    // unarchiving할때 호출된다
    required init(coder aDecoder: NSCoder) {
        key = aDecoder.decodeObject(forKey: "key") as! String? ?? "" // 내부적으로 String.init가 호출된다
        email = aDecoder.decodeObject(forKey: "email") as! String? ?? ""
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        password = aDecoder.decodeObject(forKey: "password") as! String
        fields = aDecoder.decodeObject(forKey: "fields") as? [String]
        
        super.init()
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
            
            self.init(email: email, name: name, password: password,      fields: ["자유 게시판"])
            
        }else{
            self.init(email: "", name: "", password: "",fields: [])

        }
    }
}

extension User{    
    func clone() -> User {
        let clonee = User()

        clonee.key = self.key
        clonee.email = self.email
        clonee.name = self.name
        clonee.password = self.password
        clonee.fields = self.fields
        
        return clonee
    }
}

