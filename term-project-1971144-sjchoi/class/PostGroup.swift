//
//  PostGroup.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/16.
//

import Foundation

class PostGroup: NSObject{
    var posts = [Post]()
    var database: Database!
    var parentNotification: ((Post?, DbAction?) -> Void)?
    
    init(parentNotification: ((Post?, DbAction?) -> Void)? ){
        super.init()
        self.parentNotification = parentNotification
        database = PostDbFirebase(parentNotification: receivingNotification)
    }
    func receivingNotification(post: Post?, action: DbAction?){
        if let post = post{
            switch(action){
                case .Add: addPost(post: post)
                case .Modify: modifyPost(modifiedPost: post)
                case .Delete: removePost(removedPost: post)
                default: break
            }
        }
        if let parentNotification = parentNotification{
            parentNotification(post, action)
        }
    }
}

extension PostGroup{
    
    func queryData(){
        posts.removeAll()
       
        database.queryPost()
    }
    
    func saveChange(post: Post, action: DbAction){
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
    
    // 내가 작성한 게시글만 가져온다.
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
    
    // 내가 스크랩한 글만 가져오기 위해 만든 함수
    func getPosts(postKeys:[String]?) -> [Post]{
        var postForKey: [Post] = []
        if let postKeys = postKeys {
            for post in posts{
                for postKey in postKeys {
                    if(post.key == postKey){
                        postForKey.append(post)
                    }
                }
            }
            return postForKey
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
