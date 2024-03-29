//
//  HelloWorldLayer.h
//  wenderlich_whacker
//
//  Created by Giancarlo Inductivo on 5/27/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    NSMutableArray *moles;
    
    CCAnimation *laughAnim;
    CCAnimation *hitAnim;
    
    CCLabelTTF *label;
    int score;
    int totalSpawns;
    BOOL gameOver;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
