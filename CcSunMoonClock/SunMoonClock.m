//
//  SunMoonClock.m
//  MathCloud
//
//  Created by Ian Fan on 9/03/13.
//
//

#define SUNMOONCLOCK_SUNSET_INT 30

#import "SunMoonClock.h"

@implementation SunMoonClock
@synthesize sunSprite=_sunSprite, moonSprite=_moonSprite, clockSprite=_clockSprite, sunCurrentMinute=_sunCurrentMinute, moonCurrentMinute=_moonCurrentMinute, moonFinalMinute=_moonFinalMinute;

#pragma mark - Control

-(void)setLongerOrShroterDayWithEditMinute:(int)editMin {
  _moonFinalMinute += editMin;
}

-(void)setRestartWithSunInitMinute:(int)sunInitMin moonInitMinute:(int)moonInitMin moonFinalMinute:(int)moonFinalMin {
  _sunCurrentMinute = sunInitMin;
  _moonCurrentMinute = moonInitMin;
  _moonFinalMinute = moonFinalMin;
  
  [self setClockRotationWithSprite:_sunSprite gameMinute:_sunCurrentMinute];
  [self setClockRotationWithSprite:_moonSprite gameMinute:_moonCurrentMinute];
  
  [self setSunsetColor];
}

#pragma mark - Update

-(void)update:(ccTime)dt {
  if (_sunCurrentMinute >= _moonCurrentMinute) {
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
      
      //sunset, sun is becoming black when almost close to moon
      [self setSunsetColor];
    }
    
  }
  
  float adjustMinute = (float)_currentDt/_dtPerMinute;
  
  [self setClockRotationWithSprite:_sunSprite gameMinute:_sunCurrentMinute+adjustMinute];
  
  if (_moonCurrentMinute != _moonFinalMinute) {
    if (_moonCurrentMinute < _moonFinalMinute) {
      [self setClockRotationWithSprite:_moonSprite gameMinute:(_moonCurrentMinute + 2*adjustMinute)];
      
    }else if (_moonCurrentMinute > _moonFinalMinute) {
      [self setClockRotationWithSprite:_moonSprite gameMinute:(_moonCurrentMinute - 2*adjustMinute)];
    }
  }
  
}

#pragma mark - helper

-(void)setClockRotationWithSprite:(CCSprite*)targetSprite gameMinute:(float)gameMinute {
  float degreesPerMinute = 360.0f/(_hoursPerCircle*60);
  targetSprite.rotation = degreesPerMinute*gameMinute;
  
  if (targetSprite == _sunSprite) {
    _sunSprite.rotation += _sunAdjustDegree;
  }else if (targetSprite == _moonSprite) {
    _moonSprite.rotation += _moonAdjustDegree;
  }
}

-(void)setSunsetColor {
  int sunsetMinute = SUNMOONCLOCK_SUNSET_INT;
  int differentMinute = _moonCurrentMinute - _sunCurrentMinute;
  if (differentMinute <= sunsetMinute) {
    float color = MAX(255.0f*differentMinute/sunsetMinute, 0);
    if (sunsetMinute <=2) color = 0;
    
    _sunSprite.color = ccc3(color, color, color);
  } else {
    _sunSprite.color = ccc3(255, 255, 255);
  }
}

#pragma mark - Init

-(void)setupSunMoonClockWithParentLayer:(CCLayer *)parentL clockPos:(CGPoint)clockPos hoursPerCercle:(int)hoursPerCir dtPerMinute:(int)dtPerMin {
  _parentLayer = parentL;
  _hoursPerCircle = hoursPerCir;
  _dtPerMinute = dtPerMin;
  
  // sun
  self.sunSprite = [CCSprite spriteWithFile:@"sunMoonClock_sun.png"];
  _sunSprite.position = clockPos;
  [_parentLayer addChild:self.sunSprite];
  
  // moon
  self.moonSprite = [CCSprite spriteWithFile:@"sunMoonClock_moon.png"];
  _moonSprite.position = clockPos;
  [_parentLayer addChild:self.moonSprite];
  
  // clock
  self.clockSprite = [CCSprite spriteWithFile:@"sunMoonClock_clock.png"];
  _clockSprite.position = clockPos;
  [_parentLayer addChild:self.clockSprite];
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
  [self setClockRotationWithSprite:_moonSprite gameMinute:_moonCurrentMinute];
}

-(id) init {
	if( (self = [super init]) ) {
	}
  
	return self;
}

- (void) dealloc {
  self.sunSprite = nil;
  self.moonSprite = nil;
  self.clockSprite = nil;
  self.sunMoonClockDelegate = nil;
  
	[super dealloc];
}

@end
