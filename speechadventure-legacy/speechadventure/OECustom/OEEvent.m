//
//  OEEvent.m
//  SpeechAdventure
//
//  Created by John Chambers on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OEEvent.h"

@implementation OEEvent

@synthesize text;
@synthesize recognitionScore;
@synthesize isListening;
@synthesize eventType;

- (id)initWithText:(NSString *)recognitionText andScore:(NSNumber *)score{
    if (self = [super init])
    {
        self.text = recognitionText;
        self.RecognitionScore = score;
        self.eventType = OpenEarsResponse;
    }
    return self;
}

- (id)initWithText:(NSString *)recognitionText andScore:(NSNumber *)score andType:(EventType ) type{
    if (self = [super init])
    {
        self.text = recognitionText;
        self.RecognitionScore = score;
        self.eventType = type;
    }
    return self;
}

- (id) initWithListeningState:(BOOL) listening {
    if (self = [super init])
    {
        self.isListening = listening;
    }
    return self;
}

@end
