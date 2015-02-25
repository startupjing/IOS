//
//  Cell.m
//  Lu-Lab2
//
//  Created by Labuser on 2/21/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import "Cell.h"

@implementation Cell

- (NSString *)contents{
    NSArray *markers = [Cell validMarkers];
    return markers[self.player];
}

+ (NSArray *)validMarkers{
    return @[@"",@"X",@"O"];
}

@end
