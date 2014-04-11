//
//  ViewController.h
//  speechprototype
//
//  Created by Zak Rubin on 4/30/12.
//  Copyright (c) 2012 Assistive Technology Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class PocketsphinxController;
#import <OpenEars/OpenEarsEventsObserver.h>
#import <RapidEarsDemo/OpenEarsEventsObserver+RapidEars.h>
#import "SpeechParser.h"

@interface ViewController : UIViewController <OpenEarsEventsObserverDelegate, UIAlertViewDelegate> {
    OpenEarsEventsObserver *openEarsEventsObserver; // A class whose delegate methods which will allow us to stay informed of changes in the Flite and Pocketsphinx statuses.
	PocketsphinxController *pocketsphinxController; // The controller for Pocketsphinx (voice recognition).
    SpeechParser *speechParser; //This instatiates a new speech parser. This will be used to control input as well as do cleanup.
    AVAudioRecorder *audioRecorder;

    IBOutlet UITextView *statusTextView;
    IBOutlet UITextView *heardTextView;
    IBOutlet UILabel *inputLevelLabel;
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *loadSet;
    IBOutlet UIButton *adaptModel;
    IBOutlet UIImageView *imageView;
    
    NSString *pathToGrammarToStartAppWith;
	NSString *pathToDictionaryToStartAppWith;
    
    // Our NSTimer that will help us read and display the input and output levels without locking the UI
	NSTimer *uiUpdateTimer;
    NSTimer *recordingCutoffTimer;
    
    BOOL recognitionToggled;
}

@property (nonatomic, strong) OpenEarsEventsObserver *openEarsEventsObserver;
@property (nonatomic, strong) PocketsphinxController *pocketsphinxController;
@property (nonatomic, strong) SpeechParser *speechParser;

@property (nonatomic, copy) NSString *pathToGrammarToStartAppWith;
@property (nonatomic, copy) NSString *pathToDictionaryToStartAppWith;

@property (nonatomic, assign) BOOL recognitionToggled;

@property (nonatomic, strong) IBOutlet UITextView *statusTextView;
@property (nonatomic, strong) IBOutlet UITextView *heardTextView;
@property (nonatomic, strong) IBOutlet UILabel *inputLevelLabel;
@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (nonatomic, strong) IBOutlet UIButton *loadSet;
@property (nonatomic, strong) IBOutlet UIButton *adaptModel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) 	NSTimer *uiUpdateTimer;
@property (nonatomic, strong) 	NSTimer *recordingCutoffTimer;

@end
