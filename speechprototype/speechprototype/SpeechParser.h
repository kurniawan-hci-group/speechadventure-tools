//
//  SpeechParser.h
//  speechprototype
//
//  Created by Assistive Technology Lab on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeechParser : NSObject


+ (UIImage *) parseToImage:(NSString *)hypothesis oldImg:(UIImage *) oldImg;

@end
