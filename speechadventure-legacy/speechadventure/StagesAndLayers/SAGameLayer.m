//
//  SAGameLayer.m
//  SpeechAdventure
//
//  Created by John Chambers on 7/27/12.
//
//

#import "SAGameLayer.h"
#import "MainMenuLayer.h"
#import "IntroLayer.h"

@interface SAGameLayer()

@end

@implementation SAGameLayer

@synthesize audioPlayer;
@synthesize uiUpdateTimer;
@synthesize audioLevelLabel;
@synthesize listeningIcon;
@synthesize backButton;
/*It is helpful to assign sprites to preestablished layers. This stratification helps you keep sprites in front of or behind other sprites without having to get involved with the ordering of layer children. The layers have the following purposes:
    backgroundLayer -- for the sky or deep background
    baseStageLayer -- for most of the scenery
    activityLayer -- for the player & any objects (s)he interacts with
    foregroundLayer -- for any UI as well as masking scenery (i.e. the player would be behind such scenery were (s)he to go across this scenery)
 */
@synthesize backgroundLayer;
@synthesize baseStageLayer;
@synthesize activityLayer;
@synthesize foregroundLayer;
@synthesize shouldReturnPartials;
#define kLevelUpdatesPerSecond 18 // We'll have the ui update 18 times a second to show some fluidity without hitting the CPU too hard.
BOOL listeningIconIsVisible = false;
BOOL backButtonIsVisible = false;

- (id)init {
    //initialize with white background
    if (self=[super initWithColor:ccc4(255,255,255,255)])
    {
        //Add the sublayers for sprite stratification
        //ORDER MATTERS--first added is farthest back
        [self addChild:self.backgroundLayer];
        [self addChild:self.baseStageLayer];
        [self addChild:self.activityLayer];
        [self addChild:self.foregroundLayer];
    }
    return self;
}

- (AVAudioPlayer *)audioPlayer {
    if (audioPlayer == nil)
    {
        audioPlayer = [[AVAudioPlayer alloc] init];
    }
    return audioPlayer;
}

- (CCLayer *)backgroundLayer {
    if (backgroundLayer == nil)
    {
        backgroundLayer = [CCLayer node];
    }
    return backgroundLayer;
}

- (CCLayer *)baseStageLayer {
    if (baseStageLayer == nil)
    {
        baseStageLayer = [CCLayer node];
    }
    return baseStageLayer;
}

- (CCLayer *)activityLayer {
    if (activityLayer == nil)
    {
        activityLayer = [CCLayer node];
    }
    return activityLayer;
}

- (CCLayer *)foregroundLayer {
    if (foregroundLayer == nil)
    {
        foregroundLayer = [CCLayer node];
    }
    return foregroundLayer;
}


- (void)receiveOEEvent:(OEEvent*) speechEvent{
    //abstract method for dealing with speech events
    [NSException raise:NSInternalInconsistencyException
                format:@"You must overide %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void) receiveOEState:(OEEvent*) stateEvent{
    if([stateEvent isListening]) {
        [self startListeningIcon];
    } else {
        [self stopListeningIcon];
    }
    
}

- (void) shouldReturnPartials:(BOOL)returnPartials {
    shouldReturnPartials = returnPartials;
}

//
- (void) pauseListeningAndPlaySound:(NSURL*) file delay:(ccTime)dt {
    [[OEManager sharedManager] pauseListening];
    [self.audioPlayer initWithContentsOfURL:file error:nil];
    
    [self.audioPlayer play];
    //[[SimpleAudioEngine sharedEngine] playEffect:@"S1ChildPhrase.wav"];
    [self scheduleOnce:@selector(resumeListening:) delay:dt];
}

-(void) resumeListening:(id)sender {
    [[OEManager sharedManager] resumeListening];
}

- (void) startDisplayingLevels { // Start displaying the levels using a timer
	[self stopDisplayingLevels]; // We never want more than one timer valid so we'll stop any running timers first.
	self.uiUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/kLevelUpdatesPerSecond target:self selector:@selector(updateLevelsUI) userInfo:nil repeats:YES];
}

- (void) stopDisplayingLevels { // Stop displaying the levels by stopping the timer if it's running.
	if(self.uiUpdateTimer && [self.uiUpdateTimer isValid]) { // If there is a running timer, we'll stop it here.
		[self.uiUpdateTimer invalidate];
		self.uiUpdateTimer = nil;
	}
}

- (void) toggleListeningEar {
    listeningIconIsVisible = (listeningIconIsVisible==false ? TRUE:FALSE);
    if(listeningIconIsVisible) {
        listeningIcon = [CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"ear_quiet.png" selectedImage:@"ear_selected.png" target: self selector: @selector(toggleListening:)], nil];
        listeningIcon.position = ccp(460,290);
        [self.baseStageLayer addChild:listeningIcon];
    } else {
        [self.baseStageLayer removeChild:listeningIcon cleanup: false];
    }
}

- (void) startListeningIcon { // Start displaying the levels using a timer
    if(listeningIcon != nil){
        [self removeChild:listeningIcon cleanup:false];
    }
    listeningIcon = [CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"ear_listening.png" selectedImage:@"ear_selected.png" target: self selector: @selector(toggleListening:)], nil];
    listeningIcon.position = ccp(460,290);
    if(listeningIconIsVisible){
        [self.baseStageLayer addChild:listeningIcon];
    }
    
}

- (void) stopListeningIcon { // Stop displaying the levels by stopping the timer if it's running.
	if(listeningIcon != nil){
        [self removeChild:listeningIcon cleanup:false];
    }
    listeningIcon =[CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"ear_quiet.png" selectedImage:@"ear_selected.png" target: self selector: @selector(toggleListening:)], nil];
    listeningIcon.position = ccp(460,290);
    if(listeningIconIsVisible){
        [self.baseStageLayer addChild:listeningIcon];
    }
}

- (void) toggleListening:(id)sender {
    if([[OEManager sharedManager] isListening]) {
        [[OEManager sharedManager] pauseListening];
        listeningIcon =[CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"ear_paused.png" selectedImage:@"ear_selected.png" target: self selector: @selector(toggleListening:)], nil];
        listeningIcon.position = ccp(460,290);
    } else {
        [[OEManager sharedManager] resumeListening];
        listeningIcon =[CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"ear_quiet.png" selectedImage:@"ear_selected.png" target: self selector: @selector(toggleListening:)], nil];
        listeningIcon.position = ccp(460,290);
    }
    if(listeningIconIsVisible){
        [self.baseStageLayer addChild:listeningIcon];
    }
}

- (void) toggleBackButton {
    backButtonIsVisible = (backButtonIsVisible==false ? TRUE:FALSE);
    if(backButtonIsVisible) {
        backButton = [CCMenu menuWithItems: [CCMenuItemImage itemWithNormalImage:@"backarrow.png" selectedImage:@"backarrow_selected.png" target: self selector: @selector(goBack:)], nil];
        backButton.position = ccp(30,290);
        [self.baseStageLayer addChild:backButton];
    } else {
        [self.baseStageLayer removeChild:backButton cleanup: false];
    }
}

- (void) goBack:(id)sender {
    [self toggleBackButton];
    [self toggleListeningEar];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene] withColor:ccWHITE]];
}

- (void) updateLevelsUI { // And here is how we obtain the levels.  This method includes the actual OpenEars methods and uses their results to update the UI of this view controller.
    if(audioLevelLabel != nil){
        [self removeChild:audioLevelLabel cleanup:false];
    }
	NSString* audioLevel = [NSString stringWithFormat:@"%@",[[OEManager sharedManager] getAudioLevel]];
    audioLevelLabel = [CCLabelTTF labelWithString:audioLevel fontName:@"Arial" fontSize:48.0];
    audioLevelLabel.color = ccc3(0,0,0);
    audioLevelLabel.position = ccp(0, 300);
    [self addChild: audioLevelLabel];
}

// Helper class method that creates a Scene with the current layer as the only child.
+(CCScene *) scene
{
	//abstract method for integration with Cocos2D
    [NSException raise:NSInternalInconsistencyException
                format:@"You must overide %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

@end
