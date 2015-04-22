//
//  PraticeController.m
//  ChineseMinusMinus
//
//  Created by Azure Hu on 4/2/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import "PraticeController.h"

@interface PraticeController ()

@end

@implementation PraticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
         [[NSUserDefaults standardUserDefaults] setObject: @"Todd" forKey:@"from_battleScore"];
    //set homepage background image
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [[UIImage imageNamed:@"category.jpg"] drawInRect:self.view.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
 
}




- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)CategoryOnePressed:(UIButton *)sender {
    NSString *s = sender.titleLabel.text;
    NSArray * list = [NSArray arrayWithObjects:@"ri",@"yue",@"mu" ,nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:s forKey:@"chosenCategory"];
    [[NSUserDefaults standardUserDefaults] setObject: list forKey: s];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)CategoryTwoPressed:(UIButton *)sender {
    NSString *s = sender.titleLabel.text;
    NSArray * list = [NSArray arrayWithObjects:@"ma",@"niao",@"yu" ,nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:s forKey:@"chosenCategory"];
    [[NSUserDefaults standardUserDefaults] setObject: list forKey: s];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)CategoryThreePressed:(UIButton *)sender {
    NSString *s = sender.titleLabel.text;
    NSArray * list = [NSArray arrayWithObjects:@"san",@"si",@"wu" ,nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:s forKey:@"chosenCategory"];
    [[NSUserDefaults standardUserDefaults] setObject: list forKey: s];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
