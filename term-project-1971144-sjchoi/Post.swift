//
//  Post.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/16.
//

import Foundation


class Post: NSObject, NSCoding{
//    enum Kind: Int {
//        case Todo = 0, Meeting, Study, Etc
//        func toString() -> String{
//            switch self {
//                case .Todo: return "할일";     case .Meeting: return "미팅"
//                case .Study: return "공부";    case .Etc: return "기타"
//            }
//        }
//        static var count: Int { return Kind.Etc.rawValue + 1}
//    }
    var key: String;        var date: Date
    var owner: String?;  // 게시글 작성자
    var title: String;     // var kind: Kind
    var content: String;    var likes: Int
       var kind: String;
    var numOfComments:Int;
   
    
    init(date: Date, owner: String?,title:String, content: String,kind: String, likes:Int, numOfComments: Int){
        self.key = UUID().uuidString   // 거의 unique한 id를 만들어 낸다.
        self.date = Date(timeInterval: 0, since: date)
        self.owner = owner;
        self.title = title
     //   self.owner = Owner.getOwner()
        self.kind = kind;
        self.content = content
        self.likes = likes
   
        self.numOfComments = numOfComments;
        super.init()
    }
    
    // archiving할때 호출된다
    func encode(with aCoder: NSCoder) {
        aCoder.encode(key, forKey: "key")       // 내부적으로 String의 encode가 호출된다
        aCoder.encode(date, forKey: "date")
        aCoder.encode(owner, forKey: "owner")
        aCoder.encode(kind, forKey: "kind")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(likes, forKey: "likes")
        aCoder.encode(numOfComments, forKey: "numOfComments")
        aCoder.encode(title, forKey: "title")
    }
    // unarchiving할때 호출된다
    required init(coder aDecoder: NSCoder) {
        key = aDecoder.decodeObject(forKey: "key") as! String? ?? "" // 내부적으로 String.init가 호출된다
        date = aDecoder.decodeObject(forKey: "date") as! Date
        owner = aDecoder.decodeObject(forKey: "owner") as? String
        kind = aDecoder.decodeObject(forKey: "kind") as? String ?? ""
        title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        content = aDecoder.decodeObject(forKey: "content") as! String? ?? ""
        likes = aDecoder.decodeObject(forKey: "likes") as? Int ?? 0
        numOfComments = aDecoder.decodeObject(forKey: "numOfComments") as? Int ?? 0
        
        super.init()
    }

}

extension Post{
    convenience init(withData: Bool = false){
        if withData == true{
            let kinds = ["자유게시판", "고양이 게시판", "스터디 게시판", "성북구 주민 게시판"]
            var index = Int(arc4random_uniform(UInt32(kinds.count)))
            let kind = kinds[index] // 이것의 타입은 옵셔널이다. Option+click해보라
        
            let contents = ["이것은 내용입니다.","가나다라마바사아자차카타파하 이것은 정말 긴 글쓰기를 테스트하는 중입니다.","가나다라마바사아자차카타파하 이것은 정말 긴 글쓰기를 테스트하는 중입니다.","가나다라마바사아자차카타파하 이것은 정말 긴 글쓰기를 테스트하는 중입니다.", "랜덤 글쓰기 재미있다","고양이는 정말 귀여워"]
            index = Int(arc4random_uniform(UInt32(contents.count)))
            let content = contents[index]
            
            let titles = ["고양이 구경하세요", "이것은 제목입니다.", "가나다라마바사아자차카타파하 이것은 정말 긴 제목을 테스트하는 중입니다.", "가나다라마바사아자차카타파하 이것은 정말 긴 제목을 테스트하는 중입니다."]
            index = Int(arc4random_uniform(UInt32(titles.count)))
            let title = titles[index]
            
            
            let likes = Int(arc4random_uniform(UInt32(30)))
            
            let owners = ["홍길동", "이름 뭘로하지", "고양이 집사", "공대생1","미대생3","성북구 주민"]
            index = Int(arc4random_uniform(UInt32(owners.count)))
            let owner = owners[index]
            
            self.init(date: Date(), owner: owner, title: title, content: content, kind: kind,likes: likes,  numOfComments: 0)
            
        }else{
            self.init(date: Date(), owner: "me", title: "", content: "", kind: "",likes: 0, numOfComments: 0)

        }
    }
}

extension Post{        // Plan.swift
    func clone() -> Post {
        let clonee = Post()

        clonee.key = self.key    // key는 String이고 String은 struct이다. 따라서 복제가 된다
        clonee.date = Date(timeInterval: 0, since: self.date) // Date는 struct가 아니라 class이기 때문
        clonee.owner = self.owner
        clonee.title = self.title
        clonee.kind = self.kind    // enum도 struct처럼 복제가 된다
        clonee.content = self.content
        clonee.likes = self.likes
        clonee.numOfComments = self.numOfComments
        
        return clonee
    }
}
