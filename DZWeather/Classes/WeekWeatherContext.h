//
//  WeekWeatherContext.h
//  DZWeather
//
//  Created by Ibokan on 15/11/18.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayWeatherCell.h"
#import "PageContext.h"

@interface WeekWeatherContext : PageContext

@property (nonatomic,retain)NSArray* dayWeatherCells;

@end
