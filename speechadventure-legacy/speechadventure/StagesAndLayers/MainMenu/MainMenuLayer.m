//
//  MainMenuLayer.m
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/2/13.
//
//

#import "MainMenuLayer.h"
#import "LivingRoomLayer.h"
#import "SlugFly.h"
#import "TutorialLevel.h"
#import "ViewStats.h"
#import "WhatObjectIsThis.h"

@implementation MainMenuLayer

@synthesize sentenceLabel;

//
-(id) init
{
	if( (self=[super init])) {
        // Start up the OE manager.
        if(![[OEManager sharedManager] isListening]) {
            [[OEManager sharedManager] startListening];
        }

        //BASE LAYER
        CCSprite *base = [CCSprite spriteWithFile:@"S1BaseStage.png"];
        base.anchorPoint = ccp(0,0);
        base.position = ccp(0,0);
        [self addChild:base];

        CCLabelTTF *mainTitle = [CCLabelTTF labelWithString:@"Speech Adventure" fontName:@"Arial" fontSize:48.0];
        mainTitle.color = ccc3(0,0,0);
        mainTitle.position = ccp(240, 270);
        //[[OEManager sharedManager] pauseListening];
        [self addChild: mainTitle];
        [self addMenuButtons];
    }
    return self;
}

-(void) addMenuButtons {
    CCMenuItem *startGame = [CCMenuItemImage itemWithNormalImage:@"Textbox_medium.png" selectedImage:@"Textbox_medium_sel.png" target: self selector: @selector(startGame:)];
    CCMenuItem *tutorial = [CCMenuItemImage itemWithNormalImage:@"Textbox_medium.png" selectedImage:@"Textbox_medium_sel.png" target: self selector: @selector(startTutorial:)];
    CCMenuItem *testLevel = [CCMenuItemImage itemWithNormalImage:@"Textbox_medium.png" selectedImage:@"Textbox_medium_sel.png" target: self selector: @selector(testLevel:)];
    CCMenuItem *viewStats = [CCMenuItemImage itemWithNormalImage:@"Textbox_medium.png" selectedImage:@"Textbox_medium_sel.png" target: self selector: @selector(viewStats:)];
    CCMenu *mainMenuButtons = [CCMenu menuWithItems: startGame, tutorial, testLevel, viewStats, nil];
    mainMenuButtons.position = ccp(240, 125);
    [mainMenuButtons alignItemsVertically];
    [self addChild: mainMenuButtons];
    
    sentenceLabel = [CCLabelTTF labelWithString:@"Start Game" fontName:@"Arial" fontSize:48.0];
    sentenceLabel.color = ccc3(0,0,0);
    sentenceLabel.position = ccp(240, 210);
    [self addChild: sentenceLabel];
    sentenceLabel = [CCLabelTTF labelWithString:@"Tutorial" fontName:@"Arial" fontSize:48.0];
    sentenceLabel.color = ccc3(0,0,0);
    sentenceLabel.position = ccp(240, 150);
    [self addChild: sentenceLabel];
    sentenceLabel = [CCLabelTTF labelWithString:@"Test Level" fontName:@"Arial" fontSize:48.0];
    sentenceLabel.color = ccc3(0,0,0);
    sentenceLabel.position = ccp(240, 90);
    [self addChild: sentenceLabel];
    sentenceLabel = [CCLabelTTF labelWithString:@"View Stats" fontName:@"Arial" fontSize:48.0];
    sentenceLabel.color = ccc3(0,0,0);
    sentenceLabel.position = ccp(240, 30);
    [self addChild: sentenceLabel];
}

-(void) startGame:(id)sender {
    
    [[StatManager sharedManager] startGameTime];
    [[StatManager sharedManager] newCurrentStatEntry];
	[self scheduleOnce:@selector(gameTransition:) delay:0];
}

-(void) viewStats:(id)sender {
	[self scheduleOnce:@selector(statsTransition:) delay:0];
}

-(void) startTutorial:(id)sender {
    
    [[StatManager sharedManager] startGameTime];
    [[StatManager sharedManager] newCurrentStatEntry];
	[self scheduleOnce:@selector(tutorialTransition:) delay:0];
}

-(void) testLevel:(id)sender {
    
    [[StatManager sharedManager] startGameTime];
    [[StatManager sharedManager] newCurrentStatEntry];
	[self scheduleOnce:@selector(testTransition:) delay:0];
}

-(void) gameTransition:(ccTime)dt {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LivingRoomLayer scene] withColor:ccWHITE]];
}

-(void) tutorialTransition:(ccTime)dt {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TutorialLevel scene] withColor:ccWHITE]];
}

-(void) testTransition:(ccTime)dt {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[WhatObjectIsThis scene] withColor:ccWHITE]];
}

-(void) statsTransition:(ccTime)dt {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ViewStats scene] withColor:ccWHITE]];
}


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuLayer *layer = [MainMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

@end
