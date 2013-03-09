//
//  SunMoonClock.m
//  MathCloud
//
//  Created by Ian Fan on 9/03/13.
//
//

#import "SunMoonClock.h"

@implementation SunMoonClock
@synthesize sunSprite=_sunSprite, moonSprite=_moonSprite, clockSprite=_clockSprite, sunCurrentMinute=_sunCurrentMinute, moonCurrentMinute=_moonCurrentMinute, moonFinalMinute=_moonFinalMinute;

#pragma mark - Update

-(void)updateClock:(ccTime)dt {
  if (_sunCurrentMinute == _moonCurrentMinute) {
    NSLog(@"timeOut");
    
    //time-out
    if ([self.sunMoonClockDelegate respondsToSelector:@selector(sunMoonClockDelegateSunChasedMoon)] == YES) {
      [self.sunMoonClockDelegate sunMoonClockDelegateSunChasedMoon];
    }
    
    return;
  }
  
  _currentDt ++;
  
  if (_currentDt == _dtPerMinute) {
    _currentDt = 0;
    
    //sun keep running
    _sunCurrentMinute ++;
    
    //moon should go forward or backward until stop at the final minute
    if (_moonCurrentMinute != _moonFinalMinute) {
      if (_moonCurrentMinute < _moonFinalMinute) {
        _moonCurrentMinute ++;
        if (_moonCurrentMinute < _moonFinalMinute) _moonCurrentMinute ++;
      }else if (_moonCurrentMinute > _moonFinalMinute) {
        _moonCurrentMinute --;
        if (_moonCurrentMinute > _moonFinalMinute) _moonCurrentMinute --;
      }
      
    }
    
    //sunset, sun is becoming black when almost close to moon
    int sunsetMinute = 30;
    int differentMinute = _moonCurrentMinute - _sunCurrentMinute;
    if (differentMinute <= sunsetMinute) {
      float color = 255.0f*differentMinute/sunsetMinute;
      _sunSprite.color = ccc3(color, color, color);
    }
    
  }
  
  float adjustMinute = (float)_currentDt/_dtPerMinute;
  
  [self setClockRotationWithSprite:_sunSprite gameMinute:_sunCurrentMinute+adjustMinute];
  _sunSprite.rotation += _sunAdjustDegree;
  
  if (_moonCurrentMinute != _moonFinalMinute) {
    if (_moonCurrentMinute < _moonFinalMinute) {
      [self setClockRotationWithSprite:_moonSprite gameMinute:(_moonCurrentMinute + 2*adjustMinute)];
      _moonSprite.rotation += _moonAdjustDegree;
      
    }else if (_moonCurrentMinute > _moonFinalMinute) {
      [self setClockRotationWithSprite:_moonSprite gameMinute:(_moonCurrentMinute - 2*adjustMinute)];
      _moonSprite.rotation += _moonAdjustDegree;
    }
  }
  
}

#pragma mark - helper

-(void)setClockRotationWithSprite:(CCSprite*)targetSprite gameMinute:(float)gameMinute {
  float degreesPerMinute = 360.0f/(_hoursPerCircle*60);
  targetSprite.rotation = degreesPerMinute*gameMinute;
}

#pragma mark - Init

-(void)setupSunMoonClockWithParentLayer:(CCLayer *)parentL clockPos:(CGPoint)clockPos hoursPerCercle:(int)hoursPerCir dtPerMinute:(int)dtPerMin {
  self.parentLayer = parentL;
  _hoursPerCircle = hoursPerCir;
  _dtPerMinute = dtPerMin;
  
  // sun
  self.sunSprite = [CCSprite spriteWithFile:@"sunMoonClock_sun.png"];
  _sunSprite.position = clockPos;
  [self.parentLayer addChild:self.sunSprite];
  
  // moon
  self.moonSprite = [CCSprite spriteWithFile:@"sunMoonClock_moon.png"];
  _moonSprite.position = clockPos;
  [self.parentLayer addChild:self.moonSprite];
  
  // clock
  self.clockSprite = [CCSprite spriteWithFile:@"sunMoonClock_clock.png"];
  _clockSprite.position = clockPos;
  [self.parentLayer addChild:self.clockSprite];
}

-(void)setupAdjustWithSize:(float)size sunDegree:(float)sunDegree moonDegree:(float)moonDegree {
  float scale = size/_clockSprite.boundingBox.size.width;
  _sunSprite.scale = scale;
  _moonSprite.scale = scale;
  _clockSprite.scale = scale;
  
  _sunAdjustDegree = sunDegree;
  _moonAdjustDegree = moonDegree;
}

-(void)setupSunCurrentMinute:(int)sunCurrentMin moonCurrentMinute:(int)moonCurrentMin moonFinalMinute:(int)moonFinalMin {
  _sunCurrentMinute = sunCurrentMin, _moonCurrentMinute = moonCurrentMin, _moonFinalMinute = moonFinalMin;
  
  [self setClockRotationWithSprite:_sunSprite gameMinute:_sunCurrentMinute];
  _sunSprite.rotation += _sunAdjustDegree;
  [self setClockRotationWithSprite:_moonSprite gameMinute:_moonCurrentMinute];
  _moonSprite.rotation += _moonAdjustDegree;
}

-(id) init {
	if( (self = [super init]) ) {
	}
  
	return self;
}

- (void) dealloc {
//  [self unscheduleUpdate];
  
  [self.parentLayer removeChild:self.sunSprite cleanup:NO], self.sunSprite = nil;
  [self.parentLayer removeChild:self.moonSprite cleanup:NO], self.moonSprite = nil;
  [self.parentLayer removeChild:self.clockSprite cleanup:NO], self.clockSprite = nil;
  
	[super dealloc];
}

@end