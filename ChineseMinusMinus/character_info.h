//
//  character_info.h
//  ChineseMinusMinus
//
//  Created by Labuser on 4/11/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"


#import <MediaPlayer/MediaPlayer.h>

@interface character_info : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *info_image;
@property (weak, nonatomic) IBOutlet UIWebView *charinfo_display;
@property (weak, nonatomic) IBOutlet UIImageView *infoimage_display;
@property (strong,nonatomic) MPMoviePlayerController* moviePlayerController;
@end
