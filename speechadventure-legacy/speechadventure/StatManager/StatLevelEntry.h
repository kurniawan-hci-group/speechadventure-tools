//
//  StatLevelEntry.h
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/9/13.
//
//

#import <Foundation/Foundation.h>
#import "StatSentenceEntry.h"

@interface StatLevelEntry : NSObject

- (id) initWithLevelName:(NSString *)name;
- (void)addSentence:(StatSentenceEntry*) sentence;
- (void)calculatePlayTime;

@property (nonatomic, strong) NSString *levelName;
@property (nonatomic, strong) NSMutableArray *sentences;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic) NSTimeInterval totalLevelTime;

@end
