//
//  Comment.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/24.
//

import Foundation


class Comment: NSObject, NSCoding {
//  Comment (id, userId, postId, contents, likes, date)
    var key: String;        var date: Date
    var userId: String;
    var userName: String;
    var postId: String;
    var contents: String;
    
   
    
    init(date: Date, userId: String,userName:String, postId:String, contents: String){
        self.key = UUID().uuidString   // 거의 unique한 id를 만들어 낸다.
        self.date = Date(timeInterval: 0, since: date)
        self.userId = userId
        self.postId = postId
        self.contents = contents
        self.userName = userName
        
        super.init()
    }
    
    // archiving할때 호출된다
    func encode(with aCoder: NSCoder) {
        aCoder.encode(key, forKey: "key")       // 내부적으로 String의 encode가 호출된다
        aCoder.encode(date, forKey: "date")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(postId, forKey: "kind")
        aCoder.encode(contents, forKey: "contents")
        aCoder.encode(userName, forKey: "userName")
    }
    // unarchiving할때 호출된다
    required init(coder aDecoder: NSCoder) {
        key = aDecoder.decodeObject(forKey: "key") as! String? ?? "" // 내부적으로 String.init가 호출된다
        date = aDecoder.decodeObject(forKey: "date") as! Date
        userId = aDecoder.decodeObject(forKey: "userId") as? String ?? ""
        postId = aDecoder.decodeObject(forKey: "postId") as? String ?? ""
        contents = aDecoder.decodeObject(forKey: "contents") as? String ?? ""
        userName = aDecoder.decodeObject(forKey: "userName") as? String ?? ""
 
        super.init()
    }
}

extension Comment{
    convenience init(withData: Bool = false){
        if withData == true{
        
            let contents = ["이것은 댓글입니다.","가나다라마바사아자차카타파하 이것은 정말 긴 댓글쓰기를 테스트하는 중입니다.","가나다라마바사아자차카타파하 이것은 정말 긴 글쓰기를 테스트하는 중입니다.","가나다라마바사아자차카타파하 이것은 정말 긴 글쓰기를 테스트하는 중입니다.", "랜덤 글쓰기 재미있다","고양이는 정말 귀여워"]
            var index = Int(arc4random_uniform(UInt32(contents.count)))
            let content = contents[index]
            
            
            let owners = ["홍길동", "이름 뭘로하지", "고양이 집사", "공대생1","미대생3","성북구 주민"]
            index = Int(arc4random_uniform(UInt32(owners.count)))
            let userId = owners[index]
            
            let postIds = ["postId1", "postId2", "postId3", "postId4"]
            index = Int(arc4random_uniform(UInt32(postIds.count)))
            let postId = postIds[index]
            
            self.init(date: Date(), userId: userId, userName: "김철수",postId:postId, contents:content)
            
        }else{
            self.init(date: Date(), userId: "", userName:"",postId:"", contents:"")

        }
    }
}

extension Comment{     
    func clone() -> Comment {
        let clonee = Comment()

        clonee.key = self.key    // key는 String이고 String은 struct이다. 따라서 복제가 된다
        clonee.date = Date(timeInterval: 0, since: self.date) // Date는 struct가 아니라 class이기 때문
        clonee.userId = self.userId
        clonee.postId = self.postId
        clonee.contents = self.contents
        clonee.userName = self.userName
        
        return clonee
    }
}
