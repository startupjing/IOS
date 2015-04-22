//
//  play_info.m
//  ChineseMinusMinus
//
//  Created by Peiyun Zeng on 4/12/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import "play_info.h"

@interface play_info ()


@end



@implementation play_info
@synthesize  web_view_write;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    self.web_view_write.scalesPageToFit = YES;
    self.web_view_write.contentMode = UIViewContentModeScaleAspectFit;
    
    
    NSString *curChar = [[NSUserDefaults standardUserDefaults] objectForKey:@"curChar"];
    
    
    
    

    
    // play page webview for gif
 
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:curChar ofType:@"gif"];
    NSData *gif = [NSData dataWithContentsOfFile:filePath];
    [web_view_write loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    web_view_write.userInteractionEnabled = NO;
    
    
    
}
- (IBAction)test_webview:(id)sender {
    
    if(web_view_write.isHidden){
    web_view_write.hidden = NO;
    }
    else{
        web_view_write.hidden = YES;
    }
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
