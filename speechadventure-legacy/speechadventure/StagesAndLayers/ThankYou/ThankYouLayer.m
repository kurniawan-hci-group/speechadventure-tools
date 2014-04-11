//
//  MainMenuLayer.m
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/2/13.
//
//

#import "ThankYouLayer.h"
#import "MainMenuLayer.h"

@implementation ThankYouLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ThankYouLayer *layer = [ThankYouLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
-(void) onEnter
{
	[super onEnter];
    CCLabelTTF *mainTitle = [CCLabelTTF labelWithString:@"Thanks For Playing!" fontName:@"Arial" fontSize:48.0];
    mainTitle.color = ccc3(0,0,0);
    mainTitle.position = ccp(240, 260);
    [self addChild: mainTitle];
    [[OEManager sharedManager] stopListening];

    [[StatManager sharedManager] addStats:[[StatManager sharedManager] currentStatEntry]];
    [[StatManager sharedManager] uploadStats];
    [self scheduleOnce:@selector(goToMainMenu:) delay:5];
	
}

-(void) goToMainMenu:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene] withColor:ccWHITE]];
}

-(void) viewTransition:(ccTime)dt
{
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[IntroLayer scene] withColor:ccWHITE]];
}

@end
