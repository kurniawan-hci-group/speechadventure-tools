//
//  LivingRoomLayer.h
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/10/13.
//
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"

#import "SAGameLayer.h"
#import "GameCharacter.h"

@interface LivingRoomLayer : SAGameLayer

- (id) init;

@property (nonatomic, strong) GameCharacter *samCharacter;
@property (nonatomic, strong) CCLabelTTF *sentenceLabel;
@property (nonatomic, strong) CCLabelTTF *highlightedWord;
@property (nonatomic, strong) StatLevelEntry *statLevelEntry;
@property (nonatomic, strong) StatSentenceEntry *currentSentenceStats;
@property (nonatomic, strong) NSDate *levelTime;
@property (nonatomic, strong) CCSprite *boots;
@property (nonatomic, strong) CCSprite *hat;

@end
