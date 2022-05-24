//
//  Database.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/16.
//

import Foundation

// Database.swift
enum DbAction{
    case Add, Delete, Modify // 데이터베이스 변경의 유형
}
protocol Database{
    // 생성자, 데이터베이스에 변경이 생기면 parentNotification를 호출하여 부모에게 알림
    init(parentNotification: ((Post?, DbAction?) -> Void)? )

    // Post를 읽어 parentNotification를 호출하여 부모에게 알림
    func queryPost()
    
    
    // 데이터베이스에 post를 변경하고 parentNotification를 호출하여 부모에게 알림
    func saveChange(post: Post, action: DbAction)
}



protocol PostFieldDatabase{
    init(postFieldParentNotification: ((PostField?, DbAction?) -> Void)? )
    
    // PostField를 읽어 parentNotification를 호출하여 부모에게 알림
    func queryPostField()
    
    func queryPostFieldByName(name:String)
    
    // 데이터베이스에 postField를 변경하고 parentNotification를 호출하여 부모에게 알림
    func saveFieldChange(postField: PostField, action:DbAction)
}

