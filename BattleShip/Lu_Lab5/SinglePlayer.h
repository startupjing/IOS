//
//  SinglePlayer.h
//  Lu_Lab5
//
//  Created by Labuser on 3/21/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface SinglePlayer: UIViewController{
    //AI's brain
    BOOL AI_last_hit;
    int first_hit_index;
    BOOL attack_begin;
    
    //player scores
    int p1_score;
    int p2_score;
    
    
    //audio component
    AVAudioPlayer *ship_sunk_sound;
    AVAudioPlayer *final_victory_sound;
}

//game option: easy or hard
@property (strong, nonatomic)NSMutableString *game_option;

//AI brain
@property (strong, nonatomic)NSMutableString *attack_direction;
@property (strong, nonatomic)NSMutableDictionary *smart_moves;


//ships for each player
@property (strong, nonatomic)NSMutableArray *ships_p1;
@property (strong, nonatomic)NSMutableArray *ships_p2;

//used by AI to track human ship status
@property (strong, nonatomic)NSMutableArray *human_ships;

//ship locations stored in NSValues
@property (strong, nonatomic)NSMutableDictionary *ship_to_loc_p1;
@property (strong, nonatomic)NSMutableDictionary *ship_to_loc_p2;

//ship locations stored in button index
@property (strong, nonatomic)NSMutableDictionary *ship_index_p1;
@property (strong, nonatomic)NSMutableDictionary *ship_index_p2;

//ship status
@property (strong, nonatomic)NSMutableArray *grid_button_p1;
@property (strong, nonatomic)NSMutableArray *grid_button_p2;

//game state
@property (nonatomic)int turn;
@property (nonatomic)int p1_left;
@property (nonatomic)int p2_left;

//missile image
@property (strong, nonatomic) IBOutlet UIImageView *AI_attack_human;
@property (strong, nonatomic) IBOutlet UIImageView *human_attack_AI;




//labels to display game state
@property (strong, nonatomic) IBOutlet UILabel *label_p1;
@property (strong, nonatomic) IBOutlet UILabel *label_p2;
@property (strong, nonatomic) IBOutlet UILabel *current_turn;
@property (strong, nonatomic) IBOutlet UILabel *game_info;
@property (strong, nonatomic) IBOutlet UIButton *placeDoneButton;


//grids
@property (strong, nonatomic) IBOutlet UIImageView *grid_p1;
@property (strong, nonatomic) IBOutlet UIImageView *grid_p2;

//five ships for player 1
@property (strong, nonatomic) IBOutlet UIButton *largeship_p1;
@property (strong, nonatomic) IBOutlet UIButton *mediumship_p1;
@property (strong, nonatomic) IBOutlet UIButton *smallship_p1;
@property (strong, nonatomic) IBOutlet UIButton *smallship2_p1;
@property (strong, nonatomic) IBOutlet UIButton *tinyship_p1;

//five ships for player 2
@property (strong, nonatomic) IBOutlet UIButton *largeship_p2;
@property (strong, nonatomic) IBOutlet UIButton *mediumship_p2;
@property (strong, nonatomic) IBOutlet UIButton *smallship_p2;
@property (strong, nonatomic) IBOutlet UIButton *smallship2_p2;
@property (strong, nonatomic) IBOutlet UIButton *tinyship_p2;




@end
