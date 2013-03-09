//
//  SunMoonClock.h
//  MathCloud
//
//  Created by Ian Fan on 9/03/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/*
 How to use it?
 sunMoonClock = [[SunMoonClock alloc]init];
 sunMoonClock.sunMoonClockDelegate = self;
 [sunMoonClock setupSunMoonClockWithParentLayer:self clockPos:ccp(100, 100) hoursPerCercle:8 dtPerMinute:3];
 [sunMoonClock setupAdjustWithSize:200 sunDegree:0 moonDegree:0];
 [sunMoonClock setupSunCurrentMinute:0 moonCurrentMinute:60 moonFinalMinute:0];
 [self schedule:@selector(updateClock:) interval:1.0/60.0];
*/

@protocol SunMoonClockDelegate;

@interface SunMoonClock : NSObject
{
  int _hoursPerCircle;
  int _dtPerMinute;
  int _currentDt;
  
  float _moonAdjustDegree;
  float _sunAdjustDegree;
}

@property (nonatomic,assign) id <SunMoonClockDelegate> sunMoonClockDelegate;
@property (nonatomic,retain) CCLayer *parentLayer;
@property (nonatomic,retain) CCSprite *sunSprite;
@property (nonatomic,retain) CCSprite *moonSprite;
@property (nonatomic,retain) CCSprite *clockSprite;
@property int sunCurrentMinute;
@property int moonCurrentMinute;
@property int moonFinalMinute;

-(void)setupSunMoonClockWithParentLayer:(CCLayer*)parentL clockPos:(CGPoint)clockPos hoursPerCercle:(int)hoursPerCir dtPerMinute:(int)dtPerMin;
-(void)setupAdjustWithSize:(float)size sunDegree:(float)sunDegree moonDegree:(float)moonDegree;//Optional
-(void)setupSunCurrentMinute:(int)sunCurrentMin moonCurrentMinute:(int)moonCurrentMin moonFinalMinute:(int)moonFinalMin;
-(void)updateClock:(ccTime)dt;

@end

@protocol SunMoonClockDelegate <NSObject>
-(void)sunMoonClockDelegateSunChasedMoon;
@end