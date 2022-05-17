//
//  Post.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/16.
//

import Foundation


class Post: NSObject /*, NSCoding*/{
    enum Kind: Int {
        case Todo = 0, Meeting, Study, Etc
        func toString() -> String{
            switch self {
                case .Todo: return "할일";     case .Meeting: return "미팅"
                case .Study: return "공부";    case .Etc: return "기타"
            }
        }
        static var count: Int { return Kind.Etc.rawValue + 1}
    }
    var key: String;        var date: Date
    var owner: String?;  // 게시글 작성자
    var title: String;      var kind: Kind
    var content: String;    var likes: Int
    var image: String;  
   
    
    init(date: Date, owner: String?,title:String, content: String,kind: Kind, likes:Int, image: String){
        self.key = UUID().uuidString   // 거의 unique한 id를 만들어 낸다.
        self.date = Date(timeInterval: 0, since: date)
        self.owner = owner;
        self.title = title
     //   self.owner = Owner.getOwner()
        self.kind = kind;
        self.content = content
        self.likes = likes
        self.image = image;
        super.init()
    }
}

extension Post{
    convenience init(date: Date? = nil, withData: Bool = false){
        if withData == true{
            var index = Int(arc4random_uniform(UInt32(Kind.count)))
            let kind = Kind(rawValue: index)! // 이것의 타입은 옵셔널이다. Option+click해보라
        
            let contents = ["이것은 내용입니다.", "이 문장이 다 보일까?", "랜덤 글쓰기 재미있다","고양이는 정말 귀여워"]
            index = Int(arc4random_uniform(UInt32(contents.count)))
            let content = contents[index]
            
            let titles = ["고양이 구경하세요", "이것은 제목입니다.","게시글 올리기", "가나다라마바사"]
            index = Int(arc4random_uniform(UInt32(titles.count)))
            let title = titles[index]
            
            let images = ["image1", "image2" ,""]
            index = Int(arc4random_uniform(UInt32(images.count)))
            let image = images[index]
            
            let likes = Int(arc4random_uniform(UInt32(30)))
            
            let owners = ["홍길동", "이름 뭘로하지", "고양이 집사", "공대생1","미대생3","성북구 주민"]
            index = Int(arc4random_uniform(UInt32(owners.count)))
            let owner = owners[index]
            
            self.init(date: date ?? Date(), owner: owner, title: title, content: content, kind: kind,likes: likes, image: image)
            
        }else{
            self.init(date: date ?? Date(), owner: "me", title: "", content: "", kind: .Etc,likes: 0, image: "")

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
        clonee.image = self.image
        
        return clonee
    }
}
