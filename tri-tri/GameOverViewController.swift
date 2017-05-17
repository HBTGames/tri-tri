//
//  GameOverViewController.swift
//  tri-tri
//
//  Created by Feiran Hu on 2017-05-14.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit


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
    
    
    //two vars value passed from game board
    var final_score = String()
    var is_high_score = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        score_board.text = final_score
        if !is_high_score{
            High_score_marker.text = "High Score!"
            //High_score_marker.startBlink()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
