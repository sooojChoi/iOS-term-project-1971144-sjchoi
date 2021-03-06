//
//  CommentDbFirebase.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/06/01.
//

import Foundation
import Firebase

class CommentFirebase: CommentDatabase {

    var findPostId:String?
    
    var reference: CollectionReference                    // firestore에서 데이터베이스 위치
    var commentParentNotification: ((Comment?, DbAction?) -> Void)? // PlanGroupViewController에서 설정
    var existQuery: ListenerRegistration?
    

    required init(commentParentNotification: ((Comment?, DbAction?) -> Void)?) {
        self.commentParentNotification = commentParentNotification
                reference = Firestore.firestore().collection("comments")

    }
    
    func queryComment() {
        if let existQuery = existQuery{    // 이미 적용 쿼리가 있으면 제거, 중복 방지
            existQuery.remove()
        }
        let queryReference = reference.order(by: "date", descending: false)
        existQuery = queryReference.addSnapshotListener(onChangingData)
    }
    
    func queryCommentByPostId(id: String) {
        if let existQuery = existQuery{    // 이미 적용 쿼리가 있으면 제거, 중복 방지
            existQuery.remove()
        }

        findPostId = id
        let queryReference = reference.order(by: "date", descending: false)

        existQuery = queryReference.addSnapshotListener(onChangingDataByPostId)
    }
    
    
    func saveCommentChange(comment: Comment, action: DbAction){
        if action == .Delete{
            reference.document(comment.key).delete()    // key로된 plan을 지운다
            return
        }
        // plan을 아카이빙한다.
        let data = try? NSKeyedArchiver.archivedData(withRootObject: comment, requiringSecureCoding: false)

        // 저장 형태로 만든다
        let storeDate: [String : Any] = ["date":comment.date , "data": data!]
        reference.document(comment.key).setData(storeDate)
    }
    
}

extension CommentFirebase{
    func onChangingData(querySnapshot: QuerySnapshot?, error: Error?){
        guard let querySnapshot = querySnapshot else{ return }
        // 초기 데이터가 하나도 없는 경우에 count가 0이다
        if(querySnapshot.documentChanges.count <= 0){
            if let commentParentNotification = commentParentNotification { commentParentNotification(nil, nil)} // 부모에게 알림
        }
        // 쿼리를 만족하는 데이터가 많은 경우 한꺼번에 여러 데이터가 온다
        for documentChange in querySnapshot.documentChanges {
            let data = documentChange.document.data() //["date": date, "data": data!]로 구성되어 있다
            // [“data”: data]에서 data는 아카이빙되어 있으므로 언아카이빙이 필요
            let comment = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data["data"] as! Data) as? Comment
            var action: DbAction?
            switch(documentChange.type){    // 단순히 DbAction으로 설정
                case    .added: action = .Add
                case    .modified: action = .Modify
                case    .removed: action = .Delete
            }
            if let commentParentNotification = commentParentNotification {commentParentNotification(comment, action)} // 부모에게 알림
        }
    }
    
    func onChangingDataByPostId(querySnapshot: QuerySnapshot?, error: Error?){
        guard let querySnapshot = querySnapshot else{ return }
        // 초기 데이터가 하나도 없는 경우에 count가 0이다
        if(querySnapshot.documentChanges.count <= 0){
            if let commentParentNotification = commentParentNotification { commentParentNotification(nil, nil)} // 부모에게 알림
        }
        // 쿼리를 만족하는 데이터가 많은 경우 한꺼번에 여러 데이터가 온다
        for documentChange in querySnapshot.documentChanges {
            let data = documentChange.document.data() //["date": date, "data": data!]로 구성되어 있다
            // [“data”: data]에서 data는 아카이빙되어 있으므로 언아카이빙이 필요
            let comment = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data["data"] as! Data) as? Comment
            if(comment?.postId == findPostId){
                print("댓글 있다.")
                var action: DbAction?
                switch(documentChange.type){    // 단순히 DbAction으로 설정
                    case    .added: action = .Add
                    case    .modified: action = .Modify
                    case    .removed: action = .Delete
                }
                if let commentParentNotification = commentParentNotification {commentParentNotification(comment, action)} // 부모에게 알림
            }
            
            
        }
    }
    
    
}

