//
//  StatManager.m
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/9/13.
//
//

#import "StatManager.h"

@interface StatManager()

@end

@implementation StatManager

@synthesize gameTime;
@synthesize stats;
@synthesize currentStatEntry;

- (id) init {
    stats = [[NSMutableArray alloc] init];
    return self;
}

- (void) startGameTime {
    gameTime = [NSDate date] ;
    NSLog(@"GameTime Set: %@", gameTime);
}

- (NSDate *) getGameTime {
    return gameTime;
}

- (void) newCurrentStatEntry {
    currentStatEntry = [[StatEntry alloc] init];
}

- (void) addStats:(StatEntry*) entry {
    [stats addObject:entry];
}

- (void) uploadStats {
    NSString *post = nil;
    NSString *statString = [[NSString alloc] init];
    StatLevelEntry *currentLevel;
    NSString *timeInterval = [[NSString alloc] init];
    NSString *ageString = [[NSString alloc] init];
    StatSentenceEntry *currentSentence;
    // Unwrap the statistics object.
    statString = [statString stringByAppendingString:@"Total Playtime: "];
    timeInterval = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceDate:[currentStatEntry startTime]]];
    statString = [statString stringByAppendingString:timeInterval];
    statString = [statString stringByAppendingString:@" Is Child: "];
    ageString = [NSString stringWithFormat:@"%d ",[currentStatEntry isChild]];
    statString = [statString stringByAppendingString:ageString];
    
    for(int i = 0; i<[[currentStatEntry levels] count]; i++){
        currentLevel = [[currentStatEntry levels] objectAtIndex:i];
        statString = [statString stringByAppendingString:@"LevelName: "];
        statString = [statString stringByAppendingString:[[[currentStatEntry levels] objectAtIndex:i] levelName]];
        statString = [statString stringByAppendingString:@" LevelTime: "];
        timeInterval = [NSString stringWithFormat:@"%f",[[[currentStatEntry levels] objectAtIndex:i] totalLevelTime]];
        statString = [statString stringByAppendingString:timeInterval];
        for(int j = 0; j<[[currentLevel sentences] count]; j++){
            currentSentence = [[currentLevel sentences] objectAtIndex:j];
            statString = [statString stringByAppendingString:@" TargetSentence: "];
            statString = [statString stringByAppendingString:[currentSentence sentence]];
            for(int k = 0; k<[[currentSentence utterances] count]; k++){
                statString = [statString stringByAppendingString:@" Spoken: "];
                statString = [statString stringByAppendingString:(NSString*)[[currentSentence utterances]objectAtIndex:k]];
            }
        }
        statString = [statString stringByAppendingString:@"\n"];
    }
    post = [[NSString alloc] initWithFormat:@"SpeechAdventureRecord=%@",statString];
    
    // Begin uploading statistics 
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://users.soe.ucsc.edu/~zarubin/cleft/uploadstats.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [ NSURLConnection connectionWithRequest:request delegate:self ];
}

#pragma mark -
#pragma mark Singleton Stuff. Here be dragons
static StatManager *statManager = nil;

+ (StatManager *) sharedManager {
    if (statManager == nil) {
        statManager = [[super allocWithZone:NULL] init];
    }
    return statManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


@end
