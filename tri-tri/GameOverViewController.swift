//
//  GameOverViewController.swift
//  tri-tri
//
//  Created by Feiran Hu on 2017-05-14.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import Social


extension UILabel {
    
    func startBlink() {
        UIView.animate(withDuration: 0.8,
                       delay:0.0,
                       options:[.autoreverse, .repeat],
                       animations: {
                        self.alpha = 0
        }, completion: nil)
    }
    
    func stopBlink() {
        alpha = 1
        layer.removeAllAnimations()
    }
}

class GameOverViewController: UIViewController {
    @IBOutlet weak var High_score_marker: UILabel!

    @IBOutlet weak var score_board: UILabel!
    
    @IBAction func Share_Button_Action(_ sender: UIButton) {
     let alert = UIAlertController(title: "Share", message: "Share Your Record!", preferredStyle: .actionSheet)
        //first action
        let action_one = UIAlertAction(title: "Share on Facebook", style: .default) { (action) in
            //check whether user has facebook
            if (SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)){
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
                post.setInitialText("I have played tri-tri !")
                post.add(UIImage(named: "share_pic"))
                self.present(post, animated: true, completion: nil)
            }else{
            self.showAlert(service: "Facebook")
            }
        }
        
        //second action
        let action_two = UIAlertAction(title: "Share on Twitter", style: .default) { (action) in
            //check whether user has facebook
            if (SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)){
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                post.setInitialText("I have played tri-tri !")
                post.add(UIImage(named: "share_pic"))
                self.present(post, animated: true, completion: nil)
            }else{
                self.showAlert(service: "Twitter")
            }
        }
        
        //third action
        let action_three = UIAlertAction(title: "Share on Weibo", style: .default) { (action) in
            //check whether user has facebook
            if (SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTencentWeibo)){
                let post = SLComposeViewController(forServiceType: SLServiceTypeTencentWeibo)!
                post.setInitialText("I have played tri-tri !")
                post.add(UIImage(named: "share_pic"))
                self.present(post, animated: true, completion: nil)
            }else{
                self.showAlert(service: "Weibo")
            }
        }
        
        
        //add action to action sheet
        alert.addAction(action_one)
        alert.addAction(action_two)
        alert.addAction(action_three)
        
        //present alert 
        self.present(alert, animated: true, completion: nil)
    }

    
    //two vars value passed from game board
    var final_score = String()
    var is_high_score = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        score_board.text = final_score
        if !is_high_score{
            High_score_marker.text = "New Record!"
            //High_score_marker.startBlink()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(service: String){
        let alert = UIAlertController(title: "Error", message: "You are not connected to \(service)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
