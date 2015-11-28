//
//  WeekWeatherContext.m
//  DZWeather
//
//  Created by Ibokan on 15/11/18.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "WeekWeatherContext.h"

@implementation WeekWeatherContext

@synthesize dayWeatherCells = _dayWeatherCells;

- (instancetype)init
{
    if (self = [super init]) {
        self.numberOfPageShowSameTime = 3;
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.1];
    }
    return self;
}


- (NSArray *)dayWeatherCells
{
    return _dayWeatherCells;
}

- (void)setDayWeatherCells:(NSArray *)aDayWeatherCells
{
    if ([self.dayWeatherCells isEqual:aDayWeatherCells]) return;
    NSAssert([self everyOneIsDayWeatherCell:aDayWeatherCells],
             @"anyone is not member of DayWeatherCell at reiverArray ");
    [self refreshDayWeatherCells:aDayWeatherCells];
}

- (void)refreshDayWeatherCells:(NSArray*)newDayWeatherCells
{
    [UIView beginAnimations:@"refresh" context:nil];
    [UIView setAnimationDuration:3];
    for (DayWeatherCell* cell in _dayWeatherCells) {
        [cell removeFromSuperview];
        [self setNeedsDisplay];
    }
    _dayWeatherCells = newDayWeatherCells;
    for (DayWeatherCell* cell in newDayWeatherCells) {
        [self addSubview:cell];
        [self setNeedsDisplay];
    }
    [UIView commitAnimations];
}

- (BOOL)everyOneIsDayWeatherCell:(NSArray*)checkArray
{
    BOOL noHaveOtherView = YES;
    for (NSObject* obj in checkArray) {
        if (![obj isMemberOfClass:[DayWeatherCell class]]) {
            noHaveOtherView = NO;
            break;
        }
    }
    return noHaveOtherView;
}




@end






