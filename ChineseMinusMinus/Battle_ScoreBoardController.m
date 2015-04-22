//
//  Battle_ScoreBoardController.m
//  ChineseMinusMinus
//
//  Created by Azure Hu on 4/18/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import "Battle_ScoreBoardController.h"

@interface Battle_ScoreBoardController ()

@end

@implementation Battle_ScoreBoardController
@synthesize winnerLabel;
@synthesize player1_mistake;
@synthesize player2_mistake;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    total_char = 8.0;
    
    
    [self updateLabel];
    
    /*
    NSLog(@"player1 time : %@", player1_time);
    NSLog(@"player2 time : %@", player2_time);
    NSLog(@"player1 dic : %@", player1_wrongList);
    NSLog(@"player2 dic : %@", player2_wrongList);

    */
 
    
    
    // Do any additional setup after loading the view.
}


- (void)updateLabel {
    
    dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjects:@[@"日",@"月",@"木",@"三",@"四",@"五",@"马",@"鸟",@"鱼"] forKeys:@[@"ri",@"yue",@"mu",@"san",@"si",@"wu",@"ma",@"niao",@"yu"]];
   
    
    
    player1_time =[[NSUserDefaults standardUserDefaults] objectForKey: @"player1_totalTime"];
    player2_time =[[NSUserDefaults standardUserDefaults] objectForKey: @"player2_totalTime"];
    player1_wrongList = [[NSUserDefaults standardUserDefaults] objectForKey: @"player1WrongList"];
    player2_wrongList = [[NSUserDefaults standardUserDefaults] objectForKey: @"player2WrongList"];
    
    NSArray *player1_wrongQuestions = [[NSArray alloc] init];
    player1_wrongQuestions = [player1_wrongList allKeys];
    NSArray *player2_wrongQuestions = [[NSArray alloc] init];
    player2_wrongQuestions = [player2_wrongList allKeys];
    
    double player1_score = (((total_char/2) - [player1_wrongQuestions count])/(total_char/2))* 100;
    double player2_score = (( (total_char/2) - [player2_wrongQuestions count])/(total_char/2)) * 100;
    
    NSString * string_player1Scroe = [[NSString alloc]initWithFormat:@"Player1 Score is: %.2f", player1_score ];
    
    NSString * string_player2Scroe = [[NSString alloc]initWithFormat:@"Player2 Score is: %.2f", player2_score ];
    
    
    [_player1_score setText: string_player1Scroe];
    [_player2_score setText: string_player2Scroe];
    
    
    
    NSString * string_player1Time = [[NSString alloc]initWithFormat:@"Play time: %@",player1_time];
    
    NSString * string_player2Time = [[NSString alloc]initWithFormat:@"Play time: %@",player2_time];
    [_player1_timeLabel setText:string_player1Time];
    [_player2_timeLabel setText:string_player2Time ];
    NSArray *player1_wrongAnswers = [[NSArray alloc] init];
    player1_wrongAnswers = [player1_wrongList allValues];
    NSArray *player2_wrongAnswers = [[NSArray alloc] init];
    player2_wrongAnswers = [player2_wrongList allValues];

    
    if([player1_wrongQuestions count] == [player2_wrongQuestions count]){
        if(player1_time>=player2_time){
            [winnerLabel setText:@"The winner is Player2"];
            
            
        }else{
             [winnerLabel setText:@"The winner is Player1"];
        }
    }else if([player1_wrongQuestions count] > [player2_wrongQuestions count]){
        [winnerLabel setText:@"The winner is Player2"];
    }else{
        [winnerLabel setText:@"The winner is Player1"];
    }
    
    
    
    
    NSUInteger player1_length = [player1_wrongQuestions count];
    NSUInteger player2_length = [player2_wrongQuestions count];
    
    
    
    
    //[player1_mistake[0] setTitle:@"mistake" forState:UIControlStateNormal];
    //[player1_mistake[1] setTitle:@"mistake" forState:UIControlStateNormal];
    //[player1_mistake[2] setTitle:@"mistake" forState:UIControlStateNormal];
    
    //NSString *test = @"草";
    //NSLog(@"test: %@", dict);
    
    for(int i=0; i<player1_length; i++){
        NSString *mistake_key = [player1_wrongQuestions objectAtIndex:i];
        
        NSString *button_value = [dict objectForKey:mistake_key];
        unichar c = [button_value characterAtIndex:0];
        [player1_mistake[i] setTitle:[NSString stringWithFormat:@"%C", c] forState:UIControlStateNormal];
    }

    
    for(int i=0; i<player2_length; i++){
        
       // NSLog(@"wrongquestion_array: %@", player2_wrongQuestions);
        NSString *mistake_key = [player2_wrongQuestions objectAtIndex:i];
        //NSLog(@"mistake_key : %@", mistake_key);
        NSString *button_value = [dict valueForKey:mistake_key];
       // NSLog(@"%@", button_value);
        [player2_mistake[i] setTitle:button_value forState:UIControlStateNormal];
    }
}


- (IBAction)player1_toPractice:(id)sender {
    
    
    reverse_dict = [[NSMutableDictionary alloc] init];
    reverse_dict = [NSMutableDictionary dictionaryWithObjects:@[@"ri",@"yue",@"mu",@"san",@"si",@"wu",@"ma",@"niao",@"yu"] forKeys:@[@"日",@"月",@"木",@"三",@"四",@"五",@"马",@"鸟",@"鱼"] ];
    
    NSString *curChineseTitle = [sender titleForState:UIControlStateNormal];
    
    NSLog(@"send title is is is is : %@",curChineseTitle);
    
    NSString * curTitle = [reverse_dict objectForKey:curChineseTitle];
    
    
    [[NSUserDefaults standardUserDefaults] setObject: curTitle forKey:@"battle_curChar"];
    
    NSLog(@"sender tittle %@", curTitle);
 
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject: @"hidden" forKey:@"from_battleScore"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    PraticeMainController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"PracticeController"];
    ctrl.Done.hidden = YES;
    
    [self.navigationController pushViewController:ctrl animated:YES];

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
