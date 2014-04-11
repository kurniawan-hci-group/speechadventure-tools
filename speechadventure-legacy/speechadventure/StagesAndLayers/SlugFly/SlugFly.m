//
//  HelloWorldLayer.m
//  speechadventure
//
//  Created by Zak Rubin on 10/6/13.
//  Copyright Zak Rubin 2013. All rights reserved.
//

#import "AppDelegate.h"

// Import the interfaces
#import "SlugFly.h"

enum {
	kTagParentNode = 1,
};


#pragma mark - SlugFly

@interface SlugFly ()
-(void) addNewSpriteAtPosition:(CGPoint)pos;
-(void) createMenu;
-(void) initPhysics;
@end


@implementation SlugFly

@synthesize statLevelEntry;
@synthesize currentSentenceStats;
@synthesize levelTime;

// Helper class method that creates a Scene with the SlugFly as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SlugFly *layer = [SlugFly node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) onEnter
{
	[super onEnter];
    
    //[[OEManager sharedManager] startListening];
    
    //BASE LAYER
    CCSprite *base = [CCSprite spriteWithFile:@"StartLand.png"];
    base.anchorPoint = ccp(0,0);
    base.position = ccp(0,0);
    [self.baseStageLayer addChild:base];
		
    // enable events
    self.touchEnabled = YES;
    self.accelerometerEnabled = YES;
		
    //CGSize s = [[CCDirector sharedDirector] winSize];
		
    // reset button
    [self createMenu];
		
    // init physics
    [self initPhysics];
		
    // Use batch node. Faster
    CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"sam_sprite_sheet.png" capacity:100];
    _spriteTexture = [parent texture];

    [self addChild:parent z:0 tag:kTagParentNode];
    
    [self addNewSpriteAtPosition:ccp(70,100)];
		
    [self scheduleUpdate];
    
    //Begin statistics
    levelTime = [[NSDate date] retain];
    statLevelEntry = [[StatLevelEntry alloc] initWithLevelName:@"SlugFly"];

    [[OEManager sharedManager] swapModel:@"OpenEars1"];
    //[[OEManager sharedManager] pauseListening]; //don't want events right now
    [[OEManager sharedManager] registerDelegate:self shouldReturnPartials:true];
    
    [self toggleListeningEar];
	
}

-(void) initPhysics
{
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	_space = cpSpaceNew();
	
	cpSpaceSetGravity( _space, cpv(0, -100) );
	
	//
	// rogue shapes
	// We have to free them manually
	//
	// bottom
	_walls[0] = cpSegmentShapeNew( _space->staticBody, cpv(0,35), cpv(s.width,35), 0.0f);
	
	// top
	//_walls[1] = cpSegmentShapeNew( _space->staticBody, cpv(0,s.height), cpv(s.width,s.height), 0.0f);
	
	// left
	_walls[1] = cpSegmentShapeNew( _space->staticBody, cpv(0,0), cpv(0,s.height), 0.0f);
	
	// right
	//_walls[3] = cpSegmentShapeNew( _space->staticBody, cpv(s.width,0), cpv(s.width,s.height), 0.0f);
	
	for( int i=0;i<2;i++) {
		cpShapeSetElasticity( _walls[i], 1.0f );
		cpShapeSetFriction( _walls[i], 1.0f );
		cpSpaceAddStaticShape(_space, _walls[i] );
	}
	
	_debugLayer = [CCPhysicsDebugNode debugNodeForCPSpace:_space];
	_debugLayer.visible = NO;
	[self addChild:_debugLayer z:100];
}

- (void)dealloc
{
	// manually Free rogue shapes
	for( int i=0;i<2;i++) {
		cpShapeFree( _walls[i] );
	}
	
	cpSpaceFree( _space );
	
	[super dealloc];
	
}

-(void) update:(ccTime) delta
{
	// Should use a fixed size step based on the animation interval.
	int steps = 2;
	CGFloat dt = [[CCDirector sharedDirector] animationInterval]/(CGFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(_space, dt);
	}
}

-(void) createMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
	// Reset Button
	CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
		[flyingSprite CPBody]->p.x = 100;
	}];
    reset.color = ccBLACK;
	
	// Debug Button
	CCMenuItemLabel *debug = [CCMenuItemFont itemWithString:@"Toggle Debug" block:^(id sender){
		[_debugLayer setVisible: !_debugLayer.visible];
	}];
	debug.color = ccBLACK;
	
	// to avoid a retain-cycle with the menuitem and blocks
	//__block id copy_self = self;
	
	CCMenu *menu = [CCMenu menuWithItems: debug, reset, nil];
	
	[menu alignItemsVertically];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/2)];
	
	
	[self addChild: menu];
}

-(void) addNewSpriteAtPosition:(CGPoint)pos
{
	// physics body
	int num = 4;
	cpVect verts[] = {
		cpv(-82,-60),
		cpv(-82, 60),
		cpv( 82, 60),
		cpv( 82,-60),
	};
	
	cpBody *body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, num, verts, CGPointZero));
	cpBodySetPos( body, pos );
	cpSpaceAddBody(_space, body);
	
	cpShape* shape = cpPolyShapeNew(body, num, verts, CGPointZero);
	cpShapeSetElasticity( shape, 0.0f );
	cpShapeSetFriction( shape, 1.0f );
	cpSpaceAddShape(_space, shape);
	
	// sprite
	CCNode *parent = [self getChildByTag:kTagParentNode];
    
    flyingSprite = [CCPhysicsSprite spriteWithTexture:_spriteTexture rect:CGRectMake(0, 0, 164, 119)];
	[parent addChild: flyingSprite];
	[flyingSprite setCPBody:body];
	[flyingSprite setPosition: pos];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		//[self addNewSpriteAtPosition: location];
        [flyingSprite CPBody]->v = cpv(10,10);
	}
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	static float prevX=0, prevY=0;
	
#define kFilterFactor 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	cpVect v;
	if( [[CCDirector sharedDirector] interfaceOrientation] == UIInterfaceOrientationLandscapeRight )
		v = cpv( -accelY, accelX);
	else
		v = cpv( accelY, -accelX);
	
	cpSpaceSetGravity( _space, cpvmult(v, 200) );
}

#pragma mark OpenEars delegate
- (void)receiveOEEvent:(OEEvent*) speechEvent{
    [currentSentenceStats addUtterance:speechEvent.text];
    if ([speechEvent.text rangeOfString:@"GO"].location != NSNotFound) {
        [flyingSprite CPBody]->v = cpv(100,30);
        NSLog(@"CPBody:%f",[flyingSprite CPBody]->p.x);
    }
    if ([flyingSprite CPBody]->p.x > 400) {
        NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                   pathForResource:@"GreatJob"
                                                   ofType:@"wav"]];
        [self pauseListeningAndPlaySound:soundFile delay:1];
    }
}


#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end

