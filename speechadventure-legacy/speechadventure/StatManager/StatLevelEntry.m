//
//  StatLevelEntry.m
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/9/13.
//
//

#import "StatLevelEntry.h"

@implementation StatLevelEntry

@synthesize levelName;
@synthesize sentences;
@synthesize startTime;
@synthesize totalLevelTime;

- (id) init {
    sentences = [[NSMutableArray alloc] init];
    startTime = [NSDate date];
    return self;
}

- (id) initWithLevelName:(NSString *)name {
    sentences = [[NSMutableArray alloc] init];
    startTime = [NSDate date];
    levelName = [[NSString alloc] initWithString:name];
    return self;
}

- (void)addSentence:(StatSentenceEntry*) sentence {
    [sentences addObject:sentence];
}

- (void)calculatePlayTime {
    totalLevelTime = [[NSDate date] timeIntervalSinceDate:startTime];
}

@end
