//
//  ViewStats.m
//  speechadventure
//
//  Created by Zak Rubin on 10/18/13.
//  Copyright (c) 2013 Zak Rubin. All rights reserved.
//

#import "ViewStats.h"

@implementation ViewStats

@synthesize sentenceLabel;

-(void) onEnter {
	[super onEnter];
    
    CCLabelTTF *mainTitle = [CCLabelTTF labelWithString:@"Speech Adventure" fontName:@"Arial" fontSize:48.0];
    mainTitle.color = ccc3(0,0,0);
    mainTitle.position = ccp(240, 260);
    CCMenuItem *startGame = [CCMenuItemImage itemWithNormalImage:@"Textbox_medium.png" selectedImage:@"Textbox_medium_sel.png" target: self selector: @selector(startGame:)];
    CCMenu *mainMenu = [CCMenu menuWithItems: startGame, nil];
    mainMenu.position = ccp(240, 230);
    [mainMenu alignItemsVertically];
    [self addChild: mainTitle];
    [self addChild: mainMenu];
    
    sentenceLabel = [CCLabelTTF labelWithString:@"Adapt Model" fontName:@"Arial" fontSize:48.0];
    sentenceLabel.color = ccc3(0,0,0);
    sentenceLabel.position = ccp(240, 230);
    [self addChild: sentenceLabel];
	
}

-(void) startGame:(id)sender {
    
    
}

-(void) gameTransition:(ccTime)dt {
	
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ViewStats *layer = [ViewStats node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


@end
