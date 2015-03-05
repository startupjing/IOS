//
//  AppDelegate.m
//  EmptyApplication
//
//  Created by Todd Sproull on 2/8/15.
//  Copyright (c) 2015 StudentName. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstTab.h"
#import "SecondTab.h"
#import "ThirdTab.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    FirstTab *tab1 = [[FirstTab alloc] initWithNibName:@"FirstTab" bundle:nil];
    SecondTab *tab2 = [[SecondTab alloc] initWithStyle:UITableViewStylePlain];
  
    UINavigationController *myNav = [[UINavigationController alloc] init];
    ThirdTab *tab3 = [[ThirdTab alloc] initWithNibName:@"ThirdTab" bundle:nil];
    [myNav pushViewController:tab3 animated:NO];
    
    tabBarViewController = [[UITabBarController alloc] init];
    [self.window setRootViewController:tabBarViewController];
    tabBarViewController.viewControllers = [NSArray arrayWithObjects:tab1,tab2,myNav, nil];
    
    UITabBar *tabBar = tabBarViewController.tabBar;
    tabBar.barStyle = UIBarStyleBlack;

    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:2];
 
    item1.title = @"First";
    item2.title = @"Second";
    item3.title = @"Third";
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
