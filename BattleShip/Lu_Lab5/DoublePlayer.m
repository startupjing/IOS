//
//  DoublePlayer.m
//  Lu_Lab5
//
//  Created by Labuser on 3/25/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import "DoublePlayer.h"
#import <AVFoundation/AVFoundation.h>


@interface DoublePlayer ()

@end

@implementation DoublePlayer


//synthesize variable names
@synthesize largeship_p1, mediumship_p1, smallship_p1, smallship2_p1, tinyship_p1, largeship_p2, mediumship_p2, smallship_p2, smallship2_p2, tinyship_p2;
@synthesize grid_p1, grid_p2, p1_attack_p2, p2_attack_p1;
@synthesize label_p1, label_p2, current_turn, game_info, p1_left, p2_left, placeDoneButton, switch_turn_button;
@synthesize ships_p1, ships_p2, grid_button_p1, grid_button_p2, ship_to_loc_p1, ship_to_loc_p2, ship_index_p1, ship_index_p2;



//constants

//side length of grid
#define GRID_HEIGHT 400
#define GRID_WIDTH 400

//side length of cell
#define CELLSIZE 40

//coordinates of origins for two grids
#define GRID_ONE_ORIGINX 35
#define GRID_ONE_ORIGINY 145
#define GRID_TWO_ORIGINX 505
#define GRID_TWO_ORIGINY 145

//number of spots on the grid
#define NUM_SPOTS 100

//number of ships
#define NUM_SHIPS 5;


# pragma mark - screen load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set background image
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    [self initGame];
    
}



# pragma mark - initialization

//initialize the game
- (void)initGame{
    
    //number of initial ships
    self.p1_left = NUM_SHIPS;
    self.p2_left = NUM_SHIPS;
    
    //assign five ships to each player
    ships_p1 = [[NSMutableArray alloc] initWithObjects:largeship_p1, mediumship_p1, smallship_p1, smallship2_p1, tinyship_p1, nil];
    ships_p2 = [[NSMutableArray alloc] initWithObjects:largeship_p2, mediumship_p2, smallship_p2, smallship2_p2, tinyship_p2, nil];
    
    //initialize ship locations and status
    ship_to_loc_p1 = [[NSMutableDictionary alloc] init];
    ship_to_loc_p2 = [[NSMutableDictionary alloc] init];
    ship_index_p1 = [[NSMutableDictionary alloc] init];
    ship_index_p2 = [[NSMutableDictionary alloc] init];
    
    //display buttons
    placeDoneButton.hidden = false;
    grid_button_p1 = [NSMutableArray array];
    grid_button_p2 = [NSMutableArray array];
    
    //hide missile images
    p1_attack_p2.hidden = true;
    p2_attack_p1.hidden = true;
    
    //setup initial scores
    p1_score = 0;
    p2_score = 0;
    
    //set label font 
    game_info.font = [UIFont boldSystemFontOfSize:25.0f];
    
    //hide switch turn button
    switch_turn_button.hidden = true;
    
    //boolean variable used to prevent player hit enemy's ships multiple times
    isClicked = false;
    
    
    //sound file
    ship_sunk_sound = [self audioWithFileAndType:@"ship_sunk" type:@"mp3"];
    final_victory_sound = [self audioWithFileAndType:@"winner" type:@"mp3"];
 
    //add touch events handler to ship buttons
    int n = NUM_SHIPS;
    for(int ship_idx=0; ship_idx < n; ship_idx++){
        //drap ships
        [ships_p1[ship_idx] addTarget:self action:@selector(dragShip:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [ships_p1[ship_idx] addTarget:self action:@selector(dragShip:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
        [ships_p2[ship_idx] addTarget:self action:@selector(dragShip:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [ships_p2[ship_idx] addTarget:self action:@selector(dragShip:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
        
        
        //drop ships
        [ships_p1[ship_idx] addTarget:self action:@selector(dropShip:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [ships_p1[ship_idx] addTarget:self action:@selector(dropShip:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
        [ships_p2[ship_idx] addTarget:self action:@selector(dropShip:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [ships_p2[ship_idx] addTarget:self action:@selector(dropShip:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
        
        //use double tap to rotate ships
        UITapGestureRecognizer *tapRotate1 = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(tapToRotate:)];
        tapRotate1.numberOfTapsRequired = 2;
        
        UITapGestureRecognizer *tapRotate2 = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(tapToRotate:)];
        tapRotate2.numberOfTapsRequired = 2;
        
        [ships_p1[ship_idx] addGestureRecognizer:tapRotate1];
        [ships_p2[ship_idx] addGestureRecognizer:tapRotate2];
    }
    
    
    //add buttons on the two players' grids
    for(int current_grid=1; current_grid<3; current_grid++){
        float grid_origin_x = (current_grid==1) ? GRID_ONE_ORIGINX : GRID_TWO_ORIGINX;
        float grid_origin_y = (current_grid==1) ? GRID_ONE_ORIGINY : GRID_TWO_ORIGINY;
        
        for(int row=grid_origin_x; row < grid_origin_x + GRID_WIDTH; row += CELLSIZE){
            for(int col=grid_origin_y; col < grid_origin_y + GRID_HEIGHT; col += CELLSIZE){
                //make a button with computed coordinates
                UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
                b.frame = CGRectMake(row, col, CELLSIZE, CELLSIZE);
                [b setTitle:@"" forState:UIControlStateNormal];
                [b setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [b setBackgroundImage:[UIImage imageNamed:@"ocean_img.png"] forState:UIControlStateNormal];
                [[b layer] setBorderWidth:1.0f];
                [[b layer] setBorderColor:[UIColor blueColor].CGColor];
                [self.view addSubview:b];
                b.hidden = true;
                
                //add buttons to corresponding grid
                if(current_grid == 1){
                    [grid_button_p1 addObject:b];
                }else{
                    [grid_button_p2 addObject:b];
                }
            }
        }
    }
    
  
    //randomly decide who to move ships first
    if([self randomTurn] == 1){
        self.turn = 1;
        
        [self placeShipMessage:self.turn];
        
        //hide player 2's grid
        grid_p2.hidden = true;
        label_p2.hidden = true;
        for(UIButton *ship in ships_p2){
            ship.hidden = true;
        }
        
        //update text
        [label_p1 setText:@"Player 1: placing ships"];
        [current_turn setText:@"Player 1 is placing ships"];
        
    }else{
        self.turn = 2;
        
        [self placeShipMessage:self.turn];
        
        //hide player 1's grid
        grid_p1.hidden = true;
        label_p1.hidden = true;
        for(UIButton *ship in ships_p1){
            ship.hidden = true;
        }
        
        //update text
        [label_p2 setText:@"Player 2: placing ships"];
        [current_turn setText:@"Player 2 is placing ships"];
        
    }
}



# pragma mark - touch event handler

//double tap to flip width and height of ship
- (void)tapToRotate:(UITapGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateRecognized){
        CGRect temp = sender.view.bounds;
        temp.size = CGSizeMake(sender.view.frame.size.height, sender.view.frame.size.width);
        sender.view.bounds = temp;
    }
}


//drap a ship to some position
- (void)dragShip:(UIButton *)ship withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint prev = [touch previousLocationInView:ship];
    CGPoint curr = [touch locationInView:ship];
    
    //update center
    CGPoint center = ship.center;
    center.x += curr.x - prev.x;
    center.y += curr.y - prev.y;
 
    ship.center = center;
    
}


//drop a ship to some location
- (void)dropShip:(UIButton *)ship withEvent:(UIEvent *)event{

    UIControl *target = ship;
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint prev = [touch previousLocationInView:target];
    CGPoint curr = [touch locationInView:target];
    CGPoint center = target.center;
    
    center.x += curr.x - prev.x;
    center.y += curr.y - prev.y;
    
    //ship is within the grid
    if([self isShipWithinGrid:ship]){
        
        //adjust centers if needed
        NSString *direct = (ship.bounds.size.width==CELLSIZE) ? @"vertical" : @"horizontal";
        NSInteger ship_type = [self get_ship_type:ship];
        center = [self adjust_center:direct withCenter:center withType:ship_type];
      
        
        //compute centers of each block in the ship
        NSMutableArray *ship_centers_loc;
        ship_centers_loc = [self find_ship_centers:direct withCenter:center withShipType:ship_type];
        
        
        //check if the ship is placed over another ship
        if([self isShipOverlap:ship_centers_loc]){
            [self shipOverlapAlert];
        }else{
            //put ship centers to ships_loc array
            [self setShips:ship_centers_loc withShip:ship];
            target.center = center;
        }
        
    
    //ship is out of grid
    }else{
        [self shipOutsideGridAlert];
    }
    
}




# pragma mark - adjusting placement


//return adjusted center of the ship when player drops the ship
- (CGPoint)adjust_center:(NSString *)direction withCenter:(CGPoint)center withType:(NSInteger)ship_type{
    
    //determine the origin of the grid based on current player
    float grid_origin_x, grid_origin_y;
    if(self.turn == 1){
        grid_origin_x = GRID_ONE_ORIGINX;
        grid_origin_y = GRID_ONE_ORIGINY;
    }else{
        grid_origin_x = GRID_TWO_ORIGINX;
        grid_origin_y = GRID_TWO_ORIGINY;
        
    }
    
    //deviation from origin
    float offset_x = fmodf(center.x - grid_origin_x, CELLSIZE);
    float offset_y = fmodf(center.y - grid_origin_y, CELLSIZE);
    
    //vertical ship
    if([direction isEqualToString:@"vertical"]){
        //distance to the middle
        offset_x -= CELLSIZE/2.0;
        
        //pass middle to the right
        if(offset_x > 0){
            center.x -= offset_x;
            //pass middle to the left
        }else{
            center.x += -offset_x;
        }
        
        //ship with even length
        if(ship_type==1 || ship_type==4){
            center.y += (CELLSIZE - offset_y);
        }
        //ship with odd length
        else{
            center.y += (CELLSIZE/2.0 - offset_y);
        }
  
        //horizontal ship
    }else{
        offset_y -= CELLSIZE/2.0;
        if(offset_y > 0){
            center.y -= offset_y;
        }else{
            center.y += -offset_y;
        }
        
        //ship with even length
        if(ship_type==1 || ship_type==4){
            center.x += (CELLSIZE - offset_x);
        }
        //ship with odd length
        else{
            center.x += (CELLSIZE/2.0 - offset_x);
        }
 
    }
    
    return center;
    
}


# pragma mark - helper functions for ship locations

//return array of centers of blocks in the ship
- (NSMutableArray *)find_ship_centers:(NSString *)direction withCenter:(CGPoint)center withShipType:(NSInteger)ship_type{
    NSMutableArray *ship_centers_loc = [NSMutableArray array];
    BOOL isVertical = [direction isEqualToString:@"vertical"];
    
    //large ship or small ship
    if(ship_type==0 || ship_type==2 || ship_type==3){
        //center block
        NSValue *center_block = [NSValue valueWithCGPoint:center];
        [ship_centers_loc addObject:center_block];
        
        //vertical ship
        if(isVertical){
            //two blocks close to center block
            center.y -= CELLSIZE;
            NSValue *val1 = [NSValue valueWithCGPoint:center];
            [ship_centers_loc addObject:val1];
            center.y += 2*CELLSIZE;
            NSValue *val2 =[NSValue valueWithCGPoint:center];
            [ship_centers_loc addObject:val2];
            
            //add two additional block centers if large ship
            if(ship_type==0){
                center.y += CELLSIZE;
                [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
                center.y -= 4*CELLSIZE;
                [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
            }
            
            //horizontal ship
        }else{
            //two blocks close to center block
            center.x -= CELLSIZE;
            [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
            center.x += 2*CELLSIZE;
            [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
            
            //add two additional block centers if large ship
            if(ship_type==0){
                center.x += CELLSIZE;
                [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
                center.x -= 4*CELLSIZE;
                [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
            }
            
        }
        
    }
    //medium ship or tiny ship
    else{
        //vertical ship
        if(isVertical){
            center.y -= CELLSIZE/2.0;
            [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
            
            center.y += CELLSIZE;
            [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
            
            //add two additional block centers if medium ship
            if(ship_type == 1){
                center.y += CELLSIZE;
                [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
                center.y -= 3*CELLSIZE;
                [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
            }
        }else{
            center.x -= CELLSIZE/2.0;
            [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
            
            
            center.x += CELLSIZE;
            [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
            
            
            //add two additional block centers if medium ship
            if(ship_type == 1){
                center.x += CELLSIZE;
                [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
                center.x -= 3*CELLSIZE;
                [ship_centers_loc addObject:[NSValue valueWithCGPoint:center]];
            }
            
        }
        
    }
    
    return ship_centers_loc;
    
}




# pragma mark - ship placement


//put centers of blocks of the ship in ships_loc array
- (void)setShips:(NSMutableArray *)ship_loc withShip:(UIButton *)ship{
    if(self.turn == 1){
        [ship_to_loc_p1 setObject:ship_loc forKey:[self get_ship_string:ship]];
    }else{
        [ship_to_loc_p2 setObject:ship_loc forKey:[self get_ship_string:ship]];
    }
}


//method called when player clicks on placement done button
- (IBAction)placementDone:(id)sender {
    NSMutableArray *ships = (self.turn==1) ? ships_p1 : ships_p2;
    
    //check if player has placed all ships into grid
    for(UIButton *ship in ships){
        if(![self isShipWithinGrid:ship]){
            [self shipOutsideGridAlert];
            return;
        }
    }
    
    //remove event handlers from ship buttons
    for(UIButton *ship in ships){
        //remove selectors for dragging and dropping ships
        [ship removeTarget:self action:@selector(dragShip:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [ship removeTarget:self action:@selector(dragShip:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
        [ship removeTarget:self action:@selector(dropShip:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [ship removeTarget:self action:@selector(dropShip:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
        
        // remove double tap
        for (UIGestureRecognizer *recognizer in ship.gestureRecognizers) {
            [ship removeGestureRecognizer: recognizer];
        }
    }
    
    
    //let next player place ships or start the game
    if(self.turn == 1){
        if([[ship_to_loc_p2 allKeys] count] == 5){
            [self gameStartMessage:2];
            [self startGame];
        }else{
            [self placeShipMessage:2];
            [self p2PlaceShip];
        }
    }else{
        if([[ship_to_loc_p1 allKeys] count] == 5){
            [self gameStartMessage:1];
            [self startGame];
        }else{
            [self placeShipMessage:1];
            [self p1PlaceShip];
        }
    }
}




//compute button index of ships for the given player
- (void)compute_ship_index:(int)player{
    NSMutableDictionary *target = (player == 1) ? ship_index_p1 : ship_index_p2;
    NSMutableDictionary *ship_locations = (player == 1) ? ship_to_loc_p1 : ship_to_loc_p2;
    NSMutableArray *grid = (player==1) ? grid_button_p1 : grid_button_p2;
    
    NSArray *keys = [NSArray arrayWithObjects:@"large", @"medium", @"small1", @"small2", @"tiny", nil];
    
    //loop through each kind of ship
    for(NSString *key in keys){
        NSMutableArray *button_index = [NSMutableArray array];
        NSArray *ship_loc = [ship_locations objectForKey:key];
        for(NSValue *posValue in ship_loc){
            for(UIButton *button in grid){
                
                //button index found
                if(button.center.x==posValue.CGPointValue.x && button.center.y==posValue.CGPointValue.y){
                    int idx = (int)[grid indexOfObject:button];
                    [button_index addObject:[NSNumber numberWithInt:idx]];
                }
            }
        }
        
        [target setObject:button_index forKey:key];
    }
}




# pragma mark - prepare game


//prepare to start a game
- (void)startGame{
    
    self.turn = (self.turn == 1) ? 2 : 1;
    
    //hide ships
    for(UIButton *ship in ships_p1){
        ship.hidden = true;
    }
    for(UIButton *ship in ships_p2){
        ship.hidden = true;
    }
    
    
    //hide placedone button
    placeDoneButton.hidden = true;
    
    //add press action to buttons on both grid
    for(UIButton *button in grid_button_p1){
        [button addTarget:self action:@selector(pressGrid:) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = false;
    }
    
    for(UIButton *button in grid_button_p2){
        [button addTarget:self action:@selector(pressGrid:) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = false;
    }
    

    
    //show both grid
    grid_p1.hidden = false;
    grid_p2.hidden = false;
    
    //show player labels
    label_p1.hidden = false;
    label_p2.hidden = false;
    
  
    
    //computer ship locations in terms of button index
    [self compute_ship_index:1];
    [self compute_ship_index:2];
    
    
    //show player's own ships at his turn
    //NOTE: if you do not want show player's ships, comment out the following two lines
    [self show_ships:1];
    [self show_ships:2];
    
   
    
    //player 1 start guessing
    if(self.turn == 1){
        [self p1Turn];
        
    //player 2 start guessing
    }else{
        [self p2Turn];
        
    }

}


//player 1 places ships
- (void)p1PlaceShip{
    self.turn = 1;
    
    //hide player 2's grid
    grid_p2.hidden = true;
    label_p2.hidden = true;
    for(UIButton *ship in ships_p2){
        ship.hidden = true;
    }
    
    //show player 1's grid
    grid_p1.hidden = false;
    label_p1.hidden = false;
    for(UIButton *ship in ships_p1){
        ship.hidden = false;
    }
    
    //update text
    [label_p1 setText:@"Player 1: you start to place ships"];
    [current_turn setText:@"Player 1 is placing ships"];

}


//player 2 places ships
- (void)p2PlaceShip{
    self.turn = 2;
    
    //hide player 1's grid
    grid_p1.hidden = true;
    label_p1.hidden = true;
    for(UIButton *ship in ships_p1){
        ship.hidden = true;
    }
    
    //show player 2's grid
    grid_p2.hidden = false;
    label_p2.hidden = false;
    for(UIButton *ship in ships_p2){
        ship.hidden = false;
    }
    
    //update text
    [label_p2 setText:@"Player 2: you start to place ships"];
    [current_turn setText:@"Player 2 is placing ships"];
}





# pragma mark - game in process

//press a button on the grid
- (void)pressGrid:(UIButton *)button{
    
    //prevent player from duplicate attack
    if(isClicked){
        [self duplicateAttackAlert];
    }else{
        //get text of touched button
        NSString *text = [button titleForState:UIControlStateNormal];
        
        //button already pressed
        if([text isEqualToString:@"O"] || [text isEqualToString:@"X"]){
            [self pressOccupiedButtonMessage];
            [game_info setText:@"Cannot press this button"];
            
            //click fails
            isClicked = false;
            
        //button not pressed before
        }else{
            CGPoint pressedCenter = [button center];
            
            BOOL hit = false;
            NSMutableDictionary *check_target = (self.turn == 1) ? ship_to_loc_p2 : ship_to_loc_p1;
            
            NSArray *keys = [NSArray arrayWithObjects:@"large", @"medium", @"small1", @"small2", @"tiny", nil];
            for(NSString *key in keys){
                NSArray *ship = [check_target objectForKey:key];
            
                for(int pos=0; pos<[ship count]; pos++){
                    if(ship[pos] != [NSNull null]){
                        NSValue *posValue = ship[pos];
                        //part of a ship is hit
                        if(posValue.CGPointValue.x == pressedCenter.x && posValue.CGPointValue.y==pressedCenter.y){
                            //use marker [NSNull null] to mark a hit
                            NSMutableArray *temp = [NSMutableArray arrayWithArray:ship];
                            [temp replaceObjectAtIndex:pos withObject:[NSNull null]];
                            [check_target setObject:temp forKey:key];
                            hit = true;
                            break;
                        }
                    }
                }
            }
            
            //ship hit
            if(hit){
                //update scores
                if(self.turn == 1){
                    p1_score += 5;
                }else{
                    p2_score += 5;
                }
                
                //use marker "X" for a hit
                [button setBackgroundImage:[UIImage imageNamed:@"explode.jpg"] forState:UIControlStateNormal];
                [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
                [button setBackgroundImage:nil forState:UIControlStateNormal];
                [button setTitle:@"X" forState:UIControlStateNormal];
                [game_info setText:@"a ship is hit"];
                
            //ship not hit
            }else{
                //update scores
                if(self.turn == 1){
                    p1_score -= 1;
                }else{
                    p2_score -= 1;
                }
                
                //use marker "O" for a hit
                [button setBackgroundImage:[UIImage imageNamed:@"explode.jpg"] forState:UIControlStateNormal];
                [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
                [button setBackgroundImage:nil forState:UIControlStateNormal];
                [button setTitle:@"O" forState:UIControlStateNormal];
                [game_info setText:@"A miss"];
            }
            
            //check if game ends
            [self checkGameState];
            
            //give some time for player to transfer iPad to another player
            [game_info setText:@"Click on the button below and hand iPad to the other player NOW"];
            switch_turn_button.hidden = false;
            
            //successful click
            isClicked = true;
            
        }
        
    }
}

- (IBAction)switchTurn:(id)sender {
    
    //hide all buttons for 2s
    for(UIButton *button in grid_button_p1){
        button.hidden = true;
    }
    for(UIButton *button in grid_button_p2){
        button.hidden = true;
    }
    
    //reset isClicked
    isClicked = false;
    
    
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    //switch turns
    if(self.turn == 1){
        [self p2Turn];
    }else{
        [self p1Turn];
    }
}


# pragma mark - player's turn

//player 1's turn
- (void)p1Turn{
    
    switch_turn_button.hidden = true;
    
    self.turn = 1;
    
    //show buttons
    for(UIButton *button in grid_button_p1){
        button.hidden = false;
    }
    for(UIButton *button in grid_button_p2){
        button.hidden = false;
    }
    
    
    //hiden own buttons to press
    for(UIButton *button in grid_button_p1){
        button.enabled = false;
    }
    
    //show player 2's button to press
    for(UIButton *button in grid_button_p2){
        button.enabled = true;
    }
    
   
    //update labels
    [label_p1 setText:[NSString stringWithFormat:@"Player 1 (score %d)", p1_score]];
    NSString *status = [NSString stringWithFormat:@"Target Ocean(ships left: %d)", p2_left];
    [label_p2 setText:status];
    [current_turn setText:@"Current turn: player 1"];
    [game_info setText:@"Click on target ocean"];
    
    p1_attack_p2.hidden = false;
    p2_attack_p1.hidden = true;
    
}


//player 2's turn
- (void)p2Turn{
    
    switch_turn_button.hidden = true;
    
    self.turn = 2;
    
    //show buttons
    for(UIButton *button in grid_button_p1){
        button.hidden = false;
    }
    for(UIButton *button in grid_button_p2){
        button.hidden = false;
    }
    
    
    //hiden own buttons to press
    for(UIButton *button in grid_button_p2){
        button.enabled = false;
    }
    
    //show player 1's button to press
    for(UIButton *button in grid_button_p1){
        button.enabled = true;
    }
    
 
    //update labels
    [label_p2 setText:[NSString stringWithFormat:@"Player 2 (score %d)", p2_score]];
    NSString *status = [NSString stringWithFormat:@"Target Ocean(ships left: %d)", p1_left];
    [label_p1 setText:status];
    [current_turn setText:@"Current turn: player 2"];
    [game_info setText:@"Click on target ocean"];
    
    p1_attack_p2.hidden = true;
    p2_attack_p1.hidden = false;
    
}





# pragma mark - game checkings

//check game state
- (void)checkGameState{
    int num_ships_down = 0;
    
    NSArray *keys = [NSArray arrayWithObjects:@"large", @"medium", @"small1", @"small2", @"tiny", nil];
    NSMutableDictionary *check_target = (self.turn==1) ? ship_to_loc_p2 : ship_to_loc_p1;
    
    for(NSString *key in keys){
        BOOL is_ship_down = true;
        NSArray *ship = [check_target objectForKey:key];
        for(int idx=0; idx<[ship count]; idx++){
            //at least one block of a ship is not hit
            if(ship[idx] != [NSNull null]){
                is_ship_down = false;
                break;
            }
        }
        
        //count how many ships are down
        if(is_ship_down){
            num_ships_down ++;
            
            //display the ships down
            NSMutableDictionary *dict = (self.turn==1) ? ship_index_p2 : ship_index_p1;
            NSMutableArray *grid = (self.turn==1) ? grid_button_p2 : grid_button_p1;
            NSArray *ship_buttons = [dict objectForKey:key];
            for(NSNumber *n in ship_buttons){
                UIButton *target = grid[[n intValue]];
                [target setBackgroundImage:[UIImage imageNamed:@"grey.png"] forState:UIControlStateNormal];
            }
            
        }
    }
    
    //a player wins
    if(num_ships_down == 5){
        int winner = self.turn;
        [self gameOver:winner];
    //game continues
    }else{
        
        //update the number of ships not down for each player
        if(self.turn == 1){
            if(num_ships_down != 5-p2_left){
                [ship_sunk_sound play];
                p2_left --;
            }
        }else{
            if(num_ships_down != 5-p1_left){
                [ship_sunk_sound play];
                p1_left --;
            }
            
        }
    }

}


//game over
- (void)gameOver:(int)winner{
    //disable all buttons and show all ships
    for(UIButton *button in grid_button_p1){
        button.enabled = false;
        button.hidden = true;
    }
    for(UIButton *button in grid_button_p2){
        button.enabled = false;
        button.hidden = true;
    }
    
    for(UIButton *ship in ships_p1){
        ship.hidden = false;
    }
    for(UIButton *ship in ships_p2){
        ship.hidden = false;
    }
    
    //display the winner
    if(winner == 1){
        [label_p1 setText:@"You are the winner"];
        [label_p2 setText:@"You lose"];
    }else{
        [label_p2 setText:@"You are the winner"];
        [label_p1 setText:@"You lose"];
        
    }
    
    [final_victory_sound play];
    [current_turn setText:@"Congrats!"];
    [game_info setText:@"Quit the game and start a new one"];
    
    
    //save winner score and current date to userdefault
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int winner_score = (winner==1) ? p1_score : p2_score;
    NSArray *scores = [defaults objectForKey:@"scores"];
    NSMutableArray *temp;
    if(scores == nil){
        temp = [NSMutableArray array];
    }else{
        temp = [NSMutableArray arrayWithArray:scores];
    }
    [temp addObject:[NSNumber numberWithInt:winner_score]];
    [defaults setObject:temp forKey:@"scores"];
    [defaults synchronize];

    
    
    [self gameOverMessage:winner];
    NSLog(@"game is over");
}




# pragma mark - utility functions

//return ship_type based on ship button
- (NSInteger)get_ship_type:(UIButton *)ship{
    if(ship == self.largeship_p1 || ship==self.largeship_p2){
        return 0;
    }else if(ship == self.mediumship_p1 || ship==self.mediumship_p2){
        return 1;
    }else if(ship == self.smallship_p1 || ship==self.smallship_p2){
        return 2;
    }else if(ship==self.smallship2_p1 || ship==self.smallship2_p2){
        return 3;
    }else{
        return 4;
    }
}


//return the string of the given ship
- (NSString *)get_ship_string:(UIButton *)ship{
    NSInteger ship_type = [self get_ship_type:ship];
    switch (ship_type) {
        case 0:
            return @"large";
            break;
        case 1:
            return @"medium";
            break;
        case 2:
            return @"small1";
            break;
        case 3:
            return @"small2";
            break;
        case 4:
            return @"tiny";
            break;
            
        default:
            return @"";
            break;
    }
}


//random turn
- (int)randomTurn{
    return arc4random()%2+1;
}



//setup audio player

- (AVAudioPlayer *)audioWithFileAndType:(NSString *)filename type:(NSString *)filetype {
    
    // build path to audio file
    NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:filetype];
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    //setup error handler
    NSError *player_error;
    
    //build audio player
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&player_error];
    
    //setup volume
    [player setVolume:0.3];
    return player;
}



//display ships of the given player
- (void)show_ships:(int)player{
    NSMutableDictionary *dict = (player==1) ? ship_index_p1 : ship_index_p2;
    NSMutableArray *grid = (player==1) ? grid_button_p1 : grid_button_p2;
    NSString *imgName = @"purple.png";
    for(NSArray *index in [dict allValues]){
        for(NSNumber *n in index){
            UIButton *target = grid[[n intValue]];
            [target setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateDisabled];
        }
    }
  
}





# pragma boundary_checking

//determine if the given ship overlaps with other ships
- (BOOL)isShipOverlap:(NSMutableArray *)ship_loc{
    NSMutableDictionary *check_target = (self.turn==1) ? ship_to_loc_p1 : ship_to_loc_p2;
    for(NSValue *ship_piece in ship_loc){
        for(NSArray *placed_ship in [check_target allValues]){
            for(NSValue *placed_ship_piece in placed_ship){
                //ship overlaps
                if(ship_piece.CGPointValue.x==placed_ship_piece.CGPointValue.x && ship_piece.CGPointValue.y==placed_ship_piece.CGPointValue.y){
                    return true;
                }
            }
        }
    }
    return false;
}


//check if the whole ship is placed within the grid
- (BOOL)isShipWithinGrid:(UIButton *)ship{
    float grid_origin_x = (self.turn==1) ? GRID_ONE_ORIGINX : GRID_TWO_ORIGINX;
    float grid_origin_y = (self.turn==1) ? GRID_ONE_ORIGINY : GRID_TWO_ORIGINY;
    
    BOOL check_x_boundary = ((ship.center.x - ship.bounds.size.width/2.0)>=grid_origin_x)
    && ((ship.center.x + ship.bounds.size.width/2.0)<=grid_origin_x+GRID_WIDTH);
    BOOL check_y_boundary = ((ship.center.y - ship.bounds.size.height/2.0)>=grid_origin_y)
    && ((ship.center.y + ship.bounds.size.height/2.0)<=grid_origin_y+GRID_HEIGHT);
    
    return check_x_boundary && check_y_boundary;
}





# pragma mark - alert views

- (void)gameStartMessage:(int)player{
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Welcome to the battle" message:[NSString stringWithFormat:@"Player %d: please strike your enemy's ship first", player] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [msg show];
}

- (void)gameOverMessage:(int)winner{
    int score = (winner==1) ? p1_score : p2_score;
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Winner: Player %d with score %d", winner, score] message:@"You can start a new game" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Play again", nil];
    [msg show];
}

- (void)pressOccupiedButtonMessage{
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Oops, something is wrong" message:@"You click on an occupied button" delegate:self cancelButtonTitle:@"I got it" otherButtonTitles:nil, nil];
    [msg show];
}

- (void)placeShipMessage:(int)player{
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Reminder" message:[NSString stringWithFormat:@"Player %d: please place your ships", player] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [msg show];
}



- (void)shipOutsideGridAlert{
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You place the ship out of the grid" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Place it again", nil];
    [msg show];
    
}

- (void)shipOverlapAlert{
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You place a ship on another ship" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Place it again", nil];
    [msg show];
    
}

- (void)duplicateAttackAlert{
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"You are cheating" message:@"You cannot attack twice in your turn" delegate:self cancelButtonTitle:nil otherButtonTitles:@"I'm Sorry", nil];
    [msg show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonPressed = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonPressed isEqualToString:@"Play again"]){
        [self initGame];
    }else if([buttonPressed isEqualToString:@"Start over"]){
        [self initGame];
    }else if([buttonPressed isEqualToString:@"Place it again"]){
        
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
