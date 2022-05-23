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
    
    @IBOutlet weak var writerTextView: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var numOfCommentsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    
    var post: Post?
    var saveChangeDelegate: ((Post)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        titleText.sizeToFit()
//        titleText.layoutIfNeeded()
        //(titleStackView.subviews[0] as! UILabel).sizeToFit()
       // (titleStackView.subviews[0] as! UILabel).layoutIfNeeded()
        
        //titleLabel.sizeToFit()

        post = post ?? Post(withData: true)
        dateLabel.text = post?.date.toStringDateTime()
        titleLabel.text = post?.title
        writerTextView.text = post?.owner
        contentsLabel.text = post?.content
        numOfCommentsLabel.text = String(post?.numOfComments ?? 0)
        likesLabel.text = String(post?.likes ?? 0)
        
    }
    

   

}
