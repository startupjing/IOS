//
//  IntroController.m
//  ChineseMinusMinus
//
//  Created by Peiyun Zeng on 4/18/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import "IntroController.h"

@interface IntroController ()

@end

@implementation IntroController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpages];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setpages{
    
    
    UIImage *img1 =[UIImage imageNamed:@"bg1@2x.png"];
    UIImage *img2 =[UIImage imageNamed:@"bg2@2x.png"];
    UIImage *img3 =[UIImage imageNamed:@"bg3@2x.png"];
    
    UIImage *img1done = [[UIImage alloc] initWithCGImage:img1.CGImage scale:1.0 orientation:UIImageOrientationLeft];
    UIImage *img2done = [[UIImage alloc] initWithCGImage:img2.CGImage scale:1.0 orientation:UIImageOrientationLeft];
    UIImage *img3done = [[UIImage alloc] initWithCGImage:img3.CGImage scale:1.0 orientation:UIImageOrientationLeft];
    

    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Feature1: Practice Mode";
    page1.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:40];
    page1.titlePositionY = 420;
    page1.desc = @"Practice Mode supports user to practice writing Chinese in a certain category.";
    page1.descFont = [UIFont fontWithName:@"Georgia-Italic" size:25];
    page1.descPositionY = 300;
    page1.titleIconView = [[UIImageView alloc] initWithImage:img1done];
    page1.titleIconPositionY = 100;
    
    
    
    EAIntroPage *page1_1 = [EAIntroPage page];
    page1_1.title = @"Feature2: MyList";
    page1_1.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:40];
    page1_1.titlePositionY = 420;
    page1_1.desc = @"MyList supports users to review his or her character collections";
    page1_1.descFont = [UIFont fontWithName:@"Georgia-Italic" size:25];
    page1_1.descPositionY = 300;
    page1_1.titleIconView = [[UIImageView alloc] initWithImage:img3done];
    page1_1.titleIconPositionY = 100;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Feature3: Battle Mode";
    page2.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:40];
    page2.titlePositionY = 420;
    page2.desc = @"Battle Mode supports two users to compete with each other to finish a game with questions.";
    page2.descFont = [UIFont fontWithName:@"Georgia-Italic" size:25];
    page2.descPositionY = 300;
    page2.titleIconView = [[UIImageView alloc] initWithImage:img2done];
    page2.titleIconPositionY = 100;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"Feature4: What's This ?";
    page3.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:40];
    page3.titlePositionY = 420;
    page3.desc = @"What's This supports users to look up a Chinese charater with voice recognition.";
    page3.descFont = [UIFont fontWithName:@"Georgia-Italic" size:25];
    page3.descPositionY = 300;
    page3.titleIconView = [[UIImageView alloc] initWithImage:img3done];
    page3.titleIconPositionY = 100;
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page1_1,page2,page3]];
    
    [intro showInView:self.view animateDuration:0.0];
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
