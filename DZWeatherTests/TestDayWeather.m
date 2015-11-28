//
//  TestDayWeather.m
//  DZWeather
//
//  Created by Ibokan on 15/11/22.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "TestDayWeather.h"
#import "Response.h"

@implementation TestDayWeather

+ (instancetype)currentWeatherWithArea:(Area *)area
{
    NSString* questString = [NSString stringWithFormat:@"http://api.k780.com:88/?app=weather.today&weaid=%@&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",area.ID];
    NSDictionary* infoDic = [Response responseWithQuestUrlString:questString];
    TestDayWeather* weather = [TestDayWeather new];
    [weather setValuesForKeysWithDictionary:[infoDic objectForKey:@"result"]];
    weather.area = area;
    return weather;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%s,%@",__func__,key);
    
    if ([key isEqualToString:@"temp_high"]) {
        self.hightTemp = value;
    }else if([key isEqualToString:@"temp_low"]){
        self.lowTemp = value;
    }else if([key isEqualToString:@"temperature_curr"]){
        self.temp = value;
    }else if([key isEqualToString:@"humidity"]){
        self.humi = value;
    }else if([key isEqualToString:@"days"]){
        self.date = value;
    }
}

@end
