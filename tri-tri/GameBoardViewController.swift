//
//  GameBoardViewController.swift
//  tri-tri
//
//  Created by Feiran Hu on 2017-05-10.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import UserNotifications
class GameBoardViewController: UIViewController {

//create an array to store shape_index for each UIImageView
    @IBAction func test_gameover(_ sender: Any) {
        Jump_to_Game_Over()
    }
// each int inside array reprensents shape index
//every shape is the same name as they are in Assets.xcassets file
//shape index 0: 绿色tri  index 1: 橙色tri index 2: 棕色tri index 3:brown_downwards 4:brown_left_direction 5:dark_green_tri 6:pink_right_direction 7 purple upwards  8 purple downwards
    
    var shape_type_index : Array<Int> = [0 , 0, 0]
    //indicate pause
    var paused = false

    var player = AVPlayer()
    
    //record highest score
    var HighestScore = 0
    
    //record theme type for now
    var ThemeType = 1
    
    class MyButton: UIButton {
        var action: (()->())?
        
        func whenButtonIsClicked(action: @escaping ()->()) {
            self.action = action
            self.addTarget(self, action: #selector(MyButton.clicked), for: .touchUpInside)
        }
        
        func clicked() {
            action?()
        }
    }
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
        print("Touche at x: \(initialTouchLocation.x), y:\(initialTouchLocation.y)")

    }
    @IBAction func stop_music_when_pause(_ sender: UIButton) {
        self.audioPlayer.stop()
        self.timer.invalidate()
  
    }
    
    var defaults = UserDefaults.standard
    
    //--------------------------------------------------------------------------------------------------------------------------
    //initialize an array for random generator
    var generator_array : Array<UIImage> = [UIImage(named:"绿色tri.png")!,UIImage(named:"橙色tri.png")!,UIImage(named:"棕色tri.png")!,UIImage(named:"brown_downwards.png")!,UIImage(named:"brown_left_direction.png")!,UIImage(named:"dark_green_tri.png")!,UIImage(named:"pink_right_direction.png")!,UIImage(named:"purple_upwards_as_shape.png")!,UIImage(named:"purple_downwards_as_shape")!]
    
    //--------------------------------------------------------------------------------------------------------------------------
    @IBOutlet weak var HightestScoreBoard: UILabel!
   // @IBOutlet weak var HightestScoreBoard: UITextField!

    
    
    //declare an audio player
    var fit_in_player = AVAudioPlayer()
    var audioPlayer = AVAudioPlayer()
    var timer = Timer()
   // screen width
    var screen_width : CGFloat = 0
    var screen_height : CGFloat = 0
    
    
    override func viewDidLoad() {
        
        //let screen_Rect = UIScreen.main.bounds
        super.viewDidLoad()
        //add UIPanGestureRecognizer
        ////
        screen_width = view.frame.width
        screen_height = view.frame.height
        print("screen width: \(screen_width), screen height: \(screen_height)")
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        //assign original locations of three tris located at the location on storyboard of each of them
        orange_drag_origin.y = screen_height - (68 + orange_drag_tri.frame.height)
        orange_drag_origin.x = (screen_width/2) -  (orange_drag_tri.frame.width/2)    //34
        orange_drag_tri.frame.origin = orange_drag_origin
        
        green_drag_origin.y = screen_height - (68 + green_drag_tri.frame.height)
        green_drag_origin.x =  (orange_drag_origin.x) - 19 - green_drag_tri.frame.width
        green_drag_tri.frame.origin = green_drag_origin

        
        
        light_brown_drag_origin.y = screen_height - (68 + light_brown_drag_tri.frame.height)
        light_brown_drag_origin.x = orange_drag_origin.x + orange_drag_tri.frame.width + 12.5
        light_brown_drag_tri.frame.origin = light_brown_drag_origin
        //declare original frames of the tris
        green_drag_tri_orig_rec = green_drag_tri.frame
        print("green origin x: \(green_drag_origin.x), y: \(green_drag_origin.y)")
        orange_drag_tri_orig_rec = orange_drag_tri.frame
        light_brown_drag_tri_orig_rec = light_brown_drag_tri.frame
        // Do any additional setup after loading the view.
        //generate first group
        if(score == 0){
            auto_random_generator()
        }
        //
        
        var HighScoreDefault = UserDefaults.standard
        
        if(HighScoreDefault.value(forKey: "tritri_HighestScore") != nil ){
        HighestScore = HighScoreDefault.value(forKey: "tritri_HighestScore") as! NSInteger
        print("Highest Score is \(HighestScore)")
        }else{
         HighScoreDefault.set(0, forKey: "tritri_HighestScore")
         HighestScore = 0
        }
        HightestScoreBoard.text = String(HighestScore)
        
        //---------------------------------------------------------------------------
        //var to decide night mode\
        //1: day mode
        //2: night mode
        if (defaults.value(forKey: "tritri_Theme") == nil){
            ThemeType = 1
            defaults.set(1, forKey: "tritri_Theme")
        }
        else {
            if (defaults.integer(forKey: "tritri_Theme") == 1){
                ThemeType = 1
            }
            else if (defaults.integer(forKey: "tritri_Theme") == 2){
                ThemeType = 2
            }
        }
        //change bg color
        if ThemeType == 1{
            self.view.backgroundColor = UIColor(red: 254.0/255, green: 253.0/255, blue: 252.0/255, alpha: 1.0)
        } else if ThemeType == 2{
            self.view.backgroundColor = UIColor(red: 23.0/255, green: 53.0/255, blue: 52.0/255, alpha: 1.0)
        }
        //update tris origin
        //first row
        tri_0_3.frame.origin.x = (screen_width/2) - (tri_0_3.frame.width/2)
        tri_0_3.frame.origin.y = screen_height - 422 - tri_0_3.frame.height
        tri_0_2.frame.origin.y = tri_0_3.frame.origin.y
        tri_0_2.frame.origin.x = tri_0_3.frame.origin.x - 27
        tri_0_1.frame.origin.y = tri_0_3.frame.origin.y
        tri_0_1.frame.origin.x = tri_0_2.frame.origin.x - 26
        tri_0_0.frame.origin.y = tri_0_3.frame.origin.y
        tri_0_0.frame.origin.x = tri_0_1.frame.origin.x - 26
        tri_0_4.frame.origin.y = tri_0_3.frame.origin.y
        tri_0_4.frame.origin.x = tri_0_3.frame.origin.x + 26
        tri_0_5.frame.origin.y = tri_0_3.frame.origin.y
        tri_0_5.frame.origin.x = tri_0_4.frame.origin.x + 26
        tri_0_6.frame.origin.y = tri_0_3.frame.origin.y
        tri_0_6.frame.origin.x = tri_0_5.frame.origin.x + 26
        //second row
        tri_1_4.frame.origin.y = tri_0_3.frame.origin.y + 43
        tri_1_4.frame.origin.x = tri_0_3.frame.origin.x
        tri_1_3.frame.origin.y = tri_0_3.frame.origin.y + 43
        tri_1_3.frame.origin.x = tri_1_4.frame.origin.x - 26
        tri_1_2.frame.origin.y = tri_0_3.frame.origin.y + 43
        tri_1_2.frame.origin.x = tri_1_3.frame.origin.x - 26
        tri_1_1.frame.origin.y = tri_0_3.frame.origin.y + 43
        tri_1_1.frame.origin.x = tri_1_2.frame.origin.x - 26
        tri_1_0.frame.origin.y = tri_0_3.frame.origin.y + 43
        tri_1_0.frame.origin.x = tri_1_1.frame.origin.x - 26
        tri_1_5.frame.origin.y = tri_0_3.frame.origin.y + 43
        tri_1_5.frame.origin.x = tri_1_4.frame.origin.x + 26
        tri_1_6.frame.origin.y = tri_0_3.frame.origin.y + 43
        tri_1_6.frame.origin.x = tri_1_5.frame.origin.x + 26
        tri_1_7.frame.origin.y = tri_0_3.frame.origin.y + 43
        tri_1_7.frame.origin.x = tri_1_6.frame.origin.x + 26
        tri_1_8.frame.origin.y = tri_0_3.frame.origin.y + 43
        tri_1_8.frame.origin.x = tri_1_7.frame.origin.x + 26
        //third row
        tri_2_5.frame.origin.y = tri_1_4.frame.origin.y + 43
        tri_2_5.frame.origin.x = tri_1_4.frame.origin.x
        tri_2_4.frame.origin.y = tri_1_4.frame.origin.y + 43
        tri_2_4.frame.origin.x = tri_2_5.frame.origin.x - 26
        tri_2_3.frame.origin.y = tri_1_4.frame.origin.y + 43
        tri_2_3.frame.origin.x = tri_2_4.frame.origin.x - 26
        tri_2_2.frame.origin.y = tri_1_4.frame.origin.y + 43
        tri_2_2.frame.origin.x = tri_2_3.frame.origin.x - 26
        tri_2_1.frame.origin.y = tri_1_4.frame.origin.y + 43
        tri_2_1.frame.origin.x = tri_2_2.frame.origin.x - 26
        tri_2_0.frame.origin.y = tri_1_4.frame.origin.y + 43
        tri_2_0.frame.origin.x = tri_2_1.frame.origin.x - 26
        tri_2_6.frame.origin.y = tri_1_4.frame.origin.y + 43
        tri_2_6.frame.origin.x = tri_2_5.frame.origin.x + 26
        tri_2_7.frame.origin.y = tri_1_4.frame.origin.y + 43
        tri_2_7.frame.origin.x = tri_2_6.frame.origin.x + 26
        tri_2_8.frame.origin.y = tri_1_4.frame.origin.y + 43
        tri_2_8.frame.origin.x = tri_2_7.frame.origin.x + 26
        tri_2_9.frame.origin.y = tri_1_4.frame.origin.y + 43
        tri_2_9.frame.origin.x = tri_2_8.frame.origin.x + 26
        tri_2_10.frame.origin.y = tri_1_4.frame.origin.y + 43
        tri_2_10.frame.origin.x = tri_2_9.frame.origin.x + 26
       //fourth row
        tri_3_5.frame.origin.y = tri_2_5.frame.origin.y + 43
        tri_3_5.frame.origin.x = tri_2_5.frame.origin.x
        tri_3_4.frame.origin.y = tri_2_5.frame.origin.y + 43
        tri_3_4.frame.origin.x = tri_3_5.frame.origin.x - 26
        tri_3_3.frame.origin.y = tri_2_5.frame.origin.y + 43
        tri_3_3.frame.origin.x = tri_3_4.frame.origin.x - 26
        tri_3_2.frame.origin.y = tri_2_5.frame.origin.y + 43
        tri_3_2.frame.origin.x = tri_3_3.frame.origin.x - 26
        tri_3_1.frame.origin.y = tri_2_5.frame.origin.y + 43
        tri_3_1.frame.origin.x = tri_3_2.frame.origin.x - 26
        tri_3_0.frame.origin.y = tri_2_5.frame.origin.y + 43
        tri_3_0.frame.origin.x = tri_3_1.frame.origin.x - 26
        tri_3_6.frame.origin.y = tri_2_5.frame.origin.y + 43
        tri_3_6.frame.origin.x = tri_3_5.frame.origin.x + 26
        tri_3_7.frame.origin.y = tri_2_5.frame.origin.y + 43
        tri_3_7.frame.origin.x = tri_3_6.frame.origin.x + 26
        tri_3_8.frame.origin.y = tri_2_5.frame.origin.y + 43
        tri_3_8.frame.origin.x = tri_3_7.frame.origin.x + 26
        tri_3_9.frame.origin.y = tri_2_5.frame.origin.y + 43
        tri_3_9.frame.origin.x = tri_3_8.frame.origin.x + 26
        tri_3_10.frame.origin.y = tri_2_5.frame.origin.y + 43
        tri_3_10.frame.origin.x = tri_3_9.frame.origin.x + 26
        //fifth row
        tri_4_4.frame.origin.y = tri_3_5.frame.origin.y + 43
        tri_4_4.frame.origin.x = tri_3_5.frame.origin.x
        tri_4_3.frame.origin.y = tri_3_5.frame.origin.y + 43
        tri_4_3.frame.origin.x = tri_4_4.frame.origin.x - 26
        tri_4_2.frame.origin.y = tri_3_5.frame.origin.y + 43
        tri_4_2.frame.origin.x = tri_4_3.frame.origin.x - 26
        tri_4_1.frame.origin.y = tri_3_5.frame.origin.y + 43
        tri_4_1.frame.origin.x = tri_4_2.frame.origin.x - 26
        tri_4_0.frame.origin.y = tri_3_5.frame.origin.y + 43
        tri_4_0.frame.origin.x = tri_4_1.frame.origin.x - 26
        tri_4_5.frame.origin.y = tri_3_5.frame.origin.y + 43
        tri_4_5.frame.origin.x = tri_4_4.frame.origin.x + 26
        tri_4_6.frame.origin.y = tri_3_5.frame.origin.y + 43
        tri_4_6.frame.origin.x = tri_4_5.frame.origin.x + 26
        tri_4_7.frame.origin.y = tri_3_5.frame.origin.y + 43
        tri_4_7.frame.origin.x = tri_4_6.frame.origin.x + 26
        tri_4_8.frame.origin.y = tri_3_5.frame.origin.y + 43
        tri_4_8.frame.origin.x = tri_4_7.frame.origin.x + 26
        //sixth row
        tri_5_3.frame.origin.y = tri_4_4.frame.origin.y + 43
        tri_5_3.frame.origin.x = tri_4_4.frame.origin.x
        tri_5_2.frame.origin.y = tri_4_4.frame.origin.y + 43
        tri_5_2.frame.origin.x = tri_5_3.frame.origin.x - 26
        tri_5_1.frame.origin.y = tri_4_4.frame.origin.y + 43
        tri_5_1.frame.origin.x = tri_5_2.frame.origin.x - 26
        tri_5_0.frame.origin.y = tri_4_4.frame.origin.y + 43
        tri_5_0.frame.origin.x = tri_5_1.frame.origin.x - 26
        tri_5_4.frame.origin.y = tri_4_4.frame.origin.y + 43
        tri_5_4.frame.origin.x = tri_5_3.frame.origin.x + 26
        tri_5_5.frame.origin.y = tri_4_4.frame.origin.y + 43
        tri_5_5.frame.origin.x = tri_5_4.frame.origin.x + 26
        tri_5_6.frame.origin.y = tri_4_4.frame.origin.y + 43
        tri_5_6.frame.origin.x = tri_5_5.frame.origin.x + 26

        
        
        
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
            //print("error")
        }
        //
        
        //
        //print("origin x is\(green_drag_tri.frame.origin.x), origin y is \(green_drag_tri.frame.origin.y)")
        //
        //initialize shape array
        //shape_type_index = [0 , 1 , 2]
        
        audioPlayer.play()
        self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
                        self.audioPlayer.play()   } )
        
            
            NotificationCenter.default.addObserver(self, selector: #selector(GameBoardViewController.background_music_pause) , name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(GameBoardViewController.background_music_continue), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    func background_music_pause () {
        audioPlayer.pause()
        timer.invalidate()
    }
    
    func background_music_continue() {
        audioPlayer.play()
        timer.fire()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pause_screen_x_transform(_ x: Double) -> CGFloat {
      let const = x/Double(400)
      let new_x = Double(screen_width)*const
      return CGFloat(new_x)
        
    }
    func pause_screen_y_transform(_ y: Double) -> CGFloat {
        let const = y/Double(700)
        let new_y = Double(screen_height)*const
        return CGFloat(new_y)
    }
    
    @IBAction func pause_button(_ sender: UIButton) {
        let pause_screen: UIView = UIView(frame: CGRect(origin: CGPoint(x: 0, y:0),size: CGSize(width: screen_width, height: screen_height)))
        pause_screen.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(0.8))
        pause_screen.tag = 100
        super.view.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(pause_screen)
        paused = true
        let continue_button = MyButton(frame: CGRect(x: pause_screen_x_transform(87.5), y: pause_screen_y_transform(283.5), width: 200, height: 170))
        continue_button.setBackgroundImage(continue_pic, for: .normal)
        continue_button.tag = 50
        
        let home_button = MyButton(frame: CGRect(x: pause_screen_x_transform(137.5), y: pause_screen_y_transform(190), width: 100, height: 85))
        home_button.setBackgroundImage(home_pic, for: .normal)
        home_button.tag = 51
        
        let like_button = MyButton(frame: CGRect(x: pause_screen_x_transform(52), y: pause_screen_y_transform(333.5), width: 100, height: 85))
        like_button.setBackgroundImage(like_pic, for: .normal)
        like_button.tag = 52
        
        let restart_button = MyButton(frame: CGRect(x: pause_screen_x_transform(222.5), y: pause_screen_y_transform(333.5), width: 100, height: 85))
        restart_button.setBackgroundImage(restart_pic, for: .normal)
        restart_button.tag = 53
        
        let change_theme_button = MyButton(frame: CGRect(x: pause_screen_x_transform(222.5), y: pause_screen_y_transform(570), width: 100, height: 30))
        change_theme_button.setTitle("day/night", for: .normal)
        change_theme_button.setTitleColor(.red, for: .normal)
        change_theme_button.tag = 54
        
        continue_button.whenButtonIsClicked(action:{
            pause_screen.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(0))
            continue_button.removeFromSuperview()
            home_button.removeFromSuperview()
            like_button.removeFromSuperview()
            restart_button.removeFromSuperview()
            change_theme_button.removeFromSuperview()
            pause_screen.removeFromSuperview()
            self.paused = false
            self.audioPlayer.play()
        })
        
        like_button.whenButtonIsClicked(action:{
            print ("Thank U 4 like us!!!")
        })
        
        restart_button.whenButtonIsClicked(action:{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GameBoardViewController") as! GameBoardViewController
            nextViewController.ThemeType = self.ThemeType
            self.present(nextViewController, animated: true, completion: nil)
            self.timer.invalidate()

        })
        
        home_button.whenButtonIsClicked(action:{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            self.present(nextViewController, animated: true, completion: nil)
            self.timer.invalidate()
        })
        
        change_theme_button.whenButtonIsClicked(action:{
        
            
                if (self.ThemeType == 1){
                    self.defaults.set(2, forKey: "tritri_Theme")
                    self.ThemeType = 2
                    self.view.backgroundColor = UIColor(red: 23.0/255, green: 53.0/255, blue: 52.0/255, alpha: 1.0)
                }else {
                    self.defaults.set(1, forKey: "tritri_Theme")
                    self.ThemeType = 1
                    self.view.backgroundColor = UIColor(red: 254.0/255, green: 253.0/255, blue: 252.0/255, alpha: 1.0)
                }
            
        })
        
        
        self.view.addSubview(continue_button)
        self.view.addSubview(home_button)
        self.view.addSubview(like_button)
        self.view.addSubview(restart_button)
        self.view.addSubview(change_theme_button)
        
        func continue_but(sender: UIButton!){
            pause_screen.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(0))
            continue_button.removeFromSuperview()
            home_button.removeFromSuperview()
            like_button.removeFromSuperview()
            restart_button.removeFromSuperview()
            paused = false
        }
        func home_but(sender: UIButton!){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            self.present(nextViewController, animated: true, completion: nil)
            self.timer.invalidate()
        }
        func like_but(sender: UIButton!){
            print ("Thank U 4 like us!!!")
        }
        func restart_but(sender: UIButton!){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GameBoardViewController") as! GameBoardViewController
            self.present(nextViewController, animated: true, completion: nil)
            self.timer.invalidate()
        }

        
        
        func buttonAction(sender: UIButton!) {
            print("Button tapped")
            switch (sender.tag){
            case 50: //continue
                pause_screen.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(0))
                continue_button.removeFromSuperview()
                home_button.removeFromSuperview()
                like_button.removeFromSuperview()
                restart_button.removeFromSuperview()
                break
            case 51:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                self.present(nextViewController, animated: true, completion: nil)
                self.timer.invalidate()
                break
            case 52:
                break
                
            case 53:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GameBoardViewController") as! GameBoardViewController
                self.present(nextViewController, animated: true, completion: nil)
                self.timer.invalidate()
                break
            default:
                let haha = 1
                break
                
            }
        }

        
    }
    
    
    //function in response to drag movement
    func panGestureRecognizerAction(_ gesture: UIPanGestureRecognizer){
        if !paused{
            
        
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
            let cond_before_insert = filled
            if (Shape_fitting(Shape_Type: actual_type_index, position: actual_location)){
                //play fit in sound effect
                do{
                    fit_in_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Fit_In", ofType: "aif")!))
                    fit_in_player.prepareToPlay()
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
                    try AVAudioSession.sharedInstance().setActive(false)
                }
                catch{
                    //print("error")
                }
                fit_in_player.play()
                let cond_before_erase = filled
                modify_counter(before: cond_before_insert, after: cond_before_erase)
                Check_and_Erase()
                let cond_after_erase = filled
                modify_counter(before: cond_before_erase, after: cond_after_erase)
               //if the triangles are fit
                if (position_in_use == 0){
                    green_drag_tri.frame.origin = green_drag_origin
                    exist1 = false
                }else if (position_in_use == 1){
                    orange_drag_tri.frame.origin = orange_drag_origin
                    exist2 = false
                }else if (position_in_use == 2){
                    light_brown_drag_tri.frame.origin = light_brown_drag_origin
                    exist3 = false
                }
                position_in_use = 3
                
                
               

                //
                if(Eligible_to_Generate()){
                    auto_random_generator()
                    

                }
                    
                if(Check_for_Gameover()){
            // here code perfomed with delay
                self.Jump_to_Game_Over ()
    
                    //print("haaaaaaaaaaaaaaaaa")
                    //let subView = UIView.init(frame: CGRect(origin: CGPoint(x: 0, y:0 ), size: CGSize(width: 200, height: 100)))
                   // subView.backgroundColor = UIColor.yellow
                   // self.view.addSubview(subView)
                
            
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
    }
    
    //compute distance between two CGPoint (Square Form) (not using rn)
    func distance_generator( drag_location: CGPoint, triangle_location: CGPoint) -> Double {
        let temp_distance = (drag_location.x-triangle_location.x)*(drag_location.x-triangle_location.x)+(drag_location.y-triangle_location.y)*(drag_location.y-triangle_location.y)
        return Double(temp_distance)
    }
    //--------------------------------------------------------------------------------------------------------------------
    //pause button activate
    
    @IBAction func pauseButton(_ sender: UIButton) {
        
        
    }
    
    
    
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
    
//pink elements
    
    let pink_up = UIImage(named:"pink_upwards")
    
    let pink_down = UIImage(named:"pink_downwards")
    
//purple elements
    
    let pur_up = UIImage(named:"purple_upwards")
    
    let pur_down = UIImage(named:"purple_downwards")
    
//pause icons
    
    let home_pic = UIImage(named:"home")
    
    let restart_pic = UIImage(named:"restart")
    
    let like_pic = UIImage(named:"like")
    
    let continue_pic = UIImage(named:"continue")
    
//--------------------------------------------------------------------------------------------------------------------

    
    
    
    
    
    
    //outlet connection variable for MarkBoard (top left)
    @IBOutlet weak var MarkBoard: UILabel!
    

    
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
                            position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 30){//check location
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
                                position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 30){
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
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 24 &&
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
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 24 &&
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
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 24 &&
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
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: super_light_green_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: super_light_green_up)
                                    
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
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: super_light_green_down)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: super_light_green_up)
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
        else if (Shape_Type == 6) {    //Shape_Type == 6 pink right direction
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 0||i == 1 || i == 2){//upper half
                        if (j%2 == 0 && j != tri_location[i].count - 1){//only upward not last one
                            if (position.x + 9 <= triangle_location.x + 12 && position.x + 9 >= triangle_location.x - 12 &&
                                position.y + 19.5 <= triangle_location.y + 12 && position.y + 19.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: pink_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: pink_down)
                                    
                                    filled[i][j] = true
                                    filled[i][j+1] = true
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3 || i == 4 || i == 5){//lower half
                        if (j%2 == 1){//only upward
                            if (position.x + 9 <= triangle_location.x + 12 && position.x + 9 >= triangle_location.x - 12 &&
                                position.y + 19.5 <= triangle_location.y + 12 && position.y + 19.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1]){//check available
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: pink_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: pink_down)
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

        else if (Shape_Type == 7) {    //Shape_Type == 7 purple single up
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 0||i == 1 || i == 2){//upper half
                        if (j%2 == 0){//only upward
                            if (position.x + 20 <= triangle_location.x + 12 && position.x + 20 >= triangle_location.x - 12 &&
                                position.y + 20 <= triangle_location.y + 12 && position.y + 20 >= triangle_location.y - 12){//check location
                                if (!filled[i][j]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: pur_up)
                                    
                                    filled[i][j] = true
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3 || i == 4 || i == 5){//lower half
                        if (j%2 == 1){//only upward
                            if (position.x + 20 <= triangle_location.x + 12 && position.x + 20 >= triangle_location.x - 12 &&
                                position.y + 20 <= triangle_location.y + 12 && position.y + 20 >= triangle_location.y - 12){//check location
                                if (!filled[i][j]){//check available
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: pur_up)
                                    filled[i][j] = true
                                    
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
        else if (Shape_Type == 8) {    //Shape_Type == 8 purple single down
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 0||i == 1 || i == 2){//upper half
                        if (j%2 == 1){//only downward
                            if (position.x + 22 <= triangle_location.x + 12 && position.x + 22 >= triangle_location.x - 12 &&
                                position.y + 28.5 <= triangle_location.y + 12 && position.y + 28.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: pur_down)
                                    
                                    filled[i][j] = true
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3 || i == 4 || i == 5){//lower half
                        if (j%2 == 0){//only downward
                            if (position.x + 22 <= triangle_location.x + 12 && position.x + 22 >= triangle_location.x - 12 &&
                                position.y + 28.5 <= triangle_location.y + 12 && position.y + 28.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j]){//check available
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: pur_down)
                                    filled[i][j] = true
                                    
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
                                position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 30){//check location
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
                                position.y <= triangle_location.y + 12 && position.y >= triangle_location.y - 30){
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
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 24 &&
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
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 24 &&
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
                            if (position.x <= triangle_location.x + 12 && position.x >= triangle_location.x - 24 &&
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
        else if (Shape_Type == 6) {    //Shape_Type == 6 pink right direction
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 0||i == 1 || i == 2){//upper half
                        if (j%2 == 0 && j != tri_location[i].count - 1){//only upward not last one
                            if (position.x + 9 <= triangle_location.x + 12 && position.x + 9 >= triangle_location.x - 12 &&
                                position.y + 19.5 <= triangle_location.y + 12 && position.y + 19.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: pink_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: pink_down)
                                    
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3 || i == 4 || i == 5){//lower half
                        if (j%2 == 1){//only upward
                            if (position.x + 9 <= triangle_location.x + 12 && position.x + 9 >= triangle_location.x - 12 &&
                                position.y + 19.5 <= triangle_location.y + 12 && position.y + 19.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j] && !filled[i][j+1]){//check available
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: pink_up)
                                    Change_Corresponding_Color_With_Image(x:i, y:j+1, image: pink_down)
                                    
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
        else if (Shape_Type == 7) {    //Shape_Type == 7 purple single up
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 0||i == 1 || i == 2){//upper half
                        if (j%2 == 0){//only upward
                            if (position.x + 20 <= triangle_location.x + 12 && position.x + 20 >= triangle_location.x - 12 &&
                                position.y + 20 <= triangle_location.y + 12 && position.y + 20 >= triangle_location.y - 12){//check location
                                if (!filled[i][j]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: pur_up)
                                    
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3 || i == 4 || i == 5){//lower half
                        if (j%2 == 1){//only upward
                            if (position.x + 20 <= triangle_location.x + 12 && position.x + 20 >= triangle_location.x - 12 &&
                                position.y + 20 <= triangle_location.y + 12 && position.y + 20 >= triangle_location.y - 12){//check location
                                if (!filled[i][j]){//check available
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: pur_up)
                                    
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
        else if (Shape_Type == 8) {    //Shape_Type == 8 purple single down
            var i = 0
            for triangles_location in tri_location{
                var j = 0
                
                for triangle_location in triangles_location{
                    if (i == 0||i == 1 || i == 2){//upper half
                        if (j%2 == 1){//only downward
                            if (position.x + 22 <= triangle_location.x + 12 && position.x + 22 >= triangle_location.x - 12 &&
                                position.y + 28.5 <= triangle_location.y + 12 && position.y + 28.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j]){//check available
                                    
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: pur_down)
                                    
                                    return true
                                }
                                return false
                            }
                        }
                        
                    }else if (i == 3 || i == 4 || i == 5){//lower half
                        if (j%2 == 0){//only downward
                            if (position.x + 22 <= triangle_location.x + 12 && position.x + 22 >= triangle_location.x - 12 &&
                                position.y + 28.5 <= triangle_location.y + 12 && position.y + 28.5 >= triangle_location.y - 12){//check location
                                if (!filled[i][j]){//check available
                                    auto_make_transparent()
                                    Change_Corresponding_Color_With_Image(x:i, y:j, image: pur_down)
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
        //force_recenter_drag_tris( tri: light_brown_drag_tri,tri_img: generator_array[randomIndex] )
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
    
    func Restore_A_Grey_Tri(i: Int, j: Int) ->Void {
        //row NO 0
        if (i == 0 && j == 0){
            tri_0_0.image = upwards_tri
        }
       else if(i == 0 && j == 1) {
            tri_0_1.image = downwards_tri
        }
        else if (i == 0 && j == 2){
            tri_0_2.image = upwards_tri
        }
       else if(i == 0 && j == 3) {
            tri_0_3.image = downwards_tri
        }
      else  if (i == 0 && j == 4){
            tri_0_4.image = upwards_tri
        }
       else if(i == 0 && j == 5) {
            tri_0_5.image = downwards_tri
        }
       else if (i == 0 && j == 6){
            tri_0_6.image = upwards_tri
        }
        //row NO 1
      else  if (i == 1 && j == 0){
            tri_1_0.image = upwards_tri
        }
      else  if(i == 1 && j == 1) {
            tri_1_1.image = downwards_tri
        }
     else   if (i == 1 && j == 2){
            tri_1_2.image = upwards_tri
        }
      else  if(i == 1 && j == 3) {
            tri_1_3.image = downwards_tri
        }
    else    if (i == 1 && j == 4){
            tri_1_4.image = upwards_tri
        }
    else if(i == 1 && j == 5) {
            tri_1_5.image = downwards_tri
        }
        else if (i == 1 && j == 6){
            tri_1_6.image = upwards_tri
        }
        else if(i == 1 && j == 7) {
            tri_1_7.image = downwards_tri
        }
        else if (i == 1 && j == 8){
            tri_1_8.image = upwards_tri
        }
        //row NO 2
        else if(i == 2 && j == 0) {
            tri_2_0.image = upwards_tri
        }
        else if(i == 2 && j == 1) {
            tri_2_1.image = downwards_tri
        }
        else if(i == 2 && j == 2) {
            tri_2_2.image = upwards_tri
        }
        else if(i == 2 && j == 3) {
            tri_2_3.image = downwards_tri
        }
        else if(i == 2 && j == 4) {
            tri_2_4.image = upwards_tri
        }
        else if(i == 2 && j == 5) {
            tri_2_5.image = downwards_tri
        }
        else if(i == 2 && j == 6) {
            tri_2_6.image = upwards_tri
        }
        else if(i == 2 && j == 7) {
            tri_2_7.image = downwards_tri
        }
        else if(i == 2 && j == 8) {
            tri_2_8.image = upwards_tri
        }
        else if(i == 2 && j == 9) {
            tri_2_9.image = downwards_tri
        }
        else if(i == 2 && j == 10) {
            tri_2_10.image = upwards_tri
        }
        //row NO 3
        else if(i == 3 && j == 0) {
            tri_3_0.image = downwards_tri
        }
        else if(i == 3 && j == 1) {
            tri_3_1.image = upwards_tri
        }
        else if(i == 3 && j == 2) {
            tri_3_2.image = downwards_tri
        }
        else if(i == 3 && j == 3) {
            tri_3_3.image = upwards_tri
        }
        else if(i == 3 && j == 4) {
            tri_3_4.image = downwards_tri
        }
        else if(i == 3 && j == 5) {
            tri_3_5.image = upwards_tri
        }
        else if(i == 3 && j == 6) {
            tri_3_6.image = downwards_tri
        }
        else if(i == 3 && j == 7) {
            tri_3_7.image = upwards_tri
        }
        else if(i == 3 && j == 8) {
            tri_3_8.image = downwards_tri
        }
        else if(i == 3 && j == 9) {
            tri_3_9.image = upwards_tri
        }
        else if(i == 3 && j == 10) {
             tri_3_10.image = downwards_tri
        }
        //row NO 4
        
        else if (i == 4 && j == 0){
            tri_4_0.image = downwards_tri
        }
        else if(i == 4 && j == 1) {
            tri_4_1.image = upwards_tri
        }
        else if (i == 4 && j == 2){
            tri_4_2.image = downwards_tri
        }
        else if(i == 4 && j == 3) {
            tri_4_3.image = upwards_tri
        }
        else if (i == 4 && j == 4){
            tri_4_4.image = downwards_tri
        }
        else if(i == 4 && j == 5) {
            tri_4_5.image = upwards_tri
        }
        else if (i == 4 && j == 6){
            tri_4_6.image = downwards_tri
        }
        else if(i == 4 && j == 7) {
            tri_4_7.image = upwards_tri
        }
        else if (i == 4 && j == 8){
            tri_4_8.image = downwards_tri
        }
        //row NO 5
        else if (i == 5 && j == 0){
            tri_5_0.image = downwards_tri
        }
        else if(i == 5 && j == 1) {
            tri_5_1.image = upwards_tri
        }
        else if (i == 5 && j == 2){
            tri_5_2.image = downwards_tri
        }
        else if(i == 5 && j == 3) {
            tri_5_3.image = upwards_tri
        }
        else if (i == 5 && j == 4){
            tri_5_4.image = downwards_tri
        }
        else if(i == 5 && j == 5) {
            tri_5_5.image = upwards_tri
        }
        else if (i == 5 && j == 6){
            tri_5_6.image = downwards_tri
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
        Check_for_Placable_Shape_And_Generate()
       var position_index = 0
        var end_loop = false
        var random_shape_index = 0
        while(!end_loop){
            position_index = Int(arc4random_uniform(UInt32(3)))
            random_shape_index = randomShape_for_Difficulty_Level ()
            if(shape_placable_array[random_shape_index]){
                end_loop = true
            }
        }
        
        var randomIndex = 0
        if(position_index == 0){
            green_drag_tri.image = generator_array[random_shape_index]
            green_drag_tri.sizeToFit()
            green_drag_tri_orig_rec = green_drag_tri.frame
            shape_type_index[0] = random_shape_index
            
            randomIndex = randomShape_for_Difficulty_Level ()
            //Int(arc4random_uniform(UInt32(generator_array.count)))
            orange_drag_tri.image = generator_array[randomIndex]
            orange_drag_tri.sizeToFit()
            orange_drag_tri_orig_rec = orange_drag_tri.frame
            shape_type_index[1] = randomIndex
            
            //force_recenter_drag_tris( tri: orange_drag_tri,tri_img: generator_array[randomIndex] )
            
            randomIndex = randomShape_for_Difficulty_Level ()
            //Int(arc4random_uniform(UInt32(generator_array.count)))
            light_brown_drag_tri.image = generator_array[randomIndex]
            light_brown_drag_tri.sizeToFit()
            light_brown_drag_tri_orig_rec = light_brown_drag_tri.frame
            force_recenter_drag_tris( tri: light_brown_drag_tri,tri_img: generator_array[randomIndex] )
            shape_type_index[2] = randomIndex
            
            

            
        }
        else if(position_index == 1){
            orange_drag_tri.image = generator_array[random_shape_index]
            orange_drag_tri.sizeToFit()
            orange_drag_tri_orig_rec = orange_drag_tri.frame
            shape_type_index[1] = random_shape_index
            
            randomIndex = randomShape_for_Difficulty_Level ()
            green_drag_tri.image = generator_array[randomIndex]
            green_drag_tri.sizeToFit()
            green_drag_tri_orig_rec = green_drag_tri.frame
            shape_type_index[0] = randomIndex
            
            randomIndex = randomShape_for_Difficulty_Level ()
            //Int(arc4random_uniform(UInt32(generator_array.count)))
            light_brown_drag_tri.image = generator_array[randomIndex]
            light_brown_drag_tri.sizeToFit()
            light_brown_drag_tri_orig_rec = light_brown_drag_tri.frame
            //force_recenter_drag_tris( tri: light_brown_drag_tri,tri_img: generator_array[randomIndex] )
            shape_type_index[2] = randomIndex
            
        }
        
        else if(position_index == 2){
            //Int(arc4random_uniform(UInt32(generator_array.count)))
            light_brown_drag_tri.image = generator_array[random_shape_index]
            light_brown_drag_tri.sizeToFit()
            //force_recenter_drag_tris( tri: light_brown_drag_tri,tri_img: generator_array[randomIndex] )
            shape_type_index[2] = random_shape_index
            
             randomIndex = randomShape_for_Difficulty_Level ()
            //Int(arc4random_uniform(UInt32(generator_array.count)))
            green_drag_tri.image = generator_array[randomIndex]
            green_drag_tri.sizeToFit()
            green_drag_tri_orig_rec = green_drag_tri.frame
            shape_type_index[0] = randomIndex
            
            
            randomIndex = randomShape_for_Difficulty_Level ()
            //Int(arc4random_uniform(UInt32(generator_array.count)))
            orange_drag_tri.image = generator_array[randomIndex]
            orange_drag_tri.sizeToFit()
            orange_drag_tri_orig_rec = orange_drag_tri.frame
            shape_type_index[1] = randomIndex

        }

        else{ randomIndex = randomShape_for_Difficulty_Level ()
            //Int(arc4random_uniform(UInt32(generator_array.count)))
        green_drag_tri.image = generator_array[randomIndex]
        green_drag_tri.sizeToFit()
        green_drag_tri_orig_rec = green_drag_tri.frame
        shape_type_index[0] = randomIndex
        // force_recenter_drag_tris( tri: green_drag_tri,tri_img: generator_array[randomIndex] )
        
        
        randomIndex = randomShape_for_Difficulty_Level ()
            //Int(arc4random_uniform(UInt32(generator_array.count)))
        orange_drag_tri.image = generator_array[randomIndex]
        orange_drag_tri.sizeToFit()
        orange_drag_tri_orig_rec = orange_drag_tri.frame
        shape_type_index[1] = randomIndex
        
        //force_recenter_drag_tris( tri: orange_drag_tri,tri_img: generator_array[randomIndex] )
        
        randomIndex = randomShape_for_Difficulty_Level ()
            //Int(arc4random_uniform(UInt32(generator_array.count)))
        light_brown_drag_tri.image = generator_array[randomIndex]
        light_brown_drag_tri.sizeToFit()
        light_brown_drag_tri_orig_rec = light_brown_drag_tri.frame
        force_recenter_drag_tris( tri: light_brown_drag_tri,tri_img: generator_array[randomIndex] )
        shape_type_index[2] = randomIndex
        }
        exist1 = true
        exist2 = true
        exist3 = true
    }
    
    func Duplicate_Tri_Animate(i: Int, j: Int) ->Void {
        //row NO 0
        if (i == 0 && j == 0){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_0_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 0)
                self.tri_0_0.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
                    }
        else if(i == 0 && j == 1) {
            UIView.animate(withDuration: 0.2, animations: {
               self.tri_0_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 1)
                self.tri_0_1.transform = CGAffineTransform(scaleX: 1, y: 1)
            })

        }
        else if (i == 0 && j == 2){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_0_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 2)
                self.tri_0_2.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 0 && j == 3) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_0_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 3)
                self.tri_0_3.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else  if (i == 0 && j == 4){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_0_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 4)
                self.tri_0_4.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 0 && j == 5) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_0_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 5)
                self.tri_0_5.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
    
        }
        else if (i == 0 && j == 6){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_0_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 6)
                self.tri_0_6.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
            //row NO 1
        else  if (i == 1 && j == 0){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_1_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 1, j: 0)
                self.tri_1_0.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else  if(i == 1 && j == 1) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_1_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 1, j: 1)
                self.tri_1_1.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else  if (i == 1 && j == 2){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_1_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 1, j: 2)
                self.tri_1_2.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else  if(i == 1 && j == 3) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_1_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 1, j: 3)
                self.tri_1_3.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else  if (i == 1 && j == 4){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_1_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 1, j: 4)
                self.tri_1_4.transform = CGAffineTransform(scaleX: 1, y: 1)
            })

        }
        else if(i == 1 && j == 5) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_1_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 1, j: 5)
                self.tri_1_5.transform = CGAffineTransform(scaleX: 1, y: 1)
            })

        }
        else if (i == 1 && j == 6){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_1_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 1, j: 6)
                self.tri_1_6.transform = CGAffineTransform(scaleX: 1, y: 1)
            })        }
        else if(i == 1 && j == 7) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_1_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 1, j: 7)
                self.tri_1_7.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
                  }
        else if (i == 1 && j == 8){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_1_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 1, j: 8)
                self.tri_1_8.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
          
        }
            //row NO 2
        else if(i == 2 && j == 0) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_2_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 0)
                self.tri_2_0.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 2 && j == 1) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_2_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 1)
                self.tri_2_1.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 2 && j == 2) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_2_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 2)
                self.tri_2_2.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 2 && j == 3) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_2_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 3)
                self.tri_2_3.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 2 && j == 4) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_2_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 4)
                self.tri_2_4.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 2 && j == 5) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_2_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 5)
                self.tri_2_5.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 2 && j == 6) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_2_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 6)
                self.tri_2_6.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 2 && j == 7) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_2_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 7)
                self.tri_2_7.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 2 && j == 8) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_2_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 8)
                self.tri_2_8.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 2 && j == 9) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_2_9.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 9)
                self.tri_2_9.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 2 && j == 10) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_2_10.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 10)
                self.tri_2_10.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
            //row NO 3
        else if(i == 3 && j == 0) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_3_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 3, j: 0)
                self.tri_3_0.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 3 && j == 1) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_3_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 3, j: 1)
                self.tri_3_1.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 3 && j == 2) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_3_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 3, j: 2)
                self.tri_3_2.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 3 && j == 3) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_3_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 3, j: 3)
                self.tri_3_3.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 3 && j == 4) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_3_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 3, j: 4)
                self.tri_3_4.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 3 && j == 5) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_3_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 3, j: 5)
                self.tri_3_5.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 3 && j == 6) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_3_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 3, j: 6)
                self.tri_3_6.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 3 && j == 7) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_3_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 3, j: 7)
                self.tri_3_7.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 3 && j == 8) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_3_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 3, j: 8)
                self.tri_3_8.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 3 && j == 9) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_3_9.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 3, j: 9)
                self.tri_3_9.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 3 && j == 10) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_3_10.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 3, j: 10)
                self.tri_3_10.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
            //row NO 4
            
        else if (i == 4 && j == 0){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_4_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 4, j: 0)
                self.tri_4_0.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 4 && j == 1) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_4_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 4, j: 1)
                self.tri_4_1.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if (i == 4 && j == 2){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_4_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 4, j: 2)
                self.tri_4_2.transform = CGAffineTransform(scaleX: 1, y: 1)
            })        }
        else if(i == 4 && j == 3) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_4_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 4, j: 3)
                self.tri_4_3.transform = CGAffineTransform(scaleX: 1, y: 1)
            })        }
        else if (i == 4 && j == 4){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_4_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 4, j: 4)
                self.tri_4_4.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 4 && j == 5) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_4_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 4, j: 5)
                self.tri_4_5.transform = CGAffineTransform(scaleX: 1, y: 1)
            })

        }
        else if (i == 4 && j == 6){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_4_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 4, j: 6)
                self.tri_4_6.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 4 && j == 7) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_4_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 4, j: 7)
                self.tri_4_7.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if (i == 4 && j == 8){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_4_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 4, j: 8)
                self.tri_4_8.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
            //row NO 5
        else if (i == 5 && j == 0){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_5_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 5, j: 0)
                self.tri_5_0.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 5 && j == 1) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_5_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 5, j: 1)
                self.tri_5_1.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if (i == 5 && j == 2){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_5_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 5, j: 2)
                self.tri_5_2.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 5 && j == 3) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_5_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 5, j: 3)
                self.tri_5_3.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if (i == 5 && j == 4){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_5_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 5, j: 4)
                self.tri_5_4.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if(i == 5 && j == 5) {
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_5_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 5, j: 5)
                self.tri_5_5.transform = CGAffineTransform(scaleX: 1, y: 1)
            })        }
        else if (i == 5 && j == 6){
            UIView.animate(withDuration: 0.2, animations: {
                self.tri_5_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 5, j: 6)
                self.tri_5_1.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        
        
    }
    //situation for cancel
    var situation0 = false
    var situation1 = false
    var situation2 = false
    var situation3 = false
    var situation4 = false
    var situation5 = false
    var situation6 = false
    var situation7 = false
    var situation8 = false
    var situation9 = false
    var situation10 = false
    var situation11 = false
    var situation12 = false
    var situation13 = false
    var situation14 = false
    var situation15 = false
    var situation16 = false
    var situation17 = false

    func Check_and_Erase_Create_Array() -> Array<(row: Int, column: Int)> {
        var eliminate_array = [(row: Int, column: Int)]()

        if(filled[0][0]&&filled[0][1]&&filled[0][2]&&filled[0][3]&&filled[0][4]&&filled[0][5]&&filled[0][6]){
            eliminate_array.append((row: 0, column: 0))
            eliminate_array.append((row: 0, column: 1))
            eliminate_array.append((row: 0, column: 2))
            eliminate_array.append((row: 0, column: 3))
            eliminate_array.append((row: 0, column: 4))
            eliminate_array.append((row: 0, column: 5))
            eliminate_array.append((row: 0, column: 6))
        }
          if(filled[1][0]&&filled[1][1]&&filled[1][2]&&filled[1][3]&&filled[1][4]&&filled[1][5]&&filled[1][6]&&filled[1][7]&&filled[1][8]){
            eliminate_array.append((row: 1, column: 0))
            eliminate_array.append((row: 1, column: 1))
            eliminate_array.append((row: 1, column: 2))
            eliminate_array.append((row: 1, column: 3))
            eliminate_array.append((row: 1, column: 4))
            eliminate_array.append((row: 1, column: 5))
            eliminate_array.append((row: 1, column: 6))
            eliminate_array.append((row: 1, column: 7))
            eliminate_array.append((row: 1, column: 8))
        }
        
        if(filled[2][0]&&filled[2][1]&&filled[2][2]&&filled[2][3]&&filled[2][4]&&filled[2][5]&&filled[2][6]&&filled[2][7]&&filled[2][8]&&filled[2][9]&&filled[2][10]){
            eliminate_array.append((row: 2, column: 0))
            eliminate_array.append((row: 2, column: 1))
            eliminate_array.append((row: 2, column: 2))
            eliminate_array.append((row: 2, column: 3))
            eliminate_array.append((row: 2, column: 4))
            eliminate_array.append((row: 2, column: 5))
            eliminate_array.append((row: 2, column: 6))
            eliminate_array.append((row: 2, column: 7))
            eliminate_array.append((row: 2, column: 8))
            eliminate_array.append((row: 2, column: 9))
            eliminate_array.append((row: 2, column: 10))
        }
        
       if(filled[3][0]&&filled[3][1]&&filled[3][2]&&filled[3][3]&&filled[3][4]&&filled[3][5]&&filled[3][6]&&filled[3][7]&&filled[3][8]&&filled[3][9]&&filled[3][10]){
        eliminate_array.append((row: 3, column: 0))
        eliminate_array.append((row: 3, column: 1))
        eliminate_array.append((row: 3, column: 2))
        eliminate_array.append((row: 3, column: 3))
        eliminate_array.append((row: 3, column: 4))
        eliminate_array.append((row: 3, column: 5))
        eliminate_array.append((row: 3, column: 6))
        eliminate_array.append((row: 3, column: 7))
        eliminate_array.append((row: 3, column: 8))
        eliminate_array.append((row: 3, column: 9))
        eliminate_array.append((row: 3, column: 10))
        }

        //eliminate fifth row
        if(filled[4][0]&&filled[4][1]&&filled[4][2]&&filled[4][3]&&filled[4][4]&&filled[4][5]&&filled[4][6]&&filled[4][7]&&filled[4][8]){
            
            eliminate_array.append((row: 4, column: 0))
            eliminate_array.append((row: 4, column: 1))
            eliminate_array.append((row: 4, column: 2))
            eliminate_array.append((row: 4, column: 3))
            eliminate_array.append((row: 4, column: 4))
            eliminate_array.append((row: 4, column: 5))
            eliminate_array.append((row: 4, column: 6))
            eliminate_array.append((row: 4, column: 7))
            eliminate_array.append((row: 4, column: 8))

            
        }
        ////eliminate sixth row
        if(filled[5][0]&&filled[5][1]&&filled[5][2]&&filled[5][3]&&filled[5][4]&&filled[5][5]&&filled[5][6]){

            eliminate_array.append((row: 5, column: 0))
            eliminate_array.append((row: 5, column: 1))
            eliminate_array.append((row: 5, column: 2))
            eliminate_array.append((row: 5, column: 3))
            eliminate_array.append((row: 5, column: 4))
            eliminate_array.append((row: 5, column: 5))
            eliminate_array.append((row: 5, column: 6))
            
            
        }
        
        
        //situation two - 右下斜
        if(filled[2][0]&&filled[3][0]&&filled[3][1]&&filled[4][0]&&filled[4][1]&&filled[5][0]&&filled[5][1]){

            eliminate_array.append((row: 2, column: 0))
            eliminate_array.append((row: 3, column: 0))
            eliminate_array.append((row: 3, column: 1))
            eliminate_array.append((row: 4, column: 0))
            eliminate_array.append((row: 4, column: 1))
            eliminate_array.append((row: 5, column: 0))
            eliminate_array.append((row: 5, column: 1))

            
        }
        
        
        if(filled[1][0]&&filled[2][1]&&filled[2][2]&&filled[3][2]&&filled[3][3]&&filled[4][2]&&filled[4][3]&&filled[5][2]&&filled[5][3]){
            eliminate_array.append((row: 1, column: 0))
            eliminate_array.append((row: 2, column: 1))
            eliminate_array.append((row: 2, column: 2))
            eliminate_array.append((row: 3, column: 2))
            eliminate_array.append((row: 3, column: 3))
            eliminate_array.append((row: 4, column: 2))
            eliminate_array.append((row: 4, column: 3))
            eliminate_array.append((row: 5, column: 2))
            eliminate_array.append((row: 5, column: 3))
            
        }
        if(filled[0][0]&&filled[1][1]&&filled[1][2]&&filled[2][3]&&filled[2][4]&&filled[3][4]&&filled[3][5]&&filled[4][4]&&filled[4][5]&&filled[5][4]&&filled[5][5]){
            eliminate_array.append((row: 0, column: 0))
            eliminate_array.append((row: 1, column: 1))
            eliminate_array.append((row: 1, column: 2))
            eliminate_array.append((row: 2, column: 3))
            eliminate_array.append((row: 2, column: 4))
            eliminate_array.append((row: 3, column: 4))
            eliminate_array.append((row: 3, column: 5))
            eliminate_array.append((row: 4, column: 4))
            eliminate_array.append((row: 4, column: 5))
            eliminate_array.append((row: 5, column: 4))
            eliminate_array.append((row: 5, column: 5))
            
        }
        
        
        
        
        if(filled[0][1]&&filled[0][2]&&filled[1][3]&&filled[1][4]&&filled[2][5]&&filled[2][6]&&filled[3][6]&&filled[3][7]&&filled[4][6]&&filled[4][7]&&filled[5][6]){
            eliminate_array.append((row: 0, column: 1))
            eliminate_array.append((row: 0, column: 2))
            eliminate_array.append((row: 1, column: 3))
            eliminate_array.append((row: 1, column: 4))
            eliminate_array.append((row: 2, column: 5))
            eliminate_array.append((row: 2, column: 6))
            eliminate_array.append((row: 3, column: 6))
            eliminate_array.append((row: 3, column: 7))
            eliminate_array.append((row: 4, column: 6))
            eliminate_array.append((row: 4, column: 7))
            eliminate_array.append((row: 5, column: 6))
            
        }
        
        
        if(filled[0][3]&&filled[0][4]&&filled[1][5]&&filled[1][6]&&filled[2][7]&&filled[2][8]&&filled[3][8]&&filled[3][9]&&filled[4][8]){
          
            eliminate_array.append((row: 0, column: 3))
            eliminate_array.append((row: 0, column: 4))
            eliminate_array.append((row: 1, column: 5))
            eliminate_array.append((row: 1, column: 6))
            eliminate_array.append((row: 2, column: 7))
            eliminate_array.append((row: 2, column: 8))
            eliminate_array.append((row: 3, column: 8))
            eliminate_array.append((row: 3, column: 9))
            eliminate_array.append((row: 4, column: 8))

        
        }
        if(filled[0][5]&&filled[0][6]&&filled[1][7]&&filled[1][8]&&filled[2][9]&&filled[2][10]&&filled[3][10]){

            eliminate_array.append((row: 0, column: 5))
            eliminate_array.append((row: 0, column: 6))
            eliminate_array.append((row: 1, column: 7))
            eliminate_array.append((row: 1, column: 8))
            eliminate_array.append((row: 2, column: 9))
            eliminate_array.append((row: 2, column: 10))
            eliminate_array.append((row: 3, column: 10))

            
            
        }
        
        
        //situation three - 左下斜
        if(filled[0][0]&&filled[0][1]&&filled[1][0]&&filled[1][1]&&filled[2][0]&&filled[2][1]&&filled[3][0]){
            eliminate_array.append((row: 0, column: 0))
            eliminate_array.append((row: 0, column: 1))
            eliminate_array.append((row: 1, column: 0))
            eliminate_array.append((row: 1, column: 1))
            eliminate_array.append((row: 2, column: 0))
            eliminate_array.append((row: 2, column: 1))
            eliminate_array.append((row: 3, column: 0))
        
            
            
        }
        
        
        if(filled[0][2]&&filled[0][3]&&filled[1][2]&&filled[1][3]&&filled[2][2]&&filled[2][3]&&filled[3][1]&&filled[3][2]&&filled[4][0]){
            eliminate_array.append((row: 0, column: 2))
            eliminate_array.append((row: 0, column: 3))
            eliminate_array.append((row: 1, column: 2))
            eliminate_array.append((row: 1, column: 3))
            eliminate_array.append((row: 2, column: 2))
            eliminate_array.append((row: 2, column: 3))
            eliminate_array.append((row: 3, column: 1))
            eliminate_array.append((row: 3, column: 2))
            eliminate_array.append((row: 4, column: 0))

            
            
        }
        
        if(filled[0][4]&&filled[0][5]&&filled[1][4]&&filled[1][5]&&filled[2][4]&&filled[2][5]&&filled[3][3]&&filled[3][4]&&filled[4][1]&&filled[4][2]&&filled[5][0]){
            eliminate_array.append((row: 0, column: 4))
            eliminate_array.append((row: 0, column: 5))
            eliminate_array.append((row: 1, column: 4))
            eliminate_array.append((row: 1, column: 5))
            eliminate_array.append((row: 2, column: 4))
            eliminate_array.append((row: 2, column: 5))
            eliminate_array.append((row: 3, column: 3))
            eliminate_array.append((row: 3, column: 4))
            eliminate_array.append((row: 4, column: 1))
            eliminate_array.append((row: 4, column: 2))
            eliminate_array.append((row: 5, column: 0))

        }
        if(filled[0][6]&&filled[1][6]&&filled[1][7]&&filled[2][6]&&filled[2][7]&&filled[3][5]&&filled[3][6]&&filled[4][3]&&filled[4][4]&&filled[5][1]&&filled[5][2]){
            
            eliminate_array.append((row: 0, column: 6))
            eliminate_array.append((row: 1, column: 6))
            eliminate_array.append((row: 1, column: 7))
            eliminate_array.append((row: 2, column: 6))
            eliminate_array.append((row: 2, column: 7))
            eliminate_array.append((row: 3, column: 5))
            eliminate_array.append((row: 3, column: 6))
            eliminate_array.append((row: 4, column: 3))
            eliminate_array.append((row: 4, column: 4))
            eliminate_array.append((row: 5, column: 1))
            eliminate_array.append((row: 5, column: 2))

            
        }
        
        
        
        if(filled[1][8]&&filled[2][8]&&filled[2][9]&&filled[3][7]&&filled[3][8]&&filled[4][5]&&filled[4][6]&&filled[5][3]&&filled[5][4]){
            eliminate_array.append((row: 1, column: 8))
            eliminate_array.append((row: 2, column: 8))
            eliminate_array.append((row: 2, column: 9))
            eliminate_array.append((row: 3, column: 7))
            eliminate_array.append((row: 3, column: 8))
            eliminate_array.append((row: 4, column: 5))
            eliminate_array.append((row: 4, column: 6))
            eliminate_array.append((row: 5, column: 3))
            eliminate_array.append((row: 5, column: 4))
        }
        
        
        if(filled[2][10]&&filled[3][9]&&filled[3][10]&&filled[4][7]&&filled[4][8]&&filled[5][5]&&filled[5][6]){
            eliminate_array.append((row: 2, column: 10))
            eliminate_array.append((row: 3, column: 9))
            eliminate_array.append((row: 3, column: 10))
            eliminate_array.append((row: 4, column: 7))
            eliminate_array.append((row: 4, column: 8))
            eliminate_array.append((row: 5, column: 5))
            eliminate_array.append((row: 5, column: 6))

        }
  
       
        //get the duplicate array

        let sorted_array = eliminate_array.sorted(by: {$0.row < $1.row && $0.column < $1.column})
        
        var previous_element : (row: Int , column: Int) = (row: -1, column: -1)
        var i = 0
        var duplicates_array = [(row: Int, column: Int)]()
        for pair in eliminate_array{
            let current_element = eliminate_array[i]
            if(current_element.column == previous_element.column && current_element.row == previous_element.row){
            duplicates_array.append(previous_element)
            } else{
                previous_element = current_element
            }
            i += 1
        }
        
        
        return duplicates_array
        }
    
    var duplicates_array = [(row: Int, column: Int)]()
    func Check_Element_In_Duplicate_Array(row: Int, column: Int) -> Bool{
        for every_element in duplicates_array{
            if(every_element.column == column && every_element.row == row){
                return true
            }
        }
     return false
    }

    
    func Check_and_Erase() -> Void {
      //duplicates_array = Check_and_Erase_Create_Array()
        //situation one - row
        //eliminate first row
         situation0 = false
        situation1 = false
         situation2 = false
        situation3 = false
       situation4 = false
         situation5 = false
         situation6 = false
        situation7 = false
         situation8 = false
       situation9 = false
        situation10 = false
        situation11 = false
       situation12 = false
         situation13 = false
         situation14 = false
         situation15 = false
         situation16 = false
          situation17 = false
        if(filled[0][0]&&filled[0][1]&&filled[0][2]&&filled[0][3]&&filled[0][4]&&filled[0][5]&&filled[0][6]){
          situation0 = true

            UIView.animate(withDuration: 0.1, animations: {
               self.tri_0_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 0)
                self.tri_0_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_0_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 0, j: 1)
                    self.tri_0_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                    self.tri_0_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 0, j: 2)
                        self.tri_0_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_0_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 0, j: 3)
                            self.tri_0_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                              self.tri_0_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 0, j: 4)
                                self.tri_0_4.transform = CGAffineTransform(scaleX: 1, y: 1)

                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_0_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 0, j: 5)
                                    self.tri_0_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                         self.tri_0_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        
                                        self.Restore_A_Grey_Tri(i: 0, j: 6)
                                        self.tri_0_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    
                                    })
                                })
                            })
                        })
                    })
                    
 
                })
        })
            
        }
        
        //eliminate second row
        if(filled[1][0]&&filled[1][1]&&filled[1][2]&&filled[1][3]&&filled[1][4]&&filled[1][5]&&filled[1][6]&&filled[1][7]&&filled[1][8]){
 
         situation1 = true
            
            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_1_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 1, j: 0)
                self.tri_1_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_1_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 1, j: 1)
                    self.tri_1_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_1_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 1, j: 2)
                        self.tri_1_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_1_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 1, j: 3)
                            self.tri_1_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_1_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 1, j: 4)
                                self.tri_1_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_1_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 1, j: 5)
                                    self.tri_1_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_1_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 1, j: 6)
                                        self.tri_1_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        UIView.animate(withDuration: 0.1, animations: {
                                           self.tri_1_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                        }, completion: {
                                            (finished) -> Void in
                                            self.Restore_A_Grey_Tri(i: 1, j: 7)
                                            self.tri_1_7.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            UIView.animate(withDuration: 0.1, animations: {
                                              self.tri_1_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                            }, completion: {
                                                (finished) -> Void in
                                                self.Restore_A_Grey_Tri(i: 1, j: 8)
                                                self.tri_1_8.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            })
                                        })
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })

        }
        //eliminate third row
        if(filled[2][0]&&filled[2][1]&&filled[2][2]&&filled[2][3]&&filled[2][4]&&filled[2][5]&&filled[2][6]&&filled[2][7]&&filled[2][8]&&filled[2][9]&&filled[2][10]){


            
            
            situation2 = true
            
            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_2_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 0)
                self.tri_2_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_2_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 2, j: 1)
                    self.tri_2_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_2_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 2, j: 2)
                        self.tri_2_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_2_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 2, j: 3)
                            self.tri_2_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_2_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 2, j: 4)
                                self.tri_2_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_2_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 2, j: 5)
                                    self.tri_2_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_2_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 2, j: 6)
                                        self.tri_2_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        UIView.animate(withDuration: 0.1, animations: {
                                            self.tri_2_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                        }, completion: {
                                            (finished) -> Void in
                                            self.Restore_A_Grey_Tri(i: 2, j: 7)
                                            self.tri_2_7.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            UIView.animate(withDuration: 0.1, animations: {
                                                self.tri_2_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                            }, completion: {
                                                (finished) -> Void in
                                                self.Restore_A_Grey_Tri(i: 2, j: 8)
                                                self.tri_2_8.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                UIView.animate(withDuration: 0.1, animations: {
                                                    self.tri_2_9.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                                }, completion: {
                                                    (finished) -> Void in
                                                    self.Restore_A_Grey_Tri(i: 2, j: 9)
                                                    self.tri_2_9.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                    UIView.animate(withDuration: 0.1, animations: {
                                                        self.tri_2_10.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                                    }, completion: {
                                                        (finished) -> Void in
                                                        self.Restore_A_Grey_Tri(i: 2, j: 10)
                                                        self.tri_2_10.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                    })
                                                })
                                            })
                                        })
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })

        }
        
        //eliminate fourth row
        if(filled[3][0]&&filled[3][1]&&filled[3][2]&&filled[3][3]&&filled[3][4]&&filled[3][5]&&filled[3][6]&&filled[3][7]&&filled[3][8]&&filled[3][9]&&filled[3][10]){

            situation3 = true
            
            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_3_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 3, j: 0)
                self.tri_3_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_3_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 3, j: 1)
                    self.tri_3_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_3_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 3, j: 2)
                        self.tri_3_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_3_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 3, j: 3)
                            self.tri_3_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_3_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 3, j: 4)
                                self.tri_3_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_3_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 3, j: 5)
                                    self.tri_3_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_3_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 3, j: 6)
                                        self.tri_3_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        UIView.animate(withDuration: 0.1, animations: {
                                            self.tri_3_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                        }, completion: {
                                            (finished) -> Void in
                                            self.Restore_A_Grey_Tri(i: 3, j: 7)
                                            self.tri_3_7.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            UIView.animate(withDuration: 0.1, animations: {
                                                self.tri_3_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                            }, completion: {
                                                (finished) -> Void in
                                                self.Restore_A_Grey_Tri(i: 3, j: 8)
                                                self.tri_3_8.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                UIView.animate(withDuration: 0.1, animations: {
                                                    self.tri_3_9.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                                }, completion: {
                                                    (finished) -> Void in
                                                    self.Restore_A_Grey_Tri(i: 3, j: 9)
                                                    self.tri_3_9.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                    UIView.animate(withDuration: 0.1, animations: {
                                                        self.tri_3_10.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                                    }, completion: {
                                                        (finished) -> Void in
                                                        self.Restore_A_Grey_Tri(i: 3, j: 10)
                                                        self.tri_3_10.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                    })
                                                })
                                            })
                                        })
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })

        }
        //eliminate fifth row
        if(filled[4][0]&&filled[4][1]&&filled[4][2]&&filled[4][3]&&filled[4][4]&&filled[4][5]&&filled[4][6]&&filled[4][7]&&filled[4][8]){

            

           situation4 = true
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_4_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 4, j: 0)
                self.tri_4_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_4_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 4, j: 1)
                    self.tri_4_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_4_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 4, j: 2)
                        self.tri_4_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_4_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 4, j: 3)
                            self.tri_4_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_4_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 4, j: 4)
                                self.tri_4_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_4_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 4, j: 5)
                                    self.tri_4_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_4_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 4, j: 6)
                                        self.tri_4_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        UIView.animate(withDuration: 0.1, animations: {
                                            self.tri_4_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                        }, completion: {
                                            (finished) -> Void in
                                            self.Restore_A_Grey_Tri(i: 4, j: 7)
                                            self.tri_4_7.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            UIView.animate(withDuration: 0.1, animations: {
                                                self.tri_4_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                            }, completion: {
                                                (finished) -> Void in
                                                self.Restore_A_Grey_Tri(i: 4, j: 8)
                                                self.tri_4_8.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            })
                                        })
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })

        }
        ////eliminate sixth row
        if(filled[5][0]&&filled[5][1]&&filled[5][2]&&filled[5][3]&&filled[5][4]&&filled[5][5]&&filled[5][6]){

 
            situation5 = true
            
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_5_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 5, j: 0)
                self.tri_5_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_5_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 5, j: 1)
                    self.tri_5_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_5_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 5, j: 2)
                        self.tri_5_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_5_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 5, j: 3)
                            self.tri_5_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_5_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 5, j: 4)
                                self.tri_5_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_5_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 5, j: 5)
                                    self.tri_5_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_5_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        
                                        self.Restore_A_Grey_Tri(i: 5, j: 6)
                                        self.tri_5_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })
            
        }
        
        
        //situation two - 右下斜
        if(filled[2][0]&&filled[3][0]&&filled[3][1]&&filled[4][0]&&filled[4][1]&&filled[5][0]&&filled[5][1]){


            situation6 = true
            UIView.animate(withDuration: 0.1, animations: {
                 self.tri_2_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 0)
                 self.tri_2_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                  self.tri_3_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 3, j: 0)
                    self.tri_3_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                      self.tri_3_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 3, j: 1)
                        self.tri_3_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                        self.tri_4_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 4, j: 0)
                            self.tri_4_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_4_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 4, j: 1)
                                self.tri_4_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                                UIView.animate(withDuration: 0.1, animations: {
                                self.tri_5_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 5, j: 0)
                                    self.tri_5_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_5_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 5, j: 1)
                                       self.tri_5_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    })
                                })
                            })
  
                        })
                    })
                })
            })
            
        }
        
        
        if(filled[1][0]&&filled[2][1]&&filled[2][2]&&filled[3][2]&&filled[3][3]&&filled[4][2]&&filled[4][3]&&filled[5][2]&&filled[5][3]){


 situation7 = true
            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_1_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 1, j: 0)
                self.tri_1_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_2_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 2, j: 1)
                    self.tri_2_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_2_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 2, j: 2)
                        self.tri_2_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_3_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 3, j: 2)
                            self.tri_3_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_3_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 3, j: 3)
                                self.tri_3_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_4_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 4, j: 2)
                                    self.tri_4_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_4_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 4, j: 3)
                                        self.tri_4_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        UIView.animate(withDuration: 0.1, animations: {
                                            self.tri_5_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                        }, completion: {
                                            (finished) -> Void in
                                            self.Restore_A_Grey_Tri(i: 5, j: 2)
                                            self.tri_5_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            UIView.animate(withDuration: 0.1, animations: {
                                                self.tri_5_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                            }, completion: {
                                                (finished) -> Void in
                                                self.Restore_A_Grey_Tri(i: 5, j: 3)
                                                self.tri_5_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            })
                                        })
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })
            

            
            
            
            
            
            
        }
        if(filled[0][0]&&filled[1][1]&&filled[1][2]&&filled[2][3]&&filled[2][4]&&filled[3][4]&&filled[3][5]&&filled[4][4]&&filled[4][5]&&filled[5][4]&&filled[5][5]){
 situation8 = true
            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_0_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 0)
                self.tri_0_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_1_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 1, j: 1)
                    self.tri_1_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_1_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 1, j: 2)
                        self.tri_1_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_2_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 2, j: 3)
                            self.tri_2_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_2_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 2, j: 4)
                                self.tri_2_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_3_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 3, j: 4)
                                    self.tri_3_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_3_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 3, j: 5)
                                        self.tri_3_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        UIView.animate(withDuration: 0.1, animations: {
                                            self.tri_4_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                        }, completion: {
                                            (finished) -> Void in
                                            self.Restore_A_Grey_Tri(i: 4, j: 4)
                                            self.tri_4_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            UIView.animate(withDuration: 0.1, animations: {
                                                self.tri_4_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                            }, completion: {
                                                (finished) -> Void in
                                                self.Restore_A_Grey_Tri(i: 4, j: 5)
                                                self.tri_4_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                UIView.animate(withDuration: 0.1, animations: {
                                                    self.tri_5_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                                }, completion: {
                                                    (finished) -> Void in
                                                    self.Restore_A_Grey_Tri(i: 5, j: 4)
                                                    self.tri_5_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                    UIView.animate(withDuration: 0.1, animations: {
                                                        self.tri_5_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                                    }, completion: {
                                                        (finished) -> Void in
                                                        self.Restore_A_Grey_Tri(i: 5, j: 5)
                                                        self.tri_5_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                    })
                                                })
                                            })
                                        })
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })
            
            
            
            
            
        }
        
        
        
        
        if(filled[0][1]&&filled[0][2]&&filled[1][3]&&filled[1][4]&&filled[2][5]&&filled[2][6]&&filled[3][6]&&filled[3][7]&&filled[4][6]&&filled[4][7]&&filled[5][6]){

             situation9 = true

            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_0_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 1)
                self.tri_0_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_0_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 0, j: 2)
                    self.tri_0_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_1_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 1, j: 3)
                        self.tri_1_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_1_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 1, j: 4)
                            self.tri_1_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_2_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 2, j: 5)
                                self.tri_2_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_2_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 2, j: 6)
                                    self.tri_2_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_3_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 3, j: 6)
                                        self.tri_3_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        UIView.animate(withDuration: 0.1, animations: {
                                            self.tri_3_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                        }, completion: {
                                            (finished) -> Void in
                                            self.Restore_A_Grey_Tri(i: 3, j: 7)
                                            self.tri_3_7.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            UIView.animate(withDuration: 0.1, animations: {
                                                self.tri_4_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                            }, completion: {
                                                (finished) -> Void in
                                                self.Restore_A_Grey_Tri(i: 4, j: 6)
                                                self.tri_4_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                UIView.animate(withDuration: 0.1, animations: {
                                                    self.tri_4_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                                }, completion: {
                                                    (finished) -> Void in
                                                    self.Restore_A_Grey_Tri(i: 4, j: 7)
                                                    self.tri_4_7.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                    UIView.animate(withDuration: 0.1, animations: {
                                                        self.tri_5_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                                    }, completion: {
                                                        (finished) -> Void in
                                                        self.Restore_A_Grey_Tri(i: 5, j: 6)
                                                        self.tri_5_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                    })
                                                })
                                            })
                                        })
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })
            
            
        }
        
        
        if(filled[0][3]&&filled[0][4]&&filled[1][5]&&filled[1][6]&&filled[2][7]&&filled[2][8]&&filled[3][8]&&filled[3][9]&&filled[4][8]){
            



             situation10 = true
            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_0_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 3)
                self.tri_0_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_0_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 0, j: 4)
                    self.tri_0_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_1_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 1, j: 5)
                        self.tri_1_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_1_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 1, j: 6)
                            self.tri_1_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_2_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 2, j: 7)
                                self.tri_2_7.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_2_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 2, j: 8)
                                    self.tri_2_8.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_3_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 3, j: 8)
                                        self.tri_3_8.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        UIView.animate(withDuration: 0.1, animations: {
                                            self.tri_3_9.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                        }, completion: {
                                            (finished) -> Void in
                                            self.Restore_A_Grey_Tri(i: 3, j: 9)
                                            self.tri_3_9.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            UIView.animate(withDuration: 0.1, animations: {
                                                self.tri_4_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                            }, completion: {
                                                (finished) -> Void in
                                                self.Restore_A_Grey_Tri(i: 4, j: 8)
                                                self.tri_4_8.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            })
                                        })
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })
            

        }
        if(filled[0][5]&&filled[0][6]&&filled[1][7]&&filled[1][8]&&filled[2][9]&&filled[2][10]&&filled[3][10]){


 situation11 = true
            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_0_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 5)
                self.tri_0_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_0_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 0, j: 6)
                    self.tri_0_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_1_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 1, j: 7)
                        self.tri_1_7.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_1_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 1, j: 8)
                            self.tri_1_8.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_2_9.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 2, j: 9)
                                self.tri_2_9.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_2_10.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 2, j: 10)
                                    self.tri_2_10.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_3_10.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 3, j: 10)
                                        self.tri_3_10.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })
            

        }
        
        
        //situation three - 左下斜
        if(filled[0][0]&&filled[0][1]&&filled[1][0]&&filled[1][1]&&filled[2][0]&&filled[2][1]&&filled[3][0]){

 situation12 = true

            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_0_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 0)
                self.tri_0_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_0_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 0, j: 1)
                    self.tri_0_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_1_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 1, j: 0)
                        self.tri_1_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_1_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 1, j: 1)
                            self.tri_1_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_2_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 2, j: 0)
                                self.tri_2_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_2_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 2, j: 1)
                                    self.tri_2_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_3_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 3, j: 0)
                                        self.tri_3_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })
            

        }
        
        
        if(filled[0][2]&&filled[0][3]&&filled[1][2]&&filled[1][3]&&filled[2][2]&&filled[2][3]&&filled[3][1]&&filled[3][2]&&filled[4][0]){
 situation13 = true

            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_0_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 2)
                self.tri_0_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_0_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 0, j: 3)
                    self.tri_0_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_1_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 1, j: 2)
                        self.tri_1_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_1_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 1, j: 3)
                            self.tri_1_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_2_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 2, j: 2)
                                self.tri_2_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_2_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 2, j: 3)
                                    self.tri_2_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_3_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 3, j: 1)
                                        self.tri_3_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        UIView.animate(withDuration: 0.1, animations: {
                                            self.tri_3_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                        }, completion: {
                                            (finished) -> Void in
                                                self.Restore_A_Grey_Tri(i: 3, j: 2)
                                                self.tri_3_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                UIView.animate(withDuration: 0.1, animations: {
                                                self.tri_4_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
    
                                                }, completion: {
                                                (finished) -> Void in
                                                    self.Restore_A_Grey_Tri(i: 4, j: 0)
                                                    self.tri_4_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                })
                                            
                                        })
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })
            

        }
        
        if(filled[0][4]&&filled[0][5]&&filled[1][4]&&filled[1][5]&&filled[2][4]&&filled[2][5]&&filled[3][3]&&filled[3][4]&&filled[4][1]&&filled[4][2]&&filled[5][0]){

 situation14 = true
        
            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_0_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 4)
                self.tri_0_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_0_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 0, j: 5)
                    self.tri_0_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_1_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 1, j: 4)
                        self.tri_1_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_1_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 1, j: 5)
                            self.tri_1_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_2_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 2, j: 4)
                                self.tri_2_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_2_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 2, j: 5)
                                    self.tri_2_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_3_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 3, j: 3)
                                        self.tri_3_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        UIView.animate(withDuration: 0.1, animations: {
                                            self.tri_3_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                        }, completion: {
                                            (finished) -> Void in
                                            self.Restore_A_Grey_Tri(i: 3, j: 4)
                                            self.tri_3_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            UIView.animate(withDuration: 0.1, animations: {
                                                self.tri_4_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                            }, completion: {
                                                (finished) -> Void in
                                                self.Restore_A_Grey_Tri(i: 4, j: 1)
                                                self.tri_4_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                UIView.animate(withDuration: 0.1, animations: {
                                                    self.tri_4_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                                }, completion: {
                                                    (finished) -> Void in
                                                    self.Restore_A_Grey_Tri(i: 4, j: 2)
                                                    self.tri_4_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                    UIView.animate(withDuration: 0.1, animations: {
                                                        self.tri_5_0.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                                    }, completion: {
                                                        (finished) -> Void in
                                                        self.Restore_A_Grey_Tri(i: 5, j: 0)
                                                        self.tri_5_0.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                    })
                                                })
                                            })
                                        })
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })

        }
        if(filled[0][6]&&filled[1][6]&&filled[1][7]&&filled[2][6]&&filled[2][7]&&filled[3][5]&&filled[3][6]&&filled[4][3]&&filled[4][4]&&filled[5][1]&&filled[5][2]){

 situation15 = true
            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_0_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 0, j: 6)
                self.tri_0_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_1_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 1, j: 6)
                    self.tri_1_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_1_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 1, j: 7)
                        self.tri_1_7.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_2_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 2, j: 6)
                            self.tri_2_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_2_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 2, j: 7)
                                self.tri_2_7.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_3_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 3, j: 5)
                                    self.tri_3_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_3_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 3, j: 6)
                                        self.tri_3_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        UIView.animate(withDuration: 0.1, animations: {
                                            self.tri_4_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                        }, completion: {
                                            (finished) -> Void in
                                            self.Restore_A_Grey_Tri(i: 4, j: 3)
                                            self.tri_4_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            UIView.animate(withDuration: 0.1, animations: {
                                                self.tri_4_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                            }, completion: {
                                                (finished) -> Void in
                                                self.Restore_A_Grey_Tri(i: 4, j: 4)
                                                self.tri_4_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                UIView.animate(withDuration: 0.1, animations: {
                                                    self.tri_5_1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                                }, completion: {
                                                    (finished) -> Void in
                                                    self.Restore_A_Grey_Tri(i: 5, j: 1)
                                                    self.tri_5_1.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                    UIView.animate(withDuration: 0.1, animations: {
                                                        self.tri_5_2.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                                    }, completion: {
                                                        (finished) -> Void in
                                                        self.Restore_A_Grey_Tri(i: 5, j: 2)
                                                        self.tri_5_2.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                    })
                                                })
                                            })
                                        })
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })


        }
        
        
        
        if(filled[1][8]&&filled[2][8]&&filled[2][9]&&filled[3][7]&&filled[3][8]&&filled[4][5]&&filled[4][6]&&filled[5][3]&&filled[5][4]){

 situation16 = true

            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_1_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 1, j: 8)
                self.tri_1_8.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_2_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 2, j: 8)
                    self.tri_2_8.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_2_9.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 2, j: 9)
                        self.tri_2_9.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_3_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 3, j: 7)
                            self.tri_3_7.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_3_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 3, j: 8)
                                self.tri_3_8.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_4_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 4, j: 5)
                                    self.tri_4_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_4_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 4, j: 6)
                                        self.tri_4_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        UIView.animate(withDuration: 0.1, animations: {
                                            self.tri_5_3.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                        }, completion: {
                                            (finished) -> Void in
                                            self.Restore_A_Grey_Tri(i: 5, j: 3)
                                            self.tri_5_3.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            UIView.animate(withDuration: 0.1, animations: {
                                                self.tri_5_4.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                                
                                            }, completion: {
                                                (finished) -> Void in
                                                self.Restore_A_Grey_Tri(i: 5, j: 4)
                                                self.tri_5_4.transform = CGAffineTransform(scaleX: 1, y: 1)
                                            })
                                            
                                        })
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })
        }
        
        
        if(filled[2][10]&&filled[3][9]&&filled[3][10]&&filled[4][7]&&filled[4][8]&&filled[5][5]&&filled[5][6]){
 situation17 = true


            //animation
            UIView.animate(withDuration: 0.1, animations: {
                self.tri_2_10.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
            }, completion: {
                (finished) -> Void in
                self.Restore_A_Grey_Tri(i: 2, j: 10)
                self.tri_2_10.transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    self.tri_3_9.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }, completion: {
                    (finished) -> Void in
                    self.Restore_A_Grey_Tri(i: 3, j: 9)
                    self.tri_3_9.transform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tri_3_10.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                    }, completion: {
                        (finished) -> Void in
                        self.Restore_A_Grey_Tri(i: 3, j: 10)
                        self.tri_3_10.transform = CGAffineTransform(scaleX: 1, y: 1)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.tri_4_7.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                        }, completion: {
                            (finished) -> Void in
                            self.Restore_A_Grey_Tri(i: 4, j: 7)
                            self.tri_4_7.transform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(withDuration: 0.1, animations: {
                                self.tri_4_8.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                            }, completion: {
                                (finished) -> Void in
                                self.Restore_A_Grey_Tri(i: 4, j: 8)
                                self.tri_4_8.transform = CGAffineTransform(scaleX: 1, y: 1)
                                
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.tri_5_5.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                }, completion: {
                                    (finished) -> Void in
                                    self.Restore_A_Grey_Tri(i: 5, j: 5)
                                    self.tri_5_5.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.tri_5_6.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: 360)
                                    }, completion: {
                                        (finished) -> Void in
                                        self.Restore_A_Grey_Tri(i: 5, j: 6)
                                        self.tri_5_6.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        
                                    })
                                })
                            })
                        })
                    })
                    
                    
                })
            })
        }
        Check_And_Erase_Fix_Filled()

    }
    
    
    func Check_And_Erase_Fix_Filled() -> Void {
        if(situation0){
            
            filled[0][0] = false
            filled[0][1] = false
            filled[0][2] = false
            filled[0][3] = false
            filled[0][4] = false
            filled[0][5] = false
            filled[0][6] = false
        }
        
        //eliminate second row
        if(situation1){
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
        if( situation2){
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
        if( situation3){
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
        if( situation4){
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
        if( situation5){
            filled[5][0] = false
            filled[5][1] = false
            filled[5][2] = false
            filled[5][3] = false
            filled[5][4] = false
            filled[5][5] = false
            filled[5][6] = false
            

            
        }
        
        
        //situation two - 右下斜
        if(situation6){
            filled[2][0] = false
            filled[3][0] = false
            filled[3][1] = false
            filled[4][0] = false
            filled[4][1] = false
            filled[5][0] = false
            filled[5][1] = false
            

            
        }
        
        
        if(situation7){
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
        if(situation8){
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
        
        
        
        
        if(situation9){
            
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
        
        
        if(situation10){
            
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
        if(situation11){
            filled[0][5] = false
            filled[0][6] = false
            filled[1][7] = false
            filled[1][8] = false
            filled[2][9] = false
            filled[2][10] = false
            filled[3][10] = false

            
            
        }
        
        
        //situation three - 左下斜
        if(situation12){
            filled[0][0] = false
            filled[0][1] = false
            filled[1][0] = false
            filled[1][1] = false
            filled[2][0] = false
            filled[2][1] = false
            filled[3][0] = false

            
            
        }
        
        
        if(situation13){
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
        
        if(situation14){
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
        if(situation15){
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
        
        
        
        if(situation16){
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
        
        
        if(situation17){
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
    var bool_any_pink_right_tri = true
    var bool_any_purple_upwards_tri = true
    var bool_any_purple_downwards_tri = true
    var bool_pos0_shape_available = true
    var bool_pos1_shape_available = true
    var bool_pos2_shape_available = true
    var green_result = false
    var orange_result = false
    var light_brown_result = false
    var brown_left_result = false
    var brown_downwards_result = false
    var dark_green_result  = false
    var pink_right_result = false
    var purple_upwards_result = false
    var purple_downwards_result = false
    var shape_placable_array : Array<Bool> = [false, false, false, false, false,false,false,false,false]
    
    //the funciton to find available space and autogenerate
    func Check_for_Placable_Shape_And_Generate () -> Void {
         green_result = false
         orange_result = false
         light_brown_result = false
         brown_left_result = false
         brown_downwards_result = false
         dark_green_result  = false
         pink_right_result = false
         purple_upwards_result = false
         purple_downwards_result = false
        var k = 0
        for result in shape_placable_array{
            shape_placable_array[k] = false
            k += 1
        }
        var i = 0
        for tri_row in filled{
            var j = 0
            for _ in tri_row{
                bool_any_green_tri = Find_Any_Available_Green_Tri(row: i, column: j)
                if(bool_any_green_tri){
                    green_result = true
                    shape_placable_array[0] = true
                }
                //print("whether green tri available: \(bool_any_green_tri)")
                bool_any_orange_tri = Find_Any_Available_Orange_Tri(row: i, column: j)
                if(bool_any_orange_tri){
                    orange_result = true
                    shape_placable_array[1] = true

                }
               // print("whether orange tri available: \(bool_any_orange_tri)")
                bool_any_light_brown_tri = Find_Any_Available_Light_Brown_Tri(row: i, column: j)
                if(bool_any_light_brown_tri){
                    light_brown_result = true
                    shape_placable_array[2] = true

                }
               // print("whether light_brown tri available: \(bool_any_light_brown_tri)")
                
                //print("whether brown left tri available: \(bool_any_brown_left_tri)")
                bool_any_brown_downwards_tri = Find_Any_Available_Brown_Downwards_Tri(row: i, column: j)
                if(bool_any_brown_downwards_tri){
                    brown_downwards_result = true
                    shape_placable_array[3] = true
                    
                }
                bool_any_brown_left_tri = Find_Any_Available_Brown_Left_Tri(row: i, column: j)
                if(bool_any_brown_left_tri){
                    brown_left_result = true
                    shape_placable_array[4] = true

                }

                //print("whether brown downwards tri available: \(bool_any_brown_downwards_tri)")
                bool_any_dark_green_tri = Find_Any_Dark_Green_Tri(row: i, column: j)
                if(bool_any_dark_green_tri){
                dark_green_result = true
                    shape_placable_array[5] = true

                }
               // print("whether dark green tri available: \(bool_any_dark_green_tri)")
                bool_any_pink_right_tri = Find_Any_Pink_Right_Tri(row: i, column: j)
                if(bool_any_pink_right_tri){
                    pink_right_result = true
                    shape_placable_array[6] = true

                }
                bool_any_purple_upwards_tri = Find_Any_Purple_Upwards_Tri(row: i, column: j)
                if(bool_any_purple_upwards_tri){
                    purple_upwards_result = true
                    shape_placable_array[7] = true

                }
                bool_any_purple_downwards_tri = Find_Any_Purple_Downwards_Tri(row: i, column: j)
                if(bool_any_brown_downwards_tri){
                    purple_downwards_result = true
                    shape_placable_array[8] = true

                }
                j += 1
                
    }
                i += 1
        }

    }
    
    
     //the function to check for gameover (if gameover return true, else return false)
        func Check_for_Gameover () -> Bool {
            var i = 0
            for tri_row in filled{
            var j = 0
            for _ in tri_row{
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
                bool_any_pink_right_tri = Find_Any_Pink_Right_Tri(row: i, column: j)
                bool_any_purple_upwards_tri = Find_Any_Purple_Upwards_Tri(row: i, column: j)
                bool_any_purple_downwards_tri = Find_Any_Purple_Downwards_Tri(row: i, column: j)
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
                }else if(shape_type_index[0] == 6){
                    bool_pos0_shape_available = bool_any_pink_right_tri
                }else if(shape_type_index[0] == 7){
                    bool_pos0_shape_available = bool_any_purple_upwards_tri
                }else if(shape_type_index[0] == 8){
                    bool_pos0_shape_available = bool_any_purple_downwards_tri
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
                }else if(shape_type_index[1] == 6){
                    bool_pos1_shape_available = bool_any_pink_right_tri
                }else if(shape_type_index[1] == 7){
                    bool_pos1_shape_available = bool_any_purple_upwards_tri
                }else if(shape_type_index[1] == 8){
                    bool_pos1_shape_available = bool_any_purple_downwards_tri
                }
                }else{
                    bool_pos1_shape_available = false
                }
                
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
                }else if(shape_type_index[2] == 6){
                    bool_pos2_shape_available = bool_any_pink_right_tri
                }else if(shape_type_index[2] == 7){
                    bool_pos2_shape_available = bool_any_purple_upwards_tri
                }else if(shape_type_index[2] == 8){
                    bool_pos2_shape_available = bool_any_purple_downwards_tri
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
                if(column != filled[row].count-1 && !filled[row][column] && !filled[row][column+1] && !filled[row][column+2]){
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
   /////////////////////////////////////////////////////////////////////////////////////////////////////////
    func Find_Any_Pink_Right_Tri (row: Int, column:Int) -> Bool{
        if(row == 0 || row == 1 || row == 3){
            //upwards tri
            if(column%2 == 0){
                if(column != filled[row].count-1 && !filled[row][column] && !filled[row][column+1] ){
                    return true
                }
            }//downwards tri
            else{
                if(!filled[row][column] && !filled[row][column-1]){
                    return true
                }
            }
        }else if( row == 4 || row == 5 || row == 6 ){
         //downwards tri
            if(column%2 == 0){
                if(column != 0 && !filled[row][column] && !filled[row][column-1]){
              return true
            }
            }
         //upwards tri
            else{
                if(!filled[row][column] && !filled[row][column+1]){
                    return true
                }
            }
        }
        
        return false
        
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    func Find_Any_Purple_Upwards_Tri (row: Int, column:Int) -> Bool{
        if(row == 0 || row == 1 || row == 2){
            //upwards tri
            if(column%2 == 0 && !filled[row][column]){
                return true
            }
        }else if(row == 3 || row == 4 || row == 5){
            //upwards tri
            if(column%2 != 0 && !filled[row][column]){
                return true
            }
        }
        
        
        return false
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    func Find_Any_Purple_Downwards_Tri (row: Int, column:Int) -> Bool{
        if(row == 0 || row == 1 || row == 2){
            //downwards
            if(column%2 != 0 && !filled[row][column]){
                return true
            }
            
        }else if(row == 3 || row == 4 || row == 5 ){
            if(column%2 == 0 && !filled[row][column]){
                return true
            }
        }
        
     return false
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func Jump_to_Game_Over () -> Void {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GameOverViewController") as! GameOverViewController
        nextViewController.final_score = MarkBoard.text!
        nextViewController.ThemeType = self.ThemeType
        if (Int(MarkBoard.text!)! == HighestScore){
            nextViewController.is_high_score = false
        } else {
            nextViewController.is_high_score = true
        }
        self.present(nextViewController, animated: true, completion: nil)
        self.audioPlayer.stop()
        self.timer.invalidate()
        
        
        
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    var score = 0
    func modify_counter(before: Array<Array<Bool>>, after: Array<Array<Bool>>) -> Void{
        var current_str = MarkBoard.text!
        var current_int = Int(current_str)!
        var i = 0
        for eachRow in before{
            var j = 0
            for _ in eachRow{
                if before[i][j] != after[i][j]{
                    
                    
                    current_int += 1
                }
                j+=1
            }
            i+=1
        }
        score = current_int
        current_str = String(current_int)
        MarkBoard.text = current_str
        //add animation

            UIView.animate(withDuration: 0.2, animations: {
            self.MarkBoard.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            }, completion: {
                (finished) -> Void in
                UIView.animate(withDuration: 0.1, animations: {
                    self.MarkBoard.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            })
        
        if(current_int > HighestScore){
            HighestScore = current_int
            var HighScoreDefault = UserDefaults.standard
            HighScoreDefault.set(HighestScore, forKey: "tritri_HighestScore")
            HighScoreDefault.synchronize()
            
        }
        
    }
    

func randomNumber(probabilities: [Double]) -> Int {
            
            // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
            let sum = probabilities.reduce(0, +)
            // Random number in the range 0.0 <= rnd < sum :
            let rnd = sum * Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
            // Find the first interval of accumulated probabilities into which `rnd` falls:
            var accum = 0.0
            for (i, p) in probabilities.enumerated() {
                accum += p
                if rnd < accum {
                    return i
                }
            }
            // This point might be reached due to floating point inaccuracies:
            return (probabilities.count - 1)
}
    
    func randomShape_for_Difficulty_Level () -> Int{
        if(score <= 50){
        // 0: 1/10 1: 1/10 2:1/10 3:1/10 4:1/8 5:1/20 6:1/8 7:3/20 8:3/20
          return randomNumber(probabilities: [0.1, 0.1 , 0.11 , 0.11, 0.135, 0.01, 0.135, 0.16, 0.16])
        }
        else if(score > 50 && score <= 200){
          return randomNumber(probabilities: [0.1, 0.1 , 0.1 , 0.1, 0.125, 0.1, 0.125, 0.125, 0.125])
        }else if(score > 200 && score <= 300){
           return randomNumber(probabilities: [0.1, 0.1 , 0.1 , 0.1, 0.1, 0.15, 0.1, 0.125, 0.125])
        }else if(score > 300 && score <= 400){
            return randomNumber(probabilities: [0.1, 0.1 , 0.1 , 0.1, 0.1, 0.2, 0.1, 0.1, 0.1])
        }else{
            return randomNumber(probabilities: [0.1, 0.1 , 0.1 , 0.1, 0.075, 0.3, 0.075, 0.075, 0.075])
        }
        
    }
    
    func coordiante_transform (point_in_ip7: CGPoint) -> CGPoint {
    //ip7: width 375 height:667
    let x_proportion_const = Double(point_in_ip7.x)/Double(375)
    let y_proportion_const = Double(point_in_ip7.y)/Double(667)
    let new_CGPoint = CGPoint(x: CGFloat(Double(screen_width) * x_proportion_const), y: CGFloat(Double(screen_height)*y_proportion_const))
        return new_CGPoint
        


}
    
        

    
  
    
   }



