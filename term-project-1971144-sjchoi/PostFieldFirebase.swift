//
//  PostFieldFirebase.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/25.
//

import Foundation
import Firebase


class PostFieldFirebase: PostFieldDatabase {

    var findName:String?
    
    var reference: CollectionReference                    // firestore에서 데이터베이스 위치
    var postFieldParentNotification: ((PostField?, DbAction?) -> Void)? // PlanGroupViewController에서 설정
    var existQuery: ListenerRegistration?
    

    required init(postFieldParentNotification: ((PostField?, DbAction?) -> Void)?) {
        self.postFieldParentNotification = postFieldParentNotification
                reference = Firestore.firestore().collection("postFields") // 첫번째 "posts"라는 Collection

    }
    
    func queryPostField() {
        if let existQuery = existQuery{    // 이미 적용 쿼리가 있으면 제거, 중복 방지
            existQuery.remove()
        }
        
        existQuery = reference.addSnapshotListener(onChangingData)
    }
    
    func queryPostFieldByName(name: String) {
        if let existQuery = existQuery{    // 이미 적용 쿼리가 있으면 제거, 중복 방지
            existQuery.remove()
        }

        findName = name
        // onChangingData는 쿼리를 만족하는 데이터가 있거나 firestore내에서 다른 앱에 의하여
        // 데이터가 변경되어 쿼리를 만족하는 데이터가 발생하면 호출해 달라는 것이다.
        existQuery = reference.addSnapshotListener(onChangingDataByName)
    }
    
    func saveFieldChange(postField: PostField, action: DbAction){
        if action == .Delete{
            reference.document(postField.key).delete()    // key로된 plan을 지운다
            return
        }
        // plan을 아카이빙한다.
        let data = try? NSKeyedArchiver.archivedData(withRootObject: postField, requiringSecureCoding: false)

        // 저장 형태로 만든다
        let storeDate: [String : Any] = ["name":postField.name ?? "", "data": data!]
        reference.document().setData(storeDate)
    }
    
}

extension PostFieldFirebase{
    func onChangingData(querySnapshot: QuerySnapshot?, error: Error?){
        guard let querySnapshot = querySnapshot else{ return }
        // 초기 데이터가 하나도 없는 경우에 count가 0이다
        if(querySnapshot.documentChanges.count <= 0){
            if let postFieldParentNotification = postFieldParentNotification { postFieldParentNotification(nil, nil)} // 부모에게 알림
        }
        // 쿼리를 만족하는 데이터가 많은 경우 한꺼번에 여러 데이터가 온다
        for documentChange in querySnapshot.documentChanges {
            let data = documentChange.document.data() //["date": date, "data": data!]로 구성되어 있다
            // [“data”: data]에서 data는 아카이빙되어 있으므로 언아카이빙이 필요
            let postField = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data["data"] as! Data) as? PostField
            var action: DbAction?
            switch(documentChange.type){    // 단순히 DbAction으로 설정
                case    .added: action = .Add
                case    .modified: action = .Modify
                case    .removed: action = .Delete
            }
            if let postFieldParentNotification = postFieldParentNotification {postFieldParentNotification(postField, action)} // 부모에게 알림
        }
    }
    
    func onChangingDataByName(querySnapshot: QuerySnapshot?, error: Error?){
        guard let querySnapshot = querySnapshot else{ return }
        // 초기 데이터가 하나도 없는 경우에 count가 0이다
        if(querySnapshot.documentChanges.count <= 0){
            if let postFieldParentNotification = postFieldParentNotification { postFieldParentNotification(nil, nil)} // 부모에게 알림
        }
        // 쿼리를 만족하는 데이터가 많은 경우 한꺼번에 여러 데이터가 온다
        for documentChange in querySnapshot.documentChanges {
            let data = documentChange.document.data() //["date": date, "data": data!]로 구성되어 있다
            // [“data”: data]에서 data는 아카이빙되어 있으므로 언아카이빙이 필요
            let postField = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data["data"] as! Data) as? PostField
            if(postField?.name?.contains(findName ?? "") == true){
                var action: DbAction?
                switch(documentChange.type){    // 단순히 DbAction으로 설정
                    case    .added: action = .Add
                    case    .modified: action = .Modify
                    case    .removed: action = .Delete
                }
                if let postFieldParentNotification = postFieldParentNotification {postFieldParentNotification(postField, action)} // 부모에게 알림
            }
            
            
        }
    }
}
