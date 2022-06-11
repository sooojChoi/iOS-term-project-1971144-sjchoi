//
//  LikeDbFirebase.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/06/12.
//

import Foundation
import Firebase

class LikeDbFirebase: LikeDatabase{
    var reference: CollectionReference
    var likeParentNotification: ((Like?, DbAction?) -> Void)?
    var existQuery: ListenerRegistration?
    
    var findEmail:String?
    
    required init(likeParentNotification: ((Like?, DbAction?) -> Void)?) {
        self.likeParentNotification = likeParentNotification
        reference = Firestore.firestore().collection("likes")

    }
    
    func queryLike() {
        if let existQuery = existQuery{    // 이미 적용 쿼리가 있으면 제거, 중복 방지
            existQuery.remove()
        }
       // let queryReference = reference.order(by: "date", descending: false)
        // onChangingData는 쿼리를 만족하는 데이터가 있거나 firestore내에서 다른 앱에 의하여
        // 데이터가 변경되어 쿼리를 만족하는 데이터가 발생하면 호출해 달라는 것이다.
        existQuery = reference.addSnapshotListener(onChangingData)
        
    }
    
    func queryLikeByUserEmail(email: String) {
        if let existQuery = existQuery{    // 이미 적용 쿼리가 있으면 제거, 중복 방지
            existQuery.remove()
        }
        findEmail = email
       // let queryReference = reference.order(by: "date", descending: false)
        // onChangingData는 쿼리를 만족하는 데이터가 있거나 firestore내에서 다른 앱에 의하여
        // 데이터가 변경되어 쿼리를 만족하는 데이터가 발생하면 호출해 달라는 것이다.
        existQuery = reference.addSnapshotListener(onChangingDataByEmail)
        
    }
    
    func saveLikeChange(like: Like, action: DbAction) {
        if action == .Delete{
            reference.document(like.key).delete()
            return
        }
       
        let data = try? NSKeyedArchiver.archivedData(withRootObject: like, requiringSecureCoding: false)

        // 저장 형태로 만든다
        let storeDate: [String : Any] = ["data": data!]
        reference.document(like.key).setData(storeDate)
        
       
    }
}

extension LikeDbFirebase{
    func onChangingData(querySnapshot: QuerySnapshot?, error: Error?){
        guard let querySnapshot = querySnapshot else{ return }
        // 초기 데이터가 하나도 없는 경우에 count가 0이다
        if(querySnapshot.documentChanges.count <= 0){
            if let likeParentNotification = likeParentNotification { likeParentNotification(nil, nil)} // 부모에게 알림
        }
        // 쿼리를 만족하는 데이터가 많은 경우 한꺼번에 여러 데이터가 온다
        for documentChange in querySnapshot.documentChanges {
            let data = documentChange.document.data() //["date": date, "data": data!]로 구성되어 있다
            // [“data”: data]에서 data는 아카이빙되어 있으므로 언아카이빙이 필요
            let like = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data["data"] as! Data) as? Like
            var action: DbAction?
            switch(documentChange.type){    // 단순히 DbAction으로 설정
                case    .added: action = .Add
                case    .modified: action = .Modify
                case    .removed: action = .Delete
            }
            if let likeParentNotification = likeParentNotification {
                likeParentNotification(like, action)} // 부모에게 알림
        }
    }
    
    func onChangingDataByEmail(querySnapshot: QuerySnapshot?, error: Error?){
        guard let querySnapshot = querySnapshot else{ return }
        // 초기 데이터가 하나도 없는 경우에 count가 0이다
        if(querySnapshot.documentChanges.count <= 0){
            if let likeParentNotification = likeParentNotification { likeParentNotification(nil, nil)} // 부모에게 알림
        }
        // 쿼리를 만족하는 데이터가 많은 경우 한꺼번에 여러 데이터가 온다
        for documentChange in querySnapshot.documentChanges {
            let data = documentChange.document.data() //["date": date, "data": data!]로 구성되어 있다
            // [“data”: data]에서 data는 아카이빙되어 있으므로 언아카이빙이 필요
            let like = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data["data"] as! Data) as? Like
            if(like?.userEmail == findEmail){
                var action: DbAction?
                switch(documentChange.type){    // 단순히 DbAction으로 설정
                    case    .added: action = .Add
                    case    .modified: action = .Modify
                    case    .removed: action = .Delete
                }
                if let likeParentNotification = likeParentNotification {
                    likeParentNotification(like, action)} // 부모에게 알림
            }
           
        }
    }
    
}
