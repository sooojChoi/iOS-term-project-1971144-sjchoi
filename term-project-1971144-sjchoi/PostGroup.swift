//
//  PostGroup.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/16.
//

import Foundation

class PostGroup: NSObject{
    var posts = [Post]()            // var plans: [Plan] = []와 동일, 퀴리를 만족하는 plan들만 저장한다.
    var database: Database!
    var parentNotification: ((Post?, DbAction?) -> Void)?
    
    init(parentNotification: ((Post?, DbAction?) -> Void)? ){
        super.init()
        self.parentNotification = parentNotification
        //database = DbMemory(parentNotification: receivingNotification) // 데이터베이스 생성
        database = PostDbFirebase(parentNotification: receivingNotification)
    }
    func receivingNotification(post: Post?, action: DbAction?){
        // 데이터베이스로부터 메시지를 받고 이를 부모에게 전달한다
        if let post = post{
            switch(action){    // 액션에 따라 적절히     plans에 적용한다
                case .Add: addPost(post: post)
                case .Modify: modifyPost(modifiedPost: post)
                case .Delete: removePost(removedPost: post)
                default: break
            }
        }
        if let parentNotification = parentNotification{
            parentNotification(post, action) // 역시 부모에게 알림내용을 전달한다.
        }
    }
}

extension PostGroup{    // PlanGroup.swift
    
    func queryData(){
        posts.removeAll()    // 새로운 쿼리에 맞는 데이터를 채우기 위해 기존 데이터를 전부 지운다
       
        database.queryPost()
    }
    
    func saveChange(post: Post, action: DbAction){
        // 단순히 데이터베이스에 변경요청을 하고 plans에 대해서는
        // 데이터베이스가 변경알림을 호출하는 receivingNotification에서 적용한다
        database.saveChange(post: post, action: action)
    }
}
extension PostGroup{
    func getPosts(fieldTitle:String?) -> [Post] {
        
        // 해당 게시판의 글만 가져온다.
        if let fieldTitle = fieldTitle{
            var postForField: [Post] = []
            for post in posts{
                if post.kind == fieldTitle {
                    postForField.append(post)
                }
            }
            
            return postForField
        }
        return posts
    }
    
    func getPosts(userEmail:String?) -> [Post]{
        
        if let userEmail = userEmail{
            var postForUser: [Post] = []
            for post in posts{
                if post.userId == userEmail {
                    postForUser.append(post)
                }
            }
            
            return postForUser
        }
        return posts
    }
}
extension PostGroup{     // PlanGroup.swift
    
    private func count() -> Int{ return posts.count }
    
   
    
    private func find(_ key: String) -> Int?{
        for i in 0..<posts.count{
            if key == posts[i].key{
                return i
            }
        }
        return nil
    }
}
extension PostGroup{
    private func addPost(post:Post){
       // posts.append(post)
        posts.insert(post, at: 0)
        
    }
    private func modifyPost(modifiedPost: Post){
        if let index = find(modifiedPost.key){
            posts[index] = modifiedPost
        }
    }
    private func removePost(removedPost: Post){
        if let index = find(removedPost.key){
            posts.remove(at: index)
        }
    }
    func changePost(from: Post, to: Post){
        if let fromIndex = find(from.key), let toIndex = find(to.key) {
            posts[fromIndex] = to
            posts[toIndex] = from
        }
    }
}
