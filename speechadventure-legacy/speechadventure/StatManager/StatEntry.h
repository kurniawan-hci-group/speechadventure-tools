//
//  StatEntry.h
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/9/13.
//
//

#import <Foundation/Foundation.h>
#import "StatLevelEntry.h"

@interface StatEntry : NSObject

- (void) addLevel:(StatLevelEntry*) level;

@property (nonatomic, strong) NSMutableArray *levels;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic) bool isChild;

@end
