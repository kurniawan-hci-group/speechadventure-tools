//
//  ViewStats.h
//  speechadventure
//
//  Created by Zak Rubin on 10/18/13.
//  Copyright (c) 2013 Zak Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "SAGameLayer.h"

@interface ViewStats : SAGameLayer
{
}

// returns a CCScene that contains the layer as the only child
+(CCScene *) scene;
@property (nonatomic, strong) CCLabelTTF *sentenceLabel;

@end

