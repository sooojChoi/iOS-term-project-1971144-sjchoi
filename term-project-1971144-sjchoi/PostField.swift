//
//  PostField.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/18.
//

import Foundation

// (name, description, sort, userId)
class PostField: NSObject , NSCoding{
   
    var key: String;
    var name: String?; // 게시판 이름
    var des: String;  // 게시판 설명
    var userId: String; // 게시판을 생성한 사용자 아이디
   
    
    init(name: String, des: String,  userId:String){
        self.key = UUID().uuidString   // 거의 unique한 id를 만들어 낸다.
        self.name = name
        self.des = des
        self.userId = userId
        super.init()
    }
    
    // archiving할때 호출된다
    func encode(with aCoder: NSCoder) {
        aCoder.encode(key, forKey: "key")       // 내부적으로 String의 encode가 호출된다
        aCoder.encode(name, forKey: "name")
        aCoder.encode(des, forKey: "des")
        aCoder.encode(userId, forKey: "userId")
    }
    // unarchiving할때 호출된다
    required init(coder aDecoder: NSCoder) {
        key = aDecoder.decodeObject(forKey: "key") as! String? ?? "" // 내부적으로 String.init가 호출된다
        name = aDecoder.decodeObject(forKey: "name") as? String
        des = aDecoder.decodeObject(forKey: "des") as? String ?? ""
        userId = aDecoder.decodeObject(forKey: "userId") as? String ?? ""
    
        super.init()
    }

}

extension PostField{
    convenience init(withData: Bool = false){
        self.init(name: "", des: "", userId: "")
    }
}


extension PostField{        // Plan.swift
    func clone() -> PostField {
        let clonee = PostField(name: "", des: "", userId: "")

        clonee.key = self.key    // key는 String이고 String은 struct이다. 따라서 복제가 된다
        clonee.name = self.name
        clonee.des = self.des
        clonee.userId = self.userId
        
        return clonee
    }
}
