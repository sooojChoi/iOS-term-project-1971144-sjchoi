//
//  PostDetailViewController.swift
//  term-project-1971144-sjchoi
//
//  Created by soojin choi on 2022/05/16.
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
import DropDown

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var writerTextView: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var numOfCommentsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var likeButton: UIButton!
    

    var post: Post?
    var postGroup: PostGroup!
    var saveChangeDelegate: ((Post, String)->Void)?
    
    var comment: Comment?
    var commentGroup: CommentGroup?

    var rightBarButton: UIBarButtonItem!
    var barDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        titleText.sizeToFit()
//        titleText.layoutIfNeeded()
        //(titleStackView.subviews[0] as! UILabel).sizeToFit()
       // (titleStackView.subviews[0] as! UILabel).layoutIfNeeded()
        
        //titleLabel.sizeToFit()
        
        likeButton.layer.cornerRadius = 5
        likeButton.layer.borderWidth = 1
        likeButton.layer.borderColor = likeButton.layer.backgroundColor

        post = post ?? Post(withData: true)
        dateLabel.text = post?.date.toStringDateTime()
        titleLabel.text = post?.title
        writerTextView.text = post?.owner
        contentsLabel.text = post?.content
        numOfCommentsLabel.text = String(post?.numOfComments ?? "0")
        likesLabel.text = String(post?.likes ?? "0")
    
        
        postGroup = PostGroup(parentNotification: receivingNotification) // 변경이 생기면 해당 함수를 호출하도록..
        postGroup.queryData()
        
        commentGroup = CommentGroup(commentParentNotification: commentReceivingNotification)
        commentGroup?.queryDataByPostId(id: post!.key)
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
    
        let storedEmail = UserDefaults.standard.string(forKey: "email")
        if(post?.userId == storedEmail){
            rightBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(showDropDown))
            navigationItem.rightBarButtonItems = [rightBarButton]
            
            barDropDown.anchorView = rightBarButton
            barDropDown.dataSource = ["수정하기", "삭제하기"]
            barDropDown.cellConfiguration = { (index, item) in return "\(item)" }
            
        }
        
        
    }
    
    @objc func showDropDown(){
        barDropDown.selectionAction = { [self]
            (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")

            // 수정하기 버튼이 눌렸을 때
            if index == 0{
                let svc = self.storyboard?.instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController
                
                svc.saveChangeDelegateFromDetail = saveChangeDelegate
                svc.fieldName = post?.kind
                svc.post = self.post?.clone()
                svc.fromWhere = "DetailViewController"
                
                navigationController?.pushViewController(svc, animated: true)
                
            }else{ // 삭제하기 버튼이 눌렸을 때
                self.saveChangeDelegate!(self.post!, "Delete")
                navigationController?.popViewController(animated: true)
            }
              
        }
        barDropDown.width = 140
        barDropDown.bottomOffset = CGPoint(x: 0, y:(barDropDown.anchorView?.plainView.bounds.height)!)
        barDropDown.show()
    
    }
    
    
    func receivingNotification(post: Post?, action: DbAction?){
        // 데이터가 올때마다 이 함수가 호출되는데 맨 처음에는 기본적으로 add라는 액션으로 데이터가 온다.
        if(post!.key == self.post!.key){
            self.post = post
            dateLabel.text = post?.date.toStringDateTime()
            titleLabel.text = post?.title
            writerTextView.text = post?.owner
            contentsLabel.text = post?.content
            numOfCommentsLabel.text = String(post?.numOfComments ?? "0")
            likesLabel.text = String(post?.likes ?? "0")
        
        }
     
    }
    func commentReceivingNotification(comment: Comment?, action: DbAction?){
        self.commentsTableView.reloadData()
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer){
        textView.resignFirstResponder()
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
        self.view.frame.origin.y = 0

    }

}


extension PostDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let commentGroup = commentGroup{
            return commentGroup.getComments(postId: post!.key).count
        }
        return 0    // planGroup가 생성되기전에 호출될 수도 있다
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell")
        // planGroup는 대략 1개월의 플랜을 가지고 있다.
        let comment = commentGroup!.getComments(postId: post!.key)[indexPath.row]

//        // 적절히 cell에 데이터를 채움

//        (cell?.contentView.subviews[0] as! UILabel).text = post.title
//        (cell?.contentView.subviews[1] as! UILabel).text = post.content
//        (cell?.contentView.subviews[2] as! UILabel).text = post.date.toStringDateTime()
//        (cell?.contentView.subviews[4] as! UILabel).text = String(post.likes)
//        (cell?.contentView.subviews[5] as! UILabel).text = String(post.numOfComments)
//
//
        return cell!
    }
    
    
}

extension PostDetailViewController: UITableViewDelegate{
    
}




extension PostDetailViewController{
    @IBAction func likeButtonAction(_ sender: UIButton) {
        print("like button is clicked.")
        let likes = Int(post!.likes)
        let result = likes! + 1
        post!.likes = String(result)
        print(result)
        saveChangeDelegate!(post!, "Modify")
        
    }
    
}
