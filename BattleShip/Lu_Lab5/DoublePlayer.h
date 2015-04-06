//
//  DoublePlayer.h
//  Lu_Lab5
//
//  Created by Labuser on 3/25/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



@interface DoublePlayer : UIViewController{
    int p1_score;
    int p2_score;
    BOOL isClicked;
    //audio players
    AVAudioPlayer *ship_sunk_sound;
    AVAudioPlayer *final_victory_sound;
}


//ships for each player
@property (strong, nonatomic)NSMutableArray *ships_p1;
@property (strong, nonatomic)NSMutableArray *ships_p2;

//ship locations stored in NSValues
@property (strong, nonatomic)NSMutableDictionary *ship_to_loc_p1;
@property (strong, nonatomic)NSMutableDictionary *ship_to_loc_p2;

//ship locations stored in button index
@property (strong, nonatomic)NSMutableDictionary *ship_index_p1;
@property (strong, nonatomic)NSMutableDictionary *ship_index_p2;


//ship status
@property (strong, nonatomic)NSMutableArray *grid_button_p1;
@property (strong, nonatomic)NSMutableArray *grid_button_p2;

//missile image
@property (strong, nonatomic) IBOutlet UIImageView *p2_attack_p1;
@property (strong, nonatomic) IBOutlet UIImageView *p1_attack_p2;

@property (strong, nonatomic) IBOutlet UIButton *switch_turn_button;



//game state
@property (nonatomic)int turn;
@property (nonatomic)int p1_left;
@property (nonatomic)int p2_left;

//labels
@property (strong, nonatomic) IBOutlet UILabel *label_p1;
@property (strong, nonatomic) IBOutlet UILabel *label_p2;
@property (strong, nonatomic) IBOutlet UILabel *current_turn;
@property (strong, nonatomic) IBOutlet UILabel *game_info;

//grid
@property (strong, nonatomic) IBOutlet UIImageView *grid_p1;
@property (strong, nonatomic) IBOutlet UIImageView *grid_p2;
@property (strong, nonatomic) IBOutlet UIButton *placeDoneButton;


//five ships
@property (strong, nonatomic) IBOutlet UIButton *largeship_p1;
@property (strong, nonatomic) IBOutlet UIButton *mediumship_p1;
@property (strong, nonatomic) IBOutlet UIButton *smallship_p1;
@property (strong, nonatomic) IBOutlet UIButton *smallship2_p1;
@property (strong, nonatomic) IBOutlet UIButton *tinyship_p1;


@property (strong, nonatomic) IBOutlet UIButton *largeship_p2;
@property (strong, nonatomic) IBOutlet UIButton *mediumship_p2;
@property (strong, nonatomic) IBOutlet UIButton *smallship_p2;
@property (strong, nonatomic) IBOutlet UIButton *smallship2_p2;
@property (strong, nonatomic) IBOutlet UIButton *tinyship_p2;



@end
