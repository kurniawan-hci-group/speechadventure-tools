//
//  viewController.h
//  speechScore
//
//  Created by Cédric Foucault on 4/10/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenEars/OpenEarsEventsObserver.h>
#import <OpenEars/PocketsphinxController.h>


@interface ViewController : UIViewController <OpenEarsEventsObserverDelegate>

@property (strong, nonatomic) PocketsphinxController *pocketsphinxController;
@property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;

@property BOOL recognitionIsDone;
@property (strong, nonatomic) NSString *currentWav;
@property (strong, nonatomic) NSCondition *canRunNextRecognition;
@property (strong, nonatomic) NSMutableDictionary *recognitionHypotheses;
@property (strong, nonatomic) NSMutableDictionary *recognitionScores;

@end
