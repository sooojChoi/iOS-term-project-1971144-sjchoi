//
//  Scrap.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/06/11.
//

import Foundation

class Scrap: NSObject, NSCoding{
    var key: String
    var date: Date
    var postKey: String
    var userEmail: String

    init(date: Date, postKey: String, userEmail:String){
        self.key = UUID().uuidString
        self.date = Date(timeInterval: 0, since: date)
        self.postKey = postKey
        self.userEmail = userEmail
   
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(key, forKey: "key")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(postKey, forKey: "postKey")
        aCoder.encode(userEmail, forKey: "userEmail")
    }
    // unarchiving할때 호출된다
    required init(coder aDecoder: NSCoder) {
        key = aDecoder.decodeObject(forKey: "key") as! String? ?? ""
        date = aDecoder.decodeObject(forKey: "date") as! Date
        postKey = aDecoder.decodeObject(forKey: "postKey") as? String ?? ""
        userEmail = aDecoder.decodeObject(forKey: "userEmail") as? String ?? ""
 
        super.init()
    }

}

extension Scrap{
    convenience init(withData: Bool = false){
        if withData == true{
            let postKeys = ["a", "b", "c", "d"]
            var index = Int(arc4random_uniform(UInt32(postKeys.count)))
            let postKey = postKeys[index] // 이것의 타입은 옵셔널이다. Option+click해보라
        
            let userEmails = ["soojin", "minsoo"]
            index = Int(arc4random_uniform(UInt32(userEmails.count)))
            let userEmail = userEmails[index]
            
            self.init(date: Date(), postKey: postKey, userEmail: userEmail)
            
        }else{
            self.init(date: Date(), postKey: "", userEmail: "")

        }
    }
}

extension Scrap{
    func clone() -> Scrap {
        let clonee = Scrap()

        clonee.key = self.key
        clonee.date = Date(timeInterval: 0, since: self.date) 
        clonee.postKey = self.postKey
        clonee.userEmail = self.userEmail
        
        return clonee
    }
}
