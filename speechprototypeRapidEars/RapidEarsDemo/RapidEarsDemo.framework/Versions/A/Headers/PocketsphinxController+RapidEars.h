//
//  PocketsphinxController+RapidEars.h
//  RapidEars
//
//  Created by Halle Winkler on 5/3/12.
//  Copyright (c) 2012 Politepix. All rights reserved.
//

#import <OpenEars/PocketsphinxController.h>

/**
 @category  PocketsphinxController(RapidEars)
 @brief  A plugin which adds the ability to do live speech recognition to PocketsphinxController.
 
 ## Usage examples
 > Preparing to use the class:
 @htmlinclude PocketsphinxController+RapidEars_Preconditions.txt
 > What to add to your implementation:
 @htmlinclude PocketsphinxController+RapidEars_Implementation.txt
 @warning There can only be one PocketsphinxController+RapidEars instance in your app.
 */

/**\cond HIDDEN_SYMBOLS*/   

/**\endcond */   

@interface PocketsphinxController (RapidEars) {
}
/**Start the listening loop. You will call this instead of the old PocketsphinxController method*/
- (void) startRealtimeListeningWithLanguageModelAtPath:(NSString *)languageModelPath andDictionaryAtPath:(NSString *)dictionaryPath;


/**Turn logging on or off.*/
- (void) setRapidEarsToVerbose:(BOOL)verbose;


/**Scale from 1-20 where 1 is the least accurate and 20 is the most. This has an linear relationship with the CPU overhead. The best accuracy will still be less than that of Pocketsphinx in the stock OpenEars package and this only has a notable effect in cases where setFasterPartials is set to FALSE. Defaults to 20.*/
- (void) setRapidEarsAccuracy:(int)accuracy;


/**You can decide not to have the final hypothesis delivered if you are only interested in live hypotheses. This will save some CPU work.*/
- (void) setFinalizeHypothesis:(BOOL)finalizeHypothesis;


/** This will give you faster partial hypotheses at the expense of accuracy */
- (void) setFasterPartials:(BOOL)fasterPartials; 


/** This will give you faster final hypotheses at the expense of accuracy. Setting this causes setFasterPartials to also be set.*/
- (void) setFasterFinals:(BOOL)fasterPartials; 
@end


// What follows is part of the automatically-generated documentation for RapidEars and doesn't relate to this specific class.

