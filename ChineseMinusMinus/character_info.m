//
//  character_info.m
//  ChineseMinusMinus
//
//  Created by Labuser on 4/11/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import "character_info.h"
#import <QuartzCore/QuartzCore.h>

#import <MobileCoreServices/MobileCoreServices.h>

@interface character_info ()

@end

@implementation character_info
@synthesize  info_image,moviePlayerController,charinfo_display,infoimage_display;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.navigationController setNavigationBarHidden:NO];
    
    
    self.charinfo_display.scalesPageToFit = YES;
    self.charinfo_display.contentMode = UIViewContentModeScaleAspectFit;
    
   
    NSString *curChar = [[NSUserDefaults standardUserDefaults] objectForKey:@"curChar"];
    
   
    
    [infoimage_display setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", curChar]]];
    
    NSMutableString * curChar_pic = [NSMutableString stringWithString:curChar];
    
    
    
    // info page webview for gif
    [curChar_pic appendString:@"_pic"];
    

    NSString *filePath = [[NSBundle mainBundle] pathForResource:curChar_pic ofType:@"gif"];
    NSData *gif = [NSData dataWithContentsOfFile:filePath];
    [charinfo_display loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    charinfo_display.userInteractionEnabled = NO;

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
