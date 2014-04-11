//
//  PopABalloon.h
//  SpeechAdventure
//
//  Created by John Chambers on 7/27/12.
//
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"

#import "SAGameLayer.h"
#import "GameCharacter.h"

@interface PopABalloon : SAGameLayer
    
- (id) init;

@property (nonatomic, strong) GameCharacter *samCharacter;
@property (nonatomic, strong) NSMutableArray *balloons;
@property (nonatomic, strong) CCLabelTTF *sentenceLabel;
@property (nonatomic, strong) CCLabelTTF *highlightedWord;
@property (nonatomic, strong) StatLevelEntry *statLevelEntry;
@property (nonatomic, strong) StatSentenceEntry *currentSentenceStats;
@property (nonatomic, strong) NSDate *levelTime;

@end
