//
//  WeekWeather.h
//  DZWeather
//
//  Created by Ibokan on 15/11/17.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayWeather.h"

FOUNDATION_EXTERN NSString * const WeekSunday;
FOUNDATION_EXTERN NSString * const WeekMonday;
FOUNDATION_EXTERN NSString * const WeekTuesday;
FOUNDATION_EXTERN NSString * const WeekWednesday;
FOUNDATION_EXTERN NSString * const WeekThursday;
FOUNDATION_EXTERN NSString * const WeekFriday;
FOUNDATION_EXTERN NSString * const WeekSaturday;

@interface WeekWeather : NSObject
{
    NSArray* _dayWetherList;
}
@property (nonatomic,retain)Area* area;

+ (WeekWeather*)currentWeekWeatherOfArea:(Area*)area;
- (DayWeather*)weatherOfweek:(NSString*)weekName;
- (DayWeather *)weatherOfIndex:(NSInteger)index;
- (NSInteger)countOfDayWeather;
@end

