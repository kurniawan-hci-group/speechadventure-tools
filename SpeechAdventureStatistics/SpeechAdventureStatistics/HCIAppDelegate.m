//
//  HCIAppDelegate.m
//  SpeechAdventureStatistics
//
//  Created by Jennifer on 3/7/14.
//  Copyright (c) 2014 Jennifer. All rights reserved.
//

#import "HCIAppDelegate.h"
#import "HCIGame.h"
#import "HCIGameViewController.h"

@implementation HCIAppDelegate
/*{
    NSMutableArray *_games;
}*/


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
   /* _games = [NSMutableArray arrayWithCapacity:20];
    
    HCIGame *game = [[HCIGame alloc] init];
    game.score = 95;
    game.totalTime = 3.2;
    game.numLevelsCompleted =3;
    [_games addObject:game];
    
   game = [[HCIGame alloc] init];
   game.score = 70;
   game.totalTime = 1.8;
   game.numLevelsCompleted =4;
   [_games addObject:game];
    
    game = [[HCIGame alloc] init];
    game.score = 55;
    game.totalTime = .6;
    game.numLevelsCompleted =1;
    [_games addObject:game];*/
   
   
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
