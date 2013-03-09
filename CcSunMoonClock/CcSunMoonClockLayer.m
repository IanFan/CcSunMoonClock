//
//  CcSunMoonClockLayer.m
//  CcSunMoonClock
//
//  Created by Ian Fan on 9/03/13.
//
//

#import "CcSunMoonClockLayer.h"

@implementation CcSunMoonClockLayer

#pragma mark -
#pragma mark Init

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	CcSunMoonClockLayer *layer = [CcSunMoonClockLayer node];
	[scene addChild: layer];
  
	return scene;
}

#pragma mark - SunMoonClock

-(void)setupClock {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  float sizeLength = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 300:150;
  
  sunMoonClock = [[SunMoonClock alloc]init];
  sunMoonClock.sunMoonClockDelegate = self;
  [sunMoonClock setupSunMoonClockWithParentLayer:self clockPos:ccp(winSize.width/2, winSize.height/2) hoursPerCercle:8 dtPerMinute:1];
  [sunMoonClock setupAdjustWithSize:sizeLength sunDegree:0 moonDegree:0];
  [sunMoonClock setupSunCurrentMinute:0*60 moonCurrentMinute:8*60 moonFinalMinute:8*60];
  [self schedule:@selector(updateClock:) interval:1.0/60.0];
}

-(void)updateClock:(ccTime)dt {
  [sunMoonClock updateClock:dt];
}

-(void)sunMoonClockDelegateSunChasedMoon {
  [self unschedule:@selector(updateClock:)];
}

#pragma mark -Init

-(id) init {
	if( (self = [super init]) ) {
    //bg
    [self addChild:[CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)] z:-1];
    
    [self setupClock];
	}
  
	return self;
}

- (void) dealloc {
	[super dealloc];
}

@end
