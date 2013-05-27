//
//  HelloWorldLayer.m
//  wenderlich_whacker
//
//  Created by Giancarlo Inductivo on 5/27/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		/*
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64]; 
        CGSize size = [[CCDirector sharedDirector] winSize]; // ask director for the window size
        label.position =  ccp( size.width /2 , size.height/2 ); // position the label on the center of the screen
        [self addChild: label]; // add the label as a child to this Layer
        */
        
        CGSize size = [[CCDirector sharedDirector] winSize]; // ask director for the window size
        
        // Determine names of sprite sheets and plists to load
        NSString *bgSheet = @"background.pvr.ccz";
        NSString *bgPlist = @"background.plist";
        NSString *fgSheet = @"foreground.pvr.ccz";
        NSString *fgPlist = @"foreground.plist";
        NSString *sSheet = @"sprites.pvr.ccz";
        NSString *sPlist = @"sprites.plist";

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            bgSheet = @"background-hd.pvr.ccz";
            bgPlist = @"background-hd.plist";
            fgSheet = @"foreground-hd.pvr.ccz";
            fgPlist = @"foreground-hd.plist";
            sSheet = @"sprites-hd.pvr.ccz";
            sPlist = @"sprites-hd.plist";
        }
        
        // Load background and foreground
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:bgPlist];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:fgPlist];
        
        // Add background
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *dirt = [CCSprite spriteWithSpriteFrameName:@"bg_dirt.png"];
        dirt.scale = 2.0;
        dirt.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:dirt z:-2];
        
        // Add foreground
        CCSprite *lower = [CCSprite spriteWithSpriteFrameName:@"grass_lower.png"];
        lower.anchorPoint = ccp(0.5, 1);
        lower.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:lower z:1];
        
        CCSprite *upper = [CCSprite spriteWithSpriteFrameName:@"grass_upper.png"];
        upper.anchorPoint = ccp(0.5, 0);
        upper.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:upper z:-1];
		
        // Load sprites
        CCSpriteBatchNode *spriteNode = [CCSpriteBatchNode batchNodeWithFile:sSheet];
        //[self addChild:spriteNode z:999]; // show moles on top of lower grass
        [self addChild:spriteNode z:0]; // hide moles below lower grass
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:sPlist];
        
        moles = [[NSMutableArray alloc] init];
        
        CCSprite *mole1 = [CCSprite spriteWithSpriteFrameName:@"mole_1.png"];
        mole1.position = [self convertPoint:ccp(85, 85)];
        [spriteNode addChild:mole1];
        [moles addObject:mole1];
        
        CCSprite *mole2 = [CCSprite spriteWithSpriteFrameName:@"mole_1.png"];
        mole2.position = [self convertPoint:ccp(240, 85)];
        [spriteNode addChild:mole2];
        [moles addObject:mole2];
        
        CCSprite *mole3 = [CCSprite spriteWithSpriteFrameName:@"mole_1.png"];
        mole3.position = [self convertPoint:ccp(395, 85)];
        [spriteNode addChild:mole3];
        [moles addObject:mole3];
		
		[self schedule:@selector(tryPopMoles:) interval:0.5];

		//
		// Leaderboards and Achievements
		//
		/*
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}
									   ];

		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}
									   ];
		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];
        */

	}
	return self;
}

- (void)tryPopMoles:(ccTime)dt {
    for (CCSprite *mole in moles) {
        if (arc4random() % 3 == 0) {
            if (mole.numberOfRunningActions == 0) {
                [self popMole:mole];
            }
        }
    }
}

- (void) popMole:(CCSprite *)mole {
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.2 position:ccp(0, mole.contentSize.height)]; // 1
    CCEaseInOut *easeMoveUp = [CCEaseInOut actionWithAction:moveUp rate:3.0]; // 2
    CCAction *easeMoveDown = [easeMoveUp reverse]; // 3
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.5]; // 4
    
    [mole runAction:[CCSequence actions:easeMoveUp, delay, easeMoveDown, nil]]; // 5
}

- (CGPoint)convertPoint:(CGPoint)point {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return ccp(32 + point.x*2, 64 + point.y*2);
    } else {
        return point;
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
    
    [moles release];
    moles = nil;
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
