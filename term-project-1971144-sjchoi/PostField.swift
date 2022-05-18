//
//  PostField.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/18.
//

import Foundation

// (name, description, sort, userId)
class PostField: NSObject /*, NSCoding*/{
   
    var key: String;
    var name: String?; // 게시판 이름
    var des: String;  // 게시판 설명
    var sort: String; // 게시판 종류
    var userId: String; // 게시판을 생성한 사용자 아이디
   
    
    init(name: String, des: String, sort: String, userId:String){
        self.key = UUID().uuidString   // 거의 unique한 id를 만들어 낸다.
        self.name = name
        self.des = des
        self.sort = sort
        self.userId = userId
        super.init()
    }
}


extension PostField{        // Plan.swift
    func clone() -> PostField {
        let clonee = PostField(name: "", des: "", sort: "", userId: "")

        clonee.key = self.key    // key는 String이고 String은 struct이다. 따라서 복제가 된다
        clonee.name = self.name
        clonee.des = self.des
        clonee.sort = self.sort
        clonee.userId = self.userId
        
        return clonee
    }
}
