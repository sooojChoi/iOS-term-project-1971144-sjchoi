//
//  ScrapGroup.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/06/11.
//

import Foundation

class ScrapGroup: NSObject{
    var scraps = [Scrap]()
    var database: ScrapDatabase!
    var scrapParentNotification: ((Scrap?, DbAction?) -> Void)?
    
    init(scrapParentNotification: ((Scrap?, DbAction?) -> Void)? ){
        super.init()
        self.scrapParentNotification = scrapParentNotification
        database = ScrapDbFirebase(scrapParentNotification: receivingNotification)
    }
    func receivingNotification(scrap: Scrap?, action: DbAction?){
        if let scrap = scrap{
            switch(action){
                case .Add: addScrap(scrap: scrap)
                case .Modify: modifyScrap(modifiedScrap:scrap)
                case .Delete: removeScrap(removedScrap: scrap)
                default: break
            }
        }
        if let scrapParentNotification = scrapParentNotification{
            scrapParentNotification(scrap, action)
        }
    }
}

extension ScrapGroup{
    func queryData(){
        scraps.removeAll()
       
        database.queryScrap()
    }
    
    func queryDataByEmail(email: String){
        scraps.removeAll()
        
        database.queryScrapByUserEmail(email: email)
    }
    
    func saveChange(scrap: Scrap, action: DbAction){
        database.saveScrapChange(scrap: scrap, action: action)
    }
}

extension ScrapGroup{
    func getScraps() -> [Scrap] {
        
        return scraps
    }
    
    func getPostKeysByEmail(email: String?) -> [String] {
        if let email = email{
            var postKeys: [String] = []
            for scrap in scraps{
                if scrap.userEmail == email {
                    postKeys.append(scrap.postKey)
                }
            }
            
            return postKeys
        }
        
        return [""]
    }
    
    private func count() -> Int{ return scraps.count }

    private func find(_ key: String) -> Int?{
        for i in 0..<scraps.count{
            if key == scraps[i].key{
                return i
            }
        }
        return nil
    }
    
    private func addScrap(scrap:Scrap){
       // posts.append(post)
        scraps.insert(scrap, at: 0)
        
    }
    private func modifyScrap(modifiedScrap: Scrap){
        if let index = find(modifiedScrap.key){
            scraps[index] = modifiedScrap
        }
    }
    private func removeScrap(removedScrap: Scrap){
        if let index = find(removedScrap.key){
            scraps.remove(at: index)
        }
    }
    func changeScrap(from: Scrap, to: Scrap){
        if let fromIndex = find(from.key), let toIndex = find(to.key) {
            scraps[fromIndex] = to
            scraps[toIndex] = from
        }
    }
}
