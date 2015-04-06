//
//  ScoreBoard.m
//  Lu_Lab5
//
//  Created by Labuser on 3/28/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import "ScoreBoard.h"

@interface ScoreBoard ()

@end

@implementation ScoreBoard

- (void)viewDidLoad {
    
    
    //set homepage background image
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"scoreboard.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    //retrieve best scores
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *scores = [defaults objectForKey:@"scores"];
    NSMutableArray *sortedScores = [NSMutableArray arrayWithArray:scores];
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [sortedScores sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    int size = (int)[sortedScores count];
    for(int index=0; index<size; index++){
        UILabel *label = [self indexToLabel:index];
        [label setText:[NSString stringWithFormat:@"No %d: %d", index+1, [sortedScores[index] intValue]]];
    }
    
    [super viewDidLoad];
    
}

- (UILabel *)indexToLabel:(int)index{
    switch (index) {
        case 0:
            return self.no1;
            break;
        case 1:
            return self.no2;
            break;
        case 2:
            return self.no3;
            break;
        case 3:
            return self.no4;
            break;
        case 4:
            return self.no5;
            break;
        default:
            return nil;
            break;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
