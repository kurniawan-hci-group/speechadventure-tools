//
//  SlugFly.h
//  speechadventure
//
//  Created by Zak Rubin on 10/6/13.
//  Copyright Zak Rubin 2013. All rights reserved.
//
#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "chipmunk.h"

#import "SAGameLayer.h"
#import "GameCharacter.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// HelloWorldLayer
@interface SlugFly : SAGameLayer 
{
	CCTexture2D *_spriteTexture; // weak ref
	CCPhysicsDebugNode *_debugLayer; // weak ref
	
	cpSpace *_space; // strong ref
	
	cpShape *_walls[2];
    
    CCPhysicsSprite *flyingSprite;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@property (nonatomic, strong) StatLevelEntry *statLevelEntry;
@property (nonatomic, strong) StatSentenceEntry *currentSentenceStats;
@property (nonatomic, strong) NSDate *levelTime;

@end
