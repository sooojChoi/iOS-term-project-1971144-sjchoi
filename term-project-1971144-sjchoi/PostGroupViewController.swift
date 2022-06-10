//
//  PostGroupViewController.swift
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

class PostGroupViewController: UIViewController {

    @IBOutlet weak var postGroupTableView: UITableView!
    var postGroup: PostGroup!
    
    @IBOutlet weak var fieldTitle: UINavigationItem!
    var appTitleString: String?
    
    @IBAction func addPost(_ sender: UIBarButtonItem) {
        let svc = self.storyboard?.instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController
        
        svc.saveChangeDelegate = saveAddChange
        svc.fieldName = appTitleString
        svc.fromWhere = "PostGroupViewController"
        svc.post = Post(withData: false)
        
        navigationController?.pushViewController(svc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postGroupTableView.dataSource = self        // 테이블뷰의 데이터 소스로 등록
        postGroupTableView.delegate = self        // 딜리게이터로 등록
        
        
//        postGroupTableView.rowHeight = UITableView.automaticDimension
//        postGroupTableView.estimatedRowHeight = UITableView.automaticDimension
//
        postGroupTableView.isEditing = false
  
        postGroup = PostGroup(parentNotification: receivingNotification) // 변경이 생기면 해당 함수를 호출하도록..
        postGroup.queryData()
        
        fieldTitle.title = appTitleString
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        // 여기서 호출하는 이유는 present라는 함수 ViewController의 함수인데 이함수는 ViewController의 Layout이 완료된 이후에만 동작하기 때문
//        print("viewDidAppear 호출됨")
//        Owner.loadOwner(sender: self)
//        navigationItem.title = Owner.getOwner()
//
//    }
    func receivingNotification(post: Post?, action: DbAction?){
        // 데이터가 올때마다 이 함수가 호출되는데 맨 처음에는 기본적으로 add라는 액션으로 데이터가 온다.
        self.postGroupTableView.reloadData()  // 속도를 증가시키기 위해 action에 따라 개별적 코딩도 가능하다.
       
     
    }


}

extension PostGroupViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let postGroup = postGroup{
            return postGroup.getPosts(fieldTitle: appTitleString).count
        }
        return 0    // planGroup가 생성되기전에 호출될 수도 있다
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      //  let cell = UITableViewCell(style: .value1, reuseIdentifier: "") // TableViewCell을 생성한다
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell")
        let post = postGroup.getPosts(fieldTitle: appTitleString)[indexPath.row]

//        // 적절히 cell에 데이터를 채움
        (cell?.contentView.subviews[0] as! UILabel).text = post.title
        (cell?.contentView.subviews[1] as! UILabel).text = post.content
        (cell?.contentView.subviews[2] as! UILabel).text = post.date.toStringDateTime()
        (cell?.contentView.subviews[4] as! UILabel).text = String(post.likes)
        (cell?.contentView.subviews[5] as! UILabel).text = String(post.numOfComments)
        
        
        return cell!
    }
}
extension PostGroupViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        let svc = self.storyboard?.instantiateViewController(withIdentifier: "PostDatailViewController") as! PostDetailViewController
        svc.saveChangeDelegate = saveChange
        svc.post = postGroup.getPosts(fieldTitle: appTitleString)[postGroupTableView.indexPathForSelectedRow!.row].clone()
        
        navigationController?.pushViewController(svc, animated: true)

    }

}
extension PostGroupViewController{
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

extension PostGroupViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
//        if segue.identifier == "ShowPost" {
//            let postDetailViewController = segue.destination as! PostDetailViewController
//            postDetailViewController.saveChangeDelegate = saveChange
//            postDetailViewController.post = postGroup.getPosts()[postGroupTableView.indexPathForSelectedRow!.row].clone()
//
//        }
       
        
        
//        if segue.identifier == "AddPlan" {
//            print("AddPlan")
//
//            let planDetailViewController = segue.destination as! PlanDetailViewController
//            planDetailViewController.saveChangeDelegate = saveChange
//
//            // 빈 plan을 생성하여 전달한다
//            planDetailViewController.plan = Plan(date:nil, withData: false)
//            planGroupTableView.selectRow(at: nil, animated: true, scrollPosition: .none)
//
//        }
    }
}
