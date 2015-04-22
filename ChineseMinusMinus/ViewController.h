//
//  ViewController.h
//  siriTest
//
//  Created by Azure Hu on 4/11/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "POVoiceHUD.h"
#import "SmoothedBIView.h"

//引入语音识别类
@class IFlyDataUploader;
@class IFlySpeechUnderstander;
//注意要添加语音识别代理
@interface ViewController : UIViewController <IFlySpeechRecognizerDelegate,POVoiceHUDDelegate>{
  
}
@property (nonatomic,strong) IFlySpeechUnderstander *iFlySpeechUnderstander;
@property (nonatomic,strong) NSString               *result;
@property (nonatomic,strong) NSString               *str_result;
@property (nonatomic)         BOOL                  isCanceled;
@property (nonatomic,strong) NSNumber             *totalLength;

@property (weak, nonatomic) IBOutlet UIButton *info_btn;

@property (weak, nonatomic) IBOutlet UIButton *play_btn;


@property (strong, nonatomic) NSMutableDictionary *dict;

@property (strong,nonatomic) AVAudioPlayer *soundPlayer;
@property (strong, nonatomic) IBOutlet UIButton *pro_btn;


@property (nonatomic, retain) IBOutlet POVoiceHUD *speaker;

@property (strong, nonatomic) NSArray *chineseArr;


- (IBAction)understand:(id)sender;
- (IBAction)finish:(id)sender;





@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn_arr;


@end