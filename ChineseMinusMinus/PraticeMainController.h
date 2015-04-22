//
//  PraticeMainController.h
//  ChineseMinusMinus
//
//  Created by Azure Hu on 4/2/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SmoothedBIView.h"
#import "CircleProgressBar.h"

@interface PraticeMainController : UIViewController{
    
}
@property (retain,nonatomic) SmoothedBIView * mizige;
@property (strong, nonatomic) IBOutlet UILabel *displayChosenCategory;

@property (weak, nonatomic) IBOutlet UIButton *play;

@property (weak, nonatomic) IBOutlet UIButton *clear;

@property (weak, nonatomic) IBOutlet UIWebView *play_webview;
@property (strong, nonatomic) IBOutlet UIButton *Done;

@property (weak, nonatomic) IBOutlet CircleProgressBar *prog;
@property (strong, nonatomic) AVAudioPlayer *soundPlayer;


@property (strong,nonatomic) NSMutableDictionary *dict;
@end
