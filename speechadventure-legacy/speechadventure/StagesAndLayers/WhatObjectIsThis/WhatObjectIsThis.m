//
//  WhatObjectIsThis.m
//  speechadventure
//  Throws a number of objects on the screen. The child can touch them and the game will ask what the object is.
//
//  Created by Zak Rubin on 10/18/13.
//  Copyright (c) 2013 Zak Rubin. All rights reserved.
//

#import "WhatObjectIsThis.h"

@implementation WhatObjectIsThis

CCMenu *ball, *boat, *bunny;
CCLabelTTF *ballCountLabel, *boatCountLabel, *bunnyCountLabel;
int sentenceNum, ballCount, boatCount, bunnyCount;

int lastHypothesisLength, lastWordLength;

-(void) onEnter {
	[super onEnter];
    
    ballCount = 0;
    boatCount = 0;
    bunnyCount = 0;
    
    [[OEManager sharedManager] swapModel:@"WhatObjectIsThis"];
    [[OEManager sharedManager] registerDelegate:self shouldReturnPartials:true];
    sentenceNum = -1;
    lastHypothesisLength = 0;
    [self highlightMenuItem: -1];
    [self updateScores];
    [self toggleBackButton];
    [self toggleListeningEar];
}

-(void) selectBall:(id)sender {
    [self highlightMenuItem:0];
    sentenceNum = 0;
}

-(void) selectBoat:(id)sender {
    [self highlightMenuItem:1];
    sentenceNum = 1;
}

-(void) selectBunny:(id)sender {
    [self highlightMenuItem:2];
    sentenceNum = 2;
}

-(void) highlightMenuItem:(int) menuItem {
    [self removeChild: ball];
    [self removeChild: boat];
    [self removeChild: bunny];
    
    switch (menuItem) {
            case 0:
            ball = [CCMenuItemImage itemWithNormalImage:@"ball_highlighted.png" selectedImage:@"ball_highlighted.png" target: self selector: @selector(selectBall:)];
            ball.position = ccp(80, 70);
            boat = [CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"boat.png" selectedImage:@"boat.png" target: self selector: @selector(selectBoat:)], nil];
            boat.position = ccp(240, 70);
            bunny = [CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"bunny.png" selectedImage:@"bunny.png" target: self selector: @selector(selectBunny:)], nil];
            bunny.position = ccp(400, 70);
            break;
            
            case 1:
            boat = [CCMenuItemImage itemWithNormalImage:@"boat_highlighted.png" selectedImage:@"boat.png" target: self selector: @selector(selectBoat:)];
            boat.position = ccp(240, 70);
            ball = [CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"ball.png" selectedImage:@"ball.png" target: self selector: @selector(selectBall:)], nil];
            ball.position = ccp(80, 70);
            bunny = [CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"bunny.png" selectedImage:@"bunny.png" target: self selector: @selector(selectBunny:)], nil];
            bunny.position = ccp(400, 70);
            break;
            
            case 2:
            bunny = [CCMenuItemImage itemWithNormalImage:@"bunny_highlighted.png" selectedImage:@"bunny.png" target: self selector: @selector(selectBunny:)];
            bunny.position = ccp(400, 70);
            ball = [CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"ball.png" selectedImage:@"ball.png" target: self selector: @selector(selectBall:)], nil];
            ball.position = ccp(80, 70);
            boat = [CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"boat.png" selectedImage:@"boat.png" target: self selector: @selector(selectBoat:)], nil];
            boat.position = ccp(240, 70);
            break;
            
        default:
            ball = [CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"ball.png" selectedImage:@"ball.png" target: self selector: @selector(selectBall:)], nil];
            ball.position = ccp(80, 70);
            boat = [CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"boat.png" selectedImage:@"boat.png" target: self selector: @selector(selectBoat:)], nil];
            boat.position = ccp(240, 70);
            bunny = [CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"bunny.png" selectedImage:@"bunny.png" target: self selector: @selector(selectBunny:)], nil];
            bunny.position = ccp(400, 70);
            break;
    }
    
    [self addChild: ball];
    [self addChild: boat];
    [self addChild: bunny];

}

-(void) updateScores {
    [self removeChild: ballCountLabel];
    [self removeChild: boatCountLabel];
    [self removeChild: bunnyCountLabel];
    ballCountLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", ballCount] fontName:@"Arial" fontSize:48.0];
    ballCountLabel.color = ccc3(0,0,0);
    ballCountLabel.position = ccp(80, 200);
    boatCountLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", boatCount] fontName:@"Arial" fontSize:48.0];
    boatCountLabel.color = ccc3(0,0,0);
    boatCountLabel.position = ccp(240, 200);
    bunnyCountLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", bunnyCount] fontName:@"Arial" fontSize:48.0];
    bunnyCountLabel.color = ccc3(0,0,0);
    bunnyCountLabel.position = ccp(400, 200);
    [self addChild: ballCountLabel];
    [self addChild: boatCountLabel];
    [self addChild: bunnyCountLabel];
}

- (void)receiveOEEvent:(OEEvent*) speechEvent{
    NSLog(@"WhatObject received speechEvent.\ntext:%@\nscore:%@\nEventType:%d\nLength%d\nLastHypLength%d",speechEvent.text,speechEvent.recognitionScore,(int)speechEvent.eventType,speechEvent.text.length, lastHypothesisLength);
    NSString * truncatedText;
    
    /*if(lastHypothesisLength <= speechEvent.text.length - 1) {
        truncatedText = [speechEvent.text substringFromIndex:lastHypothesisLength];
    } else {
        truncatedText = speechEvent.text;
        lastHypothesisLength = 0;
    }*/
    truncatedText = speechEvent.text;
    /*if([speechEvent.wordArray count] <= lastWordLength) {
        truncatedText = [speechEvent.text substringFromIndex:lastHypothesisLength];
    } else {
        truncatedText = speechEvent.text;
    }*/
    NSLog(@"Truncated Text:%@", truncatedText);
    
    if (([truncatedText rangeOfString:@"BALL"].location != NSNotFound)
            && sentenceNum == 0
            && (int)speechEvent.eventType == RapidEarsPartial) {
        ballCount++;
        lastHypothesisLength = [speechEvent.text length];
    } else if (([truncatedText rangeOfString:@"BOAT"].location != NSNotFound)
               && sentenceNum == 1
               && (int)speechEvent.eventType == RapidEarsPartial) {
        boatCount++;
        lastHypothesisLength = [speechEvent.text length];
    } else if (([truncatedText rangeOfString:@"BUNNY"].location != NSNotFound)
               && sentenceNum == 2
               && (int)speechEvent.eventType == RapidEarsPartial) {
        bunnyCount++;
        lastHypothesisLength = [speechEvent.text length];
    } else if((int)speechEvent.eventType == RapidEarsResponse) {
        lastHypothesisLength = 0;
    } else {
        
    }
    [self updateScores];
}

+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	WhatObjectIsThis *layer = [WhatObjectIsThis node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

@end
