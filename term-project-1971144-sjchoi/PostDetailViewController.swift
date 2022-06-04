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
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    var originalTableViewHeight:CGFloat?
    
    @IBOutlet weak var scrollView: UIScrollView!
    var currentScrollViewOffset: CGPoint?
    var originalScrollViewOffset: CGPoint?
    
    var post: Post?
    var postGroup: PostGroup!
    var saveChangeDelegate: ((Post, String)->Void)?
    
    var comment: Comment?
    var commentGroup: CommentGroup?
    
    var userGroup:UserGroup?
    var user: User?
    var storedEmail:String?

    var rightBarButton: UIBarButtonItem!
    var barDropDown = DropDown()
    
    
    @IBOutlet weak var textInputStackView: UIStackView!
    
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
        if(post?.key == nil){
            print("There is no post key.")
        }else{
            commentGroup?.queryDataByPostId(id: post!.key)
        }
        
        originalTableViewHeight = self.tableViewHeight.constant
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.separatorInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        
        
        commentsTableView.estimatedRowHeight = 60.0;
        commentsTableView.rowHeight = UITableView.automaticDimension;
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
    
        storedEmail = UserDefaults.standard.string(forKey: "email")
        if(post?.userId == storedEmail){
            rightBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(showDropDown))
            navigationItem.rightBarButtonItems = [rightBarButton]
            
            barDropDown.anchorView = rightBarButton
            barDropDown.dataSource = ["수정하기", "삭제하기"]
            barDropDown.cellConfiguration = { (index, item) in return "\(item)" }
            
        }
        
        userGroup = UserGroup(userParentNotification: userReceivingNotification) // 변경이 생기면 해당 함수를 호출하도록..
        userGroup?.queryDataByEmail(email: storedEmail ?? "")
        user = userGroup?.getUser(email: storedEmail)
        
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
    //    override func viewDidAppear(_ animated: Bool) {
    //        originalScrollViewOffset = scrollView.contentOffset
    //    }
    func commentReceivingNotification(comment: Comment?, action: DbAction?){
        commentsTableView.reloadData()
        
        // 댓글의 변경이 생겨도, 스크롤뷰가 다시 처음(위쪽)으로 올라가지 않게 하기 위함.
//        if(scrollView.contentOffset != originalScrollViewOffset){
//            currentScrollViewOffset = scrollView.contentOffset
//        }
//        currentScrollViewOffset = scrollView.contentOffset
//        self.view.layoutIfNeeded()
//        scrollView.setContentOffset(currentScrollViewOffset ?? scrollView.contentOffset, animated: false)
        
    }
    func reload(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    func userReceivingNotification(user: User?, action: DbAction?){
        if(user?.email == storedEmail){
            self.user = user
        }
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
        
        if(indexPath.row == 0){
            self.tableViewHeight.constant = originalTableViewHeight ?? 0
        }
        
        // 댓글 수에 따라 tableView의 높이를 바꾼다.
        DispatchQueue.main.async {
//            self.tableViewHeight.constant = self.commentsTableView.contentSize.height
            self.tableViewHeight.constant += cell?.contentView.frame.height ?? 0
        }

        if(indexPath.row + 1 == commentGroup?.count()){
            self.tableViewHeight.constant -= originalTableViewHeight ?? 0
        }
        
        
        let comment = commentGroup!.getComments(postId: post!.key)[indexPath.row]

        (cell?.contentView.subviews[1] as! UILabel).text = comment.userName
        (cell?.contentView.subviews[2] as! UILabel).text = comment.contents
        (cell?.contentView.subviews[3] as! UILabel).text = comment.date.toStringDateTime()
        (cell?.contentView.subviews[5] as! UILabel).text = comment.likes
        let likeButton = cell?.contentView.subviews[6] as! UIButton
        likeButton.tag = indexPath.row
        likeButton.addTarget(self, action: #selector(commentLikeButtonAction), for: .touchUpInside)
        
        
        // 좋아요가 하나도 없으면 회색으로 보이고, 하나 이상 있으면 빨간색으로 보인다.
        let likesImage = cell?.contentView.subviews[4] as! UIImageView
        let likesString = cell?.contentView.subviews[5] as! UILabel
        if(comment.likes == "0"){
            likesImage.tintColor = .gray
            likesString.textColor = .gray
        }else{
            likesImage.tintColor = .red
            likesString.textColor = .red
        }
        
        return cell!
    }
    
    @objc func commentLikeButtonAction(sender: UIButton){
        print("댓글 좋아요 버튼 눌림. tag: \(sender.tag)")
        let selectedRow = sender.tag
        let modifyComment = commentGroup!.getComments(postId: post!.key)[selectedRow].clone()

        let likes = Int(modifyComment.likes)
        let result = likes! + 1
        modifyComment.likes = String(result)
        
        commentGroup?.saveChange(comment: modifyComment, action: .Modify)
        
    }
    
    
}

extension PostDetailViewController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell")
//        let comment = commentGroup!.getComments(postId: post!.key)[indexPath.row].clone()
//
//        let likeButton = cell?.contentView.subviews[6] as! UIButton
//    }
    
}

extension PostDetailViewController{
    // 댓글 추가 함수
    @IBAction func addCommentAction(_ sender: UIButton) {
        if(user?.email != nil && user?.name != nil && textView?.text != nil){
            let newComment = Comment(withData: false)
            newComment.date = Date()
            newComment.userId = user!.email
            newComment.userName = user?.name ?? ""
            newComment.postId = post?.key ?? ""
            print("newComment.userId: \(newComment.userId)")
            print("newComment.userName: \(newComment.userName)")
            newComment.likes = "0"
            newComment.contents = textView?.text ?? ""
            textView?.text = ""
            
            commentGroup?.saveChange(comment: newComment, action: .Add)
            
            let comments = Int(post!.numOfComments)
            let result = comments! + 1
            post!.numOfComments = String(result)
            saveChangeDelegate!(post!, "Modify")
        }
        
    }
}


extension PostDetailViewController{
    // 해당 게시글에 "좋아요(공감하기)" 버튼을 누르는 함수
    @IBAction func likeButtonAction(_ sender: UIButton) {
        print("like button is clicked.")
        let likes = Int(post!.likes)
        let result = likes! + 1
        post!.likes = String(result)
        print(result)
        saveChangeDelegate!(post!, "Modify")
        
    }
}



// 테이블 뷰의 각 셀의 크기 조절
class MyOwnTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}


