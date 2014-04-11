//
//  TutorialLevel.h
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/16/13.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

#import "SAGameLayer.h"
#import "GameCharacter.h"

@interface TutorialLevel : SAGameLayer

- (id) init;

@property (nonatomic, strong) GameCharacter *samCharacter;
@property (nonatomic, strong) CCSprite *arrow;


@property (nonatomic, strong) CCMenu *ageMenu;
@property (nonatomic, strong) CCLabelTTF *childLabel;
@property (nonatomic, strong) CCLabelTTF *adultLabel;
@property (nonatomic, strong) CCLabelTTF *sentenceLabel;
@property (nonatomic, strong) CCLabelTTF *highlightedWord;
@property (nonatomic, strong) StatLevelEntry *statLevelEntry;
@property (nonatomic, strong) StatSentenceEntry *currentSentenceStats;
@property (nonatomic, strong) NSDate *levelTime;

@end
