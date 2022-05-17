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
    
    var selectedDate: Date? = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postGroupTableView.dataSource = self        // 테이블뷰의 데이터 소스로 등록
        postGroupTableView.delegate = self        // 딜리게이터로 등록
        
        // 단순히 planGroup객체만 생성한다
        postGroup = PostGroup(parentNotification: receivingNotification) // 변경이 생기면 해당 함수를 호출하도록..
        postGroup.queryData(date: Date())       // 이달의 데이터를 가져온다. 데이터가 오면 planGroupListener가 호출된다.
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
            return postGroup.getPosts(date: selectedDate).count
        }
        return 0    // planGroup가 생성되기전에 호출될 수도 있다
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      //  let cell = UITableViewCell(style: .value1, reuseIdentifier: "") // TableViewCell을 생성한다
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell")
        // planGroup는 대략 1개월의 플랜을 가지고 있다.
        let post = postGroup.getPosts(date: selectedDate)[indexPath.row] // Date를 주지않으면 전체 plan을 가지고 온다

//        // 적절히 cell에 데이터를 채움
//        cell?.textLabel!.text = plan.date.toStringDateTime()
//        cell?.detailTextLabel?.text = plan.content
        (cell?.contentView.subviews[0] as! UILabel).text = post.title
        (cell?.contentView.subviews[1] as! UILabel).text = post.content
        (cell?.contentView.subviews[2] as! UILabel).text = post.date.toStringDateTime()
        
//        cell?.accessoryType = .none
//        cell?.accessoryView = nil
//        if indexPath.row % 2 == 0 {
//            cell?.accessoryType = .detailDisclosureButton
//        }else{
//            cell?.accessoryView = UISwitch(frame: CGRect())
//        }
        
        return cell!
    }
}
extension PostGroupViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        // 이것은 데이터베이스에 까지 영향을 미치지 않는다. 그래서 planGroup에서만 위치 변경
        let from = postGroup.getPosts(date: selectedDate)[sourceIndexPath.row]
        let to = postGroup.getPosts(date: selectedDate)[destinationIndexPath.row]
        postGroup.changePost(from: from, to: to)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
    }

}
