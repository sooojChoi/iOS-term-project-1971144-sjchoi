//
//  MyPostGroupViewController.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/06/10.
//
/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/

import UIKit

class MyPostGroupViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    var postGroup: PostGroup!
    
    var sceneSort: String?
    
    var myEmail:String?
    var postKeys:[String]?
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.dataSource = self        // 테이블뷰의 데이터 소스로 등록
        postTableView.delegate = self        // 딜리게이터로 등록
        
        postTableView.isEditing = false

        postGroup = PostGroup(parentNotification: receivingNotification) // 변경이 생기면 해당 함수를 호출하도록..
        postGroup.queryData()
        
        if sceneSort == "MyPosts" {
            navigationTitle.title = "나의 게시글"
        }else{
            navigationTitle.title = "스크랩한 게시글"
        }
        
    }
    
    func receivingNotification(post: Post?, action: DbAction?){
        self.postTableView.reloadData()
    }


}


extension MyPostGroupViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let postGroup = postGroup{
            if(sceneSort == "MyPosts"){
                return postGroup.getPosts(userEmail: myEmail).count
            }else{
                return postGroup.getPosts(postKeys: postKeys).count
            }
            
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell")
        let post: Post
        if(sceneSort == "MyPosts"){
            post = postGroup.getPosts(userEmail: myEmail)[indexPath.row]
        }else{
            post = postGroup.getPosts(postKeys: postKeys)[indexPath.row]
        }

        (cell?.contentView.subviews[0] as! UILabel).text = post.title
        (cell?.contentView.subviews[1] as! UILabel).text = post.content
        (cell?.contentView.subviews[2] as! UILabel).text = post.date.toStringDateTime()
        (cell?.contentView.subviews[4] as! UILabel).text = String(post.likes)
        (cell?.contentView.subviews[5] as! UILabel).text = String(post.numOfComments)
        (cell?.contentView.subviews[7] as! UILabel).text = post.kind
        (cell?.contentView.subviews[9] as! UILabel).text = String(post.numOfScrap)
        
        
        return cell!
    }
}
extension MyPostGroupViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        let svc = self.storyboard?.instantiateViewController(withIdentifier: "PostDatailViewController") as! PostDetailViewController
        svc.saveChangeDelegate = saveChange
        if(sceneSort == "MyPosts"){
            svc.post = postGroup.getPosts(userEmail: myEmail)[postTableView.indexPathForSelectedRow!.row].clone()
        }else{
            svc.post = postGroup.getPosts(postKeys: postKeys)[postTableView.indexPathForSelectedRow!.row].clone()
        }
       
        navigationController?.pushViewController(svc, animated: true)

    }

}
extension MyPostGroupViewController{
    func saveChange(post: Post?, action:String){
        if action == "Modify" {
            postGroup.saveChange(post: post!, action: .Modify)
        }
        else if action == "Delete"{
            postGroup.saveChange(post: post!, action: .Delete)
        }
    }
    
    func saveAddChange(post:Post?){
        postGroup.saveChange(post: post!, action: .Add)
    }
    
}
