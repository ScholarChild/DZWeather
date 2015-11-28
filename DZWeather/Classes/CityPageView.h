//
//  CityPageView.h
//  DZWeather
//
//  Created by Ibokan on 15/11/16.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageView.h"
#import "WeekWeatherContext.h"
#import "PageDelegate.h"

@interface CityPageView : PageView

@property (nonatomic,retain)NSString* areaName;
@property (nonatomic,retain)NSString* tempCurrent;
@property (nonatomic,retain)NSString* humi;
@property (nonatomic,retain)NSString* wind;
@property (nonatomic,retain)NSString* winp;
@property (nonatomic,retain)NSString* time;
@property (nonatomic,retain)WeekWeatherContext* weekContext;

@property (nonatomic,assign)id<PageDelegate> delegate;

- (void)updateMainInfo;


@end
