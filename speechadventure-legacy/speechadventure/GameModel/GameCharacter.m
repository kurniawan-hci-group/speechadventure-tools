//
//  GameCharacter.m
//  SpeechAdventure
//
//  Created by John Chambers on 8/2/12.
//
//

#import "GameCharacter.h"

@implementation GameCharacter

@synthesize name;
@synthesize baseFrame;
@synthesize rewardFrame;
@synthesize spriteBatchNode;
@synthesize actualSprite;
@synthesize rewardSprite;
@synthesize walkActions;
@synthesize walkActionKeys;
@synthesize currentWalkAction;
@synthesize currentMoveAction;

- (id) initWithFilePrefix:(NSString*)filePrefix withName:(NSString*)characterName withNumberOfAnimationFrames:(int)numberOfAnimationFrames{
    //This method loads the sprites for the character and sets up associated actions & animations. In order for it to work, the name of your PLIST & sprite sheet PNG must be the same with different extentions--called the "file prefix". The number of animation frames dictates how many frames will be loaded for each animation (e.g. there could be 5 frames in the "walk stage right" series).
    if (self=[super init]) {
        
        self.name = characterName;
        self.baseFrame = [[NSString alloc] initWithFormat:@"%@_front_0.png",characterName];
        self.rewardFrame = [[NSString alloc] initWithFormat:@"%@_excite.png",characterName];

        //Configuration
        double frameDelay = 0.5f;
        
        //cache the plist
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",filePrefix]];
        
        //create sprite batch
        self.spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.png",filePrefix]];
        
        //SETUP STILL FRAMES
        self.actualSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@",baseFrame]];
        [self.spriteBatchNode addChild:self.actualSprite];
        
        //SETUP VARIOUS ACTIONS
        //Walk
        self.walkActionKeys = [NSMutableArray arrayWithObjects:
                               @"up",
                               @"up_HAT",
                               @"right_HAT",
                               @"right",
                               nil];
        self.walkActions = [[NSMutableDictionary alloc] initWithCapacity:[self.walkActionKeys count]];
        for (NSString *key in self.walkActionKeys) {
            NSMutableArray *walkFrames = [NSMutableArray arrayWithCapacity:numberOfAnimationFrames];
            for(int i = 0; i<=numberOfAnimationFrames; i++){
                [walkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@_%@_%d.png",characterName,key,i]]];
            }
            CCAnimation *walkAnimation = [CCAnimation animationWithSpriteFrames:walkFrames delay:frameDelay];
            walkAnimation.restoreOriginalFrame = YES;
            CCAction *walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnimation]];
            [self.walkActions setObject:walkAction forKey:key];
        }
    }
    
    return self;
}

- (void) walkTo:(CGPoint) destinationPoint withDirection:(NSString*)direction{
    /*//Diagnostic code for inter-object point conversion
     NSLog(@"WalkTo\nOriginal Point\nx:%f y:%f\n", destinationPoint.x, destinationPoint.y);
    CGPoint convertedPoint = [self.spriteBatchNode convertToNodeSpace:destinationPoint];
    NSLog(@"New Point\nx:%f y:%f", convertedPoint.x, convertedPoint.y);*/
    
    self.currentMoveAction = [CCMoveTo actionWithDuration:3 position:[self.spriteBatchNode convertToNodeSpace:destinationPoint]];
    id endMoveCall = [CCCallFuncN actionWithTarget:self selector:@selector(moveDone)];
    id moveSequence = [CCSequence actions:self.currentMoveAction, endMoveCall, nil];
    
    self.currentWalkAction = (CCAction*)[self.walkActions objectForKey:direction];
    
    
    //start moving before animating
    [self.actualSprite runAction:moveSequence];
    [self.actualSprite runAction:self.currentWalkAction];
}

- (void) moveDone {
    [self.actualSprite stopAction:self.currentWalkAction];
    CCSpriteFrame *stillFrameToRestore = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@",self.baseFrame]];
    [self.actualSprite setDisplayFrame:stillFrameToRestore];
}

- (void) reward {
    CCSpriteFrame *stillFrameToRestore = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@",self.rewardFrame]];
    [self.actualSprite setDisplayFrame:stillFrameToRestore];
    id rewardAction = [CCDelayTime actionWithDuration:1.0];
    id endCall = [CCCallFuncN actionWithTarget:self selector:@selector(rewardDone)];
    id rewardSequence = [CCSequence actions:rewardAction, endCall, nil];
    [self.actualSprite runAction:rewardSequence];
}

- (void) rewardDone {
    CCSpriteFrame *stillFrameToRestore = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@",self.baseFrame]];
    [self.actualSprite setDisplayFrame:stillFrameToRestore];
}

@end
