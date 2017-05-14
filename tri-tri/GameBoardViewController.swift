//
//  GameBoardViewController.swift
//  tri-tri
//
//  Created by Feiran Hu on 2017-05-10.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import AVFoundation

class GameBoardViewController: UIViewController {

//create an array to store shape_index for each UIImageView
// each int inside array reprensents shape index
//every shape is the same name as they are in Assets.xcassets file
//shape index 0: 绿色tri  index 1: 橙色tri index 2: 棕色tri index 3:brown_downwards 4:brown_left_direction 5:dark_green_tri
    
    var shape_type_index : Array<Int> = [0 , 0, 0]
//
    

    
    
//--------------------------------------------------------------------------------------------------------------------------
//draggable element three drag triangles implementation
    
    @IBOutlet weak var green_drag_tri: UIImageView!
    @IBOutlet weak var light_brown_drag_tri: UIImageView!
    @IBOutlet weak var orange_drag_tri: UIImageView!
    //the index of position which is being dragged
    var position_in_use: Int = 3
    //0 for green_drag_tri 1 for orange_drag_tri 2 for light_brown_tri
    var previous_drag_fit_UIImage_index : Int = 3
    var exist1 = true
    var exist2 = true
    var exist3 = true
    //original location of drag_image (only declaration here
    var green_drag_origin = CGPoint(x: 0, y:0 )
    var orange_drag_origin = CGPoint(x: 0, y:0 )
    var light_brown_drag_origin = CGPoint(x:0 , y:0)
    var green_drag_tri_orig_rec = CGRect(origin:  CGPoint(x: 0, y:0 ) , size: CGSize(width: 0 , height: 0))
    var orange_drag_tri_orig_rec = CGRect(origin:  CGPoint(x: 0, y:0 ) , size: CGSize(width: 0 , height: 0))
    var light_brown_drag_tri_orig_rec = CGRect(origin:  CGPoint(x: 0, y:0 ) , size: CGSize(width: 0 , height: 0))
    //adding one method by overriding touchesBegan function to get initial touch location
    var initialTouchLocation: CGPoint!
  
    //shape index refers to different shape type (FOR NOW)
    var Shape_Index_1 = 0   //0 green
    var Shape_Index_2 = 1   //1 orange
    var Shape_Index_3 = 2   //2 LIGHT BROWN
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        initialTouchLocation = touches.first!.location(in: view)
        //print("Touche at x: \(initialTouchLocation.x), y:\(initialTouchLocation.y)")

    }
    
    
    //--------------------------------------------------------------------------------------------------------------------------
    //initialize an array for random generator
        var generator_array : Array<UIImage> = [UIImage(named:"绿色tri.png")!,UIImage(named:"橙色tri.png")!,UIImage(named:"棕色tri.png")!,UIImage(named:"brown_downwards.png")!,UIImage(named:"brown_left_direction.png")!,UIImage(named:"dark_green_tri.png")!]
    
    //--------------------------------------------------------------------------------------------------------------------------
    
    
    //declare an audio player
    var audioPlayer = AVAudioPlayer()

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
        //set CGPoint value of all grey tringles
        
        //---------------------------------------------------------------------------------------------------------------------
        //ugly and long init start:
        
        tri_location[0][0] = tri_0_0.frame.origin
        //print(tri_location[0][0].x)
        //print(tri_location[0][0].y)
        tri_location[0][1] = tri_0_1.frame.origin
        tri_location[0][2] = tri_0_2.frame.origin
        tri_location[0][3] = tri_0_3.frame.origin
        tri_location[0][4] = tri_0_4.frame.origin
        tri_location[0][5] = tri_0_5.frame.origin
        tri_location[0][6] = tri_0_6.frame.origin
        tri_location[1][0] = tri_1_0.frame.origin
        //print(tri_location[1][0].x)
       // print(tri_location[1][0].y)
        tri_location[1][1] = tri_1_1.frame.origin
        tri_location[1][2] = tri_1_2.frame.origin
        tri_location[1][3] = tri_1_3.frame.origin
        tri_location[1][4] = tri_1_4.frame.origin
        tri_location[1][5] = tri_1_5.frame.origin
        tri_location[1][6] = tri_1_6.frame.origin
        tri_location[1][7] = tri_1_7.frame.origin
        tri_location[1][8] = tri_1_8.frame.origin
        tri_location[2][0] = tri_2_0.frame.origin
        //print(tri_location[2][0].x)
       // print(tri_location[2][0].y)
        tri_location[2][1] = tri_2_1.frame.origin
        //print(tri_location[2][1].x)
        //print(tri_location[2][1].y)
        tri_location[2][2] = tri_2_2.frame.origin
       // print(tri_location[2][2].x)
       // print(tri_location[2][2].y)
        tri_location[2][3] = tri_2_3.frame.origin
        //print(tri_location[2][3].x)
        //print(tri_location[2][3].y)
        tri_location[2][4] = tri_2_4.frame.origin
       // print(tri_location[2][4].x)
       // print(tri_location[2][4].y)
        tri_location[2][5] = tri_2_5.frame.origin
        //print(tri_location[2][5].x)
       // print(tri_location[2][5].y)
        tri_location[2][6] = tri_2_6.frame.origin
       // print(tri_location[2][6].x)
       // print(tri_location[2][6].y)
        tri_location[2][7] = tri_2_7.frame.origin
       // print(tri_location[2][7].x)
       // print(tri_location[2][7].y)
        tri_location[2][8] = tri_2_8.frame.origin
        //print(tri_location[2][8].x)
        //print(tri_location[2][8].y)
        tri_location[2][9] = tri_2_9.frame.origin
        //print(tri_location[2][9].x)
        //print(tri_location[2][9].y)
        tri_location[2][10] = tri_2_10.frame.origin
        //print(tri_location[2][10].x)
        //print(tri_location[2][10].y)
        tri_location[3][0] = tri_3_0.frame.origin
        //print(tri_location[3][0].x)
        //print(tri_location[3][0].y)
        tri_location[3][1] = tri_3_1.frame.origin
        tri_location[3][2] = tri_3_2.frame.origin
        tri_location[3][3] = tri_3_3.frame.origin
        tri_location[3][4] = tri_3_4.frame.origin
        tri_location[3][5] = tri_3_5.frame.origin
        tri_location[3][6] = tri_3_6.frame.origin
        tri_location[3][7] = tri_3_7.frame.origin
        tri_location[3][8] = tri_3_8.frame.origin
        tri_location[3][9] = tri_3_9.frame.origin
        tri_location[3][10] = tri_3_10.frame.origin
        tri_location[4][0] = tri_4_0.frame.origin
        //print(tri_location[4][0].x)
        //print(tri_location[4][0].y)
        tri_location[4][1] = tri_4_1.frame.origin
        tri_location[4][2] = tri_4_2.frame.origin
        tri_location[4][3] = tri_4_3.frame.origin
        tri_location[4][4] = tri_4_4.frame.origin
        tri_location[4][5] = tri_4_5.frame.origin
        tri_location[4][6] = tri_4_6.frame.origin
        tri_location[4][7] = tri_4_7.frame.origin
        tri_location[4][8] = tri_4_8.frame.origin
        tri_location[5][0] = tri_5_0.frame.origin
        //print(tri_location[5][0].x)
        //print(tri_location[5][0].y)
        tri_location[5][1] = tri_5_1.frame.origin
        tri_location[5][2] = tri_5_2.frame.origin
        tri_location[5][3] = tri_5_3.frame.origin
        tri_location[5][4] = tri_5_4.frame.origin
        tri_location[5][5] = tri_5_5.frame.origin
        tri_location[5][6] = tri_5_6.frame.origin
        
        //-----------------------------------------------------------------------------------------------
        //ugly and long init finished XD
        
        //audio intialize
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "background music", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
        }
        catch{
            print("error")
        }
        //
        
        //
        //print("origin x is\(green_drag_tri.frame.origin.x), origin y is \(green_drag_tri.frame.origin.y)")
        //
        //initialize shape array
        shape_type_index = [0 , 1 , 2]
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //function in response to drag movement
    func panGestureRecognizerAction(_ gesture: UIPanGestureRecognizer){
        var actual_type_index = 0
        var actual_location = CGPoint(x:0, y:0)
        //if original frame contains the initial point
        if(green_drag_tri_orig_rec.contains(initialTouchLocation)){
            if (exist1 == false){
                return
            }
            position_in_use = 0
            //alternative_drag_tri = green_drag_tri
            let transition0 = gesture.translation(in: green_drag_tri)
            green_drag_tri.frame.origin = CGPoint(x: green_drag_origin.x+transition0.x , y: green_drag_origin.y+transition0.y)
            actual_type_index = shape_type_index[0]
            actual_location = green_drag_tri.frame.origin
        } else if(orange_drag_tri_orig_rec.contains(initialTouchLocation)){
            if (exist2 == false){
                return
            }
            position_in_use = 1
            //alternative_drag_tri = orange_drag_tri
            let transition1 = gesture.translation(in: orange_drag_tri)
            orange_drag_tri.frame.origin = CGPoint(x:orange_drag_origin.x+transition1.x , y:orange_drag_origin.y+transition1.y)
            actual_type_index = shape_type_index[1]
            actual_location = orange_drag_tri.frame.origin
        }else if(light_brown_drag_tri_orig_rec.contains(initialTouchLocation)){
            if (exist3 == false){
                return
            }
            position_in_use = 2
            //alternative_drag_tri = *light_brown_drag_tri
            let transition2 = gesture.translation(in: light_brown_drag_tri)
            light_brown_drag_tri.frame.origin = CGPoint(x:light_brown_drag_origin.x+transition2.x , y:light_brown_drag_origin.y+transition2.y)
            actual_type_index = shape_type_index[2]
            actual_location = light_brown_drag_tri.frame.origin
        }
        
        //when dragging, keep scanning whether the shape fits any space
        if( Shape_fitting_When_Dragging(Shape_Type: actual_type_index, position: actual_location) ){
            
            
        } else if (!Shape_fitting_When_Dragging(Shape_Type: actual_type_index, position: actual_location)){
           Restore_Grey_Tris()
            if(position_in_use == 0){
                green_drag_tri.image = generator_array [actual_type_index]
            }
            else if(position_in_use == 1){
                orange_drag_tri.image = generator_array [actual_type_index]
        }else if(position_in_use == 2){
                 light_brown_drag_tri.image = generator_array [actual_type_index]
        }
        }
        
    
        //if dragging ended, return to original location (with animiation)
        if(gesture.state == .ended){
            if(Check_for_Gameover()){
                print("Game Over!")
            }
            if (Shape_fitting(Shape_Type: actual_type_index, position: actual_location)){
                Check_and_Erase()
                Restore_Grey_Tris()
                //if the triangles are fit
                if (position_in_use == 0){
                    exist1 = false
                }else if (position_in_use == 1){
                    exist2 = false
                }else if (position_in_use == 2){
                    exist3 = false
                }
                position_in_use = 3
                green_drag_tri.frame.origin = green_drag_origin
                orange_drag_tri.frame.origin = orange_drag_origin
                light_brown_drag_tri.frame.origin = light_brown_drag_origin

                if(Eligible_to_Generate()){
                    auto_random_generator()
                }
                if(Check_for_Gameover()){
                    print("haaaaaaaaaaaaaaaaa")
                    let subView = UIView.init(frame: CGRect(origin: CGPoint(x: 0, y:0 ), size: CGSize(width: 200, height: 100)))
                    subView.backgroundColor = UIColor.yellow
                    self.view.addSubview(subView)
                }

                
            } else {
                position_in_use = 3
                UIView.animate(withDuration: 0.3, animations: {
                self.green_drag_tri.frame.origin = self.green_drag_origin
                self.orange_drag_tri.frame.origin = self.orange_drag_origin
                self.light_brown_drag_tri.frame.origin = self.light_brown_drag_origin
                })
            }
            

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
    
    //color No.0 is 绿色tri (st 0)
    let tri_color_0 = UIColor(red:CGFloat(113/255.0), green:CGFloat(148/255.0), blue:CGFloat(92/255.0), alpha:CGFloat(1))
    
    //color No.1 is 橙色tri (st 1)
    let tri_color_1 = UIColor(red:CGFloat(223/255.0), green:CGFloat(110/255.0), blue:CGFloat(67/255.0), alpha:CGFloat(1))
    
    //color No.2 is 棕色tri (st 2 3 4)
    let tri_color_2 = UIColor(red:CGFloat(213/255.0), green:CGFloat(193/255.0), blue:CGFloat(151/255.0), alpha:CGFloat(1))
    
    //color No.3 is dark green (st 5)
    let tri_color_3 = UIColor(red:CGFloat(27/255.0), green:CGFloat(58/255.0), blue:CGFloat(49/255.0), alpha:CGFloat(1))
    
    //color No.4 is not yet used
     let tri_color_4 = UIColor(red:CGFloat(111/255.0), green:CGFloat(151/255.0), blue:CGFloat(91/255.0), alpha:CGFloat(1))
    
    //color No.5 is trans
    let tri_color_5 = UIColor(red:CGFloat(111/255.0), green:CGFloat(151/255.0), blue:CGFloat(91/255.0), alpha:CGFloat(0))
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
    

    //2-D array saves corresponding location
    var tri_location: Array<Array<CGPoint>> = [
        [CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 )],
        [CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 )],
        [CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 )],
        [CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 )],
        [CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 )],
        [CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 ),CGPoint(x: 0, y:0 )]]
    
    
//--------------------------------------------------------------------------------------------------------------------
//set two default grey triangle
    
//downwards triangle
    let downwards_tri = UIImage(named:"grey_tir_downwards")
    
//upwards triangle
    let upwards_tri = UIImage(named:"grey_tri_upwards")

//green tri elements
    let super_light_green_down = UIImage(named:"super_light_green_down")
    
    let super_light_green_up = UIImage(named:"super_light_green_up")
    
//orange tri elements
    
    let orange_down = UIImage(named:"orange_downwards")
    
    let orange_up = UIImage(named:"orange_up")
    
//light brown elements
    
    let light_brown_up = UIImage(named:"light_brown_up")
    
    let light_brown_down = UIImage(named:"light_brown_down")
    
//dark green elements
    
    let dark_green_up = UIImage(named:"green_up")
    
    let dark_green_down = UIImage(named:"green_down")
    
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
        audioPlayer.play()
    }
    
    
    func auto_make_transparent() -> Void {
        
        if(position_in_use == 0){
            green_drag_tri.image = UIImage(named:"绿色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
        }else if(position_in_use == 1){
           orange_drag_tri.image = UIImage(named:"橙色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
        }else if(position_in_use == 2){
             light_brown_drag_tri.image = UIImage(named:"棕色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
        }

    }
    
    
    
    func Shape_fitting(Shape_Type: Int, position: CGPoint) -> Bool {
        if (Shape_Type == 0){
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 0 || i == 1 || i == 2){//upper half
                    if (j%2 == 1){//only downward
                        if (position.x + 25 <= triangle_location.x + 12 && position.x + 25 >= triangle_location.x - 12 &&
                            position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 12){//check location
                            if (!filled[i][j] && !filled[i][j-1] && !filled[i][j+1]){//check available
                                
                                //green_drag_tri.image = UIImage(named:"绿色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                auto_make_transparent()
                                Change_Corresponding_Color_With_Image(x:i, y:j, image: super_light_green_down)
                                Change_Corresponding_Color_With_Image(x:i, y:j-1, image: super_light_green_up)
                                Change_Corresponding_Color_With_Image(x:i, y:j+1, image: super_light_green_up)
                                filled[i][j] = true
                                filled[i][j-1] = true
                                filled[i][j+1] = true
                               
                                
                                return true
                            }
                            return false
                        }
                    }
                        
                    } else if (i == 3 || i == 4 || i == 5){
                        if (j%2 == 0 && j != 0 && j != tri_location[i].count - 1){//lower half&&not edge
                            if (position.x + 25 <= triangle_location.x + 12 && position.x + 25 >= triangle_location.x - 12 &&
                                position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 12){
                                if (!filled[i][j] && !filled[i][j-1] && !filled[i][j+1]){
                                    //green_drag_tri.image = UIImage(named:"绿色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: super_light_green_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j-1, image: super_light_green_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: super_light_green_up)
                                    filled[i][j] = true
                                    filled[i][j-1] = true
                                    filled[i][j+1] = true
                                    
                                   
                                    return true
                                }
                                return false
                            }
                        }

                    }
                    j += 1
                }
                i += 1
            }
        } else if (Shape_Type == 1){
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 0 || i == 1){//upper half row 0 1
                        if (j%2 == 0){//only upward
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 12 &&
                                position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i+1][j+1]){//check available
                                    //orange_drag_tri.image = UIImage(named:"橙色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: orange_up)
                                    Change_Corresponding_Color_With_Image(x:i+1, y:j+1, image: orange_down)
                                    filled[i+1][j+1] = true
                                    filled[i][j] = true
                                    
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 2){//upper half row 2
                        if (j%2 == 0){//only upward
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 12 &&
                                position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i+1][j]){//check available
                                    //orange_drag_tri.image = UIImage(named:"橙色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: orange_up)
                                    Change_Corresponding_Color_With_Image(x:i+1, y:j, image: orange_down)
                                    filled[i][j] = true
                                    filled[i+1][j] = true
                                    
                                

                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    else if (i == 3 || i == 4){
                        if (j%2 == 1){//lower half
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 12 &&
                                position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 12){
                                if (!filled[i][j] && !filled[i+1][j-1]){
                                    //orange_drag_tri.image = UIImage(named:"橙色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: orange_up)
                                    Change_Corresponding_Color_With_Image(x:i+1, y:j-1, image: orange_down)
                                    filled[i][j] = true
                                    filled[i+1][j-1] = true
                                    
                                 

                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    j += 1
                }
                i += 1
            }
        } else if (Shape_Type == 2) {    //Shape_Type == 2
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 1 || i == 2){//upper half row 1 2
                        if (j%2 == 0 && j != tri_location[i].count - 1){//only upward
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 12 &&
                                position.y + 44 <= triangle_location.y + 12 && position.y + 44 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i-1][j]){//check available
                                   //light_brown_drag_tri.image = UIImage(named:"棕色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j, image: light_brown_up)
                                    
                                    filled[i][j] = true
                                    filled[i][j+1] = true
                                    filled[i-1][j] = true
                                   
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3){//lower half row 3
                        if (j%2 == 1){//only upward
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 12 &&
                                position.y + 44 <= triangle_location.y + 12 && position.y + 44 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i-1][j+1]){//check available
                                   // light_brown_drag_tri.image = UIImage(named:"棕色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j+1, image: light_brown_up)
                                    filled[i][j] = true
                                    filled[i][j+1] = true
                                    filled[i-1][j+1] = true
                                   
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    else if (i == 4 || i == 5){
                        if (j%2 == 1){//lower half
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 12 &&
                                position.y + 44 <= triangle_location.y + 12 && position.y+44 >= triangle_location.y - 12){
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i-1][j+2]){
                                    //light_brown_drag_tri.image = UIImage(named:"棕色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j+2, image: light_brown_up)
                                    filled[i][j] = true
                                    filled[i][j+1] = true
                                    filled[i-1][j+2] = true
                              
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    j += 1
                }
                i += 1
            }

        }
        else if (Shape_Type == 3) {    //Shape_Type == 3
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 0||i == 1 || i == 2){//upper half row 1 2
                        if (j%2 == 0 && j != tri_location[i].count - 1 && j != 0){//only upward
                            if (position.x + 31.5 <= triangle_location.x + 12 && position.x + 31.5 >= triangle_location.x - 12 &&
                                position.y + 33.5 <= triangle_location.y + 12 && position.y + 33.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i][j-1]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j-1, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_down)
                                    
                                    filled[i][j] = true
                                    filled[i][j+1] = true
                                    filled[i][j-1] = true
                                 
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3 || i == 4 || i == 5){//lower half
                        if (j%2 == 1){//only upward
                            if (position.x + 31.5 <= triangle_location.x + 12 && position.x + 31.5 >= triangle_location.x - 12 &&
                                position.y + 33.5 <= triangle_location.y + 12 && position.y + 33.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i][j-1]){//check available
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j-1, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_down)
                                    filled[i][j] = true
                                    filled[i][j+1] = true
                                    filled[i][j-1] = true
                            
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    j += 1
                }
                i += 1
            }
            
        }
        else if (Shape_Type == 4) {    //Shape_Type == 4
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 0||i == 1 || i == 2){//upper half
                        if (j%2 == 1){//only downward
                            if (position.x + 15.5 <= triangle_location.x + 12 && position.x + 15.5 >= triangle_location.x - 12 &&
                                position.y + 32.5 <= triangle_location.y + 12 && position.y + 32.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_up)
                                    
                                    filled[i][j] = true
                                    filled[i][j+1] = true
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3 || i == 4 || i == 5){//lower half
                        if (j%2 == 0 && j != tri_location[i].count - 1){//only downward
                            if (position.x + 15.5 <= triangle_location.x + 12 && position.x + 15.5 >= triangle_location.x - 12 &&
                                position.y + 32.5 <= triangle_location.y + 12 && position.y + 32.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1]){//check available
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_up)
                                    filled[i][j] = true
                                    filled[i][j+1] = true
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    j += 1
                }
                i += 1
            }
            
        }
        else if (Shape_Type == 5) {    //Shape_Type == 5
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 1 || i == 2){//upper half row 1 2
                        if (j%2 == 0 && j != 0 && j != tri_location[i].count - 1){//only upward
                            if (position.x + 21 <= triangle_location.x + 12 && position.x + 21 >= triangle_location.x - 12 &&
                                position.y + 38.5 <= triangle_location.y + 12 && position.y + 38.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i][j-1] && !filled[i-1][j] && !filled[i-1][j-2]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: dark_green_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: dark_green_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j-1, image: dark_green_down)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j, image: dark_green_up)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j-2, image: dark_green_up)
                                    
                                    filled[i][j] = true
                                    filled[i][j+1] = true
                                    filled[i][j-1] = true
                                    filled[i-1][j] = true
                                    filled[i-1][j-2] = true
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3){//lower half row 3
                        if (j%2 == 1){//only upward
                            if (position.x + 21 <= triangle_location.x + 12 && position.x + 21 >= triangle_location.x - 12 &&
                                position.y + 38.5 <= triangle_location.y + 12 && position.y + 38.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i][j-1] && !filled[i-1][j-1] && !filled[i-1][j+1]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: dark_green_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: dark_green_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j-1, image: dark_green_down)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j+1, image: dark_green_up)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j-1, image: dark_green_up)
                                    
                                    filled[i][j] = true
                                    filled[i][j+1] = true
                                    filled[i][j-1] = true
                                    filled[i-1][j-1] = true
                                    filled[i-1][j+1] = true
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    else if (i == 4 || i == 5){//lower half row 4 5
                        if (j%2 == 1){//only upward
                            if (position.x + 21 <= triangle_location.x + 12 && position.x + 21 >= triangle_location.x - 12 &&
                                position.y + 38.5 <= triangle_location.y + 12 && position.y + 38.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i][j-1] && !filled[i-1][j] && !filled[i-1][j+2]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: dark_green_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: dark_green_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j-1, image: dark_green_down)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j+2, image: dark_green_up)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j, image: dark_green_up)
                                    
                                    filled[i][j] = true
                                    filled[i][j+1] = true
                                    filled[i][j-1] = true
                                    filled[i-1][j] = true
                                    filled[i-1][j+2] = true
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    j += 1
                }
                i += 1
            }
            
        }

        return false
    }
    
    
    func Shape_fitting_When_Dragging(Shape_Type: Int, position: CGPoint) -> Bool {
        if (Shape_Type == 0){
            
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                for triangle_location in triangles_location{
                    if (i == 0 || i == 1 || i == 2){//upper half
                        if (j%2 == 1){//only downward
                            if (position.x + 25 <= triangle_location.x + 12 && position.x + 25 >= triangle_location.x - 12 &&
                                position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j-1] && !filled[i][j+1]){//check available
                                    //green_drag_tri.image = UIImage(named:"绿色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: super_light_green_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j-1, image: super_light_green_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: super_light_green_up)
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    } else if (i == 3 || i == 4 || i == 5){
                        if (j%2 == 0 && j != 0 && j != tri_location[i].count - 1){//lower half&&not edge
                            if (position.x + 25 <= triangle_location.x + 12 && position.x + 25 >= triangle_location.x - 12 &&
                                position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 12){
                                if (!filled[i][j] && !filled[i][j-1] && !filled[i][j+1]){
                                    //green_drag_tri.image = UIImage(named:"绿色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: super_light_green_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j-1, image: super_light_green_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: super_light_green_up)
            
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    j += 1
                }
                i += 1
            }
        } else if (Shape_Type == 1){
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 0 || i == 1){//upper half row 0 1
                        if (j%2 == 0){//only upward
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 12 &&
                                position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i+1][j+1]){//check available
                                    //orange_drag_tri.image = UIImage(named:"橙色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: orange_up)
                                    Change_Corresponding_Color_With_Image(x:i+1, y:j+1, image: orange_down)
                           
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 2){//upper half row 2
                        if (j%2 == 0){//only upward
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 12 &&
                                position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i+1][j]){//check available
                                    //orange_drag_tri.image = UIImage(named:"橙色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: orange_up)
                                    Change_Corresponding_Color_With_Image(x:i+1, y:j, image: orange_down)
                              
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    else if (i == 3 || i == 4){
                        if (j%2 == 1){//lower half
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 12 &&
                                position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 12){
                                if (!filled[i][j] && !filled[i+1][j-1]){
                                    //orange_drag_tri.image = UIImage(named:"橙色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: orange_up)
                                    Change_Corresponding_Color_With_Image(x:i+1, y:j-1, image: orange_down)
                                 
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    j += 1
                }
                i += 1
            }
        } else if (Shape_Type == 2) {    //Shape_Type == 2
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 1 || i == 2){//upper half row 1 2
                        if (j%2 == 0 && j != tri_location[i].count - 1){//only upward
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 12 &&
                                position.y + 44 <= triangle_location.y + 12 && position.y + 44 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i-1][j]){//check available
                                    //light_brown_drag_tri.image = UIImage(named:"棕色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j, image: light_brown_up)
                                  
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3){//lower half row 3
                        if (j%2 == 1){//only upward
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 12 &&
                                position.y + 44 <= triangle_location.y + 12 && position.y + 44 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i-1][j+1]){//check available
                                    //light_brown_drag_tri.image = UIImage(named:"棕色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j+1, image: light_brown_up)
                                   
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    else if (i == 4 || i == 5){
                        if (j%2 == 1){//lower half
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 12 &&
                                position.y + 44 <= triangle_location.y + 12 && position.y+44 >= triangle_location.y - 12){
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i-1][j+2]){
                                    //light_brown_drag_tri.image = UIImage(named:"棕色tri")?.tint(color: tri_color_5, blendMode: .destinationIn)
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j+2, image: light_brown_up)
                                  
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    j += 1
                }
                i += 1
            }
            
        }
        else if (Shape_Type == 3) {    //Shape_Type == 3
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 0||i == 1 || i == 2){//upper half row 1 2
                        if (j%2 == 0 && j != tri_location[i].count - 1 && j != 0){//only upward
                            if (position.x + 31.5 <= triangle_location.x + 12 && position.x + 31.5 >= triangle_location.x - 12 &&
                                position.y + 33.5 <= triangle_location.y + 12 && position.y + 33.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i][j-1]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j-1, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_down)
                                    
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3 || i == 4 || i == 5){//lower half
                        if (j%2 == 1){//only upward
                            if (position.x + 31.5 <= triangle_location.x + 12 && position.x + 31.5 >= triangle_location.x - 12 &&
                                position.y + 33.5 <= triangle_location.y + 12 && position.y + 33.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i][j-1]){//check available
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j-1, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_down)
                                    
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    j += 1
                }
                i += 1
            }
            
        }
        else if (Shape_Type == 4) {    //Shape_Type == 4
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 0||i == 1 || i == 2){//upper half
                        if (j%2 == 1){//only upward
                            if (position.x + 15.5 <= triangle_location.x + 12 && position.x + 15.5 >= triangle_location.x - 12 &&
                                position.y + 32.5 <= triangle_location.y + 12 && position.y + 32.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_up)
                                    
                                    
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3 || i == 4 || i == 5){//lower half
                        if (j%2 == 0 && j != tri_location[i].count - 1){//only downward
                            if (position.x + 15.5 <= triangle_location.x + 12 && position.x + 15.5 >= triangle_location.x - 12 &&
                                position.y + 32.5 <= triangle_location.y + 12 && position.y + 32.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1]){//check available
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: light_brown_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: light_brown_up)
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    j += 1
                }
                i += 1
            }
            
        }
        else if (Shape_Type == 5) {    //Shape_Type == 5
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 1 || i == 2){//upper half row 1 2
                        if (j%2 == 0 && j != 0 && j != tri_location[i].count - 1){//only upward
                            if (position.x + 21 <= triangle_location.x + 12 && position.x + 21 >= triangle_location.x - 12 &&
                                position.y + 38.5 <= triangle_location.y + 12 && position.y + 38.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i][j-1] && !filled[i-1][j] && !filled[i-1][j-2]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: dark_green_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: dark_green_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j-1, image: dark_green_down)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j, image: dark_green_up)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j-2, image: dark_green_up)
                                    
                                    
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3){//lower half row 3
                        if (j%2 == 1){//only upward
                            if (position.x + 21 <= triangle_location.x + 12 && position.x + 21 >= triangle_location.x - 12 &&
                                position.y + 38.5 <= triangle_location.y + 12 && position.y + 38.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i][j-1] && !filled[i-1][j-1] && !filled[i-1][j+1]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: dark_green_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: dark_green_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j-1, image: dark_green_down)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j+1, image: dark_green_up)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j-1, image: dark_green_up)
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    else if (i == 4 || i == 5){//lower half row 4 5
                        if (j%2 == 1){//only upward
                            if (position.x + 21 <= triangle_location.x + 12 && position.x + 21 >= triangle_location.x - 12 &&
                                position.y + 38.5 <= triangle_location.y + 12 && position.y + 38.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1] && !filled[i][j-1] && !filled[i-1][j] && !filled[i-1][j+2]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: dark_green_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: dark_green_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j-1, image: dark_green_down)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j+2, image: dark_green_up)
                                    Change_Corresponding_Color_With_Image(x:i-1, y:j, image: dark_green_up)
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }
                    j += 1
                }
                i += 1
            }
            
        }
        return false
    }

    
    
    
    func Change_Corresponding_Color(x:Int, y:Int, color: UIColor) -> (){
        //row NO 0
        if (x == 0 && y == 0){
            tri_0_0.image = tri_0_0.image!.withRenderingMode(.alwaysTemplate)
            tri_0_0.tintColor = color
        }else if(x == 0 && y == 1) {
            tri_0_1.image = tri_0_1.image!.withRenderingMode(.alwaysTemplate)
            tri_0_1.tintColor = color
        }else if (x == 0 && y == 2){
            tri_0_2.image = tri_0_2.image!.withRenderingMode(.alwaysTemplate)
            tri_0_2.tintColor = color
        }else if(x == 0 && y == 3) {
            tri_0_3.image = tri_0_3.image!.withRenderingMode(.alwaysTemplate)
            tri_0_3.tintColor = color
        }else if (x == 0 && y == 4){
            tri_0_4.image = tri_0_4.image!.withRenderingMode(.alwaysTemplate)
            tri_0_4.tintColor = color
        }else if(x == 0 && y == 5) {
            tri_0_5.image = tri_0_5.image!.withRenderingMode(.alwaysTemplate)
            tri_0_5.tintColor = color
        }else if (x == 0 && y == 6){
            tri_0_6.image = tri_0_6.image!.withRenderingMode(.alwaysTemplate)
            tri_0_6.tintColor = color
        }
        //row NO 1
        else if (x == 1 && y == 0){
            tri_1_0.image = tri_1_0.image!.withRenderingMode(.alwaysTemplate)
            tri_1_0.tintColor = color
        }else if(x == 1 && y == 1) {
            tri_1_1.image = tri_1_1.image!.withRenderingMode(.alwaysTemplate)
            tri_1_1.tintColor = color
        }else if (x == 1 && y == 2){
            tri_1_2.image = tri_1_2.image!.withRenderingMode(.alwaysTemplate)
            tri_1_2.tintColor = color
        }else if(x == 1 && y == 3) {
            tri_1_3.image = tri_1_3.image!.withRenderingMode(.alwaysTemplate)
            tri_1_3.tintColor = color
        }else if (x == 1 && y == 4){
            tri_1_4.image = tri_1_4.image!.withRenderingMode(.alwaysTemplate)
            tri_1_4.tintColor = color
        }else if(x == 1 && y == 5) {
            tri_1_5.image = tri_1_5.image!.withRenderingMode(.alwaysTemplate)
            tri_1_5.tintColor = color
        }else if (x == 1 && y == 6){
            tri_1_6.image = tri_1_6.image!.withRenderingMode(.alwaysTemplate)
            tri_1_6.tintColor = color
        }else if(x == 1 && y == 7) {
            tri_1_7.image = tri_1_7.image!.withRenderingMode(.alwaysTemplate)
            tri_1_7.tintColor = color
        }else if (x == 1 && y == 8){
            tri_1_8.image = tri_1_8.image!.withRenderingMode(.alwaysTemplate)
            tri_1_8.tintColor = color
        }
        //row NO 2
        else if(x == 2 && y == 0) {
            tri_2_0.image = tri_2_0.image!.withRenderingMode(.alwaysTemplate)
            tri_2_0.tintColor = color
        }else if(x == 2 && y == 1) {
            tri_2_1.image = tri_2_1.image!.withRenderingMode(.alwaysTemplate)
            tri_2_1.tintColor = color
        }else if(x == 2 && y == 2) {
            tri_2_2.image = tri_2_2.image!.withRenderingMode(.alwaysTemplate)
            tri_2_2.tintColor = color
        }else if(x == 2 && y == 3) {
            tri_2_3.image = tri_2_3.image!.withRenderingMode(.alwaysTemplate)
            tri_2_3.tintColor = color
        }else if(x == 2 && y == 4) {
            tri_2_4.image = tri_2_4.image!.withRenderingMode(.alwaysTemplate)
            tri_2_4.tintColor = color
        }else if(x == 2 && y == 5) {
            tri_2_5.image = tri_2_5.image!.withRenderingMode(.alwaysTemplate)
            tri_2_5.tintColor = color
        }else if(x == 2 && y == 6) {
            tri_2_6.image = tri_2_6.image!.withRenderingMode(.alwaysTemplate)
            tri_2_6.tintColor = color
        }else if(x == 2 && y == 7) {
            tri_2_7.image = tri_2_7.image!.withRenderingMode(.alwaysTemplate)
            tri_2_7.tintColor = color
        }else if(x == 2 && y == 8) {
            tri_2_8.image = tri_2_8.image!.withRenderingMode(.alwaysTemplate)
            tri_2_8.tintColor = color
        }else if(x == 2 && y == 9) {
            tri_2_9.image = tri_2_9.image!.withRenderingMode(.alwaysTemplate)
            tri_2_9.tintColor = color
        }else if(x == 2 && y == 10) {
            tri_2_10.image = tri_2_10.image!.withRenderingMode(.alwaysTemplate)
            tri_2_10.tintColor = color
        }
        //row NO 3
        else if(x == 3 && y == 0) {
            tri_3_0.image = tri_3_0.image!.withRenderingMode(.alwaysTemplate)
            tri_3_0.tintColor = color
        }else if(x == 3 && y == 1) {
            tri_3_1.image = tri_3_1.image!.withRenderingMode(.alwaysTemplate)
            tri_3_1.tintColor = color
        }else if(x == 3 && y == 2) {
            tri_3_2.image = tri_3_2.image!.withRenderingMode(.alwaysTemplate)
            tri_3_2.tintColor = color
        }else if(x == 3 && y == 3) {
            tri_3_3.image = tri_3_3.image!.withRenderingMode(.alwaysTemplate)
            tri_3_3.tintColor = color
        }else if(x == 3 && y == 4) {
            tri_3_4.image = tri_3_4.image!.withRenderingMode(.alwaysTemplate)
            tri_3_4.tintColor = color
        }else if(x == 3 && y == 5) {
            tri_3_5.image = tri_3_5.image!.withRenderingMode(.alwaysTemplate)
            tri_3_5.tintColor = color
        }else if(x == 3 && y == 6) {
            tri_3_6.image = tri_3_6.image!.withRenderingMode(.alwaysTemplate)
            tri_3_6.tintColor = color
        }else if(x == 3 && y == 7) {
            tri_3_7.image = tri_3_7.image!.withRenderingMode(.alwaysTemplate)
            tri_3_7.tintColor = color
        }else if(x == 3 && y == 8) {
            tri_3_8.image = tri_3_8.image!.withRenderingMode(.alwaysTemplate)
            tri_3_8.tintColor = color
        }else if(x == 3 && y == 9) {
            tri_3_9.image = tri_3_9.image!.withRenderingMode(.alwaysTemplate)
            tri_3_9.tintColor = color
        }else if(x == 3 && y == 10) {
            tri_3_10.image = tri_3_10.image!.withRenderingMode(.alwaysTemplate)
            tri_3_10.tintColor = color
        }
        //row NO 4
        else if (x == 4 && y == 0){
            tri_4_0.image = tri_4_0.image!.withRenderingMode(.alwaysTemplate)
            tri_4_0.tintColor = color
        }else if(x == 4 && y == 1) {
            tri_4_1.image = tri_4_1.image!.withRenderingMode(.alwaysTemplate)
            tri_4_1.tintColor = color
        }else if (x == 4 && y == 2){
            tri_4_2.image = tri_4_2.image!.withRenderingMode(.alwaysTemplate)
            tri_4_2.tintColor = color
        }else if(x == 4 && y == 3) {
            tri_4_3.image = tri_4_3.image!.withRenderingMode(.alwaysTemplate)
            tri_4_3.tintColor = color
        }else if (x == 4 && y == 4){
            tri_4_4.image = tri_4_4.image!.withRenderingMode(.alwaysTemplate)
            tri_4_4.tintColor = color
        }else if(x == 4 && y == 5) {
            tri_4_5.image = tri_4_5.image!.withRenderingMode(.alwaysTemplate)
            tri_4_5.tintColor = color
        }else if (x == 4 && y == 6){
            tri_4_6.image = tri_4_6.image!.withRenderingMode(.alwaysTemplate)
            tri_4_6.tintColor = color
        }else if(x == 4 && y == 7) {
            tri_4_7.image = tri_4_7.image!.withRenderingMode(.alwaysTemplate)
            tri_4_7.tintColor = color
        }else if (x == 4 && y == 8){
            tri_4_8.image = tri_4_8.image!.withRenderingMode(.alwaysTemplate)
            tri_4_8.tintColor = color
        }
        //row NO 5
        else if (x == 5 && y == 0){
            tri_5_0.image = tri_5_0.image!.withRenderingMode(.alwaysTemplate)
            tri_5_0.tintColor = color
        }else if(x == 5 && y == 1) {
            tri_5_1.image = tri_5_1.image!.withRenderingMode(.alwaysTemplate)
            tri_5_1.tintColor = color
        }else if (x == 5 && y == 2){
            tri_5_2.image = tri_5_2.image!.withRenderingMode(.alwaysTemplate)
            tri_5_2.tintColor = color
        }else if(x == 5 && y == 3) {
            tri_5_3.image = tri_5_3.image!.withRenderingMode(.alwaysTemplate)
            tri_5_3.tintColor = color
        }else if (x == 5 && y == 4){
            tri_5_4.image = tri_5_4.image!.withRenderingMode(.alwaysTemplate)
            tri_5_4.tintColor = color
        }else if(x == 5 && y == 5) {
            tri_5_5.image = tri_5_5.image!.withRenderingMode(.alwaysTemplate)
            tri_5_5.tintColor = color
        }else if (x == 5 && y == 6){
            tri_5_6.image = tri_5_6.image!.withRenderingMode(.alwaysTemplate)
            tri_5_6.tintColor = color
        }


        return
    }
    
    @IBAction func random_generator(_ sender: UIButton) {
        var randomIndex = Int(arc4random_uniform(UInt32(generator_array.count)))
        green_drag_tri.image = generator_array[randomIndex]
        green_drag_tri.sizeToFit()
        green_drag_tri_orig_rec = green_drag_tri.frame
        shape_type_index[0] = randomIndex
        //print("position 0 shape index : \(shape_type_index[0])")
        //print("new origin x is\(green_drag_tri.frame.origin.x), new origin y is \(green_drag_tri.frame.origin.y)")
        //print("upperleft coordiante is (x: \(green_drag_tri.frame.origin.x - green_drag_tri.frame.width/2)) ")
       // force_recenter_drag_tris( tri: green_drag_tri,tri_img: generator_array[randomIndex] )
    
        
        randomIndex = Int(arc4random_uniform(UInt32(generator_array.count)))
        orange_drag_tri.image = generator_array[randomIndex]
        orange_drag_tri.sizeToFit()
        orange_drag_tri_orig_rec = orange_drag_tri.frame
        shape_type_index[1] = randomIndex
        //print("position 1 shape index : \(shape_type_index[1])")

        //force_recenter_drag_tris( tri: orange_drag_tri,tri_img: generator_array[randomIndex] )

        randomIndex = Int(arc4random_uniform(UInt32(generator_array.count)))
        light_brown_drag_tri.image = generator_array[randomIndex]
        light_brown_drag_tri.sizeToFit()
        light_brown_drag_tri_orig_rec = light_brown_drag_tri.frame
        force_recenter_drag_tris( tri: light_brown_drag_tri,tri_img: generator_array[randomIndex] )
        shape_type_index[2] = randomIndex
        //print("position 2 shape index : \(shape_type_index[2])")

        exist1 = true
        exist2 = true
        exist3 = true
    }
    
    
    func force_recenter_drag_tris ( tri: UIImageView, tri_img: UIImage!) -> Void{
        switch tri_img {
        case UIImage(named:"绿色tri.png")!:
            if(tri == green_drag_tri){
                tri.frame.origin = green_drag_origin
            }else if(tri == orange_drag_tri){
                tri.frame.origin = CGPoint(x:orange_drag_origin.x-CGFloat(30), y:orange_drag_origin.y + CGFloat(17))
            }else if(tri == light_brown_drag_tri){
                tri.frame.origin = CGPoint(x:light_brown_drag_origin.x, y:light_brown_drag_origin.y + CGFloat(10))
            }
       // case UIImage(nm)
        default:
            if(tri == green_drag_tri){
            tri.frame.origin = green_drag_origin
            }else if(tri == orange_drag_tri){
                tri.frame.origin = orange_drag_origin
            }else if(tri == light_brown_drag_tri){
          
                
                tri.frame.origin = light_brown_drag_origin
            }
        }
    }
    
    func Restore_Grey_Tris( ) ->Void {
        //row NO 0
        if (!filled[0][0]){
            tri_0_0.image = upwards_tri
        }
        if(!filled[0][1]) {
            tri_0_1.image = downwards_tri
        }
        if (!filled[0][2]){
            tri_0_2.image = upwards_tri
        }
        if(!filled[0][3]) {
            tri_0_3.image = downwards_tri
        }
        if (!filled[0][4]){
            tri_0_4.image = upwards_tri
        }
        if(!filled[0][5]) {
            tri_0_5.image = downwards_tri
        }
        if (!filled[0][6]){
            tri_0_6.image = upwards_tri
        }
            //row NO 1
        if (!filled[1][0]){
            tri_1_0.image = upwards_tri
        }
        if(!filled[1][1]) {
            tri_1_1.image = downwards_tri
        }
        if (!filled[1][2]){
            tri_1_2.image = upwards_tri
        }
        if(!filled[1][3]) {
            tri_1_3.image = downwards_tri
        }
        if (!filled[1][4]){
            tri_1_4.image = upwards_tri
        }
        if(!filled[1][5]) {
            tri_1_5.image = downwards_tri
        }
        if (!filled[1][6]){
            tri_1_6.image = upwards_tri
        }
        if(!filled[1][7]) {
            tri_1_7.image = downwards_tri
        }
        if (!filled[1][8]){
            tri_1_8.image = upwards_tri
        }
            //row NO 2
        if(!filled[2][0]) {
            tri_2_0.image = upwards_tri
        }
        if(!filled[2][1]) {
            tri_2_1.image = downwards_tri
        }
        if(!filled[2][2]) {
            tri_2_2.image = upwards_tri
        }
        if(!filled[2][3]) {
            tri_2_3.image = downwards_tri
        }
        if(!filled[2][4]) {
            tri_2_4.image = upwards_tri
       }
        if(!filled[2][5]) {
            tri_2_5.image = downwards_tri
        }
        if(!filled[2][6]) {
            tri_2_6.image = upwards_tri
        }
        if(!filled[2][7]) {
            tri_2_7.image = downwards_tri
        }
        if(!filled[2][8]) {
            tri_2_8.image = upwards_tri
        }
        if(!filled[2][9]) {
            tri_2_9.image = downwards_tri
        }
        if(!filled[2][10]) {
            tri_2_10.image = upwards_tri
        }
            //row NO 3
        if(!filled[3][0]) {
            tri_3_0.image = downwards_tri
        }
        if(!filled[3][1]) {
            tri_3_1.image = upwards_tri
        }
        if(!filled[3][2]) {
            tri_3_2.image = downwards_tri
        }
        if(!filled[3][3]) {
            tri_3_3.image = upwards_tri
        }
        if(!filled[3][4]) {
            tri_3_4.image = downwards_tri
        }
        if(!filled[3][5]) {
            tri_3_5.image = upwards_tri
        }
        if(!filled[3][6]) {
            tri_3_6.image = downwards_tri
        }
        if(!filled[3][7]) {
            tri_3_7.image = upwards_tri
        }
        if(!filled[3][8]) {
            tri_3_8.image = downwards_tri
       }
        if(!filled[3][9]) {
            tri_3_9.image = upwards_tri
      }
        if(!filled[3][10]) {
            tri_3_10.image = downwards_tri
        }
            //row NO 4
        
        if (!filled[4][0]){
            tri_4_0.image = downwards_tri
        }
        if(!filled[4][1]) {
            tri_4_1.image = upwards_tri
        }
        if (!filled[4][2]){
            tri_4_2.image = downwards_tri
        }
        if(!filled[4][3]) {
            tri_4_3.image = upwards_tri
        }
        if (!filled[4][4]){
            tri_4_4.image = downwards_tri
        }
        if(!filled[4][5]) {
            tri_4_5.image = upwards_tri
        }
        if (!filled[4][6]){
            tri_4_6.image = downwards_tri
        }
        if(!filled[4][7]) {
            tri_4_7.image = upwards_tri
       }
        if (!filled[4][8]){
            tri_4_8.image = downwards_tri
        }
            //row NO 5
        if (!filled[5][0]){
            tri_5_0.image = downwards_tri
        }
        if(!filled[5][1]) {
            tri_5_1.image = upwards_tri
        }
        if (!filled[5][2]){
            tri_5_2.image = downwards_tri
        }
        if(!filled[5][3]) {
            tri_5_3.image = upwards_tri
        }
        if (!filled[5][4]){
            tri_5_4.image = downwards_tri
        }
        if(!filled[5][5]) {
            tri_5_5.image = upwards_tri
        }
        if (!filled[5][6]){
            tri_5_6.image = downwards_tri
        }

    }
    
    //change color with image
    func Change_Corresponding_Color_With_Image(x:Int, y:Int, image: UIImage?) -> (){
        //row NO 0
        if (x == 0 && y == 0){
            tri_0_0.image = image
        }else if(x == 0 && y == 1) {
            tri_0_1.image = image
        }else if (x == 0 && y == 2){
            tri_0_2.image = image
        }else if(x == 0 && y == 3) {
            tri_0_3.image = image
        }else if (x == 0 && y == 4){
            tri_0_4.image = image
        }else if(x == 0 && y == 5) {
            tri_0_5.image = image
        }else if (x == 0 && y == 6){
            tri_0_6.image = image
        }
            //row NO 1
        else if (x == 1 && y == 0){
            tri_1_0.image = image
        }else if(x == 1 && y == 1) {
            tri_1_1.image = image
        }else if (x == 1 && y == 2){
            tri_1_2.image = image
        }else if(x == 1 && y == 3) {
            tri_1_3.image = image
        }else if (x == 1 && y == 4){
            tri_1_4.image = image
        }else if(x == 1 && y == 5) {
            tri_1_5.image = image
        }else if (x == 1 && y == 6){
            tri_1_6.image = image
        }else if(x == 1 && y == 7) {
            tri_1_7.image = image
        }else if (x == 1 && y == 8){
            tri_1_8.image = image
        }
            //row NO 2
        else if(x == 2 && y == 0) {
            tri_2_0.image = image
        }else if(x == 2 && y == 1) {
            tri_2_1.image = image
        }else if(x == 2 && y == 2) {
            tri_2_2.image = image
        }else if(x == 2 && y == 3) {
            tri_2_3.image = image
        }else if(x == 2 && y == 4) {
            tri_2_4.image = image
        }else if(x == 2 && y == 5) {
            tri_2_5.image = image
        }else if(x == 2 && y == 6) {
            tri_2_6.image = image
        }else if(x == 2 && y == 7) {
            tri_2_7.image = image
        }else if(x == 2 && y == 8) {
            tri_2_8.image = image
        }else if(x == 2 && y == 9) {
            tri_2_9.image = image
        }else if(x == 2 && y == 10) {
            tri_2_10.image = image
        }
            //row NO 3
        else if(x == 3 && y == 0) {
            tri_3_0.image = image
        }else if(x == 3 && y == 1) {
            tri_3_1.image = image
        }else if(x == 3 && y == 2) {
            tri_3_2.image = image
        }else if(x == 3 && y == 3) {
            tri_3_3.image = image
        }else if(x == 3 && y == 4) {
            tri_3_4.image = image
        }else if(x == 3 && y == 5) {
            tri_3_5.image = image
        }else if(x == 3 && y == 6) {
            tri_3_6.image = image
        }else if(x == 3 && y == 7) {
            tri_3_7.image = image
        }else if(x == 3 && y == 8) {
            tri_3_8.image = image
        }else if(x == 3 && y == 9) {
            tri_3_9.image = image
        }else if(x == 3 && y == 10) {
            tri_3_10.image = image
        }
            //row NO 4
        else if (x == 4 && y == 0){
            tri_4_0.image = image
        }else if(x == 4 && y == 1) {
            tri_4_1.image = image
        }else if (x == 4 && y == 2){
            tri_4_2.image = image
        }else if(x == 4 && y == 3) {
            tri_4_3.image = image
        }else if (x == 4 && y == 4){
            tri_4_4.image = image
        }else if(x == 4 && y == 5) {
            tri_4_5.image = image
        }else if (x == 4 && y == 6){
            tri_4_6.image = image
        }else if(x == 4 && y == 7) {
            tri_4_7.image = image
        }else if (x == 4 && y == 8){
            tri_4_8.image = image
        }
            //row NO 5
        else if (x == 5 && y == 0){
            tri_5_0.image = image
        }else if(x == 5 && y == 1) {
            tri_5_1.image = image
        }else if (x == 5 && y == 2){
            tri_5_2.image = image
        }else if(x == 5 && y == 3) {
            tri_5_3.image = image
        }else if (x == 5 && y == 4){
            tri_5_4.image = image
        }else if(x == 5 && y == 5) {
            tri_5_5.image = image
        }else if (x == 5 && y == 6){
            tri_5_6.image = image
        }
        
        
        return
    }
    
    func Eligible_to_Generate () -> Bool {
        if(!exist1 && !exist2 && !exist3){
            exist1 = true
            exist2 = true
            exist3 = true
            return true
        }else{
            return false
        }
            }
    
    //auto generate three tris when previous are all fit in
      func auto_random_generator() -> Void {
        var randomIndex = Int(arc4random_uniform(UInt32(generator_array.count)))
        green_drag_tri.image = generator_array[randomIndex]
        green_drag_tri.sizeToFit()
        green_drag_tri_orig_rec = green_drag_tri.frame
        shape_type_index[0] = randomIndex
        // force_recenter_drag_tris( tri: green_drag_tri,tri_img: generator_array[randomIndex] )
        
        
        randomIndex = Int(arc4random_uniform(UInt32(generator_array.count)))
        orange_drag_tri.image = generator_array[randomIndex]
        orange_drag_tri.sizeToFit()
        orange_drag_tri_orig_rec = orange_drag_tri.frame
        shape_type_index[1] = randomIndex
        
        //force_recenter_drag_tris( tri: orange_drag_tri,tri_img: generator_array[randomIndex] )
        
        randomIndex = Int(arc4random_uniform(UInt32(generator_array.count)))
        light_brown_drag_tri.image = generator_array[randomIndex]
        light_brown_drag_tri.sizeToFit()
        light_brown_drag_tri_orig_rec = light_brown_drag_tri.frame
        force_recenter_drag_tris( tri: light_brown_drag_tri,tri_img: generator_array[randomIndex] )
        shape_type_index[2] = randomIndex
        
        exist1 = true
        exist2 = true
        exist3 = true
    }
    
    
    func Check_and_Erase() -> Void {
        
        //situation one - row
        //eliminate first row
        if(filled[0][0]&&filled[0][1]&&filled[0][2]&&filled[0][3]&&filled[0][4]&&filled[0][5]&&filled[0][6]){
            filled[0][0] = false
            filled[0][1] = false
            filled[0][2] = false
            filled[0][3] = false
            filled[0][4] = false
            filled[0][5] = false
            filled[0][6] = false
        }
        //eliminate second row
        if(filled[1][0]&&filled[1][1]&&filled[1][2]&&filled[1][3]&&filled[1][4]&&filled[1][5]&&filled[1][6]&&filled[1][7]&&filled[1][8]){
            filled[1][0] = false
            filled[1][1] = false
            filled[1][2] = false
            filled[1][3] = false
            filled[1][4] = false
            filled[1][5] = false
            filled[1][6] = false
            filled[1][7] = false
            filled[1][8] = false
        }
        //eliminate third row
        if(filled[2][0]&&filled[2][1]&&filled[2][2]&&filled[2][3]&&filled[2][4]&&filled[2][5]&&filled[2][6]&&filled[2][7]&&filled[2][8]&&filled[2][9]&&filled[2][10]){
            filled[2][0] = false
            filled[2][1] = false
            filled[2][2] = false
            filled[2][3] = false
            filled[2][4] = false
            filled[2][5] = false
            filled[2][6] = false
            filled[2][7] = false
            filled[2][8] = false
            filled[2][9] = false
            filled[2][10] = false
        }
        //eliminate fourth row
        if(filled[3][0]&&filled[3][1]&&filled[3][2]&&filled[3][3]&&filled[3][4]&&filled[3][5]&&filled[3][6]&&filled[3][7]&&filled[3][8]&&filled[3][9]&&filled[3][10]){
            filled[3][0] = false
            filled[3][1] = false
            filled[3][2] = false
            filled[3][3] = false
            filled[3][4] = false
            filled[3][5] = false
            filled[3][6] = false
            filled[3][7] = false
            filled[3][8] = false
            filled[3][9] = false
            filled[3][10] = false
        }
        //eliminate fifth row
        if(filled[4][0]&&filled[4][1]&&filled[4][2]&&filled[4][3]&&filled[4][4]&&filled[4][5]&&filled[4][6]&&filled[4][7]&&filled[4][8]){
            filled[4][0] = false
            filled[4][1] = false
            filled[4][2] = false
            filled[4][3] = false
            filled[4][4] = false
            filled[4][5] = false
            filled[4][6] = false
            filled[4][7] = false
            filled[4][8] = false
        }
        ////eliminate sixth row
        if(filled[5][0]&&filled[5][1]&&filled[5][2]&&filled[5][3]&&filled[5][4]&&filled[5][5]&&filled[5][6]){
            filled[5][0] = false
            filled[5][1] = false
            filled[5][2] = false
            filled[5][3] = false
            filled[5][4] = false
            filled[5][5] = false
            filled[5][6] = false
        }
        
        
        //situation two - 右下斜
        if(filled[2][0]&&filled[3][0]&&filled[3][1]&&filled[4][0]&&filled[4][1]&&filled[5][0]&&filled[5][1]){
            filled[2][0] = false
            filled[3][0] = false
            filled[3][1] = false
            filled[4][0] = false
            filled[4][1] = false
            filled[5][0] = false
            filled[5][1] = false
            
        }
        if(filled[1][0]&&filled[2][1]&&filled[2][2]&&filled[3][2]&&filled[3][3]&&filled[4][2]&&filled[4][3]&&filled[5][2]&&filled[5][3]){
            filled[1][0] = false
            filled[2][1] = false
            filled[2][2] = false
            filled[3][2] = false
            filled[3][3] = false
            filled[4][2] = false
            filled[4][3] = false
            filled[5][2] = false
            filled[5][3] = false
            
            
            
            
            
            
        }
        if(filled[0][0]&&filled[1][1]&&filled[1][2]&&filled[2][3]&&filled[2][4]&&filled[3][4]&&filled[3][5]&&filled[4][4]&&filled[4][5]&&filled[5][4]&&filled[5][5]){
            filled[0][0] = false
            filled[1][1] = false
            filled[1][2] = false
            filled[2][3] = false
            filled[2][4] = false
            filled[3][4] = false
            filled[3][5] = false
            filled[4][4] = false
            filled[4][5] = false
            filled[5][4] = false
            filled[5][5] = false
            
        }
        if(filled[0][1]&&filled[0][2]&&filled[1][3]&&filled[1][4]&&filled[2][5]&&filled[2][6]&&filled[3][6]&&filled[3][7]&&filled[4][6]&&filled[4][7]&&filled[5][6]){
            
            filled[0][1] = false
            filled[0][2] = false
            filled[1][3] = false
            filled[1][4] = false
            filled[2][5] = false
            filled[2][6] = false
            filled[3][6] = false
            filled[3][7] = false
            filled[4][6] = false
            filled[4][7] = false
            filled[5][6] = false
            
        }
        if(filled[0][3]&&filled[0][4]&&filled[1][5]&&filled[1][6]&&filled[2][7]&&filled[2][8]&&filled[3][8]&&filled[3][9]&&filled[4][8]){
            
            filled[0][3] = false
            filled[0][4] = false
            filled[1][5] = false
            filled[1][6] = false
            filled[2][7] = false
            filled[2][8] = false
            filled[3][8] = false
            filled[3][9] = false
            filled[4][8] = false
        }
        if(filled[0][5]&&filled[0][6]&&filled[1][7]&&filled[1][8]&&filled[2][9]&&filled[2][10]&&filled[3][10]){
            filled[0][5] = false
            filled[0][6] = false
            filled[1][7] = false
            filled[1][8] = false
            filled[2][9] = false
            filled[2][10] = false
            filled[3][10] = false
        }
        
        
        //situation three - 左下斜
        if(filled[0][0]&&filled[0][1]&&filled[1][0]&&filled[1][1]&&filled[2][0]&&filled[2][1]&&filled[3][0]){
            filled[0][0] = false
            filled[0][1] = false
            filled[1][0] = false
            filled[1][1] = false
            filled[2][0] = false
            filled[2][1] = false
            filled[3][0] = false
        }
        if(filled[0][2]&&filled[0][3]&&filled[1][2]&&filled[1][3]&&filled[2][2]&&filled[2][3]&&filled[3][1]&&filled[3][2]&&filled[4][0]){
            filled[0][2] = false
            filled[0][3] = false
            filled[1][2] = false
            filled[1][3] = false
            filled[2][2] = false
            filled[2][3] = false
            filled[3][1] = false
            filled[3][2] = false
            filled[4][0] = false
        }
        if(filled[0][4]&&filled[0][5]&&filled[1][4]&&filled[1][5]&&filled[2][4]&&filled[2][5]&&filled[3][3]&&filled[3][4]&&filled[4][1]&&filled[4][2]&&filled[5][0]){
            filled[0][4] = false
            filled[0][5] = false
            filled[1][4] = false
            filled[1][5] = false
            filled[2][4] = false
            filled[2][5] = false
            filled[3][3] = false
            filled[3][4] = false
            filled[4][1] = false
            filled[4][2] = false
            filled[5][0] = false
        }
        if(filled[0][6]&&filled[1][6]&&filled[1][7]&&filled[2][6]&&filled[2][7]&&filled[3][5]&&filled[3][6]&&filled[4][3]&&filled[4][4]&&filled[5][1]&&filled[5][2]){
            filled[0][6] = false
            filled[1][6] = false
            filled[1][7] = false
            filled[2][6] = false
            filled[2][7] = false
            filled[3][5] = false
            filled[3][6] = false
            filled[4][3] = false
            filled[4][4] = false
            filled[5][1] = false
            filled[5][2] = false
        }
        if(filled[1][8]&&filled[2][8]&&filled[2][9]&&filled[3][7]&&filled[3][8]&&filled[4][5]&&filled[4][6]&&filled[5][3]&&filled[5][4]){
            filled[1][8] = false
            filled[2][8] = false
            filled[2][9] = false
            filled[3][7] = false
            filled[3][8] = false
            filled[4][5] = false
            filled[4][6] = false
            filled[5][3] = false
            filled[5][4] = false
        }
        if(filled[2][10]&&filled[3][9]&&filled[3][10]&&filled[4][7]&&filled[4][8]&&filled[5][5]&&filled[5][6]){
            filled[2][10] = false
            filled[3][9] = false
            filled[3][10] = false
            filled[4][7] = false
            filled[4][8] = false
            filled[5][5] = false
            filled[5][6] = false
        }
    }
   /////////////////////////////////////////////////////////////////////////////////////////////////////////
    var bool_any_green_tri = true
    var bool_any_orange_tri = true
    var bool_any_light_brown_tri = true
    var bool_any_brown_left_tri = true
    var bool_any_brown_downwards_tri = true
    var bool_any_dark_green_tri = true
    var bool_pos0_shape_available = true
    var bool_pos1_shape_available = true
    var bool_pos2_shape_available = true
     //the function to check for gameover (if gameover return true, else return false)
        func Check_for_Gameover () -> Bool {
            var i = 0
            for tri_row in filled{
            var j = 0
            for tri_location in tri_row{
                bool_any_green_tri = Find_Any_Available_Green_Tri(row: i, column: j)
                print("whether green tri available: \(bool_any_green_tri)")
                bool_any_orange_tri = Find_Any_Available_Orange_Tri(row: i, column: j)
                print("whether orange tri available: \(bool_any_orange_tri)")
                bool_any_light_brown_tri = Find_Any_Available_Light_Brown_Tri(row: i, column: j)
                print("whether light_brown tri available: \(bool_any_light_brown_tri)")
                bool_any_brown_left_tri = Find_Any_Available_Brown_Left_Tri(row: i, column: j)
                print("whether brown left tri available: \(bool_any_brown_left_tri)")
                bool_any_brown_downwards_tri = Find_Any_Available_Brown_Downwards_Tri(row: i, column: j)
                print("whether brown downwards tri available: \(bool_any_brown_downwards_tri)")
                bool_any_dark_green_tri = Find_Any_Dark_Green_Tri(row: i, column: j)
                 print("whether dark green tri available: \(bool_any_dark_green_tri)")
                if(bool_any_dark_green_tri){
                 print("dark green available at \(i) , \(j)")
                }
                if(exist1){
                if(shape_type_index[0] == 0){
                    bool_pos0_shape_available = bool_any_green_tri
                }else if(shape_type_index[0] == 1){
                    bool_pos0_shape_available = bool_any_orange_tri
                }else if(shape_type_index[0] == 2){
                    bool_pos0_shape_available = bool_any_light_brown_tri
                }else if(shape_type_index[0] == 3){
                    bool_pos0_shape_available =  bool_any_brown_downwards_tri
                }else if(shape_type_index[0] == 4){
                    bool_pos0_shape_available = bool_any_brown_left_tri
                }else if(shape_type_index[0] == 5){
                    bool_pos0_shape_available = bool_any_dark_green_tri
                }
                }else{
                    bool_pos0_shape_available = false
                }
                print("po0 bool: \(bool_pos0_shape_available)")
                if(exist2){
                if(shape_type_index[1] == 0){
                    bool_pos1_shape_available = bool_any_green_tri
                }else if(shape_type_index[1] == 1){
                    bool_pos1_shape_available = bool_any_orange_tri
                }else if(shape_type_index[1] == 2){
                    bool_pos1_shape_available = bool_any_light_brown_tri
                }else if(shape_type_index[1] == 3){
                    bool_pos1_shape_available =  bool_any_brown_downwards_tri
                }else if(shape_type_index[1] == 4){
                    bool_pos1_shape_available = bool_any_brown_left_tri
                }else if(shape_type_index[1] == 5){
                    bool_pos1_shape_available = bool_any_dark_green_tri
                }
                }else{
                    bool_pos1_shape_available = false
                }
                print("po1 bool: \(bool_pos1_shape_available)")
                if(exist3){
                if(shape_type_index[2] == 0){
                    bool_pos2_shape_available = bool_any_green_tri
                }else if(shape_type_index[2] == 1){
                    bool_pos2_shape_available = bool_any_orange_tri
                }else if(shape_type_index[2] == 2){
                    bool_pos2_shape_available = bool_any_light_brown_tri
                }else if(shape_type_index[2] == 3){
                    bool_pos2_shape_available =  bool_any_brown_downwards_tri
                }else if(shape_type_index[2] == 4){
                    bool_pos2_shape_available = bool_any_brown_left_tri
                }else if(shape_type_index[2] == 5){
                    bool_pos2_shape_available = bool_any_dark_green_tri
                }
                }else{
                    bool_pos2_shape_available = false
                }
                
                print("po2 bool: \(bool_pos2_shape_available)")
                if(bool_pos0_shape_available || bool_pos1_shape_available || bool_pos2_shape_available){
                    return false
                }
                j += 1
                }
                i += 1
                   }
            return true

        }
    

    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    func Find_Any_Available_Green_Tri(row: Int, column: Int) -> Bool {
        //upper row
        if(row == 0 || row == 1 || row == 2){
            //upwards tri (pos0 or pos2)
            if(column % 2 == 0){
                if(column != filled[row].count-1 && !filled[row][column] && !filled[row][column+1] && !filled[row][column+2]){
                    return true
                }
                if(column != 0 && !filled[row][column-2] && !filled[row][column-1] && !filled[row][column]){
                    return true
                }
            }
                //downwards tri (pos1)
                else{
                if(!filled[row][column] && !filled[row][column-1] && !filled[row][column+1]){
                    return true
                }
                
                }
            
            

        }
        else if(row == 3 || row == 4 || row == 5    ){
            //upwards tri (pos0 and pos2)
            if(column % 2 != 0){
                if(column != 1 && !filled[row][column-2] && !filled[row][column-1] && !filled[row][column]){
                    return true
                }
                else if(column != filled[row].count-2 && !filled[row][column] && !filled[row][column+1] && !filled[row][column+2]){
                    return true
                }
            }
            
            
            
        }
        
        return false
        
        
    }
   /////////////////////////////////////////////////////////////////////////////////////////////////////////
    func Find_Any_Available_Orange_Tri (row: Int, column:Int) -> Bool{
        if(row == 0 || row == 1){
            //upwards tri
            if(column % 2 == 0){
                if(!filled[row][column] && !filled[row+1][column+1]){
                    return true
                }
            }
                    //downwards tri
            else{
                if(row == 1 && !filled[row][column] && !filled[row-1][column-1]){
                    return true
                }
                }
            
        }
        
        else if(row == 2){
            //upwards tri
            if(column%2 == 0){
                if(!filled[row][column] && !filled[row+1][column]){
                    return true
                }
            }
            //downwards tri
            else{
                if(!filled[row][column] && !filled[row-1][column-1]){
                    return true
                }
                
            }
        }
        else if(row == 3){
            //downwards tri
            if(column%2 == 0){
                if(!filled[row][column] && !filled[row-1][column]){
                    return true
                }
            }
            //upwards tri
            else{
                if(!filled[row][column] && !filled[row+1][column-1]){
                    return true
                }
                
            }
        }
        else if(row == 4 || row == 5){
         //downwards tri
            if(column%2 == 0){
            if(!filled[row][column] && !filled[row-1][column+1]){
                        return true
                    }
                }
        //upwards tri
            else{
                if(row == 4 && !filled[row][column] && !filled[row+1][column-1]){
                    return true
                }
                
                
            }
        }
        
        return false
    }
        
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    func Find_Any_Available_Light_Brown_Tri (row: Int, column:Int) -> Bool{
        if(row == 0){
            //upwards tri
            if(column%2 == 0 && !filled[row][column] && !filled[row+1][column] && !filled[row+1][column+1]){
                return true
            }
        }
        else if(row == 1){
            //upwards tri
            if(column%2 == 0){
                if(!filled[row][column] && !filled[row+1][column] && !filled[row+1][column+1]){
                    return true
                }
                if(column != filled[row].count-1 && !filled[row][column] && !filled[row][column+1] && !filled[row-1][column]){
                    return true
                }
            }
            //downwards tri
            else{
                if(!filled[row][column] && !filled[row][column-1] && !filled[row-1][column-1]){
                    return true
                }
            }
        }
        else if(row == 2){
            //upwards tri
            if(column%2 == 0){
                if(column != filled[row].count-1 && !filled[row][column] && !filled[row][column+1] && !filled[row-1][column]){
                    return true
                }
                if(column != 0 && !filled[row][column] && !filled[row+1][column] && !filled[row+1][column-1]){
                    return true
                }
            }
            //downwards tri
            else{
                if(!filled[row][column] && !filled[row][column-1] && !filled[row-1][column-1]){
                    return true
                }
            }
        }
        
        else if(row == 3){
            //downwards tri
            if(column%2 == 0){
                if(column != 0 && !filled[row][column] && !filled[row][column-1] && !filled[row-1][column]){
                    return true
                }
            }
            //upwards tri
            else{
                if(!filled[row][column] && !filled[row][column+1] && !filled[row-1][column+1]){
                    return true
                }
                if(column != 1 && !filled[row][column] && !filled[row+1][column-1] && !filled[row+1][column-2]){
                    return true
                }
            }
        }
        else if(row == 4){
            //downwards tri
            if(column%2 == 0){
                if(column != 0 && !filled[row][column] && !filled[row][column-1] && !filled[row-1][column+1]){
                    return true
            }
        }
                //upwards tri
            else{
                if(!filled[row][column] && !filled[row][column+1] && !filled[row-1][column+2]){
                    return true
                }
                if(column != 1 && !filled[row][column] && !filled[row+1][column-1] && !filled[row+1][column-2]){
                    return true
                }
            }
        }
        else if(row == 5 ){
            //downwards tri
            if(column%2 == 0){
                if(column != 0 && !filled[row][column] && !filled[row][column-1] && !filled[row-1][column+1]){
                    return true
                }
            }
            //upwards tri
            else{
                if(!filled[row][column] && !filled[row][column+1] && !filled[row-1][column+2]){
                    return true
                }
            }
        }
    
    return false
    }
        
   /////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func Find_Any_Available_Brown_Left_Tri (row: Int, column:Int) -> Bool{
        if(row == 0 || row == 1 || row == 2){
            //upwards tri
            if(column%2 == 0){
                if(column != 0 && !filled[row][column] && !filled[row][column-1]){
                    return true
                }
            }
                //downwards tri
            else{
                if(!filled[row][column] && !filled[row][column+1]){
                    return true
                }
            }
        }
        else if(row == 3 || row == 4 || row == 5){
            //downwards tri
            if(column%2 == 0){
                if(column != filled[row].count-1 && !filled[row][column] && !filled[row][column+1]){
                    return true
                }
            }
            //upwards tri
            else{
                if(!filled[row][column] && !filled[row][column-1]){
                    return true
                    }
            }
        }
        
        return false
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func Find_Any_Available_Brown_Downwards_Tri (row: Int, column:Int) -> Bool{
        if(row == 0 || row == 1 || row == 2){
            //upwards tri
            if(column%2 == 0){
                if(column != 0 && column != filled[row].count-1 && !filled[row][column] && !filled[row][column-1] && !filled[row][column+1]){
                    return true
                }
            }
            //downwards tri
            else{
                if(column != 1 && !filled[row][column] && !filled[row][column-1] && !filled[row][column-2]){
                    return true
                }
                if(column != filled[row].count-2 && !filled[row][column] && !filled[row][column+1] && !filled[row][column+2]){
                    return true
                }
            }
        }
        else if(row == 3 || row == 4 || row == 5){
        //downwards tri
            if(column%2 == 0){
                if(column != filled[row].count-1 && !filled[row][column] && !filled[row][column+1] && filled[row][column+2]){
                    return true
                }
                if(column != 0 && !filled[row][column] && !filled[row][column-1] && !filled[row][column-2]){
                    return true
                }
            }
            //upwards tri
            else{
                if(!filled[row][column-1] && !filled[row][column] && !filled[row][column+1]){
                    return true
                }
            }
        }
        return false
    }

     /////////////////////////////////////////////////////////////////////////////////////////////////////////
    func Find_Any_Dark_Green_Tri (row: Int, column:Int) -> Bool{
        
        if(row == 0){
            //upwards tri
            if(column%2 == 0){
                
              //left to right
                if(column != filled[row].count-1 && !filled[row][column] && !filled[row][column+2] && !filled[row+1][column+1] && !filled[row+1][column+2] && !filled[row+1][column+3]){
                    return true
                }
              //right to left
                if(column != 0 && !filled[row][column] && !filled[row][column-2] && !filled[row+1][column] && !filled[row+1][column-1] && !filled[row+1][column+1]){
                    return true
                }
                //center not possible
               
            }
            //downwards tri not possible
            else{
                return false
            }
        }
        else if(row == 1){
         //upwards tri
            if(column%2 == 0){
                //left to right
                if(column != filled[row].count-1 && !filled[row][column] && !filled[row][column+2] && !filled[row+1][column+1] && !filled[row+1][column+2] && !filled[row+1][column+3]){
                    return true
                }
                //right to left
                if(column != 0 && !filled[row][column] && !filled[row][column-2] && !filled[row+1][column] && !filled[row+1][column-1] && !filled[row+1][column+1]){
                    return true
                }
                //as center
                if(column != 0 && column != filled[row].count-1 && !filled[row][column] && !filled[row][column-1] && !filled[row][column+1] && !filled[row-1][column-2] && !filled[row-1][column]){
                    return true
                }
            }
            //downwards tri
            else{
                //bottom left to right
                if(column != filled[row].count-2 && !filled[row][column] && !filled[row][column+1] && !filled[row][column+2] && !filled[row-1][column-1] && !filled[row-1][column+1]){
                    return true
                }
                //bottom right to left
                if(column != 1 && !filled[row][column] && !filled[row][column-1] && !filled[row][column-2] && !filled[row-1][column-1] && !filled[row-1][column-3]){
                    return true
                }
            }
        }
        
        else if(row == 2){
        //upwards tri
            if(column%2 == 0){
                //left to right
                if(column != filled[row].count-1 && !filled[row][column] && !filled[row][column+2] && !filled[row+1][column] && !filled[row+1][column+1] && !filled[row+1][column+2] ){
                    return true
                }
                //right to left
                if(column != 0 && !filled[row][column] && !filled[row][column-2] && !filled[row+1][column] && !filled[row+1][column-1] && !filled[row+1][column-2]){
                    return true
                }
                //as center 
                if(column != 0 && column != filled[row].count-1 && !filled[row][column] && !filled[row][column-1] && !filled[row][column+1] && !filled[row-1][column-2] && !filled[row-1][column]){
                    return true
                }
            }
            //downwards tri
            else{
                //bottom left to right
                if(column != filled[row].count-2 && !filled[row][column] && !filled[row][column+1] && !filled[row][column+2]  && !filled[row-1][column-1] && !filled[row-1][column+1]){
                    return true
                }
                //bottom right to left
                if(column != 1 && !filled[row][column] && !filled[row][column-1] && !filled[row][column-2] && !filled[row-1][column-1] && !filled[row-1][column-3]){
                    return true
                }

            }
        }
        else if(row == 3){
            //downwards tri
            if(column%2 == 0){
                //bottom left to right
                if(column != filled[row].count-1 && !filled[row][column] && !filled[row][column+1] && !filled[row][column+2] && !filled[row-1][column] && !filled[row-1][column+2]){
                    return true
                }
                //bottom right to left
                if(column != 0 && !filled[row][column] && !filled[row][column-1] && !filled[row][column-2] && !filled[row-1][column] && !filled[row-1][column-2]){
                    return true
                }
            }
            //upwards tri
            else{
             //left to right
                if(column != filled[row].count-2 && !filled[row][column] && !filled[row][column+2] && !filled[row+1][column-1] && !filled[row+1][column] && !filled[row+1][column+1]){
                    return true
                }
                //right to left
                if(column != 1 && !filled[row][column] && !filled[row][column-2] && !filled[row+1][column-1] && !filled[row+1][column-2] && !filled[row+1][column-3]){
                    return true
                }
                //as center
                if(!filled[row][column] && !filled[row][column-1] && !filled[row][column+1] && !filled[row-1][column-1] && !filled[row-1][column+1]){
                    return true
                }
            }
        }
        else if(row == 4){
        //downwards tri
        if(column%2 == 0){
        //bottom left to right
            if(column != filled[row].count-1 && !filled[row][column] && !filled[row][column+1] && !filled[row][column+2] && !filled[row-1][column+1] && !filled[row-1][column+3]){
                return true
            }
        //bottom right to left
            if(column != 0 && !filled[row][column] && !filled[row][column-1] && !filled[row][column-2] && !filled[row-1][column-1] && !filled[row-1][column+1]){
                return true
            }
        }
        //upwards tri
        else{
            //left to right 
            if(column != filled[row].count-2 && !filled[row][column] && !filled[row][column+2] && !filled[row+1][column-1] && !filled[row+1][column] && !filled[row+1][column+1]){
                return true
            }
            //right to left
            if(column != 1 && !filled[row][column] && !filled[row][column-2] && !filled[row+1][column-1] && !filled[row+1][column-2] && !filled[row+1][column-3]){
                return true
            }
            //as center
            if(!filled[row][column] && !filled[row][column-1] && !filled[row][column+1] && !filled[row-1][column] && !filled[row-1][column+2]){
                return true
            }
        
        }
        }
        else if(row == 5){
        //downwards tri
            if(column%2 == 0){
                //bottom left to right
                if(column != filled[row].count-1 && !filled[row][column] && !filled[row][column+1] && !filled[row][column+2] && !filled[row-1][column+1] && !filled[row-1][column+3]){
                    return true
                }
                //bottom right to left
                if(column != 0 && !filled[row][column] && !filled[row][column-1] && !filled[row][column-2] && !filled[row-1][column-1] && !filled[row-1][column+1]){
                    return true
                }
   
            }
            //upwards tri
            else{
            //left to right & right to left not possible
            //as center
                if(!filled[row][column] && !filled[row][column-1] && !filled[row][column+1] && !filled[row-1][column] && !filled[row-1][column+2]){
                    return true
                }
                
            }
        }
    return false
    }
    
    
    

    
}




