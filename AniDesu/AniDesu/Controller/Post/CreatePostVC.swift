import UIKit
import Kingfisher

protocol CreatePostDelegate {
    func onPostComplete()
}

class CreatePostVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var profileImageView: CircleImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var statusTextView: UITextView!
    
    // Variables
    var delegate: CreatePostDelegate?
    var currentPost: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusTextView.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreatePostVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        setUpView()
    }
    
    func setUpView() {
        profileImageView.kf.setImage(with: AllFormat.instance.getURL(stringURL: UserDataService.instance.imageUrlProfile))
        nameLabel.text = UserDataService.instance.displayName
        aboutLabel.text = UserDataService.instance.about
        
        if currentPost != nil {
            statusTextView.text = currentPost?.status
            statusTextView.textColor = UIColor.black
            self.navigationController?.navigationBar.topItem?.title = "Edit Post"
        } else {
            statusTextView.text = "What's on your mind?"
            statusTextView.textColor = UIColor.lightGray
            self.navigationController?.navigationBar.topItem?.title = "Create Post"
        }
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        let status = statusTextView.text
        let currentTime = AllFormat.instance.getCurrentTime()
        var post = Post(uid: UserDataService.instance.uid, status: status!, postDate: currentTime, likeCount: 0)
        
        if currentPost != nil {
            post.postKey = (currentPost?.postKey)!
            PostService.instance.editPost(post: post) { (success) in
                if success {
                    self.dismiss(animated: true, completion: {
                        self.delegate?.onPostComplete()
                    })
                }
            }
        } else {
            PostService.instance.postStatus(post: post) { (success) in
                if success {
                    self.dismiss(animated: true, completion: {
                        self.delegate?.onPostComplete()
                    })
                }
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension CreatePostVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            shareBtn.isEnabled = false
        } else {
            shareBtn.isEnabled = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's on your mind?"
            textView.textColor = UIColor.lightGray
        }
    }
}
