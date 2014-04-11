//
//  TutorialLevel.m
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/16/13.
//
//

#import "TutorialLevel.h"
#import "LivingRoomLayer.h"

@implementation TutorialLevel

@synthesize samCharacter;
@synthesize arrow;

@synthesize ageMenu;
@synthesize childLabel;
@synthesize adultLabel;
@synthesize sentenceLabel;
@synthesize highlightedWord;
@synthesize statLevelEntry;
@synthesize currentSentenceStats;
@synthesize levelTime;

#pragma mark -
#pragma mark Initializer & memory management

- (id) init {
    if (self=[super init]) {
        //SETUP CHARACTER(S)
        self.samCharacter = [[GameCharacter alloc] initWithFilePrefix:@"sam_sprite_sheet" withName:@"sam" withNumberOfAnimationFrames:1];
        
        //******************ADD SPRITES TO THE PROPER LAYERS******************
        
        //Oh baby it's statistics time
        levelTime = [[NSDate date] retain];
        statLevelEntry = [[StatLevelEntry alloc] initWithLevelName:@"Tutorial"];
        
        //SETUP RECOGNITION
        //if(random()%2 isEqualToString) {
        //[[OEManager sharedManager] swapModel:@"LivingRoomPlosives"];
        //} else {
        [[OEManager sharedManager] swapModel:@"OpenEars1"];
        //}
        [[OEManager sharedManager] pauseListening]; //don't want events right now
        [[OEManager sharedManager] registerDelegate:self shouldReturnPartials:false];
        
        //BEGIN ACTIONS
        [self intro];
    }
    return self;
}

- (void)ageSelect {
    [self displayPhrase:@"Please touch your age" wordsToHighLight:nil];
    [self displayAgeSelect];
}

- (void)intro{
    
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"TutorialIntroPrompt"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:5];
    //sam2
    self.samCharacter.actualSprite.scale = 1.0f;
    self.samCharacter.spriteBatchNode.position = ccp(180,80);
    [self.activityLayer addChild:self.samCharacter.spriteBatchNode];
    
    self.arrow = [CCSprite spriteWithFile:@"Arrow.png"];
    self.arrow.position = ccp(420,290);
    //animate sam2
    [self.samCharacter walkTo:ccp(180,180) withDirection:@"up"];
    [self displayPhrase:@"Talk to Sam to help him" wordsToHighLight:nil];
    [self scheduleOnce:@selector(sentence1:) delay:2];
}

-(void) sentence1:(ccTime)dt{
    [self displayPhrase:@"When he hears you" wordsToHighLight:nil];
    [self scheduleOnce:@selector(sentence2:) delay:2];
}

-(void) sentence2:(ccTime)dt{
    //[self startDisplayingLevels];
    [self toggleListeningEar];
    [self.activityLayer addChild:self.arrow];
    [self displayPhrase:@"The ear will turn blue!" wordsToHighLight:nil];
    [self scheduleOnce:@selector(sentence3:) delay:2];
}

-(void) sentence3:(ccTime)dt{
    //[self startDisplayingLevels];
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"TutorialPrompt1"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:2];
    [self.activityLayer removeChild:self.arrow cleanup:false];
    currentSentenceStats = [[StatSentenceEntry alloc] init];
    [currentSentenceStats setSentence:@"GO RIGHT"];
    [self displayPhrase:@"Say \"Go right!\"" wordsToHighLight:nil];
}

-(void) sentence4:(ccTime)dt{
    //[self startDisplayingLevels];
    currentSentenceStats = [[StatSentenceEntry alloc] init];
    [currentSentenceStats setSentence:@"TOUCH TO START"];
    [self displayPhrase:@"Touch here to start" wordsToHighLight:nil];
}

- (void)sentence3Action{
    //Stat Collection
    NSLog(@"Number of attempts: %d", [currentSentenceStats attempts]);
    [statLevelEntry addSentence:currentSentenceStats];
    [self.samCharacter reward];
    [self reward1];
    [self scheduleOnce:@selector(sentence4:) delay:1];
}

- (void)reward1{
    //[self.sam runAction:exitAction];
    [self.samCharacter walkTo:ccp(600,180) withDirection:@"right"];
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"ThatsRight"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:2];
    [self scheduleOnce:@selector(sentence4:) delay:2];
}

-(void) sayPhrase:(id)sender{
    if([[currentSentenceStats getSentence] isEqualToString:@"TOUCH TO START"]) {
        [self scheduleOnce:@selector(nextScene:) delay:0];
    }
}


-(void) childSelected:(id)sender{
    [[[StatManager sharedManager] currentStatEntry] setIsChild:true];
    [self removeChild: childLabel cleanup:true];
    [self removeChild: adultLabel cleanup:true];
    [self removeChild: ageMenu cleanup:true];
    
    [self intro];
}

-(void) adultSelected:(id)sender{
    [[[StatManager sharedManager] currentStatEntry] setIsChild:false];
    [self removeChild: childLabel cleanup:true];
    [self removeChild: adultLabel cleanup:true];
    [self removeChild: ageMenu cleanup:true];
    
    [self intro];
}

-(void) displayAgeSelect {
    CCMenuItem *childBox = [CCMenuItemImage itemWithNormalImage:@"Textbox_small.png" selectedImage:@"Textbox_small_sel.png" target: self selector: @selector(childSelected:)];
    childBox.position = ccp(180, 160);
    CCMenuItem *adultBox = [CCMenuItemImage itemWithNormalImage:@"Textbox_small.png" selectedImage:@"Textbox_small_sel.png" target: self selector: @selector(adultSelected:)];
    adultBox.position = ccp(300, 160);
    ageMenu = [CCMenu menuWithItems:childBox, adultBox, nil];
    ageMenu.position = CGPointZero;
    [self addChild: ageMenu];

    NSString *childText = [[NSString alloc] initWithString:@"0-7"];
    NSString *adultText = [[NSString alloc] initWithString:@"7+"];
    
    childLabel = [CCLabelTTF labelWithString:childText fontName:@"Arial" fontSize:44.0];
    childLabel.color = ccc3(0,0,0);
    childLabel.position = ccp(180, 160);
    adultLabel = [CCLabelTTF labelWithString:adultText fontName:@"Arial" fontSize:44.0];
    adultLabel.color = ccc3(0,0,0);
    adultLabel.position = ccp(300, 160);
    [self addChild: childLabel];
    [self addChild: adultLabel];
}

-(void) displayPhrase:(NSString*)phrase wordsToHighLight:(NSArray*)highlightedWords {
    CCMenuItem *promptBox = [CCMenuItemImage itemWithNormalImage:@"Textbox_large.png" selectedImage:@"Textbox_large_sel.png" target: self selector: @selector(sayPhrase:)];
    promptBox.position = ccp(240, 29);
    CCMenu *promptMenu = [CCMenu menuWithItems:promptBox, nil];
    promptMenu.position = CGPointZero;
    [self addChild: promptMenu];
    if(sentenceLabel != nil) {
        [self removeChild:sentenceLabel cleanup:false];
    }
    NSString *obstacleText = [[NSString alloc] initWithString:phrase];
    sentenceLabel = [CCLabelTTF labelWithString:obstacleText fontName:@"Arial" fontSize:44.0];
    sentenceLabel.color = ccc3(0,0,0);
    sentenceLabel.position = ccp(240, 29);
    [self addChild: sentenceLabel];
    int i;
    if([highlightedWords count] > 0){
        if(highlightedWord != nil) {
            [self removeChild:highlightedWord cleanup:false];
        }
        for(i=0; i<[highlightedWords count]; i++) {
            if([(NSString*)highlightedWords[i] isEqualToString:@"Put"]) {
                highlightedWord = [CCLabelTTF labelWithString:@"Put" fontName:@"Arial" fontSize:44.0];
                highlightedWord.color = ccc3(255,255,0);
                highlightedWord.position = ccp(175, 29);
            } else if([(NSString*)highlightedWords[i] isEqualToString:@"Boots"]) {
                highlightedWord = [CCLabelTTF labelWithString:@"Boots" fontName:@"Arial" fontSize:44.0];
                highlightedWord.color = ccc3(255,255,0);
                highlightedWord.position = ccp(350, 29);
            }
        }
        [self addChild: highlightedWord];
    }
}

- (void)receiveOEEvent:(OEEvent*) speechEvent{
    NSLog(@"PopABalloon received speechEvent.\ntext:%@\nscore:%@",speechEvent.text,speechEvent.recognitionScore);
    
    [currentSentenceStats addUtterance:speechEvent.text];
    
    if (([speechEvent.text rangeOfString:@"GO RIGHT"].location != NSNotFound || [currentSentenceStats attempts] >= 2)
        && [[currentSentenceStats getSentence] isEqualToString:@"GO RIGHT"] ) {
        [self sentence3Action];
    }
}

-(void) nextScene:(ccTime)dt {
    [statLevelEntry calculatePlayTime];
    [self toggleListeningEar];
    [[[StatManager sharedManager] currentStatEntry] addLevel:statLevelEntry];
    [[OEManager sharedManager] removeDelegate:self];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LivingRoomLayer scene] withColor:ccWHITE]];
}

#pragma mark -
#pragma mark Cocos2D Methods
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	TutorialLevel *layer = [TutorialLevel node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
    // return the scene
	return scene;
}

@end
