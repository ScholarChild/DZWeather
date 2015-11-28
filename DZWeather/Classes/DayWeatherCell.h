//
//  DayWeatherView.h
//  DZWeather
//
//  Created by Ibokan on 15/11/18.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageView.h"
@interface DayWeatherCell : PageView

@property (nonatomic,retain)NSString* week;
@property (nonatomic,retain)NSString* hightTemp;
@property (nonatomic,retain)NSString* lowTemp;

@property (nonatomic,retain)NSString* weather;
@property (nonatomic,retain)NSString* weatid;

@end
