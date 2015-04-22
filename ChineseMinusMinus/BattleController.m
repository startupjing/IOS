//
//  BattleController.m
//  ChineseMinusMinus
//
//  Created by Azure Hu on 4/17/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import "BattleController.h"


@interface BattleController ()

@end

@implementation BattleController
@synthesize character_list, currChar1_index, currChar2_index, currTurn, battle_info;
@synthesize question,choiceA,choiceB,choiceC,choiceD,abcd, chooseButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self preparation];
    player1_wrongList =  [[NSMutableDictionary alloc]init];
    player2_wrongList  = [[NSMutableDictionary alloc]init];
  

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)questionMe:(id)sender {
    
    choiceA.enabled = true;
    choiceB.enabled = true;
    choiceC.enabled = true;
    choiceD.enabled = true;
    choiceA.alpha = 1.0;
    choiceB.alpha = 1;
    choiceC.alpha = 1;
    choiceD.alpha = 1;
    
    
    
}


- (void)readyAlert
{
    UIAlertView *chooseView = [[UIAlertView alloc] initWithTitle:nil message:@"Ready to play?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ready!", nil];
    [chooseView show];
}


- (void)transitionAlert
{
    UIAlertView *chooseView = [[UIAlertView alloc] initWithTitle:nil message:@"Please pass the game to the other player" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [chooseView show];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *selectedButton = [alertView buttonTitleAtIndex:buttonIndex];
    //if the user chooses to play with computer
    if([selectedButton isEqual:@"Random"]){
        currTurn = arc4random()%2;
    }else if([selectedButton isEqual:@"OK"]){
        //end the game when the count becomes 18
        
        
        if(currTurn == 0){
            player1_finish = [NSDate date];
            NSTimeInterval duration = [player1_finish timeIntervalSinceDate: player1_start];
            player1_time += duration;
            NSLog(@"player1 time : %.2f", player1_time);
            player2_start = [NSDate date];
        }else{
            
            player2_finish = [NSDate date];
            NSTimeInterval duration = [player2_finish timeIntervalSinceDate: player2_start];
            player2_time += duration;
            NSLog(@"player2 time : %.2f", player2_time);
            player1_start = [NSDate date];
        }
        
        
        [self answeringQuestion:chooseButton];
        
        
        
        
        [self endGame];
        
       

      
        
        
        
        
        
    }else if([selectedButton isEqual:@"Ready!"]){
        if(currTurn == 0){
            player1_start = [NSDate date];
            
        }else{
            player2_start = [NSDate date];
        }
    }
    
    

}


- (void) endGame {
    end_game_count ++ ;
    NSLog(@"%d", end_game_count);
    if(end_game_count == 8){
        
        NSString * player1Time = [[NSString alloc] initWithFormat:@"%.2f", player1_time];
        NSString * player2Time = [[NSString alloc] initWithFormat:@"%.2f", player2_time];
        
        [[NSUserDefaults standardUserDefaults] setObject: player1Time forKey:@"player1_totalTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject: player2Time forKey:@"player2_totalTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"player1_wronglist: %@", player1_wrongList);
        NSLog(@"player2_wronglist: %@", player2_wrongList);
        
        [[NSUserDefaults standardUserDefaults] setObject: player1_wrongList forKey:@"player1WrongList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject: player2_wrongList forKey:@"player2WrongList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        Battle_ScoreBoardController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"Battle_ScoreBoard"];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
    
}

- (IBAction)answerQuestion:(UIButton *)sender {
    
    [self transitionAlert];
    chooseButton = sender;
    
    
}


- (void)answeringQuestion:(UIButton *)sender{
     NSString * curCharacter = [[NSUserDefaults standardUserDefaults] objectForKey:@"battle_curChar"];
    
    NSString * title = [sender titleForState:UIControlStateNormal];
    
    NSString * answer = [correct_answer objectForKey: curCharacter];
    NSString * firstChar = [title substringToIndex:1];
    
    if( [firstChar isEqualToString:answer]){
        if(currTurn ==0){
            score_player1++;
        }
        else{
            score_player2++;
        }
        
        
    }
    else{
        if(currTurn ==0){
            
           
            [player1_wrongList setValue:title forKey:curCharacter];
            //[player1_wrongList setValue: title forKey: curCharacter];
        }
        else{
            
           [player2_wrongList setValue: title forKey: curCharacter];
        }
    
    }
    
    
    
    //Debug sesction
//    
//    NSLog(@"correct answer: %@", answer);
//    NSLog(@"Todd's answer : %@", title );
//    NSLog(@"player1 current Score : %d", score_player1);
//    NSLog(@"player2 current Score : %d", score_player2);
//    NSLog(@"player1 wrong_list : %@", player1_wrongList);
//    NSLog(@"player2 wrong_list : %@", player2_wrongList);
    
    
    //counter
    if(currTurn ==0 ){
        currChar1_index ++;
        currChar1_index %= 9;
    }
    else{
        currChar2_index ++;
        currChar2_index %= 9;
    }
    
    
    //switch turn
    currTurn = currTurn == 0 ? 1 : 0;
    
    //set_abcd
    
    [self set_abcd];
    
    
    [self updateABCD];
    // now switch user
    // Probabally need a alert view to freeze here
    
    
    [self disableButtons];
    
    
    
}


- (void)disableButtons{
    choiceA.enabled = false;
    choiceB.enabled = false;
    choiceC.enabled = false;
    choiceD.enabled = false;
    choiceA.alpha = 0.5;
      choiceB.alpha = 0.5;
      choiceC.alpha = 0.5;
      choiceD.alpha = 0.5;
    
    
    
}

- (void)updateABCD{
    
    [battle_info setText:currTurn==0? @"Player1" : @"Player2"];
    [choiceA setTitle:abcd[0] forState:UIControlStateNormal];
    [choiceB setTitle:abcd[1] forState:UIControlStateNormal];
    [choiceC setTitle:abcd[2] forState:UIControlStateNormal];
    [choiceD setTitle:abcd[3] forState:UIControlStateNormal];
    
    
    
}

-(void)set_abcd{
    NSMutableString *filePath;
    NSMutableString *character = [[NSMutableString alloc] init];
    if(currTurn == 0){
        character = [NSMutableString stringWithFormat:@"%@_mizige.jpg", character_list[currChar1_index]];
        filePath = [[NSMutableString alloc] initWithString:[[NSBundle mainBundle] pathForResource:character_list[currChar1_index]ofType:@"txt"]];
        
        [[NSUserDefaults standardUserDefaults] setObject: character_list[currChar1_index] forKey:@"battle_curChar"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:character_list[currChar2_index] forKey:@"battle_curChar"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        character = [NSMutableString stringWithFormat:@"%@_mizige.jpg", character_list[currChar2_index] ];
        filePath = [[NSMutableString alloc] initWithString:[[NSBundle mainBundle] pathForResource: character_list[currChar2_index] ofType:@"txt"]];
    }
    
    
    
    NSString *fileString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    abcd = [[NSMutableArray alloc] initWithArray:[fileString componentsSeparatedByString:@"\n"]];
    
    
    
    
    mizige = [[battle_smoothedBIView alloc] initWithFrame:CGRectMake(170, 120, 550, 520)];
    
    UIGraphicsBeginImageContext(mizige.frame.size);
    [[UIImage imageNamed:character] drawInRect:mizige.bounds];
    UIImage *back_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    mizige.backgroundColor = [UIColor colorWithPatternImage:back_image];
    
    
    for(UIView * view in [self.view subviews]){
        if([view isKindOfClass:[battle_smoothedBIView class]]){
            [view removeFromSuperview];
        }
    }
    
    [self.view addSubview:mizige];
    

    
}


-(void)preparation {
    
    // Initialize character_list
    
    
    character_list = @[@"ri",@"yue",@"mu",@"san",@"si",@"wu",@"ma",@"niao",@"yu"];
    
    
   //Initialize Counter for both players
    currChar1_index = arc4random()%9 ;
    currChar2_index = arc4random()%9 ;

    
    while(currChar2_index == currChar1_index){
        
        currChar2_index  = arc4random()%9;
        
    }
   //Set current Turn
    
    NSMutableString * who_play = [[NSMutableString alloc] init];
    who_play = [[NSUserDefaults standardUserDefaults] objectForKey:@"who_play"];
    if([ who_play isEqualToString:@"player1"]){
        currTurn = 0;
    
    }
    else if([ who_play isEqualToString:@"player2"]){
        currTurn = 1;
        
    }
    else{
        NSLog(@"insdie random");
        currTurn = arc4random()%2;
    }
    
    NSLog(@"Who play: %@", who_play);
    NSLog(@"decide turn: %d", currTurn);
    
    // initialize correct_answer
    NSArray *key = character_list;\
    // character_list = @[@"ri",@"yue",@"mu",@"san",@"si",@"wu",@"ma",@"niao",@"yu"];
    NSArray *values = @[@"A",@"B", @"B", @"C", @"C", @"C", @"B", @"C", @"C"];
    
    correct_answer = [NSMutableDictionary dictionaryWithObjects:values forKeys: key];
    
    NSLog(@"correct_answer length %@", correct_answer );
    
    [self set_abcd];
    
 
    [self updateABCD];
    [self disableButtons];
     [self readyAlert];

    
}




@end
