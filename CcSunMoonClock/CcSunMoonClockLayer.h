//
//  CcSunMoonClockLayer.h
//  CcSunMoonClock
//
//  Created by Ian Fan on 9/03/13.
//
//

#import "cocos2d.h"
#import "SunMoonClock.h"

@interface CcSunMoonClockLayer : CCLayer <SunMoonClockDelegate>
{
  SunMoonClock *sunMoonClock;
}

+(CCScene *) scene;

@end
