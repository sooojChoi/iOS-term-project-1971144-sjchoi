//
//  PostDbFirebase.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/24.
//

import Foundation
import Firebase

class PostDbFirebase: Database {
    
    var reference: CollectionReference                    
    var parentNotification: ((Post?, DbAction?) -> Void)?
    var existQuery: ListenerRegistration?
    

    required init(parentNotification: ((Post?, DbAction?) -> Void)?) {
        self.parentNotification = parentNotification
        reference = Firestore.firestore().collection("posts") // 첫번째 "posts"라는 Collection

    }
    
    func queryPost() {
        print("query post is called")
        if let existQuery = existQuery{    // 이미 적용 쿼리가 있으면 제거, 중복 방지
            existQuery.remove()
        }
        let queryReference = reference.order(by: "date", descending: false)
        // onChangingData는 쿼리를 만족하는 데이터가 있거나 firestore내에서 다른 앱에 의하여
        // 데이터가 변경되어 쿼리를 만족하는 데이터가 발생하면 호출해 달라는 것이다.
        existQuery = queryReference.addSnapshotListener(onChangingData)
        

    }

    func saveChange(post: Post, action: DbAction){
        if action == .Delete{
            reference.document(post.key).delete()    // key로된 plan을 지운다
            return
        }
        
        let data = try? NSKeyedArchiver.archivedData(withRootObject: post, requiringSecureCoding: false)

        // 저장 형태로 만든다
        let storeDate: [String : Any] = ["date": post.date, "data": data!]
        reference.document(post.key).setData(storeDate)
        
       
    }
    
}

extension PostDbFirebase{
    func onChangingData(querySnapshot: QuerySnapshot?, error: Error?){
        guard let querySnapshot = querySnapshot else{ return }
        // 초기 데이터가 하나도 없는 경우에 count가 0이다
        if(querySnapshot.documentChanges.count <= 0){
            if let parentNotification = parentNotification { parentNotification(nil, nil)} // 부모에게 알림
        }
        // 쿼리를 만족하는 데이터가 많은 경우 한꺼번에 여러 데이터가 온다
        for documentChange in querySnapshot.documentChanges {
            let data = documentChange.document.data() //["date": date, "data": data!]로 구성되어 있다
            // [“data”: data]에서 data는 아카이빙되어 있으므로 언아카이빙이 필요
            let post = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data["data"] as! Data) as? Post
            var action: DbAction?
            switch(documentChange.type){    // 단순히 DbAction으로 설정
                case    .added: action = .Add
                case    .modified: action = .Modify
                case    .removed: action = .Delete
            }
            if let parentNotification = parentNotification {parentNotification(post, action)} // 부모에게 알림
        }
    }
}
