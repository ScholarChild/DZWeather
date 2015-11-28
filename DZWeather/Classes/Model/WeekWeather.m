//
//  WeekWeather.m
//  DZWeather
//
//  Created by Ibokan on 15/11/17.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "WeekWeather.h"
#import "Response.h"

 NSString * const WeekSunday = @"星期日";
 NSString * const WeekMonday = @"星期一";
 NSString * const WeekTuesday = @"星期二";
 NSString * const WeekWednesday = @"星期三";
 NSString * const WeekThursday = @"星期四";
 NSString * const WeekFriday = @"星期五";
 NSString * const WeekSaturday = @"星期六";

@implementation WeekWeather

+ (WeekWeather *)currentWeekWeatherOfArea:(Area *)area
{
    return [[WeekWeather alloc]initWithArea:area];
}

- (instancetype)initWithArea:(Area*)area
{
    if (self = [super init]) {
        self.area = area;
        NSArray* dayWeatherInfo = [self currentDayWeatherInfoOfArea:area];
        NSAssert([dayWeatherInfo count] > 5, @"dayWeatherMessage obtain fail");
        [self addDayWeatheresWithDayWeatherInfo:dayWeatherInfo];
    }
    return self;
}

- (NSArray*)currentDayWeatherInfoOfArea:(Area*)area
{
    NSString* questString = [NSString stringWithFormat:@"http://api.k780.com:88/?app=weather.future&weaid=%@&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",area.ID];
    NSDictionary* infoDic = [Response responseWithQuestUrlString:questString];
    return [infoDic objectForKey:@"result"];
}

- (void)addDayWeatheresWithDayWeatherInfo:(NSArray*)dayWeatherInfoArr
{
    NSMutableArray* tempArr = [NSMutableArray arrayWithCapacity:[dayWeatherInfoArr count]];
    for (NSDictionary* dayInfoDic in dayWeatherInfoArr) {
        DayWeather* aDayWeather = [DayWeather new];
        [aDayWeather setValuesForKeysWithDictionary:dayInfoDic];
        aDayWeather.area = self.area;
        [tempArr addObject:aDayWeather];
    }
    _dayWetherList = [NSArray arrayWithArray:tempArr];
}

- (DayWeather *)weatherOfweek:(NSString *)weekName
{
    DayWeather* searchWeather;
    for (DayWeather* day in _dayWetherList) {
        if ([day.week isEqualToString:weekName]) {
            searchWeather = day;
            break;
        }
    }
    return searchWeather;
}

- (DayWeather *)weatherOfIndex:(NSInteger)index
{
    return [_dayWetherList objectAtIndex:index];
}

- (NSInteger)countOfDayWeather
{
    return [_dayWetherList count];
}

@end
