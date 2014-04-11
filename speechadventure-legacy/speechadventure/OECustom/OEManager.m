//
//  OEManager.m
//  SpeechAdventure
//
//  Created by John Chambers on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OpenEars/PocketSphinxController.h>
#import <RapidEars/PocketsphinxController+RapidEars.h>
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/OpenEarsLogging.h>
#import <Rejecto/LanguageModelGenerator+Rejecto.h>
#import <OpenEars/AcousticModel.h>

#import "OEManager.h"

@interface OEManager()

@end

@implementation OEManager

@synthesize openEarsEventsObserver = _openEarsEventsObserver;
@synthesize pocketsphinxController = _pocketsphinxController;
@synthesize languageModelGenerator = _languageModelGenerator;
@synthesize modelKeyword = _modelKeyword;
@synthesize modelDictionaryPath = _modelDictionaryPath;
@synthesize modelGrammarPath = _modelGrammarPath;
@synthesize notificationRegistrants = _notificationRegistrants;
@synthesize modelsDictionary = _modelsDictionary;
@synthesize useLiveSpeech;
@synthesize debuggingMode = _debuggingMode;
@synthesize recordingCutoffTimer;

#define recordingCutoffTime 3

#pragma mark -
#pragma mark Memory Management

// Lazily allocate utility objects

// Lazily allocate PocketsphinxController.
- (PocketsphinxController *)pocketsphinxController { 
	if (_pocketsphinxController == nil) {
		_pocketsphinxController = [[PocketsphinxController alloc] init];
        //great for troubleshooting
        _pocketsphinxController.verbosePocketSphinx = TRUE;
	}
	return _pocketsphinxController;
}

// Lazily allocate OpenEarsEventsObserver.
- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (_openEarsEventsObserver == nil) {
		_openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return _openEarsEventsObserver;
}

//Lazily allocate LanguageModelGenerator
- (LanguageModelGenerator *)languageModelGenerator {
    if (_languageModelGenerator == nil) {
        _languageModelGenerator = [[LanguageModelGenerator alloc] init];
    }
    return _languageModelGenerator;
}

//Lazily allocate notificationRegistrants array
- (NSMutableArray *)notificationRegistrants {
    if (_notificationRegistrants == nil)
    {
        _notificationRegistrants = [[NSMutableArray alloc] initWithCapacity:15];
    }
    return _notificationRegistrants;
}

//Lazily allocate modelsDictionary
- (NSMutableDictionary *)modelsDictionary {
    if (_modelsDictionary == nil)
    {
        _modelsDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return _modelsDictionary;
}

#pragma mark -
#pragma mark Initializers

- (id) initWithModel:(NSString *)modelName {
    if (self = [super init])
    {
        //register for OpenEars events
        [self.openEarsEventsObserver setDelegate:self];
        
        //apply any parameters
        [self setModel:modelName];
    }
    NSLog(@"Successfully initialized");
    return self;
}

- (id) init {
    return [self initWithModel:@"OpenEars1"];
}

#pragma mark -
#pragma mark PocketSphinx Control

- (void) startListening {
    if(!self.listeningStarted) {
        NSLog(@"OpenEars: About to start listening");
        //[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.modelGrammarPath dictionaryAtPath:self.modelDictionaryPath languageModelIsJSGF: NO];
        [self.pocketsphinxController setRapidEarsToVerbose:FALSE]; // This defaults to FALSE but will give a lot of debug readout if set TRUE
        [self.pocketsphinxController setRapidEarsAccuracy:20]; // This defaults to 20, maximum accuracy, but can be set as low as 1 to save CPU
        [self.pocketsphinxController setFinalizeHypothesis:TRUE]; // This defaults to TRUE and will return a final hypothesis, but can be turned off to save a little CPU and will then return no final hypothesis; only partial "live" hypotheses.
        [self.pocketsphinxController setFasterPartials:TRUE]; // This will give faster rapid recognition with less accuracy. This is what you want in most cases since more accuracy for partial hypotheses will have a delay.
        [self.pocketsphinxController setFasterFinals:FALSE]; // This will give an accurate final recognition. You can have earlier final recognitions with less accuracy as well by setting this to TRUE.
        [self.pocketsphinxController startRealtimeListeningWithLanguageModelAtPath:self.modelGrammarPath dictionaryAtPath:self.modelDictionaryPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"]];
        //[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.modelGrammarPath dictionaryAtPath:self.modelDictionaryPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:false];
        self.listeningStarted = true;
        self.isListening = true;
        NSLog(@"OpenEars: Started listening");
    }
}

- (void) stopListening {
    [self.pocketsphinxController stopListening];
    self.listeningStarted = false;
    NSLog(@"OpenEars: Stopped listening");
}

- (void) pauseListening {
    [self.pocketsphinxController suspendRecognition];
    self.isListening = false;
    NSLog(@"OpenEars: Paused listening");
}

- (void) resumeListening {
    [self.pocketsphinxController resumeRecognition];
    self.isListening = true;
    NSLog(@"OpenEars: Resumed listening");
}

- (NSString*) getAudioLevel{
    return [NSString stringWithFormat:@"Input level:%f",[self.pocketsphinxController pocketsphinxInputLevel]];
}


- (void) setModel:(NSString *) modelName {
    NSString *dicName = [modelName stringByAppendingString:@".dic"];
    NSString *grammarName = [modelName stringByAppendingString:@".langmodel"];
    self.modelGrammarPath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], grammarName];
    self.modelDictionaryPath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], dicName];
}

- (void) swapModel:(NSString *) modelName {
    NSString *dicName = [modelName stringByAppendingString:@".dic"];
    NSString *grammarName = [modelName stringByAppendingString:@".langmodel"];
    self.modelGrammarPath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], grammarName];
    self.modelDictionaryPath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], dicName];
    [self.pocketsphinxController changeLanguageModelToFile:self.modelGrammarPath withDictionary:self.modelDictionaryPath];
}

- (void) swapToDynamicModel:(NSString *) grammarPath withDictionary: (NSString*) dictionaryPath {
    self.modelGrammarPath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], grammarPath];
    self.modelDictionaryPath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], dictionaryPath];
    [self.pocketsphinxController changeLanguageModelToFile:self.modelGrammarPath withDictionary:self.modelDictionaryPath];
    
}

#pragma mark -
#pragma mark Notification Registration
- (void) registerDelegate:(id<OEDelegate>)delegate shouldReturnPartials:(BOOL) shouldReturnPartials{
    [delegate setShouldReturnPartials:shouldReturnPartials];
    [self.notificationRegistrants addObject:delegate];
    NSLog(@"OpenEars Delegate registered");
}

- (void) removeDelegate:(id<OEDelegate>)delegate {
    [self.notificationRegistrants removeObject:delegate];
}

#pragma mark -
#pragma mark Singleton Stuff
static OEManager *theManager = nil;

+ (OEManager *) sharedManager {
    if (theManager == nil) {
        theManager = [[super allocWithZone:NULL] init];
    }
    return theManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
    
}

- (id)autorelease {
    return self;
}

#pragma mark -
#pragma mark OpenEarsEventsObserver delegate methods

// pocketsphinxDidReceiveHypothesis is deprecated, please use rapidEarsDidDetectFinishedSpeechAsWordArray 
- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    
	NSLog(@"OpenEars received hypothesis %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID); // Log it.
    if ([hypothesis isEqualToString:@"STOP"])
    {
        [self stopListening];
    }
    
    //generate the event
    OEEvent *voiceEvent = [[OEEvent alloc] initWithText:hypothesis andScore:[[NSNumber alloc] initWithDouble:[recognitionScore doubleValue]]];
    
    //actually deliver the event
    NSEnumerator *registrantArrayTraverser = [self.notificationRegistrants objectEnumerator];
    id<OEDelegate> currentRegistrant;
    
    while (currentRegistrant = [registrantArrayTraverser nextObject])
    {
        if ([currentRegistrant conformsToProtocol:@protocol(OEDelegate)] &&
            ![currentRegistrant shouldReturnPartials])
        {
            [currentRegistrant receiveOEEvent:voiceEvent];
        }
    }
}

- (void) rapidEarsDidReceiveLiveSpeechHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore {
    NSLog(@"detected words: %@",hypothesis);
    OEEvent *voiceEvent = [[OEEvent alloc] initWithText:hypothesis andScore:[[NSNumber alloc] initWithDouble:0.0] andType:RapidEarsPartial];
    NSEnumerator *registrantArrayTraverser = [self.notificationRegistrants objectEnumerator];
    id<OEDelegate> currentRegistrant;
    
    while (currentRegistrant = [registrantArrayTraverser nextObject])
    {
        if ([currentRegistrant conformsToProtocol:@protocol(OEDelegate)] &&
            [currentRegistrant shouldReturnPartials])
        {
            [currentRegistrant receiveOEEvent:voiceEvent];
        }
    }
}

- (void) rapidEarsDidReceiveFinishedSpeechHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore {
    NSLog(@"detected complete statement: %@",hypothesis);
    // Generate and deliver the event
    OEEvent *voiceEvent = [[OEEvent alloc] initWithText:hypothesis andScore:[[NSNumber alloc] initWithDouble:0.0] andType:RapidEarsResponse];
    NSEnumerator *registrantArrayTraverser = [self.notificationRegistrants objectEnumerator];
    id<OEDelegate> currentRegistrant;
    
    while (currentRegistrant = [registrantArrayTraverser nextObject])
    {
        if ([currentRegistrant conformsToProtocol:@protocol(OEDelegate)] &&
            [currentRegistrant shouldReturnPartials])
        {
            [currentRegistrant receiveOEEvent:voiceEvent];
        }
    }
}

- (void) rapidEarsDidDetectBeginningOfSpeech {
    NSLog(@"rapidEarsDidDetectBeginningOfSpeech");
}

- (void) rapidEarsDidDetectEndOfSpeech {
    NSLog(@"rapidEarsDidDetectEndOfSpeech");
}

- (void) pocketSphinxContinuousSetupDidFail {
    NSLog(@"OpenEars setup failed");
}

- (void) pocketsphinxDidCompleteCalibration {
    if (self.debuggingMode) {
        NSLog(@"OpenEars calibration complete");
    }
}

- (void) pocketsphinxDidResumeRecognition {
    if (self.debuggingMode) {
        NSLog(@"OpenEars resume complete");
    }
}

- (void) pocketsphinxDidDetectSpeech {
    NSLog(@"OpenEars detected speech");
    //self.recordingCutoffTimer = [NSTimer scheduledTimerWithTimeInterval:recordingCutoffTime target:self selector:@selector(recordingCutoff) userInfo:nil repeats:NO];
    OEEvent *listening = [[OEEvent alloc] initWithListeningState:true];
    
    //actually deliver the event
    NSEnumerator *registrantArrayTraverser = [self.notificationRegistrants objectEnumerator];
    id<OEDelegate> currentRegistrant;
    
    while (currentRegistrant = [registrantArrayTraverser nextObject])
    {
        if ([currentRegistrant conformsToProtocol:@protocol(OEDelegate)])
        {
            [currentRegistrant receiveOEState:listening];
        }
    }
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
    
    OEEvent *listening = [[OEEvent alloc] initWithListeningState:false];
    NSEnumerator *registrantArrayTraverser = [self.notificationRegistrants objectEnumerator];
    id<OEDelegate> currentRegistrant;
    
    while (currentRegistrant = [registrantArrayTraverser nextObject])
    {
        if ([currentRegistrant conformsToProtocol:@protocol(OEDelegate)])
        {
            [currentRegistrant receiveOEState:listening];
        }
    }
    //[self.recordingCutoffTimer invalidate];
}

// This ensures that the system doesn't get locked up with a big sentence.
// Buggy as hell, don't use for now.
- (void) recordingCutoff {
    NSLog(@"Recording is too long, cutting"); // Log it.
    [self.pocketsphinxController suspendRecognition];
    //[self.pocketsphinxController.continuousModel stopDevice];
    self.recordingCutoffTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(recordingResume) userInfo:nil repeats:NO];
}

- (void) recordingResume {
    
}

@end
