//
//  CommentGroup.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/06/01.
//

import Foundation

class CommentGroup: NSObject{
    var comments = [Comment]()            // var plans: [Plan] = []와 동일, 퀴리를 만족하는 plan들만 저장한다.
    var database: CommentDatabase!
    var commentParentNotification: ((Comment?, DbAction?) -> Void)?
    
    init(commentParentNotification: ((Comment?, DbAction?) -> Void)? ){
        super.init()
        self.commentParentNotification = commentParentNotification
       // database = PostDbFirebase(commentParentNotification: receivingNotification)
    }
    func receivingNotification(comment: Comment?, action: DbAction?){
        // 데이터베이스로부터 메시지를 받고 이를 부모에게 전달한다
        if let comment = comment{
            switch(action){    // 액션에 따라 적절히     plans에 적용한다
                case .Add: addComment(comment: comment)
                case .Modify: modifyComment(modifiedComment: comment)
                case .Delete: removeComment(removedComment: comment)
                default: break
            }
        }
        if let commentParentNotification = commentParentNotification{
            commentParentNotification(comment, action) // 역시 부모에게 알림내용을 전달한다.
        }
    }
}

extension CommentGroup{    // PlanGroup.swift
    
    func queryData(){
        comments.removeAll()    // 새로운 쿼리에 맞는 데이터를 채우기 위해 기존 데이터를 전부 지운다
        
        database.queryComment()
    }
    
    func queryDataByPostId(id: String){
        comments.removeAll()
        
        database.queryCommentByPostId(id: id)
    }
    
    func saveChange(comment: Comment, action: DbAction){
        // 단순히 데이터베이스에 변경요청을 하고 plans에 대해서는
        // 데이터베이스가 변경알림을 호출하는 receivingNotification에서 적용한다
        database.saveCommentChange(comment: comment, action: action)
    }
}
extension CommentGroup{     // PlanGroup.swift
    func getComments(postId :String?) -> [Comment] {
        
        // 해당 게시판의 댓글만 가져온다.
        if let postId = postId{
            var commentForPost: [Comment] = []
            for comment in comments{
                if comment.postId == postId {
                    commentForPost.append(comment)
                }
            }
            
            return commentForPost
        }
        
        return comments
    }
}
extension CommentGroup{     // PlanGroup.swift
    
    private func count() -> Int{ return comments.count }
    
   
    
    private func find(_ key: String) -> Int?{
        for i in 0..<comments.count{
            if key == comments[i].key{
                return i
            }
        }
        return nil
    }
}
extension CommentGroup{
    private func addComment(comment:Comment){ comments.append(comment) }
    private func modifyComment(modifiedComment: Comment){
        if let index = find(modifiedComment.key){
            comments[index] = modifiedComment
        }
    }
    private func removeComment(removedComment: Comment){
        if let index = find(removedComment.key){
            comments.remove(at: index)
        }
    }
    
}

