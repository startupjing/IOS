//
//  ViewController.m
//  Lu-Lab2
//
//  Created by Labuser on 2/21/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//



//NOTE: Please ignore the files created in model folder. They are just my previous attempts
//      Run the project on iPhone 6


#import "ViewController.h"


@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *boardCells; //ignore this
@property (strong, nonatomic) IBOutlet UILabel *playerLabel; //text label to display game state
@property (nonatomic)NSInteger gameMode; //1 for single player and 2 for two players
@property (strong, nonatomic)NSString *currentPlayer;
@property (strong, nonatomic)NSMutableArray *cells;
@property (strong, nonatomic)NSString *winner;
@property (strong, nonatomic)NSString *message;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons; //store buttons on storyboard
@property (strong, nonatomic)NSString *label1;
@property (strong, nonatomic)NSString *label2;

@end

@implementation ViewController




//decide piece randomly
- (void)randomPiece{
    int rand = arc4random()%2;
    if(rand == 0){
        self.label1 = @"X";
        self.label2 = @"O";
    }else{
        self.label1 = @"O";
        self.label2 = @"X";
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // initiliza the game
    [self initGame];
    
    //build initial display
    self.cells = [[NSMutableArray alloc] initWithObjects:@"Here",@"Here",@"Here",@"Here",@"Here",@"Here",@"Here",@"Here",@"Here",nil];
    
    //decide piece randomly
    [self randomPiece];
    
    //print welcome message
    [self welcomeMessage];
    
}



- (IBAction)buttonPressed:(UIButton *)sender {
    
    //get the index of pressed button
    NSInteger chosenIndex = [self.buttons indexOfObject:sender];
    
    //two players game
    if(self.gameMode == 2){
        NSString *chosenLabel = [sender currentTitle];
        
        //cannot press occupied cell
        if(![chosenLabel isEqualToString:@"Here"]){
            self.message = [NSString stringWithFormat:@"You cannot choose occupied cell"];
            [self alertMessage];
         
        }else{
            if([[_cells objectAtIndex:chosenIndex] isEqualToString:@"Here"]){
                
                //decide marker for corresponding player
                NSString *playerLabel;
                if([self.currentPlayer isEqualToString:@"Player One"]){
                    playerLabel = self.label1;
                }else{
                    playerLabel = self.label2;
                }
                
                //update button display
                [sender setTitle:playerLabel forState:UIControlStateNormal];
                [_cells replaceObjectAtIndex:chosenIndex withObject: playerLabel];
                
                //game over
                if([self isOver]){
                    self.winner = [NSString stringWithString:self.currentPlayer];
                    self.message = [[NSString stringWithFormat:@"Winner is: "] stringByAppendingString:self.winner];
                    [self finalMessage];
                //game tie
                }else if(![self isOver] && ![self.cells containsObject:@"Here"]){
                    self.message = [NSString stringWithFormat:@"Oops, it is a tie"];
                    [self finalMessage];
                //decide next turn
                }else{
                    self.currentPlayer = [self.currentPlayer isEqualToString:@"Player One"] ?  @"Player Two" : @"Player One";
                    [self updateUI];
                }
                
            }
        }
    
    //single player game against computer
    }else if(self.gameMode == 1){
        
        //human player
        if([self.currentPlayer isEqualToString:@"Human"]){
            NSString *chosenLabel = [sender currentTitle];
            
            //cannot press occupied cell
            if(![chosenLabel isEqualToString:@"Here"]){
                self.message = [NSString stringWithFormat:@"You cannot choose occupied cell"];
                [self alertMessage];
            }else{
                if([[self.cells objectAtIndex:chosenIndex] isEqualToString:@"Here"]){
                    
                    //human uses label1
                    NSString *playerLabel = self.label1;
                    
                    //update button display
                    [sender setTitle:playerLabel forState:UIControlStateNormal];
                    [_cells replaceObjectAtIndex:chosenIndex withObject:playerLabel];
        
                    //game over
                    if([self isOver]){
                        self.winner = [self.currentPlayer isEqualToString:@"Human"] ? @"Human" : @"Computer";
                        self.message = [[NSString stringWithFormat:@"Winner is: "] stringByAppendingString:self.winner];
                        [self finalMessage];
                    //game tie
                    }else if(![self isOver] && ![self.cells containsObject:@"Here"]){
                        self.message = [NSString stringWithFormat:@"Oops, it is a tie"];
                        [self finalMessage];
                    //switch to computer's turn
                    }else{
                        self.currentPlayer = @"Computer";
                        [self updateUI];
                        [self computerTurn];
                    }
                }
            }
        }else{
            NSLog(@"Something is wrong");
        }
        
    }else{
        [self welcomeMessage];
    }
}


- (void)updateUI{
    NSString *update = [NSString stringWithFormat:@"Next move: %@", self.currentPlayer];
    self.playerLabel.text = update;
}



- (void)computerTurn{
    //decide next move
    int nextMove = [self smartMove];
    
    //update corresponding button
    //computer uses label2
    UIButton *target = [self.buttons objectAtIndex:nextMove];
    [target setTitle:self.label2 forState:UIControlStateNormal];
    [self.cells replaceObjectAtIndex:nextMove withObject:self.label2];
    
    //game over
    if([self isOver]){
        self.winner = @"Computer";
        self.message = [[NSString stringWithFormat:@"Winner is: "] stringByAppendingString:self.winner];
        [self finalMessage];
    //game tie
    }else if(![self isOver] && ![self.cells containsObject:@"Here"]){
        self.message = [NSString stringWithFormat:@"Oops, it is a tie"];
        [self finalMessage];
    //switch to human player
    }else{
        self.currentPlayer = @"Human";
        [self updateUI];
    }

}


- (int)smartMove{
 
    int blockMove = -1;
    
    //check next move by scanning rows
    for(int row=0; row<7; row+=3){
        NSArray *currRow = [NSArray arrayWithObjects:[self.cells objectAtIndex:row], [self.cells objectAtIndex:row+1], [self.cells objectAtIndex:row+2], nil];
        //**-
        if(![[currRow objectAtIndex:0] isEqualToString:@"Here"] && [[currRow objectAtIndex:0] isEqualToString:[currRow objectAtIndex:1]] && [[currRow objectAtIndex:2] isEqualToString:@"Here"]){
            //computer will win by next move
            if([[currRow objectAtIndex:0] isEqualToString:self.label2]){
                return row+2;
            //temporarilty store block move
            }else{
                blockMove = row+2;
            }
        //*-*
        }else if(![[currRow objectAtIndex:0] isEqualToString:@"Here"] && [[currRow objectAtIndex:0] isEqualToString:[currRow objectAtIndex:2]] && [[currRow objectAtIndex:1] isEqualToString:@"Here"]){
            //computer will win by next move
            if([[currRow objectAtIndex:0] isEqualToString:self.label2]){
                return row+1;
                //temporarilty store block move
            }else{
                blockMove = row+1;
            }
        //-**
        }else if(![[currRow objectAtIndex:1] isEqualToString:@"Here"] && [[currRow objectAtIndex:1] isEqualToString:[currRow objectAtIndex:2]] && [[currRow objectAtIndex:0] isEqualToString:@"Here"]){
            //computer will win by next move
            if([[currRow objectAtIndex:1] isEqualToString:self.label2]){
                return row;
                //temporarilty store block move
            }else{
                blockMove = row;
            }
        }
        
    }
    
    //check next move by scanning columns
    for(int col=0; col<3; col++){
        NSArray *currCol = [NSArray arrayWithObjects:[self.cells objectAtIndex:col], [self.cells objectAtIndex:col+3], [self.cells objectAtIndex:col+6], nil];
        
        //*
        //*
        //-
        if(![[currCol objectAtIndex:0] isEqualToString:@"Here"] && [[currCol objectAtIndex:0] isEqualToString:[currCol objectAtIndex:1]] && [[currCol objectAtIndex:2] isEqualToString:@"Here"]){
            //computer will win by next move
            if([[currCol objectAtIndex:0] isEqualToString:self.label2]){
                return col+6;
                //temporarilty store block move
            }else{
                blockMove = col+6;
            }

        //X
        //-
        //X
        }else if(![[currCol objectAtIndex:0] isEqualToString:@"Here"] && [[currCol objectAtIndex:0] isEqualToString:[currCol objectAtIndex:2]] && [[currCol objectAtIndex:1] isEqualToString:@"Here"]){
            //computer will win by next move
            if([[currCol objectAtIndex:0] isEqualToString:self.label2]){
                return col+3;
                //temporarilty store block move
            }else{
                blockMove = col+3;
            }
        //-
        //*
        //*
        }else if(![[currCol objectAtIndex:1] isEqualToString:@"Here"] && [[currCol objectAtIndex:1] isEqualToString:[currCol objectAtIndex:2]] && [[currCol objectAtIndex:0] isEqualToString:@"Here"]){
            //computer will win by next move
            if([[currCol objectAtIndex:1] isEqualToString:self.label2]){
                return col;
                //temporarilty store block move
            }else{
                blockMove = col;
            }
    
        }
        
    }
                                                                          
    
    //check next move by scanning diagonals
    NSArray *diagOne = [NSArray arrayWithObjects:[self.cells objectAtIndex:0], [self.cells objectAtIndex:4], [self.cells objectAtIndex:8], nil];
    NSArray *diagTwo = [NSArray arrayWithObjects:[self.cells objectAtIndex:2], [self.cells objectAtIndex:4], [self.cells objectAtIndex:6], nil];

    
    //*
    // *
    //  -
    if(![[diagOne objectAtIndex:0] isEqualToString:@"Here"] && [[diagOne objectAtIndex:0] isEqualToString:[diagOne objectAtIndex:1]] && [[diagOne objectAtIndex:2] isEqualToString:@"Here"]){
        //computer will win by next move
        if([[diagOne objectAtIndex:0] isEqualToString:self.label2]){
            return 8;
            //temporarilty store block move
        }else{
            blockMove = 8;
        }

    //*
    // -
    //  *
    }else if(![[diagOne objectAtIndex:0] isEqualToString:@"Here"] && [[diagOne objectAtIndex:0] isEqualToString:[diagOne objectAtIndex:2]] && [[diagOne objectAtIndex:1] isEqualToString:@"Here"]){
        //computer will win by next move
        if([[diagOne objectAtIndex:0] isEqualToString:self.label2]){
            return 4;
            //temporarilty store block move
        }else{
            blockMove = 4;
        }

    //-
    // *
    //  *
    }else if(![[diagOne objectAtIndex:1] isEqualToString:@"Here"] && [[diagOne objectAtIndex:1] isEqualToString:[diagOne objectAtIndex:2]] && [[diagOne objectAtIndex:0] isEqualToString:@"Here"]){
        //computer will win by next move
        if([[diagOne objectAtIndex:1] isEqualToString:self.label2]){
            return 0;
            //temporarilty store block move
        }else{
            blockMove = 0;
        }
    }
    
    
    
    //   *
    // *
    //-
    if(![[diagTwo objectAtIndex:0] isEqualToString:@"Here"] && [[diagTwo objectAtIndex:0] isEqualToString:[diagTwo objectAtIndex:1]] && [[diagTwo objectAtIndex:2] isEqualToString:@"Here"]){
        //computer will win by next move
        if([[diagTwo objectAtIndex:0] isEqualToString:self.label2]){
            return 6;
            //temporarilty store block move
        }else{
            blockMove = 6;
        }

    //   *
    // -
    //*
    }else if(![[diagTwo objectAtIndex:0] isEqualToString:@"Here"] && [[diagTwo objectAtIndex:0] isEqualToString:[diagTwo objectAtIndex:2]] && [[diagTwo objectAtIndex:1] isEqualToString:@"Here"]){
        //computer will win by next move
        if([[diagTwo objectAtIndex:0] isEqualToString:self.label2]){
            return 4;
            //temporarilty store block move
        }else{
            blockMove = 4;
        }
 
    //   -
    // *
    //*
    }else if(![[diagTwo objectAtIndex:1] isEqualToString:@"Here"] && [[diagTwo objectAtIndex:1] isEqualToString:[diagTwo objectAtIndex:2]] && [[diagTwo objectAtIndex:0] isEqualToString:@"Here"]){
        //computer will win by next move
        if([[diagTwo objectAtIndex:1] isEqualToString:self.label2]){
            return 2;
            //temporarilty store block move
        }else{
            blockMove = 2;
        }
    }
    
    
    //if need to block human, block it
    if(blockMove != -1){
        return blockMove;
    }
    
    //first try center cell
    if([[self.cells objectAtIndex:4] isEqualToString:@"Here"]){
        return 4;
    }
    
    
    
    int res = 0;
    //otherwise, computer will try two in a row
    for(NSString *curr in self.cells){
        if([curr isEqualToString:self.label2]){
            NSInteger index = [self.cells indexOfObject:curr];
            
            //right, left, bottom, up
            NSMutableArray *possibleMoves;
            
            //if center tile, add 4 more possible moves
            //add those moves only if the other spot in the diagonal is not occupied by human's move
            if(index == 4){
                if(![[self.cells objectAtIndex:8] isEqualToString:self.label1]){
                    [possibleMoves addObject:[NSNumber numberWithInt:0]];
                }
                if(![[self.cells objectAtIndex:6] isEqualToString:self.label1]){
                    [possibleMoves addObject:[NSNumber numberWithInt:2]];
                }
                if(![[self.cells objectAtIndex:2] isEqualToString:self.label1]){
                    [possibleMoves addObject:[NSNumber numberWithInt:6]];
                }
                if(![[self.cells objectAtIndex:0] isEqualToString:self.label1]){
                    [possibleMoves addObject:[NSNumber numberWithInt:8]];
                }
            }
            
            
            //add possible moves based on positions
            //try two in a row
            if(index==0){
                [possibleMoves addObject:[NSNumber numberWithInt:1]];
                [possibleMoves addObject:[NSNumber numberWithInt:3]];
                [possibleMoves addObject:[NSNumber numberWithInt:4]];
            }else if(index==1){
                [possibleMoves addObject:[NSNumber numberWithInt:0]];
                [possibleMoves addObject:[NSNumber numberWithInt:2]];
                [possibleMoves addObject:[NSNumber numberWithInt:4]];
            }else if(index==2){
                [possibleMoves addObject:[NSNumber numberWithInt:1]];
                [possibleMoves addObject:[NSNumber numberWithInt:5]];
                [possibleMoves addObject:[NSNumber numberWithInt:4]];
                
            }else if(index==3){
                [possibleMoves addObject:[NSNumber numberWithInt:0]];
                [possibleMoves addObject:[NSNumber numberWithInt:4]];
                [possibleMoves addObject:[NSNumber numberWithInt:6]];
                
            }else if(index==5){
                [possibleMoves addObject:[NSNumber numberWithInt:2]];
                [possibleMoves addObject:[NSNumber numberWithInt:4]];
                [possibleMoves addObject:[NSNumber numberWithInt:8]];
                
            }else if(index==6){
                [possibleMoves addObject:[NSNumber numberWithInt:3]];
                [possibleMoves addObject:[NSNumber numberWithInt:4]];
                [possibleMoves addObject:[NSNumber numberWithInt:7]];
                
            }else if(index==7){
                [possibleMoves addObject:[NSNumber numberWithInt:4]];
                [possibleMoves addObject:[NSNumber numberWithInt:6]];
                [possibleMoves addObject:[NSNumber numberWithInt:8]];
                
            }else if(index==8){
                [possibleMoves addObject:[NSNumber numberWithInt:4]];
                [possibleMoves addObject:[NSNumber numberWithInt:5]];
                [possibleMoves addObject:[NSNumber numberWithInt:7]];
                
            }
            
            //use the possible move if the spot is not occupied
            for(NSNumber *m in possibleMoves){
                int temp = (int)[m integerValue];
                if([[self.cells objectAtIndex:temp] isEqualToString:@"Here"]){
                    return (int)[m integerValue];
                }
            }
        }
    }
    
    //if two in a row is not possible, just choose next move randomly
    res = arc4random()%9;
    while(![[self.cells objectAtIndex:res] isEqualToString:@"Here"]){
        res = arc4random()%9;
    }
    
    
    return res;
    
}



- (BOOL)isOver{
    
    //check winning by diagonals
    //first check center element
    if(![[self.cells objectAtIndex:4] isEqualToString:@"Here"]){
        NSString *center = [self.cells objectAtIndex:4];
        if([center isEqualToString:[self.cells objectAtIndex:0]] && [center isEqualToString:[self.cells objectAtIndex:8]]){
            return true;
        }
        if([center isEqualToString:[self.cells objectAtIndex:2]] && [center isEqualToString:[self.cells objectAtIndex:6]]){
            return true;
        }
        
    }
    
    //check winning by rows
    for(int row=0; row<7; row+=3){
        NSArray *currRow = [NSArray arrayWithObjects:[self.cells objectAtIndex:row], [self.cells objectAtIndex:row+1], [self.cells objectAtIndex:row+2], nil];
        if(![currRow containsObject:@"Here"]){
            if([[currRow objectAtIndex:0] isEqualToString:[currRow objectAtIndex:1]] && [[currRow objectAtIndex:1] isEqualToString:[currRow objectAtIndex:2]]){
                return true;
            }
        }
        
    }
    
    //check winning by columns
    for(int col=0; col<3; col++){
        NSArray *currCol = [NSArray arrayWithObjects:[self.cells objectAtIndex:col], [self.cells objectAtIndex:col+3], [self.cells objectAtIndex:col+6], nil];
        if(![currCol containsObject:@"Here"]){
            if([[currCol objectAtIndex:0] isEqualToString:[currCol objectAtIndex:1]] && [[currCol objectAtIndex:1] isEqualToString:[currCol objectAtIndex:2]]){
                return true;
            }
        }
    }
    
                                                                
    return false;
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonPressed = [alertView buttonTitleAtIndex:buttonIndex];
    
    //decide game mode
    if([buttonPressed isEqualToString:@"Single Player"]){
        self.gameMode = 1;
        [self whoFirst];
    }else if([buttonPressed isEqualToString:@"Two Players"]){
        self.gameMode = 2;
        [self whoFirst];
        
    //decide if game continues
    }else if ([buttonPressed isEqualToString:@"Yes"]) {
        [self viewDidLoad];
    } else if ([buttonPressed isEqualToString:@"No"]) {
        self.gameMode = 0;
        
    //decide which player to go first
    }else if([buttonPressed isEqualToString:@"Human"]){
        self.currentPlayer = [NSString stringWithFormat:@"Human"];
        [self updateUI];
    }else if([buttonPressed isEqualToString:@"Computer"]){
        self.currentPlayer = [NSString stringWithFormat:@"Computer"];
        [self computerTurn];
    }else if([buttonPressed isEqualToString:@"Player Two"]){
        self.currentPlayer = [NSString stringWithFormat:@"Player Two"];
        [self updateUI];
    }else if([buttonPressed isEqualToString:@"Player One"]){
        self.currentPlayer = [NSString stringWithFormat:@"Player One"];
        [self updateUI];
    }else if([buttonPressed isEqualToString:@"Random"]){
        int randomPlayer = arc4random()%2;
        if(self.gameMode == 1){
            self.currentPlayer = randomPlayer==0 ? [NSString stringWithFormat:@"Human"] : [NSString stringWithFormat:@"Computer"];
            [self updateUI];
            if([self.currentPlayer isEqualToString:@"Computer"]){
                [self computerTurn];
            }
        }else{
            self.currentPlayer = randomPlayer==0 ? [NSString stringWithFormat:@"Player One"] : [NSString stringWithFormat:@"Player Two"];
            [self updateUI];
        }
    }
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initGame{
    //reset display label
    self.playerLabel.text = @"Enjoy the game";
    
    //reset buttons to initial state
    for(UIButton *b in self.buttons){
        [b setTitle:@"Here" forState:UIControlStateNormal];
    }
}

- (void)welcomeMessage{
    //print welcome message and choose game mode
    UIAlertView *welcome = [[UIAlertView alloc] initWithTitle:@"Enjoy Tic-Tac-Toe" message:@"Choose game mode: " delegate:self cancelButtonTitle:nil otherButtonTitles:@"Single Player", @"Two Players", nil];
    [welcome show];
}

- (void)whoFirst{
    UIAlertView *firstPlayer = nil;
    //who to go first
    if(self.gameMode == 1){
        firstPlayer = [[UIAlertView alloc] initWithTitle:@"Who is first" message:@"Pick One" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Human", @"Computer", @"Random", nil];
    }else{
        firstPlayer = [[UIAlertView alloc] initWithTitle:@"Who is first" message:@"Pick One " delegate:self cancelButtonTitle:nil otherButtonTitles:@"Player One", @"Player Two", @"Random", nil];
    }
    [firstPlayer show];
}

- (void)finalMessage{
    //print welcome message and choose game mode
    UIAlertView *final = [[UIAlertView alloc] initWithTitle:self.message message:@"Play again?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [final show];
}

- (void)alertMessage{
    //print welcome message and choose game mode
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.message message:@"continue the game" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"I know, thanks", nil];
    [alert show];
}



@end
