//
//  MainMenuLayer.h
//  SpeechAdventure
//
//  Created by Zak Rubin on 5/2/13.
//
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface MainMenuLayer : CCLayer
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
@property (nonatomic, strong) CCLabelTTF *sentenceLabel;

@end
