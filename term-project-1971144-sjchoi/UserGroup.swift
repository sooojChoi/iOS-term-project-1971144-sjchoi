//
//  UserGroup.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/31.
//

import Foundation
import Firebase

class UserGroup: NSObject{
    var users = [User]()
    var database: UserDatabase!
    var userParentNotification: ((User?, DbAction?) -> Void)?
    
    init(userParentNotification: ((User?, DbAction?) -> Void)? ){
        super.init()
        self.userParentNotification = userParentNotification
        //database = DbMemory(parentNotification: receivingNotification) // 데이터베이스 생성
        database = UserFirebase(userParentNotification: receivingNotification)
    }
    func receivingNotification(user: User?, action: DbAction?){
        // 데이터베이스로부터 메시지를 받고 이를 부모에게 전달한다
        if let user = user{
            switch(action){    // 액션에 따라 적절히     plans에 적용한다
                case .Add: addUser(user: user)
                case .Modify: modifyUser(modifiedUser: user)
                case .Delete: removeUser(removedUser: user)
                default: break
            }
        }
        if let userParentNotification = userParentNotification{
            userParentNotification(user, action) // 역시 부모에게 알림내용을 전달한다.
        }
    }
}

extension UserGroup{    // PlanGroup.swift
    
    func queryData(){
        users.removeAll()    // 새로운 쿼리에 맞는 데이터를 채우기 위해 기존 데이터를 전부 지운다
       
        database.queryUser()
    }
    
    func queryDataByEmail(email: String){
        users.removeAll()
        
        database.queryUserByEmail(email: email)
    }
    
    func saveChange(user: User, action: DbAction){
        // 단순히 데이터베이스에 변경요청을 하고 plans에 대해서는
        // 데이터베이스가 변경알림을 호출하는 receivingNotification에서 적용한다
        print("userGroup's save change is called")
        print(user.fields)
        database.saveUserChange(user: user, action: action)
    }
}
extension UserGroup{
    func getUser(email:String?) -> User {
        
        // 해당 게시판의 글만 가져온다.
        if let email = email{
            for user in users{
                if user.email == email {
                    return user
                }
            }
        }
        return User(withData: false)
    }
}
extension UserGroup{     // PlanGroup.swift
    
    private func count() -> Int{ return users.count }
    
   
    private func find(_ key: String) -> Int?{
        for i in 0..<users.count{
            if key == users[i].key{
                return i
            }
        }
        return nil
    }
}
extension UserGroup{
    private func addUser(user:User){
       // posts.append(post)
        users.insert(user, at: 0)
        
    }
    private func modifyUser(modifiedUser: User){
        if let index = find(modifiedUser.key){
            users[index] = modifiedUser
        }
    }
    private func removeUser(removedUser: User){
        if let index = find(removedUser.key){
            users.remove(at: index)
        }
    }
}

