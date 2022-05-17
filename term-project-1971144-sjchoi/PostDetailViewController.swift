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

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var dateTextView: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var post: Post?
    var saveChangeDelegate: ((Post)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        post = post ?? Post(date: nil, withData: true)
        dateTextView.text = post?.date.toStringDateTime()
        titleText.text = post?.title
        owner.text = post?.owner
        contents.text = post?.content
        
    }
    

   

}
