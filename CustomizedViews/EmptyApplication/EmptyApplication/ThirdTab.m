//
//  ThirdTab.m
//  EmptyApplication
//
//  Created by Labuser on 2/25/15.
//  Copyright (c) 2015 StudentName. All rights reserved.
//

#import "ThirdTab.h"
#import "AnotherThirdTab.h"

@interface ThirdTab ()

@end

@implementation ThirdTab
- (IBAction)buttonPressed:(id)sender {
    [self.navigationItem setTitle:@"Part 1"];
    AnotherThirdTab *another = [[AnotherThirdTab alloc] initWithNibName:@"AnotherThirdTab" bundle:nil];
    [self.navigationController pushViewController:another animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = @"Third Screen Part 1";
}



@end
