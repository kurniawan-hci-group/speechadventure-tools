//
//  StatManager.h
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/9/13.
//
//

#import <Foundation/Foundation.h>
#import "StatEntry.h"

@interface StatManager : NSObject

- (void) startGameTime;
- (NSDate *) getGameTime;

- (void) newCurrentStatEntry;
- (void) addStats:(StatEntry*) entry;
- (void) uploadStats;

+ (StatManager *) sharedManager;

@property (nonatomic, retain) NSDate *gameTime;
@property (nonatomic, strong) NSMutableArray *stats;
@property (nonatomic, strong) StatEntry* currentStatEntry;

@end
