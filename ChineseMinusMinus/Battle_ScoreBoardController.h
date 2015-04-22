//
//  Battle_ScoreBoardController.h
//  ChineseMinusMinus
//
//  Created by Azure Hu on 4/18/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"PraticeMainController.h"

@interface Battle_ScoreBoardController : UIViewController{
    double total_char;
    NSString *player1_time;
    NSString *player2_time;
    NSMutableDictionary * player1_wrongList;
    NSMutableDictionary * player2_wrongList;
    NSMutableDictionary * dict;
    NSMutableDictionary * reverse_dict;
}



@property (strong, nonatomic) IBOutlet UILabel *winnerLabel;
@property (strong, nonatomic) IBOutlet UILabel *player1_score;
@property (strong, nonatomic) IBOutlet UILabel *player2_score;
@property (strong, nonatomic) IBOutlet UILabel *player1_timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *player2_timeLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *player1_mistake;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *player2_mistake;


@end
