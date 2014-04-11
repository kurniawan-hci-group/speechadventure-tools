//
//  viewController.m
//  speechScore
//
//  Created by Cédric Foucault on 4/10/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "ViewController.h"
#import <OpenEars/OpenEarsLogging.h>

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        self.pocketsphinxController = [[PocketsphinxController alloc] init];
        self.pocketsphinxController.verbosePocketSphinx = YES;
//        self.pocketsphinxController.returnNbest = YES;
//        self.pocketsphinxController.nBestNumber = 3;
//        self.pocketsphinxController.returnNullHypotheses = YES;
        self.openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
        [self.openEarsEventsObserver setDelegate:self];
//        [OpenEarsLogging startOpenEarsLogging];
        self.canRunNextRecognition = [[NSCondition alloc] init];
        self.recognitionIsDone = YES;
        self.recognitionHypotheses = [[NSMutableDictionary alloc] init];
        self.recognitionScores = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelectorInBackground:@selector(runRecognitionOnWavs) withObject:nil];
}

- (void)runRecognitionOnWavs {
    // paths to the wave samples
    NSArray *wavPaths_brt = [[NSBundle mainBundle] pathsForResourcesOfType:@"wav" inDirectory:@"big_red_truck"];
    NSArray *wavPaths_tttt = [[NSBundle mainBundle] pathsForResourcesOfType:@"wav" inDirectory:@"take_teddy_to_town"];
    // paths to the grammars/language models
    NSString *lmPath_brt = [[NSBundle mainBundle] pathForResource:@"big_red_truck" ofType:@"gram"];
    NSString *lmPath_tttt = [[NSBundle mainBundle] pathForResource:@"take_teddy_to_town" ofType:@"gram"];
    //    NSString *lmPath = [[NSBundle mainBundle] pathForResource:@"big_red_truck_variants_man" ofType:@"arpa"];
    // paths to the dictionaries
    NSString *dicPath_brt = [[NSBundle mainBundle] pathForResource:@"big_red_truck" ofType:@"dic"];
    NSString *dicPath_tttt = [[NSBundle mainBundle] pathForResource:@"take_teddy_to_town" ofType:@"dic"];
    
    // run the recognition on every "big red truck" wav sample
    for (NSString *wavPath in wavPaths_brt) {
        if (lmPath_brt && dicPath_brt && wavPath) {
            // lock
            [self.canRunNextRecognition lock];
            // wait until recognition is done
            while (!self.recognitionIsDone) {
                NSLog(@"waiting");
                [self.canRunNextRecognition wait];
            }
            // reset bool flag
            self.recognitionIsDone = NO;
            // set the current wav
            self.currentWav = [[wavPath lastPathComponent] stringByDeletingPathExtension];
            // run the recognition
            [self.pocketsphinxController runRecognitionOnWavFileAtPath:wavPath usingLanguageModelAtPath:lmPath_brt dictionaryAtPath:dicPath_brt languageModelIsJSGF:YES];
            //        [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath languageModelIsJSGF:YES];
            //        [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath languageModelIsJSGF:NO];
            // unlock
            [self.canRunNextRecognition unlock];
        } else {
            NSLog(@"Couldn't load a file");
        }
    }
    // run the recognition on every "take teddy to town" wav sample
    for (NSString *wavPath in wavPaths_tttt) {
        if (lmPath_tttt && dicPath_tttt && wavPath) {
            // lock
            [self.canRunNextRecognition lock];
            // wait until recognition is done
            while (!self.recognitionIsDone) {
                NSLog(@"waiting");
                [self.canRunNextRecognition wait];
            }
            // reset bool flag
            self.recognitionIsDone = NO;
            // set the current wav
            self.currentWav = [[wavPath lastPathComponent] stringByDeletingPathExtension];
            // run the recognition
            [self.pocketsphinxController runRecognitionOnWavFileAtPath:wavPath usingLanguageModelAtPath:lmPath_tttt dictionaryAtPath:dicPath_tttt languageModelIsJSGF:YES];
            //        [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath languageModelIsJSGF:YES];
            //        [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath languageModelIsJSGF:NO];
            // unlock
            [self.canRunNextRecognition unlock];
        } else {
            NSLog(@"Couldn't load a file");
        }
    }
    
    // output the recognition results: hypotheses and scores
    for (NSString *wavName in self.recognitionHypotheses) {
        NSLog(@"%@: \"%@\", %@", wavName, self.recognitionHypotheses[wavName], self.recognitionScores[wavName]);
    }
}


- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
//	NSLog(@"The received hypothesis for %@ is %@ with a score of %@ and an ID of %@", self.currentWav, hypothesis, recognitionScore, utteranceID);
    self.recognitionHypotheses[self.currentWav] = hypothesis;
    self.recognitionScores[self.currentWav] = recognitionScore;
    self.recognitionIsDone = YES;
    [self.canRunNextRecognition signal];
}

- (void) pocketsphinxDidReceiveNBestHypothesisArray:(NSArray *) hypothesisArray {
    int i = 0;
    
	for (NSDictionary *dictionary in hypothesisArray) {
        i++;
		NSLog(@"Hypothesis %i: %@ with a score of %i", i, [dictionary objectForKey:@"Hypothesis"],[[dictionary objectForKey:@"Score"]intValue]);
	}
}

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
}

- (void) pocketsphinxDidStartListening {
	NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}

@end
