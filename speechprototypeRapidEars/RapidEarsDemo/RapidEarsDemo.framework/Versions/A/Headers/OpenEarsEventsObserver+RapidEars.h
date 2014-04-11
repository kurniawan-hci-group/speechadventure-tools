//
//  OpenEarsEventsObserver+RapidEars.h
//  RapidEars
//
//  Created by Halle Winkler on 5/3/12.
//  Copyright (c) 2012 Politepix. All rights reserved.
//

#import <OpenEars/OpenEarsEventsObserver.h>

/**
 @category  OpenEarsEventsObserver(RapidEars)
 @brief  This plugin returns the results of your speech recognition by adding some new callbacks to the OpenEarsEventsObserver.
 
 ## Usage examples
 > What to add to your implementation:
 @htmlinclude OpenEarsEventsObserver+RapidEars_Implementation.txt
 */

@interface OpenEarsEventsObserver (RapidEars) <OpenEarsEventsObserverDelegate>

/**The engine has detected in-progress speech. Words and respective scores are delivered in separate arrays with corresponding indexes.*/
- (void) rapidEarsDidDetectLiveSpeechAsWordArray:(NSArray *)words andScoreArray:(NSArray *)scores;

/**A final speech hypothesis was detected after the user paused. Words and respective scores are delivered in separate arrays with corresponding indexes.*/
- (void) rapidEarsDidDetectFinishedSpeechAsWordArray:(NSArray *)words andScoreArray:(NSArray *)scores;

/**Speech has started. This is primarily intended as a UI state signal.*/
- (void) rapidEarsDidDetectBeginningOfSpeech;

/**Speech has ended. This is primarily intended as a UI state signal.*/
- (void) rapidEarsDidDetectEndOfSpeech;


@end
