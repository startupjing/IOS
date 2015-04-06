//
//  SinglePlayer.m
//  Lu_Lab5
//
//  Created by Labuser on 3/21/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import "SinglePlayer.h"
#import <AVFoundation/AVFoundation.h>


@implementation SinglePlayer

//synthesize variable names
@synthesize largeship_p1, mediumship_p1, smallship_p1, smallship2_p1, tinyship_p1, largeship_p2, mediumship_p2, smallship_p2, smallship2_p2, tinyship_p2;
@synthesize grid_p1, grid_p2, human_attack_AI, AI_attack_human;
@synthesize label_p1, label_p2, current_turn, game_info, p1_left, p2_left, placeDoneButton;
@synthesize ships_p1, ships_p2, human_ships, grid_button_p1, grid_button_p2, ship_to_loc_p1, ship_to_loc_p2, ship_index_p1, ship_index_p2;
@synthesize attack_direction, smart_moves, game_option;



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

//number of buttons
#define NUM_SPOTS 100

//number of ships
#define NUM_SHIPS 5;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set background image
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

    //initialize the game
    [self initGame];
}

# pragma mark - initialization

- (void)initGame{
    
    
    //let user choose game option
    [self gameOptionAlert];
    
    //number of initial ships
    self.p1_left = NUM_SHIPS;
    self.p2_left = NUM_SHIPS;
    
    //assign five ships to each player
    ships_p1 = [[NSMutableArray alloc] initWithObjects:largeship_p1, mediumship_p1, smallship_p1, smallship2_p1, tinyship_p1, nil];
    ships_p2 = [[NSMutableArray alloc] initWithObjects:largeship_p2, mediumship_p2, smallship_p2, smallship2_p2, tinyship_p2, nil];
    human_ships = [NSMutableArray arrayWithObjects:@"large", @"medium", @"small1", @"small2", @"tiny", nil];
    
    //initialize ship locations
    ship_to_loc_p1 = [[NSMutableDictionary alloc] init];
    ship_to_loc_p2 = [[NSMutableDictionary alloc] init];
    ship_index_p1 = [[NSMutableDictionary alloc] init];
    ship_index_p2 = [[NSMutableDictionary alloc] init];
    
    
    //display placement done button
    placeDoneButton.hidden = false;
    
    //create buttons for the grid
    grid_button_p1 = [NSMutableArray array];
    grid_button_p2 = [NSMutableArray array];
    
    
    //sound fil
    ship_sunk_sound = [self audioWithFileAndType: @"ship_sunk" type:@"mp3"];
    final_victory_sound = [self audioWithFileAndType:@"winner" type:@"mp3"];
    
    //label font
    game_info.font = [UIFont boldSystemFontOfSize:25.0f];
    
    //setup AI brain
    AI_last_hit = false;
    first_hit_index = -1;
    attack_begin = false;
    attack_direction = [NSMutableString stringWithFormat:@""];
    smart_moves = [[NSMutableDictionary alloc] init];
    
    //game option
    game_option = [NSMutableString stringWithFormat:@"Easy"];
    
    //hide missile image
    AI_attack_human.hidden = true;
    human_attack_AI.hidden = true;
    
    //initial scores
    p1_score = 0;
    p2_score = 0;
 
    
    //add touch events handler to ship buttons
    int n = NUM_SHIPS;
    for(int ship_idx=0; ship_idx < n; ship_idx++){
        //drap ships
        [ships_p1[ship_idx] addTarget:self action:@selector(dragShip:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [ships_p1[ship_idx] addTarget:self action:@selector(dragShip:withEvent:) forControlEvents:UIControlEventTouchDragOutside];

        //drop ships
        [ships_p1[ship_idx] addTarget:self action:@selector(dropShip:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [ships_p1[ship_idx] addTarget:self action:@selector(dropShip:withEvent:) forControlEvents:UIControlEventTouchUpOutside];

        //use double tap to rotate ships
        UITapGestureRecognizer *tapRotate = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(tapToRotate:)];
        tapRotate.numberOfTapsRequired = 2;
        [ships_p1[ship_idx] addGestureRecognizer:tapRotate];
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
                
                //use ocean image as background
                [b setBackgroundImage:[UIImage imageNamed:@"ocean_img.png"] forState:UIControlStateNormal];
                
                //add borders
                [[b layer] setBorderWidth:0.5f];
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
    if([self randomTurn] == 1){;
        NSLog(@"human places ship first");
        
        self.turn = 1;
        [self placeShipMessage:self.turn];
        [self humanPlaceShip];

    }else{
        self.turn = 2;
        NSLog(@"AI places ship first");
        
        //AI randomly place ships
        [self computerPlace];
        NSLog(@"AI finish placing ships");
     

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






# pragma mark - adjust placement


//return adjusted center of the ship when player drops the ship to match up with grid
- (CGPoint)adjust_center:(NSString *)direction withCenter:(CGPoint)center withType:(NSInteger)ship_type{
    
    //determine origin of grid based on current player
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



# pragma mark - process ship locations

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

//AI place ships
- (void)computerPlace{
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
    [label_p2 setText:@"AI: start placing ships"];
    [current_turn setText:@"AI is placing ships"];
    
    int num = NUM_SHIPS;
    for(int ship_no=0; ship_no<num; ship_no++){
        UIButton *ship = ships_p2[ship_no];
        
        //get a random orientation
        NSString *randomDirection = [self randomDirection];
        
        //rotate the ship if needed
        if([randomDirection isEqualToString:@"vertical"]){
            CGRect temp = ship.bounds;
            temp.size = CGSizeMake(ship.frame.size.height, ship.frame.size.width);
            ship.bounds = temp;
        }
        
        NSInteger ship_type = [self get_ship_type:ship];
        
        //get a random ship_center
        CGPoint random_ship_center = [self random_center:randomDirection withType:ship_type];
        NSMutableArray *ship_loc = [self find_ship_centers:randomDirection withCenter:random_ship_center withShipType:ship_type];
        
        //keep trying if random location of the ship has overlap with other ships
        BOOL shipOverlap = [self isShipOverlap:ship_loc];
        while(shipOverlap){
            random_ship_center = [self random_center:randomDirection withType:ship_type];
            ship_loc = [self find_ship_centers:randomDirection withCenter:random_ship_center withShipType:ship_type];
            shipOverlap = [self isShipOverlap:ship_loc];
        }
        
        [self setShips:ship_loc withShip:ship];
        ship.center = random_ship_center;
        
        
    }
    
    //alert view to indicate AI finishes placing ships
    [self computerPlaceDone];
    
    //let human player place the ships or start the game
    if([ship_to_loc_p1 count] == 5){
        [self startGame];
    }else{
        [self placeShipMessage:1];
        [self humanPlaceShip];
    }
    
}




//human player place ships
- (void)humanPlaceShip{
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
    [label_p1 setText:@"Human: you start to place ships"];
    [current_turn setText:@"Human is placing ships"];
    
}


//put centers of blocks of the ship in ships_loc array
- (void)setShips:(NSMutableArray *)ship_loc withShip:(UIButton *)ship{
    if(self.turn == 1){
        [ship_to_loc_p1 setObject:ship_loc forKey:[self get_ship_string:ship]];
    }else{
        [ship_to_loc_p2 setObject:ship_loc forKey:[self get_ship_string:ship]];
    }
}


//method called when user click on placement done button
- (IBAction)placementDone:(id)sender {
 
    //check if human player has placed all ships into grid
    for(UIButton *ship in ships_p1){
        if(![self isShipWithinGrid:ship]){
            [self shipOutsideGridAlert];
            return;
        }
    }
    
    //remove event handlers from ship buttons
    for(UIButton *ship in ships_p1){
        //remove selectors for dragging and dropping ships
        [ship removeTarget:self action:@selector(dragShip:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [ship removeTarget:self action:@selector(dragShip:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
        [ship removeTarget:self action:@selector(dropShip:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [ship removeTarget:self action:@selector(dropShip:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
        
        // remove double tap handler
        for (UIGestureRecognizer *recognizer in ship.gestureRecognizers) {
            [ship removeGestureRecognizer: recognizer];
        }
    }
    
    
    //let AI place the ship or start the game
    if([[ship_to_loc_p2 allKeys] count] == 5){
        [self startGame];
    }else{
        [self computerPlace];
    }
    
}





# pragma mark - prepare game


//prepare to start a game
- (void)startGame{
    
    
    
    //start the game based on who places ships first
    self.turn = (self.turn == 1) ? 2 : 1;
    
    //hide ships
    for(UIButton *ship in ships_p1){
        ship.hidden = true;
    }
    for(UIButton *ship in ships_p2){
        ship.hidden = true;
    }
    
    //hide placement done button
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
    
    //compute ship locations in terms of button index
    [self compute_ship_index:1];
    [self compute_ship_index:2];
    
    
    //show human player's ships in his turn
    //NOTE: if you do not want to show human's ships, comment the following line
    [self show_ships:1];
    //[self show_ships:2];
    
    
    //human starts guessing
    if(self.turn == 1){
        NSLog(@"human starts guessing");
        [self humanTurn];
    //AI starts guessing
    }else{
        NSLog(@"AI starts guessing");
        [self computerTurn];
        
    }
    
}




# pragma mark - game in process

//method called when button on the grid is pressed
- (void)pressGrid:(UIButton *)button{
    //get text of touched button
    NSString *text = [button titleForState:UIControlStateNormal];
    
    //button already pressed
    if([text isEqualToString:@"O"] || [text isEqualToString:@"X"]){
        [self pressOccupiedButtonMessage];
        [game_info setText:@"Cannot press this button"];
        
    //button not pressed before
    }else{
        CGPoint pressedCenter = [button center];
        BOOL hit = false;
        NSMutableDictionary *check_target = (self.turn == 1) ? ship_to_loc_p2 : ship_to_loc_p1;
        NSArray *keys = [NSArray arrayWithObjects:@"large", @"medium", @"small1", @"small2", @"tiny", nil];
        
        //check if part of ship is hit
        for(NSString *key in keys){
            NSArray *ship = [check_target objectForKey:key];
            for(int pos=0; pos<[ship count]; pos++){
                if(ship[pos] != [NSNull null]){
                    NSValue *posValue = ship[pos];
                    //part of ship is hit
                    if(posValue.CGPointValue.x == pressedCenter.x && posValue.CGPointValue.y==pressedCenter.y){
                        
                        //set a marker using [NSNull null]
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
            
            //update score
            if(self.turn == 1){
                p1_score += 5;
            }else{
                p2_score += 5;
            }
            
            //AI's strategy
            if(self.turn == 2){
                
                //start hard_strike mode if needed
                if(!attack_begin){
                    first_hit_index = (int)[grid_button_p1 indexOfObjectIdenticalTo:button];
                    //NSLog(@"first hit index: %d", first_hit_index);
                    attack_begin = true;
                    attack_direction = [NSMutableString stringWithFormat:@""];
                    
                    //compute possible adjacent moves
                    [self computeSmartMoves];
                }
            
                AI_last_hit = true;
            }
            
            //set marker "X" if hit
            [button setBackgroundImage:[UIImage imageNamed:@"explode.jpg"] forState:UIControlStateNormal];
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
            [button setBackgroundImage:nil forState:UIControlStateNormal];
            [button setTitle:@"X" forState:UIControlStateNormal];
            [game_info setText:@"Part of a ship is hit"];
            
        //ship not hit
        }else{
            
            //update scores
            if(self.turn == 1){
                p1_score -= 1;
            }else{
                p2_score -= 1;
            }
            
            //AI's strategy
            if(self.turn == 2){
                AI_last_hit = false;
            }
            
            //set marker "O" if not hit
            [button setBackgroundImage:[UIImage imageNamed:@"explode.jpg"] forState:UIControlStateNormal];
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
            [button setBackgroundImage:nil forState:UIControlStateNormal];
            [button setTitle:@"O" forState:UIControlStateNormal];
            [game_info setText:@"A miss"];
        }
        
        //check game state
        [self checkGameState];
        
        
        //switch turns
        if(self.turn == 1){
            [self computerTurn];
        }else{
            [self humanTurn];
        }
        
    }
}



# pragma mark - player's turn

//human's turn
- (void)humanTurn{
    self.turn = 1;
    
    //disable own buttons
    for(UIButton *button in grid_button_p1){
        button.enabled = false;
    }
    
    //enable player 2's button to press
    for(UIButton *button in grid_button_p2){
        button.enabled = true;
    }
    
    //update label
    [label_p1 setText:[NSString stringWithFormat:@"Human (score %d)", p1_score]];
    NSString *status = [NSString stringWithFormat:@"Target Ocean(ships left: %d)", p2_left];
    [label_p2 setText:status];
    [current_turn setText:@"Current turn: Human"];
    [game_info setText:@"Click on target ocean"];
    
    human_attack_AI.hidden = false;
    AI_attack_human.hidden = true;
    
    NSLog(@"human's turn done");
}


//AI's turn
- (void)computerTurn{
    self.turn = 2;
    
    //disable own buttons
    for(UIButton *button in grid_button_p2){
        button.enabled = false;
    }
    
    //enable player 1's button to press
    for(UIButton *button in grid_button_p1){
        button.enabled = true;
    }
    
    
    //update labels
    [label_p2 setText:[NSString stringWithFormat:@"AI (score %d)" ,p2_score]];
    NSString *status = [NSString stringWithFormat:@"Target Ocean(ships left: %d)", p1_left];
    [label_p1 setText:status];
    [current_turn setText:@"Current turn: AI"];
    [game_info setText:@"Click on target ocean"];
    
    AI_attack_human.hidden = false;
    human_attack_AI.hidden = true;
    
    //let AI think for a moment
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    
    
    //choose strategy based on game option
    if([game_option isEqualToString:@"Easy"]){
        [self randomHit];
    }else{
        [self smartHit];

    }
    
    
    NSLog(@"AI's turn done");
}


//pick a random position on human's grid and hit
- (void)randomHit{
    int randomPosition = arc4random() % NUM_SPOTS;
    UIButton *target = grid_button_p1[randomPosition];
    NSString *text = [target titleForState:UIControlStateNormal];
    
    //keep finding a valid position
    while(![text isEqualToString:@""]){
        randomPosition = arc4random() % NUM_SPOTS;
        target = grid_button_p1[randomPosition];
        text = [target titleForState:UIControlStateNormal];
    }
    
    //NSLog(@"------ Random Hit -----");
    //NSLog(@"Random hit index: %d", randomPosition);
    
    //press selected spot
    [self pressGrid:target];
}



//pick a position on human's grid with smart strategy
- (void)smartHit{

    //hard_strike mode: keep striking a ship until it is down
    if(attack_begin && [smart_moves count]>0 && [[smart_moves objectForKey:[smart_moves allKeys][0]] count]>0){
        
        if(AI_last_hit){
            
            //eliminate either horizontal move or vertical move if attack direction is confirmed
            if(![attack_direction isEqualToString:@""]){
                if([attack_direction isEqualToString:@"left"] || [attack_direction isEqualToString:@"right"]){
                    
                    if([[smart_moves allKeys] containsObject:@"up"]){
                        [smart_moves removeObjectForKey:@"up"];
                        NSLog(@"Confirm horizontal attack: remove up direction");
                    }
                    if([[smart_moves allKeys] containsObject:@"down"]){
                        [smart_moves removeObjectForKey:@"down"];
                        NSLog(@"Confirm horizontal attack: remove down direction");
                    }
                }
                
                if([attack_direction isEqualToString:@"up"] || [attack_direction isEqualToString:@"down"]){
                    if([[smart_moves allKeys] containsObject:@"left"]){
                        [smart_moves removeObjectForKey:@"left"];
                        NSLog(@"Confirm vertical attack: remove left direction");
                    }
                    if([[smart_moves allKeys] containsObject:@"right"]){
                        [smart_moves removeObjectForKey:@"right"];
                        NSLog(@"Confirm vertical attack: remove right direction");
                    }
                }
            }
            
            
            //select attack direction
            attack_direction = [NSMutableString stringWithString:[smart_moves allKeys][0]];
            NSMutableArray *movesInDirection = [smart_moves objectForKey:attack_direction];
            
            //determine the spot to hit
            int next_idx = [movesInDirection[0] intValue];
            
            //update AI's mind
            [movesInDirection removeObject:[NSNumber numberWithInt:next_idx]];
            if([movesInDirection count] > 0){
                [smart_moves setObject:movesInDirection forKey:attack_direction];
            }else{
                [smart_moves removeObjectForKey:attack_direction];
            }
            
            //NSLog(@"--- smart hit ----");
            //NSLog(@"Index: %d, Direction: %@", next_idx, attack_direction);
            
            //hit the selected spot
            [self pressGrid:grid_button_p1[next_idx]];
            
        //if not hit last time, remove moves for last direction and try a new direction
        }else{
            //NSLog(@"Last attack not successful, remove direction: %@", attack_direction);
            
            //remove possible for previous direction
            if([attack_direction isEqualToString:@"left"]){
                [smart_moves removeObjectForKey:@"left"];
            }else if([attack_direction isEqualToString:@"right"]){
                [smart_moves removeObjectForKey:@"right"];
            }else if([attack_direction isEqualToString:@"up"]){
                [smart_moves removeObjectForKey:@"up"];
            }else{
                [smart_moves removeObjectForKey:@"down"];
            }
            
            //pick another direction if possible and hit
            if([smart_moves count] > 0){
                attack_direction = [NSMutableString stringWithString:[smart_moves allKeys][0]];
                NSMutableArray *movesInDirection = [smart_moves objectForKey:attack_direction];
                int next_idx = [movesInDirection[0] intValue];
                
                //update AI's mind
                [movesInDirection removeObject:[NSNumber numberWithInt:next_idx]];
                if([movesInDirection count] > 0){
                    [smart_moves setObject:movesInDirection forKey:attack_direction];
                }else{
                    [smart_moves removeObjectForKey:attack_direction];
                }
                
                //NSLog(@"--- smart hit ----");
                //NSLog(@"Index: %d, Direction: %@", next_idx, attack_direction);
                
                [self pressGrid:grid_button_p1[next_idx]];
            }else{
                
                //clear AI's mind
                attack_begin = false;
                [smart_moves removeAllObjects];
                first_hit_index = -1;
                attack_direction = [NSMutableString stringWithFormat:@""];
                NSLog(@"reset AI mind");
                
                [self randomHit];
            }
        }
        
    //AI targets random position if not in hard_strike mode
    }else{
        [self randomHit];
    }
    
}


//compute smart possible moves in each direction
- (void)computeSmartMoves{
    int maxLength = 0;
    
    //determine the length of largest ship not down up to now
    if([human_ships containsObject:@"tiny"]){
        maxLength = 2;
    }
    if([human_ships containsObject:@"small1"] || [human_ships containsObject:@"small2"]){
        maxLength = 3;
    }
    if([human_ships containsObject:@"medium"]){
        maxLength = 4;
    }
    if([human_ships containsObject:@"large"]){
        maxLength = 5;
    }
    
    //compute smart moves in each direction
    NSArray *directions = [NSArray arrayWithObjects:@"left", @"right", @"up", @"down", nil];
    for(NSString *key in directions){
        NSMutableArray *moves = [self extendToDirection:key withLimit:maxLength-1];
        if([moves count] > 0){
            [smart_moves setObject:moves forKey:key];
        }
    }
    
    
    //NSLog(@"------Strategy------");
    //NSLog(@"first hit index: %d", first_hit_index);
    //for(NSString *key in [smart_moves allKeys]){
    //    NSLog(@"Direction: %@, Moves: %@", key, [smart_moves objectForKey:key]);
    //}
}


//compute possible moves in the given direction
- (NSMutableArray *)extendToDirection:(NSString *)direction withLimit:(int)limit{
    NSMutableArray *moves = [NSMutableArray array];
    
    if(limit <= 0){
        return moves;
    }
    
    //determine the furtherest distance to extend in the given direction
    if([direction isEqualToString:@"left"]){
        limit = MIN(limit, first_hit_index/10);
    }else if([direction isEqualToString:@"right"]){
        limit = MIN(limit, 9 - first_hit_index/10);
    }else if([direction isEqualToString:@"up"]){
        limit = MIN(limit, first_hit_index%10);
    }else{
        limit = MIN(limit, 9-first_hit_index%10);
    }
    
    
    //extend possible moves in the given direction
    for(int i=1; i<=limit; i++){
        if([direction isEqualToString:@"left"]){
            if([self validGuess:first_hit_index-10*i]){
                [moves addObject:[NSNumber numberWithInt:first_hit_index-10*i]];
            }else{
                NSLog(@"An invalid spot stops finding smart moves in left direcrtion");
                break;
            }
        }
        if([direction isEqualToString:@"right"]){
            if([self validGuess:first_hit_index+10*i]){
                [moves addObject:[NSNumber numberWithInt:first_hit_index+10*i]];
            }else{
                NSLog(@"An invalid spot stops finding smart moves in right direcrtion");
                break;
            }
        }
        if([direction isEqualToString:@"up"]){
            if([self validGuess:first_hit_index-i]){
                [moves addObject:[NSNumber numberWithInt:first_hit_index-i]];
            }else{
                NSLog(@"An invalid spot stops finding smart moves in up direcrtion");
                break;
            }
        }
        if([direction isEqualToString:@"down"]){
            if([self validGuess:first_hit_index+i]){
                [moves addObject:[NSNumber numberWithInt:first_hit_index+i]];
            }else{
                NSLog(@"An invalid spot stops finding smart moves in down direcrtion");
                break;
            }
        }
   
    }
    return moves;
}



# pragma mark - game checkings

//check game state
- (void)checkGameState{
    int num_ships_down = 0;
    
    NSArray *keys = [NSArray arrayWithObjects:@"large", @"medium", @"small1", @"small2", @"tiny", nil];
    NSMutableDictionary *check_target = (self.turn==1) ? ship_to_loc_p2 : ship_to_loc_p1;
    
    //check state of each kind of ship
    for(NSString *key in keys){
        BOOL is_ship_down = true;
        NSArray *ship = [check_target objectForKey:key];
        
        //check through blocks of the ship
        for(int idx=0; idx<[ship count]; idx++){
            //at least one block of a ship is not hit
            if(ship[idx] != [NSNull null]){
                is_ship_down = false;
                break;
            }
        }
        
        //a ship is down
        if(is_ship_down){
            
            //update AI's mind
            if(self.turn == 2){
                if([human_ships containsObject:key]){
                    [human_ships removeObject:key];
                }
            }
            
            //display the ships down
            NSMutableDictionary *dict = (self.turn==1) ? ship_index_p2 : ship_index_p1;
            NSMutableArray *grid = (self.turn==1) ? grid_button_p2 : grid_button_p1;
            NSArray *ship_buttons = [dict objectForKey:key];
            for(NSNumber *n in ship_buttons){
                UIButton *target = grid[[n intValue]];
                [target setBackgroundImage:[UIImage imageNamed:@"grey.png"] forState:UIControlStateNormal];
            }

            
            //count the number of ships down
            num_ships_down ++;
        }
        
        
    }
    
    //one of the players wins
    if(num_ships_down == 5){
        int winner = self.turn;
        [self gameOver:winner];
    //game continues
    }else{
        
        //update number of ships not down for each player
        if(self.turn == 1){
            if(num_ships_down != 5-p2_left){
                [ship_sunk_sound play];
                p2_left --;
            }
        }else{
            if(num_ships_down != 5-p1_left){
                [ship_sunk_sound play];
                
                //clear AI's mind if hit a whole ship
                attack_begin = false;
                [smart_moves removeAllObjects];
                first_hit_index = -1;
                attack_direction = [NSMutableString stringWithFormat:@""];
                NSLog(@"reset AI mind");
                
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
    
    //update label to show the winner
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
    
    //alert message
    [self gameOverMessage:winner];

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


//randomly select an orientation
- (NSString *)randomDirection{
    int rand = arc4random() % 2;
    if(rand == 0){
        return @"vertical";
    }else{
        return @"horizontal";
    }
}



//randomly select a center of the given ship type
- (CGPoint)random_center:(NSString *)direction withType:(NSInteger)ship_type{
    CGPoint random_center;
    float random_x, random_y;
    
    //ships with even length
    if(ship_type==1 || ship_type==4){
        if([direction isEqualToString:@"vertical"]){
            random_x = GRID_TWO_ORIGINX + CELLSIZE/2.0 + (arc4random() % 10)*CELLSIZE;
            random_y = GRID_TWO_ORIGINY + 2*CELLSIZE + (arc4random() % 7)*CELLSIZE;
        }else{
            random_x = GRID_TWO_ORIGINX + 2*CELLSIZE + (arc4random() % 7)*CELLSIZE;
            random_y = GRID_TWO_ORIGINY + CELLSIZE/2.0 + (arc4random() % 10)*CELLSIZE;
        }
    //ships with odd length
    }else{
        if([direction isEqualToString:@"vertical"]){
            random_x = GRID_TWO_ORIGINX + CELLSIZE/2.0 + (arc4random() % 10)*CELLSIZE;
            random_y = GRID_TWO_ORIGINY + 2.5*CELLSIZE + (arc4random() % 6)*CELLSIZE;
        }else{
            random_x = GRID_TWO_ORIGINX + 2.5*CELLSIZE + (arc4random() % 6)*CELLSIZE;
            random_y = GRID_TWO_ORIGINY + CELLSIZE/2.0 + (arc4random() % 10)*CELLSIZE;
        }
    }
    random_center = CGPointMake(random_x, random_y);
    return random_center;
    
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



//determine if given button index on the grid is valid
- (BOOL)validGuess:(int)button_idx{
    //button index out of bound
    if(button_idx<0 || button_idx>=100){
        return false;
    }
    //button should not be pressed before
    NSString *text = [grid_button_p1[button_idx] titleForState:UIControlStateNormal];
    return [text isEqualToString:@""];
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
                //button index found for the block of a ship
                if(button.center.x==posValue.CGPointValue.x && button.center.y==posValue.CGPointValue.y){
                    int idx = (int)[grid indexOfObject:button];
                    [button_index addObject:[NSNumber numberWithInt:idx]];
                }
            }
        }
        
        [target setObject:button_index forKey:key];
    }
}


//display ships for the given player
- (void)show_ships:(int)player{
    NSMutableDictionary *dict = (player==1) ? ship_index_p1 : ship_index_p2;
    NSMutableArray *grid = (player==1) ? grid_button_p1 : grid_button_p2;
    for(NSArray *index in [dict allValues]){
        for(NSNumber *n in index){
            UIButton *target = grid[[n intValue]];
            [target setBackgroundImage:[UIImage imageNamed:@"purple.png"] forState:UIControlStateDisabled];
        }
    }
}


//return string for the given player
- (NSString *)get_player_string:(int)player{
    return (player==1) ? @"Human" : @"AI";
}


# pragma boundary_checking

//determine if a ship overlaps with another ship
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
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Welcome to the battle" message:[NSString stringWithFormat:@"%@: please strike your enemy's ship first", [self get_player_string:player]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [msg show];
}

- (void)gameOverMessage:(int)winner{
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Winner: %@", [self get_player_string:winner]] message:@"You can start a new game" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Play again", nil];
    [msg show];
}

- (void)pressOccupiedButtonMessage{
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Oops, something is wrong" message:@"You click on an occupied button" delegate:self cancelButtonTitle:@"I got it" otherButtonTitles:nil, nil];
    [msg show];
}

- (void)placeShipMessage:(int)player{
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Reminder" message:[NSString stringWithFormat:@"%@: please place your ships", [self get_player_string:player]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [msg show];
}

- (void)computerPlaceDone{
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Game Info" message:@"Computer have finished placing ships" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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

- (void)gameOptionAlert{
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Welcome to battle with AI" message:@"Please choose battle option" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Easy",@"Hard", nil];
    [msg show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonPressed = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonPressed isEqualToString:@"Play again"]){
        [self initGame];
    }else if([buttonPressed isEqualToString:@"Start over"]){
        [self initGame];
    }else if([buttonPressed isEqualToString:@"Hard"]){
        game_option = [NSMutableString stringWithFormat:@"Hard"];
    }else if([buttonPressed isEqualToString:@"Easy"]){
        game_option = [NSMutableString stringWithFormat:@"Easy"];
    }else{
        
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
