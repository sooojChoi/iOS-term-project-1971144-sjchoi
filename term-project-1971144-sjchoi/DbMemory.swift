//
//  DbMemory.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/16.
//

import Foundation

class DbMemory: Database {
    
    private var storage: [Post]  // 데이터 저장고

    // storgae내의 데이터변화가 있으면 이 함수를 호출해야 함
    var parentNotification: ((Post?, DbAction?) -> Void)?
    
    // required라는 것은 이 클래스가 Database를 만족하여야 하기 때문임, see Database
    required init(parentNotification: ((Post?, DbAction?) -> Void)?) {

        self.parentNotification = parentNotification // nil일 수도 있다

        storage = []
        let amount = 15
        for _ in 0...amount{
            let delta = Int(arc4random_uniform(UInt32(amount))) - amount/2
            let date = Date(timeInterval: TimeInterval(delta*24*60*60), since: Date())
            storage.append(Post(date: date, withData: true))
            print("새로 추가")
        }
    }
    

}

extension DbMemory{    // DbMemory.swift
    // 이 함수는 fromDate~toDate사이의 플랜을 찾아서 리턴한다.
    // 재미있는 것은 찾아서 전부 한거번에 리턴하는 것이 아니라
    // parentNotification에게 한번에 1개씩 전해준다
    func queryPost() {
        
        for i in 0..<storage.count{
            if let parentNotification = parentNotification{
                parentNotification(storage[i], .Add) // 한개씩 여러번 전달한다
            }
        }
    }
}

extension DbMemory{// DbMemory.swift
    // 주어진 플랜에 대하여 삽입, 수정, 삭제를 storage에서 하고
    // 역시 parentListener를 호출하여 이러한 사실을 알린다.
    func saveChange(post: Post, action: DbAction){
        if action == .Add{
            storage.append(post)
        }else{
            for i in 0..<storage.count{
                if post.key == storage[i].key{
                    if action == .Delete{ storage.remove(at: i) }
                    if action == .Modify{ storage[i] = post }
                    break
                }
            }
        }
        if let parentNotification = parentNotification{
            parentNotification(post, action)  // 변경된 내역을 알려준다
        }
    }
}


class PostFieldDbMemory: PostFieldDatabase{
    private var fieldStorage: [PostField]
    // storgae내의 데이터변화가 있으면 이 함수를 호출해야 함
    var postFieldParentNotification: ((PostField?, DbAction?) -> Void)?
    
    //     required라는 것은 이 클래스가 Database를 만족하여야 하기 때문임, see Database
    required init(postFieldParentNotification: ((PostField?, DbAction?) -> Void)?) {

        self.postFieldParentNotification = postFieldParentNotification // nil일 수도 있다

        fieldStorage = []

        fieldStorage.append(PostField(name: "자유게시판", des: "어떤 글이라도 자유롭게 작성할 수 있는 게시판입니다.", sort: "기타", userId: "홍길동"))
        fieldStorage.append(PostField(name: "고양이 게시판", des: "고양이를 사랑하는 사람들을 위한 게시판입니다.", sort: "동물", userId: "김민수"))
        fieldStorage.append(PostField(name: "스터디 게시판", des: "함께 스터디를 할 사람을 구인하고, 공부 관련해서 자유롭게 글을 작성할 수 있는 게시판입니다.", sort: "공부", userId: "김철수"))
        fieldStorage.append(PostField(name: "성북구 주민 게시판", des: "성북구에 대한 자유로운 이야기를 나눌 수 있는 게시판입니다.", sort: "기타", userId: "닉네임"))

    }
}

extension PostFieldDbMemory{
    func queryPostField() {
        for i in 0..<fieldStorage.count{
            if let postFieldParentNotification = postFieldParentNotification{
                postFieldParentNotification(fieldStorage[i], .Add) // 한개씩 여러번 전달한다
            }
        }
    }
    
    func saveFieldChange(postField: PostField, action: DbAction) {
        if action == .Add{
            fieldStorage.append(postField)
        }else{
            for i in 0..<fieldStorage.count{
                if postField.key == fieldStorage[i].key{
                    if action == .Delete{ fieldStorage.remove(at: i) }
                    if action == .Modify{ fieldStorage[i] = postField }
                    break
                }
            }
        }
        if let postFieldParentNotification = postFieldParentNotification{
            postFieldParentNotification(postField, action)  // 변경된 내역을 알려준다
        }
    }
}
