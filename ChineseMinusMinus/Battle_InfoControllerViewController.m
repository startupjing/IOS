//
//  Battle_InfoControllerViewController.m
//  ChineseMinusMinus
//
//  Created by Azure Hu on 4/18/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import "Battle_InfoControllerViewController.h"

@interface Battle_InfoControllerViewController ()

@end

@implementation Battle_InfoControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)player1_start:(id)sender {
      [[NSUserDefaults standardUserDefaults] setObject: @"player1" forKey:@
       "who_play"];
    NSLog(@"set player 1");
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    BattleController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"BattleController"];
    [self.navigationController pushViewController:ctrl animated:YES];
    

    
}
- (IBAction)player2_start:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject: @"player2" forKey:@
     "who_play"];
    NSLog(@"set player 2");
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    BattleController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"BattleController"];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}
- (IBAction)random_start:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject: @"random" forKey:@
     "who_play"];
    NSLog(@"set random");
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    BattleController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"BattleController"];
    [self.navigationController pushViewController:ctrl animated:YES];
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
