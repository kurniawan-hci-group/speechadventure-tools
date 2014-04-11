//
//  StatEntry.m
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/9/13.
//
//

#import "StatEntry.h"

@implementation StatEntry

@synthesize startTime;
@synthesize levels;
@synthesize isChild;

- (id) init {
    levels = [[NSMutableArray alloc] init];
    startTime = [NSDate date];
    return self;
}

- (void) addLevel:(StatLevelEntry*) level {
    [levels addObject:level];
}


@end
