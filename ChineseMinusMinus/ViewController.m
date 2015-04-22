//
//  ViewController.m
//  siriTest
//
//  Created by Azure Hu on 4/11/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import "ViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import <AVFoundation/AVFoundation.h>

#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechUnderstander.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize pro_btn, btn_arr, dict, soundPlayer,speaker, info_btn,play_btn, chineseArr;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"blank"     forKey:@"curChar"];
 
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",@"5529853f",@"20000"];
    
    
    [IFlySpeechUtility createUtility:initString];
    _iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
    _iFlySpeechUnderstander.delegate = self;
    
    
    
    
   SmoothedBIView *mizige  = [[SmoothedBIView alloc] initWithFrame:CGRectMake(250, 240, 400, 400)];
    
    NSString * curChar = @"blank_mizige.jpg";
    
    UIGraphicsBeginImageContext(mizige.frame.size);
    [[UIImage imageNamed:curChar] drawInRect:mizige.bounds];
    UIImage *back_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    mizige.backgroundColor = [UIColor colorWithPatternImage:back_image];
    
    [self.view addSubview:mizige];
    
    
    
    
    for(UIButton *b in btn_arr){
        b.titleLabel.font = [UIFont systemFontOfSize:40];
        [b addTarget:self action:@selector(chooseCharacter:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    dict = [NSMutableDictionary dictionaryWithObjects:@[@"ri",@"yue",@"mu",@"san",@"si",@"wu",@"ma",@"niao",@"yu"] forKeys:@[@"日",@"月",@"木",@"三",@"四",@"五",@"马",@"鸟",@"鱼"]];
    
 
    
    
    
    
    
    
    self.speaker = [[POVoiceHUD alloc] initWithParentView:self.view];
    self.speaker.title = @"Speak Now";
    
    [self.speaker setDelegate:self];
    [self.view addSubview:self.speaker];
    
    
    play_btn.enabled = false;
    info_btn.enabled = false;
    pro_btn.enabled = false;

}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_iFlySpeechUnderstander cancel];
    _iFlySpeechUnderstander.delegate = nil;

    [_iFlySpeechUnderstander destroy];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)clear:(id)sender {
    NSString *currCharacter = [[NSUserDefaults standardUserDefaults] objectForKey:@"curChar"];
    
   SmoothedBIView *mizige  = [[SmoothedBIView alloc] initWithFrame:CGRectMake(250, 240, 400, 400)];
    
    
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





- (IBAction)pro:(id)sender {
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




- (IBAction)understand:(id)sender {
    NSLog(@"inside begin");
    bool ret = [_iFlySpeechUnderstander startListening];  //Start Listening
    if (ret) {
        for(UIButton *b in btn_arr){
            b.enabled = true;
        }
        
        self.isCanceled = NO;
        
        self.speaker.hidden = false;
        [self.speaker startForFilePath:[NSString stringWithFormat:@"%@/Documents/MySound.caf", NSHomeDirectory()]];
    }
    else{
        NSLog(@"启动识别失败!");
    }
}

- (IBAction)finish:(id)sender {
    NSLog(@"inside end");
    [_iFlySpeechUnderstander stopListening];   //Finish Listening
    self.speaker.hidden = true;
    [self.speaker cancelRecording];
    
    
    
}


- (IBAction)chooseCharacter:(id)sender{
    NSString *target = [sender titleForState:UIControlStateNormal];
    NSString *translate = [dict objectForKey:target];
    [[NSUserDefaults standardUserDefaults] setObject:translate forKey:@"curChar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    NSMutableString * curChar = [[NSMutableString alloc] initWithString: translate];
    [curChar appendString:@"_mizige.jpg"];
   SmoothedBIView * mizige = [[SmoothedBIView alloc] initWithFrame:CGRectMake(250, 240, 400, 400)];
    
    
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
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"curChar"] isEqualToString:@"blank"]){
        info_btn.enabled = true;
        play_btn.enabled = true;
        pro_btn.enabled = true;
        
    }
    
}






#pragma mark - IFlySpeechRecognizerDelegate

- (void) onVolumeChanged: (int)volume
{
    
}


- (void) onBeginOfSpeech
{
    
}


- (void) onEndOfSpeech
{
    
}


- (void) onError:(IFlySpeechError *) error
{
    NSString *text ;
    if (self.isCanceled) {
        text = @"识别取消";
    }
    else if (error.errorCode ==0 ) {
        if (_result.length==0) {
            text = @"无识别结果";
        }
        else{
            text = @"识别成功";
        }
    }
    else{
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }
}


- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSArray * temp = [[NSArray alloc]init];
    NSString * str = [[NSString alloc]init];
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
        
    }
    NSLog(@"听写结果：%@",result);
    // Jason File
    NSError * error;
    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"data: %@",data);
    NSDictionary * dic_result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSArray * array_ws = [dic_result objectForKey:@"ws"];

    for (int i=0; i<array_ws.count; i++) {
        temp = [[array_ws objectAtIndex:i] objectForKey:@"cw"];
        NSDictionary * dic_cw = [temp objectAtIndex:0];
        str = [str  stringByAppendingString:[dic_cw objectForKey:@"w"]];
        NSLog(@"识别结果:%@",[dic_cw objectForKey:@"w"]);
    }
    NSLog(@"最终的识别结果:%@",str);
   
    if ([str isEqualToString:@"。"] || [str isEqualToString:@"？"] || [str isEqualToString:@"！"]) {
        NSLog(@"末尾标点符号：%@",str);
    }
    else{
        
        
        
        chineseArr = [[NSArray alloc] init];
        chineseArr = @[@"日",@"月",@"木",@"三",@"四",@"五",@"马",@"鸟",@"鱼"];
        
        for(UIButton *b in btn_arr){
            [b setTitle:@"" forState:UIControlStateNormal];
        }
        
        
        NSUInteger length = str.length>=6 ? 6 : str.length;
        NSLog(@" the length of string is %ld", length);
        
        
        NSMutableArray *singleCharArray = [[NSMutableArray alloc] init];
        
        for(int i=0; i<length; i++){
            unichar theChar = [str characterAtIndex:i];
            
            
            NSString *recog =[NSString stringWithFormat:@"%C", theChar];
            
            [singleCharArray addObject:recog];
            
            
            [btn_arr[i] setTitle:singleCharArray[i] forState:UIControlStateNormal];
            
            if(![chineseArr containsObject:recog]){
                [btn_arr[i] setEnabled:false];
                
            }
            
            NSLog(@"%@", [singleCharArray objectAtIndex:i]);
        }
        
      
        

    }
    _result = str;
}


#pragma mark - POVoiceHUD Delegate

- (void)POVoiceHUD:(POVoiceHUD *)voiceHUD voiceRecorded:(NSString *)recordPath length:(float)recordLength {
    NSLog(@"Sound recorded with file %@ for %.2f seconds", [recordPath lastPathComponent], recordLength);
}

- (void)voiceRecordCancelledByUser:(POVoiceHUD *)voiceHUD {
    NSLog(@"Voice recording cancelled for HUD: %@", voiceHUD);
}

@end