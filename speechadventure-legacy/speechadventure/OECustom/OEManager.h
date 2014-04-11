//
//  OEManager.h
//  SpeechAdventure
//
//  Created by John Chambers on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class PocketsphinxController;

#import <OpenEars/OpenEarsEventsObserver.h>
#import <RapidEars/OpenEarsEventsObserver+RapidEars.h>

#import <OpenEars/LanguageModelGenerator.h>

#import "OEDelegate.h"

@interface OEManager : NSObject<OpenEarsEventsObserverDelegate>

- (id) initWithModel:(NSString *) modelName;
- (id) init;

- (void) startListening;
- (void) stopListening;
- (void) pauseListening;
- (void) resumeListening;
- (NSString*) getAudioLevel;

- (void) setModel:(NSString *) modelName;
- (void) swapModel:(NSString *) modelName;
- (void) swapToDynamicModel:(NSString *) grammarPath withDictionary: (NSString*) dictionaryPath;

- (void) registerDelegate:(id <OEDelegate>) delegate shouldReturnPartials:(BOOL) returnPartials;
- (void) removeDelegate:(id <OEDelegate>) delegate;

//have a shared manager for the whole program
+ (OEManager *) sharedManager;

@property (nonatomic, strong) OpenEarsEventsObserver *openEarsEventsObserver;
@property (nonatomic, strong) PocketsphinxController *pocketsphinxController;
@property (nonatomic, copy) NSString *modelKeyword;
@property (nonatomic, copy) NSString *modelDictionaryPath;
@property (nonatomic, copy) NSString *modelGrammarPath;
@property (nonatomic, assign) BOOL listeningStarted;
@property (nonatomic, assign) BOOL isListening;
@property (nonatomic, assign) BOOL debuggingMode;
@property (nonatomic, assign) BOOL useLiveSpeech;
@property (nonatomic, strong) LanguageModelGenerator *languageModelGenerator;
@property (nonatomic, strong) NSMutableArray *notificationRegistrants;
@property (nonatomic, strong) NSMutableDictionary *modelsDictionary;
@property (nonatomic, strong) NSTimer *recordingCutoffTimer;

@end


