//
//  StatSentenceEntry.m
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/9/13.
//
//

#import "StatSentenceEntry.h"

@implementation StatSentenceEntry

@synthesize sentence;
@synthesize utterances;
@synthesize attempts;

- (id) init {
    
    attempts = 0;
    utterances = [[NSMutableArray alloc] init];
    return self;
}

- (void) addUtterance:(NSString *)utterance {
    [utterances addObject:utterance];
    attempts++;
}

- (void) setSentence:(NSString*) targetSentence {
    sentence = targetSentence;
}

- (NSString*) getSentence{
    return sentence;
}

@end
