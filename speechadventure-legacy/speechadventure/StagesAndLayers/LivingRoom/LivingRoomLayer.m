//
//  LivingRoomLayer.m
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/10/13.
//
//

#import "LivingRoomLayer.h"
#import "PopABalloon.h"

@implementation LivingRoomLayer

//@synthesize sam = _sam;
@synthesize samCharacter = _samCharacter;
@synthesize sentenceLabel = _sentenceLabel;
@synthesize highlightedWord = _highlightedWord;
@synthesize statLevelEntry = _statLevelEntry;
@synthesize currentSentenceStats = _currentSentenceStats;
@synthesize levelTime = _levelTime;
@synthesize boots;
@synthesize hat;


#pragma mark -
#pragma mark Initializer & memory management

- (id) init {
    if (self=[super init]) {
        // SETUP CHARACTER(S)
        self.samCharacter = [[GameCharacter alloc] initWithFilePrefix:@"sam_sprite_sheet" withName:@"sam" withNumberOfAnimationFrames:1];
        
        //******************ADD SPRITES TO THE PROPER LAYERS******************
        
        // BASE LAYER
        CCSprite *base = [CCSprite spriteWithFile:@"BaseStage.png"];
        base.anchorPoint = ccp(0,0);
        base.position = ccp(0,0);
        [self.baseStageLayer addChild:base];
        
        // boots
        self.boots = [CCSprite spriteWithFile:@"boots.png"];
        self.boots.position = ccp(180,110);
        self.boots.scale = 0.75f;
        [self.activityLayer addChild:boots];
        // hat
        self.hat = [CCSprite spriteWithFile:@"hat.png"];
        self.hat.position = ccp(260,170);
        [self.activityLayer addChild:hat];
        
        // sam2
        self.samCharacter.actualSprite.scale = 1.0f;
        self.samCharacter.spriteBatchNode.position = ccp(0,0);
        [self.activityLayer addChild:self.samCharacter.spriteBatchNode];
        
        // It's statistics time
        _statLevelEntry = [[StatLevelEntry alloc] initWithLevelName:@"LivingRoomPlosives"];
        
        // SETUP RECOGNITION
        [[OEManager sharedManager] swapModel:@"LivingRoomPlosives"];
        [[OEManager sharedManager] registerDelegate:self shouldReturnPartials:true];
        
        // BEGIN ACTIONS
        [self intro];
    }
    return self;
}

//Initializer methods

#pragma mark -
#pragma mark Acts within the stage

- (void)intro{
    //animate sam2
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"LivingRoomIntro"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:2];
    [self.samCharacter walkTo:ccp(255,80) withDirection:@"right"];
    [self scheduleOnce:@selector(sentence1:) delay:2];
}

-(void) sentence1:(ccTime)dt{
    // DISPLAY THE ALL-LISTENING EAR.
    [self toggleListeningEar];
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"PutOnBoots"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:2];
    _currentSentenceStats = [[StatSentenceEntry alloc] init];
    [_currentSentenceStats setSentence:@"PUT ON BOOTS"];
    [self displayPhrase:@"Put on boots" wordsToHighLight:nil];
}

-(void) sentence2:(ccTime)dt{
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"WearAHat"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:2];
    _currentSentenceStats = [[StatSentenceEntry alloc] init];
    [_currentSentenceStats setSentence:@"WEAR A HAT"];
    [self displayPhrase:@"Wear a hat" wordsToHighLight:nil];
}

-(void) sentence3:(ccTime)dt{
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"OpenTheDoor"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:2];
    _currentSentenceStats = [[StatSentenceEntry alloc] init];
    [_currentSentenceStats setSentence:@"OPEN THE DOOR"];
    [self displayPhrase:@"Open the door" wordsToHighLight:nil];
}

- (void)sentence1Action{
    //Stat Collection
    [self.samCharacter reward];
    NSLog(@"Number of attempts: %d", [_currentSentenceStats attempts]);
    [_statLevelEntry addSentence:_currentSentenceStats];
    [self reward1];
}

- (void)sentence2Action{
    [self.samCharacter reward];
    [_statLevelEntry addSentence:_currentSentenceStats];
    [self.activityLayer removeChild:hat cleanup:true];
    [self.samCharacter setBaseFrame:@"sam_front_HAT.png"];
    [self.samCharacter setRewardFrame:@"sam_excite_HAT.png"];
    [self reward2];
}

- (void)sentence3Action{
    [self.samCharacter reward];
    CCSprite *base = [CCSprite spriteWithFile:@"BaseStage_opendoor.png"];
    base.anchorPoint = ccp(0,0);
    base.position = ccp(0,0);
    [self.baseStageLayer addChild:base];
    [_statLevelEntry addSentence:_currentSentenceStats];
    [self reward3];
}

- (void)reward1{
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"SlugsDontWearBoots"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:3];
    [self scheduleOnce:@selector(sentence2:) delay:3];
}

- (void)reward2{
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"SomethingASlugCanWear"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:3];
    [self scheduleOnce:@selector(sentence3:) delay:3];
}

- (void)reward3{
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"LivingRoomComplete"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:3];
    [self scheduleOnce:@selector(nextScene:) delay:3];
}

-(void) sayPhrase:(id)sender{
    /*NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"S1ChildPhrase"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:1.5];*/
}

-(void) displayPhrase:(NSString*)phrase wordsToHighLight:(NSArray*)highlightedWords {
    CCMenuItem *promptBox = [CCMenuItemImage itemWithNormalImage:@"Textbox_large.png" selectedImage:@"Textbox_large_sel.png" target: self selector: @selector(sayPhrase:)];
    promptBox.position = ccp(240, 29);
    CCMenu *promptMenu = [CCMenu menuWithItems:promptBox, nil];
    promptMenu.position = CGPointZero;
    [self addChild: promptMenu];
    if(_sentenceLabel != nil) {
        [self removeChild:_sentenceLabel cleanup:false];
    }
    NSString *obstacleText = @"Say \"";
    obstacleText = [obstacleText stringByAppendingString:phrase];
    obstacleText = [obstacleText stringByAppendingString:@"\"!"];
    _sentenceLabel = [CCLabelTTF labelWithString:obstacleText fontName:@"Arial" fontSize:48.0];
    _sentenceLabel.color = ccc3(0,0,0);
    _sentenceLabel.position = ccp(240, 29);
    [self addChild: _sentenceLabel];
    int i;
    if([highlightedWords count] > 0){
        if(_highlightedWord != nil) {
            [self removeChild:_highlightedWord cleanup:false];
        }
        for(i=0; i<[highlightedWords count]; i++) {
            if([(NSString*)highlightedWords[i] isEqualToString:@"Put"]) {
                _highlightedWord = [CCLabelTTF labelWithString:@"Put" fontName:@"Arial" fontSize:48.0];
                _highlightedWord.color = ccc3(255,255,0);
                _highlightedWord.position = ccp(215, 29);
            }
            if([(NSString*)highlightedWords[i] isEqualToString:@"Put on"]) {
                _highlightedWord = [CCLabelTTF labelWithString:@"Put on" fontName:@"Arial" fontSize:48.0];
                _highlightedWord.color = ccc3(255,255,0);
                _highlightedWord.position = ccp(215, 29);
            }
            if([(NSString*)highlightedWords[i] isEqualToString:@"Put on boots"]) {
                _highlightedWord = [CCLabelTTF labelWithString:@"Put on boots" fontName:@"Arial" fontSize:48.0];
                _highlightedWord.color = ccc3(255,255,0);
                _highlightedWord.position = ccp(355, 29);
            }
            if([(NSString*)highlightedWords[i] isEqualToString:@"Wear"]) {
                _highlightedWord = [CCLabelTTF labelWithString:@"Wear" fontName:@"Arial" fontSize:48.0];
                _highlightedWord.color = ccc3(255,255,0);
                _highlightedWord.position = ccp(220, 29);
            }
            if([(NSString*)highlightedWords[i] isEqualToString:@"Wear a"]) {
                _highlightedWord = [CCLabelTTF labelWithString:@"Wear a" fontName:@"Arial" fontSize:48.0];
                _highlightedWord.color = ccc3(255,255,0);
                _highlightedWord.position = ccp(365, 29);
            }
            if([(NSString*)highlightedWords[i] isEqualToString:@"Wear a hat"]) {
                _highlightedWord = [CCLabelTTF labelWithString:@"Wear a hat" fontName:@"Arial" fontSize:48.0];
                _highlightedWord.color = ccc3(255,255,0);
                _highlightedWord.position = ccp(365, 29);
            }
            if([(NSString*)highlightedWords[i] isEqualToString:@"Open"]) {
                _highlightedWord = [CCLabelTTF labelWithString:@"Open" fontName:@"Arial" fontSize:48.0];
                _highlightedWord.color = ccc3(255,255,0);
                _highlightedWord.position = ccp(186, 29);
            }
            if([(NSString*)highlightedWords[i] isEqualToString:@"Open the"]) {
                _highlightedWord = [CCLabelTTF labelWithString:@"Open the" fontName:@"Arial" fontSize:48.0];
                _highlightedWord.color = ccc3(255,255,0);
                _highlightedWord.position = ccp(227, 29);
            }
            if([(NSString*)highlightedWords[i] isEqualToString:@"Open the door"]) {
                _highlightedWord = [CCLabelTTF labelWithString:@"Open the door" fontName:@"Arial" fontSize:48.0];
                _highlightedWord.color = ccc3(255,255,0);
                _highlightedWord.position = ccp(280, 29);
            }
        }
        [self addChild: _highlightedWord];
    }
}

-(void) nextScene:(ccTime)dt {
    [self toggleListeningEar];
    [_statLevelEntry calculatePlayTime];
    [[[StatManager sharedManager] currentStatEntry] addLevel:_statLevelEntry];
    [[OEManager sharedManager] removeDelegate:self];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[PopABalloon scene] withColor:ccWHITE]];
}

#pragma mark -
#pragma mark Voice input handling

- (void)receiveOEEvent:(OEEvent*) speechEvent{
    NSLog(@"LivingRoom received speechEvent.\ntext:%@\nscore:%@",speechEvent.text,speechEvent.recognitionScore);
    
    [_currentSentenceStats addUtterance:speechEvent.text];
    
    if (([speechEvent.text rangeOfString:@"PUT ON BOOTS"].location != NSNotFound)
        && [[_currentSentenceStats getSentence] isEqualToString:@"PUT ON BOOTS"]) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self sentence1Action];
    }
    if ([speechEvent.text rangeOfString:@"PUT ON"].location != NSNotFound && [[_currentSentenceStats getSentence] isEqualToString:@"PUT ON BOOTS"]) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self displayPhrase:@"Put on boots" wordsToHighLight:[NSArray arrayWithObjects:@"Put on", nil]];
    }
    if ([speechEvent.text rangeOfString:@"PUT"].location != NSNotFound && [[_currentSentenceStats getSentence] isEqualToString:@"PUT ON BOOTS"]) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self displayPhrase:@"Put on boots" wordsToHighLight:[NSArray arrayWithObjects:@"Put", nil]];
    }
    
    if (([speechEvent.text rangeOfString:@"WEAR A HAT"].location != NSNotFound)
        && [[_currentSentenceStats getSentence] isEqualToString:@"WEAR A HAT"]) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self sentence2Action];
    } else if ([speechEvent.text rangeOfString:@"WEAR"].location != NSNotFound && [[_currentSentenceStats getSentence] isEqualToString:@"WEAR A HAT"]) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self displayPhrase:@"Wear a hat" wordsToHighLight:[NSArray arrayWithObjects:@"Wear", nil]];
    } else if ([speechEvent.text rangeOfString:@"HAT"].location != NSNotFound && [[_currentSentenceStats getSentence] isEqualToString:@"WEAR A HAT"]) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self displayPhrase:@"Wear a hat" wordsToHighLight:[NSArray arrayWithObjects:@"Hat", nil]];
    }
    
    if (([speechEvent.text rangeOfString:@"OPEN THE DOOR"].location != NSNotFound)
        && [[_currentSentenceStats getSentence] isEqualToString:@"OPEN THE DOOR"]) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self displayPhrase:@"Open the door" wordsToHighLight:[NSArray arrayWithObjects:@"Open the door", nil]];
        [self sentence3Action];
    } else if ([speechEvent.text rangeOfString:@"OPEN THE"].location != NSNotFound && [[_currentSentenceStats getSentence] isEqualToString:@"OPEN THE DOOR"]) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self displayPhrase:@"Open the door" wordsToHighLight:[NSArray arrayWithObjects:@"Open the", nil]];
    } else if ([speechEvent.text rangeOfString:@"OPEN"].location != NSNotFound && [[_currentSentenceStats getSentence] isEqualToString:@"OPEN THE DOOR"]) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self displayPhrase:@"Open the door" wordsToHighLight:[NSArray arrayWithObjects:@"Open", nil]];
    }
}

#pragma mark -
#pragma mark Cocos2D Methods
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	LivingRoomLayer *layer = [LivingRoomLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
    // return the scene
	return scene;
}

@end
