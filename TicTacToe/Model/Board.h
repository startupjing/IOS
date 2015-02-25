//
//  Board.h
//  Lu-Lab2
//
//  Created by Labuser on 2/21/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"

@interface Board : NSObject

- (void)addCell:(Cell *)cell;
- (void)chooseCellAtIndex:(NSUInteger)index;
- (Cell *)cellAtIndex:(NSUInteger)index;

@property (nonatomic, readonly)NSUInteger currentPlayer;


@end
