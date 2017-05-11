//
//  GameBoardViewController.swift
//  tri-tri
//
//  Created by Feiran Hu on 2017-05-10.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController {


    
//--------------------------------------------------------------------------------------------------------------------------
//draggable element three drag triangles implementation
    
    @IBOutlet weak var green_drag_tri: UIImageView!
    @IBOutlet weak var light_brown_drag_tri: UIImageView!
    @IBOutlet weak var orange_drag_tri: UIImageView!
    //original location of drag_image (only declaration here
    var green_drag_origin = CGPoint(x: 0, y:0 )
    var orange_drag_origin = CGPoint(x: 0, y:0 )
    var light_brown_drag_origin = CGPoint(x:0 , y:0)
    var green_drag_tri_orig_rec = CGRect(origin:  CGPoint(x: 0, y:0 ) , size: CGSize(width: 0 , height: 0))
    var orange_drag_tri_orig_rec = CGRect(origin:  CGPoint(x: 0, y:0 ) , size: CGSize(width: 0 , height: 0))
    var light_brown_drag_tri_orig_rec = CGRect(origin:  CGPoint(x: 0, y:0 ) , size: CGSize(width: 0 , height: 0))
    //adding one method by overriding touchesBegan function to get initial touch location
    var initialTouchLocation: CGPoint!
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        initialTouchLocation = touches.first!.location(in: view)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add UIPanGestureRecognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        //assign original locations of three tris located at the location on storyboard of each of them
        green_drag_origin = green_drag_tri.frame.origin
        orange_drag_origin = orange_drag_tri.frame.origin
        light_brown_drag_origin = light_brown_drag_tri.frame.origin
        //declare original frames of the tris
        green_drag_tri_orig_rec = green_drag_tri.frame
        orange_drag_tri_orig_rec = orange_drag_tri.frame
        light_brown_drag_tri_orig_rec = light_brown_drag_tri.frame
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //function in response to drag movement
    func panGestureRecognizerAction(_ gesture: UIPanGestureRecognizer){
        //if original frame contains the initial point
        if(green_drag_tri_orig_rec.contains(initialTouchLocation)){
        let transition0 = gesture.translation(in: green_drag_tri)
        green_drag_tri.frame.origin = CGPoint(x: green_drag_origin.x+transition0.x , y: green_drag_origin.y+transition0.y)
        } else if(orange_drag_tri_orig_rec.contains(initialTouchLocation)){
        let transition1 = gesture.translation(in: orange_drag_tri)
        orange_drag_tri.frame.origin = CGPoint(x:orange_drag_origin.x+transition1.x , y:orange_drag_origin.y+transition1.y)
        }else if(light_brown_drag_tri_orig_rec.contains(initialTouchLocation)){
        let transition2 = gesture.translation(in: light_brown_drag_tri)
        light_brown_drag_tri.frame.origin = CGPoint(x:light_brown_drag_origin.x+transition2.x , y:light_brown_drag_origin.y+transition2.y)
        }
        //if dragging ended, return to original location (with animiation)
        if(gesture.state == .ended){
            UIView.animate(withDuration: 0.3, animations: {
            self.green_drag_tri.frame.origin = self.green_drag_origin
             self.orange_drag_tri.frame.origin = self.orange_drag_origin
            self.light_brown_drag_tri.frame.origin = self.light_brown_drag_origin
            })
        }
        
    }
    
    //compute distance between two CGPoint (Square Form) (not using rn)
    func distance_generator( drag_location: CGPoint, triangle_location: CGPoint) -> Double {
        let temp_distance = (drag_location.x-triangle_location.x)*(drag_location.x-triangle_location.x)+(drag_location.y-triangle_location.y)*(drag_location.y-triangle_location.y)
        return Double(temp_distance)
    }
    //--------------------------------------------------------------------------------------------------------------------

    
    
    
    
    //--------------------------------------------------------------------------------------------------------------------
    //construct a list of colors that will be implemented in gameboard
    
    //color No.1 is mix of red and orange
    let tri_color_0 = UIColor(red:CGFloat(222/255.0), green:CGFloat(111/255.0), blue:CGFloat(69/255.0), alpha:CGFloat(1))
    
    //color No.2 is dark green
    let tri_color_1 = UIColor(red:CGFloat(83/255.0), green:CGFloat(142/255.0), blue:CGFloat(136/255.0), alpha:CGFloat(1))
    
    //color No.3 is mix of deep black and green
    let tri_color_2 = UIColor(red:CGFloat(27/255.0), green:CGFloat(62/255.0), blue:CGFloat(49/255.0), alpha:CGFloat(1))
    
    //color No.4 is light brown
    let tri_color_3 = UIColor(red:CGFloat(212/255.0), green:CGFloat(192/255.0), blue:CGFloat(148/255.0), alpha:CGFloat(1))
    
    //color No.5 is light green
     let tri_color_4 = UIColor(red:CGFloat(111/255.0), green:CGFloat(151/255.0), blue:CGFloat(91/255.0), alpha:CGFloat(1))
    //--------------------------------------------------------------------------------------------------------------------
    
    
    
    
    
    
    
    //--------------------------------------------------------------------------------------------------------------------
    //outlet connection variable for each triangle in gameboard
    //name follows protocol:
    //  "tri_(row)_(column)"
    @IBOutlet weak var tri_0_0: UIImageView!
    @IBOutlet weak var tri_0_1: UIImageView!
    @IBOutlet weak var tri_0_2: UIImageView!
    @IBOutlet weak var tri_0_3: UIImageView!
    @IBOutlet weak var tri_0_4: UIImageView!
    @IBOutlet weak var tri_0_5: UIImageView!
    @IBOutlet weak var tri_0_6: UIImageView!
    @IBOutlet weak var tri_1_0: UIImageView!
    @IBOutlet weak var tri_1_1: UIImageView!
    @IBOutlet weak var tri_1_2: UIImageView!
    @IBOutlet weak var tri_1_3: UIImageView!
    @IBOutlet weak var tri_1_4: UIImageView!
    @IBOutlet weak var tri_1_5: UIImageView!
    @IBOutlet weak var tri_1_6: UIImageView!
    @IBOutlet weak var tri_1_7: UIImageView!
    @IBOutlet weak var tri_1_8: UIImageView!
    @IBOutlet weak var tri_2_0: UIImageView!
    @IBOutlet weak var tri_2_1: UIImageView!
    @IBOutlet weak var tri_2_2: UIImageView!
    @IBOutlet weak var tri_2_3: UIImageView!
    @IBOutlet weak var tri_2_4: UIImageView!
    @IBOutlet weak var tri_2_5: UIImageView!
    @IBOutlet weak var tri_2_6: UIImageView!
    @IBOutlet weak var tri_2_7: UIImageView!
    @IBOutlet weak var tri_2_8: UIImageView!
    @IBOutlet weak var tri_2_9: UIImageView!
    @IBOutlet weak var tri_2_10: UIImageView!
    @IBOutlet weak var tri_3_0: UIImageView!
    @IBOutlet weak var tri_3_1: UIImageView!
    @IBOutlet weak var tri_3_2: UIImageView!
    @IBOutlet weak var tri_3_3: UIImageView!
    @IBOutlet weak var tri_3_4: UIImageView!
    @IBOutlet weak var tri_3_5: UIImageView!
    @IBOutlet weak var tri_3_6: UIImageView!
    @IBOutlet weak var tri_3_7: UIImageView!
    @IBOutlet weak var tri_3_8: UIImageView!
    @IBOutlet weak var tri_3_9: UIImageView!
    @IBOutlet weak var tri_3_10: UIImageView!
    @IBOutlet weak var tri_4_0: UIImageView!
    @IBOutlet weak var tri_4_1: UIImageView!
    @IBOutlet weak var tri_4_2: UIImageView!
    @IBOutlet weak var tri_4_3: UIImageView!
    @IBOutlet weak var tri_4_4: UIImageView!
    @IBOutlet weak var tri_4_5: UIImageView!
    @IBOutlet weak var tri_4_6: UIImageView!
    @IBOutlet weak var tri_4_7: UIImageView!
    @IBOutlet weak var tri_4_8: UIImageView!
    @IBOutlet weak var tri_5_0: UIImageView!
    @IBOutlet weak var tri_5_1: UIImageView!
    @IBOutlet weak var tri_5_2: UIImageView!
    @IBOutlet weak var tri_5_3: UIImageView!
    @IBOutlet weak var tri_5_4: UIImageView!
    @IBOutlet weak var tri_5_5: UIImageView!
    @IBOutlet weak var tri_5_6: UIImageView!
   //--------------------------------------------------------------------------------------------------------------------
 
    
    //2-D array saves whether each triangle is filled or not
    var filled: Array<Array<Bool>> = [[false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false, false,false, false],[false,false,false,false,false,false,false,false, false,false, false],[false,false,false,false,false,false,false,false, false],[false,false,false,false,false,false,false]]
    
    
    
//--------------------------------------------------------------------------------------------------------------------
//set two default grey triangle
    
//downwards triangle
    let downwards_tri = UIImage(named:"grey_tir_downwards")
    
//upwards triangle
    let upwards_tri = UIImage(named:"grey_tri_upwards")
//--------------------------------------------------------------------------------------------------------------------

    
    
    
    
    
    
    //outlet connection variable for MarkBoard (top left)
    @IBOutlet weak var MarkBoard: UILabel!
    
    
    
    
    
    //initialize two temporary mark value
    var temp_mark_str = String()
    var temp_mark_int = 0
    //implement the function to increment 1 whenever press "test" button
    @IBAction func Mark_Mannual_Increment_Test(_ sender: UIButton) {
        temp_mark_str = MarkBoard.text!
        temp_mark_int = Int(temp_mark_str)!
        temp_mark_int += 1
        temp_mark_str = String(temp_mark_int)
        MarkBoard.text = temp_mark_str
        //a series of changing color of some triangles
        tri_4_6.image = downwards_tri?.tint(color: tri_color_0,blendMode: .destinationIn)
        tri_0_0.image = upwards_tri?.tint(color: tri_color_1, blendMode: .destinationIn)
        tri_1_1.image = downwards_tri?.tint(color: tri_color_2, blendMode: .destinationIn)
        tri_2_3.image = downwards_tri?.tint(color: tri_color_3, blendMode: .destinationIn)
        tri_4_2.image = downwards_tri?.tint(color: tri_color_4, blendMode: .destinationIn)
    }
    
    
    
    
    
    
    
   }




