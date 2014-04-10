//
//  HCISummaryViewController.m
//  SpeechAdventureStatistics
//
//  Created by Jennifer on 3/8/14.
//  Copyright (c) 2014 Jennifer. All rights reserved.
//

#import "HCISummaryViewController.h"
#import "HCISummaryStats.h"
#include <stdio.h>

#define MAX_LEN 250

@interface HCISummaryViewController ()

@end

@implementation HCISummaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

NSString *readLineAsNSString(FILE *file)
{
    char buffer[4096];
    
    // tune this capacity to your liking -- larger buffer sizes will be faster, but
    // use more memory
    NSMutableString *result = [NSMutableString stringWithCapacity:256];
    
    // Read up to 4095 non-newline characters, then read and discard the newline
    int charsRead;
    do
    {
        if(fscanf(file, "%4095[^\n]%n%*c", buffer, &charsRead) == 1)
            [result appendFormat:@"%s", buffer];
        else
            break;
    } while(charsRead == 4095);
    
    return result;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    FILE *in;
    char line[MAX_LEN];
    NSMutableArray * summary = [[NSMutableArray alloc] init];
    
    in = fopen("/Users/Jennifer/SpeechAdventureStatistics/SpeechAdventureStatistics/SamanthaSummary.dat", "r");
    
    if (in == NULL) {
        NSLog(@"Unable to open file for reading");
    }
    
    while(fgets(line,MAX_LEN,in) != NULL) {
        NSString* s = [[NSString alloc] initWithBytes:line length:sizeof(line) encoding:NSASCIIStringEncoding];
       // NSLog(s);
        [summary addObject: s];
        //printf("count: %d\n",[summary count]);
    }
    
   
    
    fclose(in);
    
    /*scoreLabel.text = [NSString stringWithFormat:@"%@%@", scorez, game.score];*/
    
    _name.text = [NSString stringWithFormat:@"%@%@", @"Name: ",[summary objectAtIndex:0]];
    _age.text = [NSString stringWithFormat:@"%@%@", @"Age: ",[summary objectAtIndex:1]];
    _score.text = [NSString stringWithFormat:@"%@%@", @"Score: ",[summary objectAtIndex:2]];
    _numGames.text = [NSString stringWithFormat:@"%@%@", @"Number of Games Completed: ",[summary objectAtIndex:3]];
    _time.text = [NSString stringWithFormat:@"%@%@", @"Total Gameplay: ",[summary objectAtIndex:4]];
    
    
   // dataFile = @"/Users/Jennifer/SpeechAdventureStatistics/SpeechAdventureStatistics/SamanthaSummary.dat";
    
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
