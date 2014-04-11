//
//  PopABalloon.m
//  SpeechAdventure
//
//  Created by John Chambers on 7/27/12.
//
//

#import "PopABalloon.h"
#import "ThankYouLayer.h"

@implementation PopABalloon

//@synthesize sam = _sam;
@synthesize samCharacter = _samCharacter;
@synthesize balloons = _balloons;
@synthesize sentenceLabel = _sentenceLabel;
@synthesize highlightedWord = _highlightedWord;
@synthesize statLevelEntry = _statLevelEntry;
@synthesize currentSentenceStats = _currentSentenceStats;
@synthesize levelTime = _levelTime;


#pragma mark -
#pragma mark Initializer & memory management

- (id) init {
    if (self=[super init]) {
        //SETUP CHARACTER(S)
        self.samCharacter = [[GameCharacter alloc] initWithFilePrefix:@"sam_sprite_sheet" withName:@"sam" withNumberOfAnimationFrames:1];
        [self.samCharacter setBaseFrame:@"sam_front_HAT.png"];
        [self.samCharacter setRewardFrame:@"sam_excite_HAT.png"];
        
        //******************ADD SPRITES TO THE PROPER LAYERS******************
        
        //BASE LAYER
        CCSprite *base = [CCSprite spriteWithFile:@"S1BaseStage.png"];
        base.anchorPoint = ccp(0,0);
        base.position = ccp(0,0);
        [self.baseStageLayer addChild:base];
        
        //sam2
        self.samCharacter.actualSprite.scale = 0.75f;
        self.samCharacter.spriteBatchNode.position = ccp(77,30);
        [self.activityLayer addChild:self.samCharacter.spriteBatchNode];
        
        //balloons
        for (int i = 0; i<3; i++) {
            CCSprite *newBalloon = [CCSprite spriteWithFile:@"Balloon2.png"];
            [self.balloons addObject:newBalloon];
        }
        ((CCSprite *)[self.balloons objectAtIndex:0]).position = ccp(325,170);
        ((CCSprite *)[self.balloons objectAtIndex:1]).position = ccp(345,150);
        ((CCSprite *)[self.balloons objectAtIndex:2]).position = ccp(365,180);
        
        for (CCSprite* myBalloon in self.balloons) {
            [self.activityLayer addChild:myBalloon];
        };
        
        //Oh baby it's statistics time
        _levelTime = [[NSDate date] retain];
        _statLevelEntry = [[StatLevelEntry alloc] initWithLevelName:@"PopABalloon"];
        
        //SETUP RECOGNITION
        //if(random()%2 == 0) {
            [[OEManager sharedManager] swapModel:@"PopABalloonPlosives"];
        //} else {
            //[[OEManager sharedManager] swapModel:@"PopABalloonPlosivesH"];
        //}
        [[OEManager sharedManager] registerDelegate:self shouldReturnPartials:false];
        
        //BEGIN ACTIONS
        [self intro];
    }
    return self;
}

//Initializer methods

- (NSMutableArray *)balloons {
    if (_balloons == nil)
    {
        _balloons = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _balloons;
}

#pragma mark -
#pragma mark Acts within the stage

- (void)intro{
    //animate sam2
    [self.samCharacter walkTo:ccp(255,80) withDirection:@"right_HAT"];
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"S1Prompt-Lourdes"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:6];
    [self scheduleOnce:@selector(sentence1:) delay:6];
}

-(void) sentence1:(ccTime)dt{
    // DISPLAY THE ALL-LISTENING EAR.
    [self toggleListeningEar];
    
    _currentSentenceStats = [[StatSentenceEntry alloc] init];
    [_currentSentenceStats setSentence:@"POP A BALLOON"];
    [self displayPhrase:@"Pop a Balloon" wordsToHighLight:nil];
}

-(void) sentence2:(ccTime)dt{
    _currentSentenceStats = [[StatSentenceEntry alloc] init];
    [_currentSentenceStats setSentence:@"CROSS THE BRIDGE"];
    [self displayPhrase:@"Cross the bridge" wordsToHighLight:nil];
}

- (void)sentence1Action{
    //Stat Collection
    NSLog(@"Number of attempts: %d", [_currentSentenceStats attempts]);
    [_statLevelEntry addSentence:_currentSentenceStats];
    
    //New stat
    _currentSentenceStats = [[StatSentenceEntry alloc] init];
    [_currentSentenceStats setSentence:@"POP A BALLOON"];
    
    //remove a balloon & play a sound
    [((CCSprite*)[self.balloons lastObject]) runAction:[CCHide action]];
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                   pathForResource:@"PoppingBalloon1"
                                                   ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:1.5];
    [self.balloons removeLastObject];
    
    //trigger exit if done
    if (self.balloons.count == 0) {
        [self scheduleOnce:@selector(reward1:) delay:1.5];
    }
}

- (void)sentence2Action{
    [_statLevelEntry addSentence:_currentSentenceStats];
    [self.samCharacter walkTo:ccp(340,150) withDirection:@"right_HAT"];
    [self reward2];
}

- (void)reward1:(ccTime)dt{
    //[self.sam runAction:exitAction];
    //[self.samCharacter reward];
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"S1Reward-Lourdes"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:6];
    [self scheduleOnce:@selector(sentence2:) delay:6];
}

- (void)reward2{
    NSURL* soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"ThatsRight"
                                               ofType:@"wav"]];
    [self pauseListeningAndPlaySound:soundFile delay:6];
    [self scheduleOnce:@selector(nextScene:) delay:6];
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
            if([(NSString*)highlightedWords[i] isEqualToString:@"Pop"]) {
                _highlightedWord = [CCLabelTTF labelWithString:@"Pop" fontName:@"Arial" fontSize:48.0];
                _highlightedWord.color = ccc3(255,255,0);
                _highlightedWord.position = ccp(175, 29);
            } else if([(NSString*)highlightedWords[i] isEqualToString:@"Balloon"]) {
                _highlightedWord = [CCLabelTTF labelWithString:@"Balloon" fontName:@"Arial" fontSize:48.0];
                _highlightedWord.color = ccc3(255,255,0);
                _highlightedWord.position = ccp(350, 29);
            } else if([(NSString*)highlightedWords[i] isEqualToString:@"Cross"]) {
                _highlightedWord = [CCLabelTTF labelWithString:@"Cross" fontName:@"Arial" fontSize:48.0];
                _highlightedWord.color = ccc3(255,255,0);
                _highlightedWord.position = ccp(165, 29);
            } else if([(NSString*)highlightedWords[i] isEqualToString:@"Bridge"]) {
                _highlightedWord = [CCLabelTTF labelWithString:@"Bridge" fontName:@"Arial" fontSize:48.0];
                _highlightedWord.color = ccc3(255,255,0);
                _highlightedWord.position = ccp(390, 29);
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
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ThankYouLayer scene] withColor:ccWHITE]];
}

#pragma mark -
#pragma mark Voice input handling

- (void)receiveOEEvent:(OEEvent*) speechEvent{
    NSLog(@"PopABalloon received speechEvent.\ntext:%@\nscore:%@",speechEvent.text,speechEvent.recognitionScore);
    
    if (([speechEvent.text rangeOfString:@"POP A BALLOON"].location != NSNotFound || [_currentSentenceStats attempts] >= 2)
        && [[_currentSentenceStats getSentence] isEqualToString:@"POP A BALLOON"] ) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self sentence1Action];
    } else if ([speechEvent.text rangeOfString:@"POP"].location != NSNotFound && [[_currentSentenceStats getSentence] isEqualToString:@"POP A BALLOON"] ) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self displayPhrase:@"Pop a Balloon" wordsToHighLight:[NSArray arrayWithObjects:@"Pop", nil]];
    } else if ([speechEvent.text rangeOfString:@"BALLOON"].location != NSNotFound && [[_currentSentenceStats getSentence] isEqualToString:@"POP A BALLOON"] ) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self displayPhrase:@"Pop a Balloon" wordsToHighLight:[NSArray arrayWithObjects:@"Balloon", nil]];
    }
    
    if (([speechEvent.text rangeOfString:@"CROSS THE BRIDGE"].location != NSNotFound || [_currentSentenceStats attempts] >= 3)
         && [[_currentSentenceStats getSentence] isEqualToString:@"CROSS THE BRIDGE"] ) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self sentence2Action];
    } else if ([speechEvent.text rangeOfString:@"CROSS"].location != NSNotFound && [[_currentSentenceStats getSentence] isEqualToString:@"CROSS THE BRIDGE"] ) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self displayPhrase:@"Cross the Bridge" wordsToHighLight:[NSArray arrayWithObjects:@"Cross", nil]];
    } else if ([speechEvent.text rangeOfString:@"BRIDGE"].location != NSNotFound && [[_currentSentenceStats getSentence] isEqualToString:@"CROSS THE BRIDGE"] ) {
        [_currentSentenceStats addUtterance:speechEvent.text];
        [self displayPhrase:@"Cross the Bridge" wordsToHighLight:[NSArray arrayWithObjects:@"Bridge", nil]];
    }
}

#pragma mark -
#pragma mark Cocos2D Methods
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	PopABalloon *layer = [PopABalloon node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
    // return the scene
	return scene;
}

@end
