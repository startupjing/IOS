//
//  Board.m
//  Lu-Lab2
//
//  Created by Labuser on 2/21/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import "Board.h"
#import "Cell.h"

@interface Board()
@property (strong, nonatomic)NSMutableArray *cells;
@property (nonatomic, readwrite)NSUInteger currentPlayer;
@end


@implementation Board


static const int BOARD_SIZE=9;

- (instancetype)init{
    self = [super init];
    if(self){
        for(int i=0; i<BOARD_SIZE; i++){
            Cell *cell = [[Cell alloc] init];
            [self addCell:cell];
        }
    }
    self.currentPlayer = 0;
    return self;
}


- (NSMutableArray *)cells{
    if(!_cells){
        _cells = [[NSMutableArray alloc] init];
    }
    return _cells;
}

- (void)addCell:(Cell *)cell{
    [self.cells addObject:cell];
}

- (void)chooseCellAtIndex:(NSUInteger)index{
    Cell *cell = [self cellAtIndex:index];
    cell.player = self.currentPlayer;
    
}

- (Cell *)cellAtIndex:(NSUInteger)index{
    return (index < [self.cells count] ? self.cells[index] : nil);
}




@end
