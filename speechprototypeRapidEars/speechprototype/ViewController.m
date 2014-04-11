//
//  ViewController.m
//  speechprototype
//
//  Created by Assistive Technology Lab on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SpeechParser.h"
#import <OpenEars/PocketsphinxController.h>
#import <RapidEarsDemo/PocketsphinxController+RapidEars.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize openEarsEventsObserver;
@synthesize pocketsphinxController;
@synthesize speechParser;
@synthesize pathToGrammarToStartAppWith, pathToDictionaryToStartAppWith;
@synthesize statusTextView, heardTextView;
@synthesize startButton, loadSet, adaptModel;
@synthesize imageView;
@synthesize inputLevelLabel;
@synthesize recognitionToggled;
@synthesize uiUpdateTimer;
@synthesize recordingCutoffTimer;

#define kLevelUpdatesPerSecond 18 // We'll have the ui update 18 times a second to show some fluidity without hitting the CPU too hard.
#define recordingCutoffTime 3

#pragma mark - 
#pragma mark Memory Management

- (void)dealloc {
	//[self stopDisplayingLevels]; // We'll need to stop any running timers before attempting to deallocate here.
	openEarsEventsObserver.delegate = nil;
}

#pragma mark -
#pragma mark Lazy Allocation

// Lazily allocated PocketsphinxController.
- (PocketsphinxController *)pocketsphinxController { 
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
        
	}
	return pocketsphinxController;
}

// Lazily allocated OpenEarsEventsObserver.
- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
        self.pocketsphinxController.verbosePocketSphinx = YES;
	}
	return openEarsEventsObserver;
}

- (SpeechParser *) speechParser{
    if (speechParser == nil) {
        speechParser = [[SpeechParser alloc] init];
    }
    return speechParser;
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.openEarsEventsObserver setDelegate:self];
    
//    self.pathToGrammarToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"plosiveslvl1.arpa"];
    self.pathToGrammarToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"LivingRoomPlosives.arpa"];
    
	// This is the dictionary we're going to start up with. The only reason I'm making it a class property is that I reuse it a bunch of times in this example, 
	// but you can pass the string contents directly to PocketsphinxController:startListeningWithLanguageModelAtPath:dictionaryAtPath:languageModelIsJSGF:
//	self.pathToDictionaryToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"plosiveslvl1.dic"];
    self.pathToDictionaryToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"LivingRoomPlosives.dic"];
	
	//self.usingStartLanguageModel = TRUE; // This is not an OpenEars thing, this is just so I can switch back and forth between the two models in this sample app.
    
    [self startDisplayingLevels];
    
    self.recognitionToggled = TRUE;
    
//    [self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
    //[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:NO];
    [self.pocketsphinxController setRapidEarsToVerbose:FALSE]; // This defaults to FALSE but will give a lot of debug readout if set TRUE
    [self.pocketsphinxController setRapidEarsAccuracy:20]; // This defaults to 20, maximum accuracy, but can be set as low as 1 to save CPU
    [self.pocketsphinxController setFinalizeHypothesis:TRUE]; // This defaults to TRUE and will return a final hypothesis, but can be turned off to save a little CPU and will then return no final hypothesis; only partial "live" hypotheses.
    [self.pocketsphinxController setFasterPartials:TRUE]; // This will give faster rapid recognition with less accuracy. This is what you want in most cases since more accuracy for partial hypotheses will have a delay.
    [self.pocketsphinxController setFasterFinals:FALSE]; // This will give an accurate final recognition. You can have earlier final recognitions with less accuracy as well by setting this to TRUE.
    [self.pocketsphinxController startRealtimeListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith andDictionaryAtPath:self.pathToDictionaryToStartAppWith]; // Starts the rapid recognition loop.

    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sound.wav"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM],
                                    AVFormatIDKey,
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 1],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:soundFileURL settings:recordSettings error:&error];
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    }
    else
    {
        [audioRecorder prepareToRecord];
    }
}

#pragma mark -
#pragma mark 

#pragma mark -
#pragma mark OpenEarsEventsObserver delegate methods

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID); // Log it.
	self.heardTextView.text = [NSString stringWithFormat:@"Heard: \"%@\"", hypothesis]; // Show it in the status box.
    self.statusTextView.text = @"Status: Waiting for input"; // Show it in the status box.
    
    imageView.image = [SpeechParser parseToImage:hypothesis oldImg:imageView.image];
}

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started."); // Log it.
	self.statusTextView.text = @"Status: Calibrating."; // Show it in the status box.
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
    [self.recordingCutoffTimer invalidate];
}

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop completed the calibration stage in its startup.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx.
- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete."); // Log it.
	self.statusTextView.text = @"Status: Waiting for input"; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx detected speech and is starting to process it.
- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech."); // Log it.
	self.statusTextView.text = @"Status: Listening"; // Show it in the status box.
    
    //Cut Recording off 
    self.recordingCutoffTimer = [NSTimer scheduledTimerWithTimeInterval:recordingCutoffTime target:self selector:@selector(recordingCutoff) userInfo:nil repeats:NO]; 

}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx is still in its listening loop but it is not
// Going to react to speech until listening is resumed.  This can happen as a result of Flite speech being
// in progress on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
// or as a result of the PocketsphinxController being told to suspend recognition via the suspendRecognition method.
- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition."); // Log it.
	self.statusTextView.text = @"Status: Paused."; // Show it in the status box.
}

- (void) rapidEarsDidDetectLiveSpeechAsWordArray:(NSArray *)words
                                   andScoreArray:(NSArray *)scores {
    NSLog(@"detected words: %@",[words componentsJoinedByString:@" "]);
    // NSLog(@"detected scores: %@",scores);
}
- (void) rapidEarsDidDetectFinishedSpeechAsWordArray:(NSArray *)words
                                       andScoreArray:(NSArray *)scores {
    NSString *hypothesis = [words componentsJoinedByString:@" "];
    NSLog(@"detected complete statement: %@",hypothesis);
    imageView.image = [SpeechParser parseToImage:hypothesis oldImg:imageView.image];
    // NSLog(@"detected scores: %@",scores);
}
- (void) rapidEarsDidDetectBeginningOfSpeech {
    NSLog(@"rapidEarsDidDetectBeginningOfSpeech");
}
- (void) rapidEarsDidDetectEndOfSpeech {
    NSLog(@"rapidEarsDidDetectEndOfSpeech");
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction) startListeningButtonAction{
    if(self.recognitionToggled)
    {
        [self.pocketsphinxController suspendRecognition];
        [startButton setTitle:@"Start Listening" forState:UIControlStateNormal];
        recognitionToggled = false;
    }
    else {
        [self.pocketsphinxController resumeRecognition];
        [startButton setTitle:@"Pause Listening" forState:UIControlStateNormal];
        recognitionToggled = true;
    }
}

- (IBAction) loadSetButtonAction{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change Model"
                                                     message:@"Please select which model to use"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"Lateral", @"Plosives Lvl 1", @"Glottal Lvl 2", nil];
    [alert show];

}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        NSLog(@"Loading Lateral");
        self.pathToGrammarToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"lateral.arpa"]; 
        self.pathToDictionaryToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"lateral.dic"]; 
        [self.pocketsphinxController changeLanguageModelToFile:self.pathToGrammarToStartAppWith withDictionary:self.pathToDictionaryToStartAppWith];
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"Loading Plosives Level 1");
        self.pathToGrammarToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"plosiveslvl1.arpa"]; 
        self.pathToDictionaryToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"plosiveslvl1.dic"]; 
        [self.pocketsphinxController changeLanguageModelToFile:self.pathToGrammarToStartAppWith withDictionary:self.pathToDictionaryToStartAppWith];
    }
    else
    {
        NSLog(@"Loading Glottal Level 2");
        self.pathToGrammarToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"8134.arpa"]; 
        self.pathToDictionaryToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"8134.dic"]; 
        [self.pocketsphinxController changeLanguageModelToFile:self.pathToGrammarToStartAppWith withDictionary:self.pathToDictionaryToStartAppWith];
        
    }
}

- (IBAction) adaptButtonAction{
    if(!audioRecorder.recording)
    {
        [audioRecorder record];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Recording"
                                                        message:@"Started"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    else
    {
        [audioRecorder stop];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Recording"
                                                        message:@"Stopped"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
        NSLog(@"The filename is %@", audioRecorder.url);
        [alert show];
    }
    
    
    
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

- (void) updateLevelsUI { // And here is how we obtain the levels.  This method includes the actual OpenEars methods and uses their results to update the UI of this view controller.
    
	self.inputLevelLabel.text = [NSString stringWithFormat:@"Input level:%f",[self.pocketsphinxController pocketsphinxInputLevel]];  //
}

//This ensures that the system doesn't get locked up with a big sentence.
- (void) recordingCutoff {
    NSLog(@"Recording is too long, cutting"); // Log it.
    [self.pocketsphinxController suspendRecognition];
    [self.pocketsphinxController.continuousModel stopDevice];
    [self.pocketsphinxController resumeRecognition];
    [self.pocketsphinxController.continuousModel startDevice];
}

- (void) fixRecording {
    NSLog(@"Recording is too long, cutting"); // Log it.
    [self.pocketsphinxController resumeRecognition];
    [self.pocketsphinxController.continuousModel startDevice];
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
