//
//  TestDayWeather.h
//  DZWeather
//
//  Created by Ibokan on 15/11/22.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Area.h"

@interface TestDayWeather : NSObject

@property (nonatomic,retain)Area* area;
@property (nonatomic,retain)NSString* week;
@property (nonatomic,retain)NSString* date;

@property (nonatomic,retain)NSString* temp;
@property (nonatomic,retain)NSString* hightTemp;
@property (nonatomic,retain)NSString* lowTemp;

@property (nonatomic,retain)NSString* weather;
@property (nonatomic,retain)NSString* weatid;

@property (nonatomic,retain)NSString* humi;//湿度

@property (nonatomic,retain)NSString* wind;//风向
@property (nonatomic,retain)NSString* winp;//风级

+ (instancetype)currentWeatherWithArea:(Area*)area;

@end
