//
//  StatSentenceEntry.h
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/9/13.
//
//

#import <Foundation/Foundation.h>

@interface StatSentenceEntry : NSObject

- (id) init;

- (void) addUtterance:(NSString*) utterance;
- (void) setSentence:(NSString*) targetSentence;
- (NSString*) getSentence;

@property (nonatomic, copy) NSString *sentence;
@property (nonatomic, strong) NSMutableArray *utterances;
@property NSInteger attempts;


@end
