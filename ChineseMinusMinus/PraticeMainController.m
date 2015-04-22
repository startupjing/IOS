//
//  PraticeMainController.m
//  ChineseMinusMinus
//
//  Created by Azure Hu on 4/2/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import "PraticeMainController.h"
#import "ScoreBoardController.h"

#import "play_info.h"
#import <AVFoundation/AVFoundation.h>

@interface PraticeMainController ()



@end

@implementation PraticeMainController

@synthesize soundPlayer,mizige;


NSArray* list ;
int counter = 0;
bool switch_hidden = YES;

@synthesize displayChosenCategory,play,clear,play_webview;
@synthesize Done, dict;
- (void)viewDidLoad {
    [super viewDidLoad];
    //For Battle Score Mode
    
    [self.navigationController setNavigationBarHidden:NO];
    
    NSString * from_battle = [[NSUserDefaults standardUserDefaults] objectForKey:@"from_battleScore"];
    NSString * from_battle_curChar =[[NSUserDefaults standardUserDefaults] objectForKey:@"battle_curChar"];
    
    NSLog(@"from_batle_curchar %@",from_battle_curChar);
    
    [[NSUserDefaults standardUserDefaults] setObject:from_battle_curChar      forKey:@"curChar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if([from_battle isEqual:@"hidden"]){
        Done.hidden =YES;
        _prog.hidden = YES;
    }

    else{
        Done.hidden = NO;
        _prog.hidden = NO;
    }
    
    NSLog(@"from battle string %@", from_battle);
//    //set homepage background image
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [[UIImage imageNamed:@"grid.jpg"] drawInRect:self.view.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    
    
    //[self.view addSubview:play_webview];
    counter = 0;
    // Do any additional setup after loading the view.
    NSString *category = [[NSUserDefaults standardUserDefaults] objectForKey:@"chosenCategory"];
    
    list =[[NSUserDefaults standardUserDefaults] objectForKey: category];
    
    [displayChosenCategory setText:category];
    
    if(Done.hidden == NO){
        [[NSUserDefaults standardUserDefaults] setObject: list[0] forKey:@"curChar"];}
    
    NSString *currCharacter = [[NSUserDefaults standardUserDefaults] objectForKey:@"curChar"];
    
    NSLog(@"curChar in pracice mode %@", currCharacter );
    
    mizige = [[SmoothedBIView alloc] initWithFrame:CGRectMake(240, 120, 550, 520)];
    
    
    NSMutableString * curChar = [[NSMutableString alloc] initWithString: currCharacter];
    [curChar appendString:@"_mizige.jpg"];
    
    //curChar = [NSMutableString stringWithFormat:@"intro_back_after.jpg"];
    UIGraphicsBeginImageContext(mizige.frame.size);
    [[UIImage imageNamed:curChar] drawInRect:mizige.bounds];
    UIImage *back_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    mizige.backgroundColor = [UIColor colorWithPatternImage:back_image];
    //UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", currCharacter]]];
    //mizige.backgroundColor = background;
    //mizige.backgroundColor = [UIColor whiteColor];
    
    
    for(UIView * view in [self.view subviews]){
        if([view isKindOfClass:[SmoothedBIView class]]){
            [view removeFromSuperview];
        }
    }
    
    
    [self.view addSubview:mizige];
    //[mizige setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", list[0]]]];
    
    dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjects:@[@"日",@"月",@"木",@"三",@"四",@"五",@"马",@"鸟",@"鱼"] forKeys:@[@"ri",@"yue",@"mu",@"san",@"si",@"wu",@"ma",@"niao",@"yu"]];
    
    
    
}



- (IBAction)pronounce:(id)sender {
    NSString *currentCharacter = [[NSUserDefaults standardUserDefaults] objectForKey:@"curChar"];
    
    NSString *s = [NSString stringWithFormat:@"%@_sound", currentCharacter];
    //NSLog(@"%@", s);
    soundPlayer = [self audioWithFileAndType:s type:@"mp3"];
    [soundPlayer play];
}




- (AVAudioPlayer *)audioWithFileAndType:(NSString *)filename type:(NSString *)filetype {
    
    // build path to audio file
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:filetype];
    
    NSLog(@"%@",filepath);
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    //setup error handler
    NSError *player_error;
    
    //build audio player
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&player_error];
    
    //setup volume
    [player setVolume:0.6];
    return player;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(id)sender {
    

  
    
    
}


- (IBAction)clear:(id)sender {
    NSString *currCharacter = [[NSUserDefaults standardUserDefaults] objectForKey:@"curChar"];
    
    mizige = [[SmoothedBIView alloc] initWithFrame:CGRectMake(240, 120, 550, 520)];
    
    
    NSMutableString * curChar = [[NSMutableString alloc] initWithString: currCharacter];
    [curChar appendString:@"_mizige.jpg"];
    
    
    UIGraphicsBeginImageContext(mizige.frame.size);
    [[UIImage imageNamed:curChar] drawInRect:mizige.bounds];
    UIImage *back_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    mizige.backgroundColor = [UIColor colorWithPatternImage:back_image];
    
    for(UIView * view in [self.view subviews]){
        if([view isKindOfClass:[SmoothedBIView class]]){
            [view removeFromSuperview];
        }
    }
    
    [self.view addSubview:mizige];

    
}


- (IBAction)addlist:(id)sender {
    NSMutableString *currCharacter = [[NSUserDefaults standardUserDefaults] objectForKey:@"curChar"];
    NSLog(@"****");
    NSString *chinese = [dict objectForKey:currCharacter];
    NSLog(@"****");
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"mylist"]];
    

    NSLog(@"****");
    
    
    [arr addObject:chinese];
    NSLog(@"****");
    [[NSUserDefaults standardUserDefaults] setObject:[[NSArray alloc] initWithArray:arr] forKey:@"mylist"];
    NSLog(@"****");
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"****");
    
}







- (IBAction)next:(id)sender {
    
    if (counter<2){
        
        mizige = nil;
  
        [[NSUserDefaults standardUserDefaults] setObject: list[counter+1] forKey:@"curChar"];
        
        NSString *currCharacter = [[NSUserDefaults standardUserDefaults] objectForKey:@"curChar"];
        
       mizige = [[SmoothedBIView alloc] initWithFrame:CGRectMake(240, 120, 550, 520)];
        
        
        NSMutableString * curChar = [[NSMutableString alloc] initWithString: currCharacter];
        [curChar appendString:@"_mizige.jpg"];
        
        
        UIGraphicsBeginImageContext(mizige.frame.size);
        [[UIImage imageNamed:curChar] drawInRect:mizige.bounds];
        UIImage *back_image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        mizige.backgroundColor = [UIColor colorWithPatternImage:back_image];
        
        for(UIView * view in [self.view subviews]){
            if([view isKindOfClass:[SmoothedBIView class]]){
                [view removeFromSuperview];
            }
        }
        
        [self.view addSubview:mizige];
        
        NSLog(@"the views inside Practice %@", self.view.subviews);
        
        [_prog setProgress:(_prog.progress + 0.33333f) animated:YES];
        
        

        
        
        counter++;
    }
    else{
        
        
        NSLog(@"hahahaha");
        
        
        
        ScoreBoardController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreBoardController"];
        
        [self.navigationController pushViewController:ctrl animated:YES];
        
//        ScoreBoardController* scoreboard = [[ScoreBoardController alloc] initWithNibName:@"ScoreBoardController" bundle:nil];  //might need xib
//        [self.navigationController pushViewController:scoreboard animated:YES];
        
        counter = 0;
        
    }
}
- (IBAction)screenshot:(id)sender {
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(snapShotImage,nil,nil,nil);

}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
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
