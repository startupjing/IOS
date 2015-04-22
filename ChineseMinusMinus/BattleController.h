//
//  BattleController.h
//  ChineseMinusMinus
//
//  Created by Azure Hu on 4/17/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmoothedBIView.h"
#import "battle_smoothedBIView.h"
#import "Battle_ScoreBoardController.h"


@interface BattleController : UIViewController{
    // Score, correct answers, wrong list
    
    battle_smoothedBIView *mizige;
    NSMutableDictionary * correct_answer;
    int score_player1;
    int score_player2;
    int end_game_count;
    NSTimeInterval player1_time;
    NSTimeInterval player2_time;
    
    NSMutableDictionary * player1_wrongList;
    NSMutableDictionary * player2_wrongList;

    NSDate *player1_start;
    NSDate *player2_start;
    NSDate *player1_finish;
    NSDate *player2_finish;
}

//Sender button info


//List counter
@property (strong,nonatomic) NSArray *character_list;
@property int currChar1_index;
@property  int currChar2_index;
@property int currTurn;

@property (weak, nonatomic) IBOutlet UILabel *battle_info;
@property (strong, nonatomic) NSMutableArray *abcd;
// UPdate Question
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UIButton *choiceA;
@property (weak, nonatomic) IBOutlet UIButton *choiceB;
@property (weak, nonatomic) IBOutlet UIButton *choiceC;
@property (weak, nonatomic) IBOutlet UIButton *choiceD;

@property (strong, nonatomic) IBOutlet UIButton *chooseButton;




@end
