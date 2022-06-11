//
//  PostFieldGroup.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/18.
//

import Foundation

class PostFieldGroup: NSObject{
    var postFields = [PostField]()
    var database: PostFieldDatabase!
    var postFieldParentNotification: ((PostField?, DbAction?) -> Void)?
   
    
    
    init(postFieldParentNotification: ((PostField?, DbAction?) -> Void)? ){
        super.init()
        self.postFieldParentNotification = postFieldParentNotification
      //  database = PostFieldDbMemory(postFieldParentNotification: receivingNotification) // 데이터베이스 생성
        database = PostFieldFirebase(postFieldParentNotification: receivingNotification)
    }
    func receivingNotification(postField: PostField?, action: DbAction?){
        // 데이터베이스로부터 메시지를 받고 이를 부모에게 전달한다
        if let postField = postField{
            switch(action){    // 액션에 따라 적절히     plans에 적용한다
                case .Add: addPostField(postField: postField)
                case .Modify: modifyPostField(modifiedPostField: postField)
                case .Delete: removePostField(removePostField: postField)
                default: break
            }
        }
        if let postFieldParentNotification = postFieldParentNotification{
            postFieldParentNotification(postField, action) // 역시 부모에게 알림내용을 전달한다.
        }
    }
}

extension PostFieldGroup{
    
    func queryData(){
        postFields.removeAll()    // 새로운 쿼리에 맞는 데이터를 채우기 위해 기존 데이터를 전부 지운다
        
        
        database.queryPostField()
    }
    
    func queryDataByName(name: String){
        postFields.removeAll()
        
        database.queryPostFieldByName(name: name)
    }
    
    func queryDataByUser(fieldArray:[String]){
        postFields.removeAll()
        
        database.queryPostFieldByUser(fieldArray: fieldArray)
    }
    
    func saveChange(postField: PostField, action: DbAction){
        // 단순히 데이터베이스에 변경요청을 하고 plans에 대해서는
        // 데이터베이스가 변경알림을 호출하는 receivingNotification에서 적용한다
        database.saveFieldChange(postField: postField, action: action)
    }
}
extension PostFieldGroup{
    func getPostFields() -> [PostField] {
        
        return postFields
    }
}
extension PostFieldGroup{
    
    private func count() -> Int{ return postFields.count }
    
   
    
    private func find(_ key: String) -> Int?{
        for i in 0..<postFields.count{
            if key == postFields[i].key{
                return i
            }
        }
        return nil
    }
}
extension PostFieldGroup{
    private func addPostField(postField:PostField){ postFields.append(postField) }
    private func modifyPostField(modifiedPostField: PostField){
        if let index = find(modifiedPostField.key){
            postFields[index] = modifiedPostField
        }
    }
    private func removePostField(removePostField: PostField){
        if let index = find(removePostField.key){
            postFields.remove(at: index)
        }
    }
    
}

