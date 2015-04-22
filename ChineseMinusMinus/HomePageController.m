//
//  ViewController.m
//  ChineseMinusMinus
//
//  Created by Azure Hu on 4/2/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import "HomePageController.h"

@interface HomePageController ()

@end

@implementation HomePageController
@synthesize caligraphy;
- (void)viewDidLoad{
    
    [super viewDidLoad];
   

    //set homepage background image
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"homepage.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)animationCode {
    // you animation code
}

-(void) viewDidAppear:(BOOL)animated{
    animated = NO;
    //[self performSelector:@selector(animationCode) withObject:nil afterDelay:0.0f];
    
     [self.navigationController setNavigationBarHidden:YES];
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
