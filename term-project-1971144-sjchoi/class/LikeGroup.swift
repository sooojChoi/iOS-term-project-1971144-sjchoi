//
//  LikeGroup.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/06/12.
//

import Foundation


class LikeGroup: NSObject{
    var likes = [Like]()
    var database: LikeDatabase!
    var likeParentNotification: ((Like?, DbAction?) -> Void)?
    
    init(likeParentNotification: ((Like?, DbAction?) -> Void)? ){
        super.init()
        self.likeParentNotification = likeParentNotification
        database = LikeDbFirebase(likeParentNotification: receivingNotification)
    }
    func receivingNotification(like: Like?, action: DbAction?){
        if let like = like{
            switch(action){
                case .Add: addLike(like: like)
                case .Modify: modifyLike(modifiedLike:like)
                case .Delete: removeLike(removedLike: like)
                default: break
            }
        }
        if let likeParentNotification = likeParentNotification{
            likeParentNotification(like, action)
        }
    }
}

extension LikeGroup{
    func queryData(){
        likes.removeAll()
       
        database.queryLike()
    }
    
    func queryDataByEmail(email: String){
        likes.removeAll()
        
        database.queryLikeByUserEmail(email: email)
    }
    
    func saveChange(like: Like, action: DbAction){
        database.saveLikeChange(like: like, action: action)
    }
}

extension LikeGroup{
    func getLikes() -> [Like] {
        
        return likes
    }
    
    func getPostKeysByEmail(email: String?) -> [String] {
        if let email = email{
            var postKeys: [String] = []
            for like in likes{
                if like.userEmail == email {
                    postKeys.append(like.postKey)
                }
            }

            return postKeys
        }

        return [""]
    }
    
    // 현재 게시글에 좋아요를 눌렀는지 확인하기 위한 함수
    func isLikeByPostKey(postKey: String?, userEmail: String?) -> Bool {
        if let postKey = postKey, let userEmail = userEmail {
            for like in likes{
                if like.postKey == postKey && like.userEmail == userEmail {
                    return true
                }
            }
        }
        return false
    }
    
    private func count() -> Int{ return likes.count }

    private func find(_ key: String) -> Int?{
        for i in 0..<likes.count{
            if key == likes[i].key{
                return i
            }
        }
        return nil
    }
    
    private func addLike(like:Like){
        likes.append(like)
        
    }
    private func modifyLike(modifiedLike: Like){
        if let index = find(modifiedLike.key){
            likes[index] = modifiedLike
        }
    }
    private func removeLike(removedLike: Like){
        if let index = find(removedLike.key){
            likes.remove(at: index)
        }
    }
}
