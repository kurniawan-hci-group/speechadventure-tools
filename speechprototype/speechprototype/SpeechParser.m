//
//  SpeechParser.m
//  speechprototype
//
//  Created by Assistive Technology Lab on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpeechParser.h"
#import <AVFoundation/AVFoundation.h>

@implementation SpeechParser

- (NSString *) cleanInput:(NSString *)hypothesis
{
    return @"Yarp";
}

+ (UIImage *) parseToImage:(NSString *)hypothesis oldImg:(UIImage *) oldImg
{
    UIImage *img = oldImg;
    
    if([hypothesis isEqualToString:@"BLOW A BALLOON"] || [hypothesis isEqualToString:@"WEAR A BALLOON"])
    {
        img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"balloon" ofType:@"jpg"]];
        [self playSoundEffect:@"ballooninflate"];
    }
    else if([hypothesis isEqualToString:@"WEAR A HAT"] || [hypothesis isEqualToString:@"BLOW A HAT"])
    {
        img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"cowboyhat" ofType:@"jpg"]];
        [self playSoundEffect:@"ballooninflate"];
    }
    else if([hypothesis isEqualToString:@"POP A HAT"] || [hypothesis isEqualToString:@"POP A BALLOON"])
    {
        img = NULL;
        [self playSoundEffect:@"balloonpop"];
    }
    return img;
}

+ (void) playSoundEffect:(NSString *)soundfile
{
    NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] 
                                               pathForResource:soundfile
                                               ofType:@"wav"]];
    AVAudioPlayer *click = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    [click play];
}

@end
