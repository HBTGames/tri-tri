//
//  ViewController.swift
//  tri-tri
//
//  Created by mac on 2017-05-08.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var MarkBoard: UILabel!
    
    
    var temp_mark_str = String()
    var temp_mark_int = 0
    @IBAction func Add_Mark_Test(_ sender: Any) {
    temp_mark_str = MarkBoard.text!
    temp_mark_int = Int(temp_mark_str)!
    temp_mark_int += 1
    temp_mark_str = String(temp_mark_int)
    MarkBoard.text = temp_mark_str
    }
    
    
    
    
    
    
    
    
    
    

}

