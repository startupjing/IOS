//
//  SecondTab.m
//  EmptyApplication
//
//  Created by Labuser on 2/25/15.
//  Copyright (c) 2015 StudentName. All rights reserved.
//

#import "SecondTab.h"

@interface SecondTab ()

@end

@implementation SecondTab

- (id)initWithStyle:(UITableViewStyle)style{
    
    if (self = [super initWithStyle:style]) {
        
    }
    
    [self loadNames];
    
    return self;
}

- (void) loadNames{
    names = [[NSMutableArray alloc] initWithObjects:@"Todd", @"Andrew", @"Eric", @"Justin", nil];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



#pragma mark Table view methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [names count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Set up the cell...
    cell.textLabel.text = [names objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = [names objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"Hello, %@.", name];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"Who are you?" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alertView show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
