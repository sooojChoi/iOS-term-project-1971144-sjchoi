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
    
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        print("like button is clicked.")
    }
    var post: Post?
    var saveChangeDelegate: ((Post)->Void)?

    
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
        numOfCommentsLabel.text = String(post?.numOfComments ?? 0)
        likesLabel.text = String(post?.likes ?? 0)
    
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
        
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
