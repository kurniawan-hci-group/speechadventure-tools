//
//  HCISummaryViewController.h
//  SpeechAdventureStatistics
//
//  Created by Jennifer on 3/8/14.
//  Copyright (c) 2014 Jennifer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCISummaryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *numGames;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
