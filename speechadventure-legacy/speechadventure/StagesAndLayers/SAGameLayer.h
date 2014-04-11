//
//  SAGameLayer.h
//  SpeechAdventure
//
//  Created by John Chambers on 7/27/12.
//
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"
//SAEngine Seems to be causing problems.
//#import "SimpleAudioEngine.h"

#import "OEDelegate.h"
#import "OEManager.h"
#import "OEEvent.h"

#import "StatManager.h"

@interface SAGameLayer : CCLayerColor<OEDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) 	NSTimer *uiUpdateTimer;
@property (nonatomic, strong) 	CCLabelTTF *audioLevelLabel;
@property (nonatomic, strong) CCMenu *listeningIcon;
@property (nonatomic, strong) CCMenu *backButton;
@property (nonatomic, strong) CCLayer *backgroundLayer;
@property (nonatomic, strong) CCLayer *baseStageLayer;
@property (nonatomic, strong) CCLayer *activityLayer;
@property (nonatomic, strong) CCLayer *foregroundLayer;

- (id) init;
- (void) receiveOEEvent:(OEEvent*) speechEvent;
- (void) receiveOEState:(OEEvent*) stateEvent;
- (void) shouldReturnPartials:(BOOL)returnPartials;
- (void) pauseListeningAndPlaySound:(NSURL*) file delay:(ccTime)dt;
- (void) startDisplayingLevels;
- (void) stopDisplayingLevels;
- (void) toggleListeningEar;
- (void) toggleBackButton;

// returns a CCScene that contains the class's layer as the only child
+(CCScene *) scene;

@end