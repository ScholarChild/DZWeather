//
//  DayWeatherView.m
//  DZWeather
//
//  Created by Ibokan on 15/11/18.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "DayWeatherCell.h"
#define loadingAttr [[NSAttributedString alloc]initWithString:@"loading..."]

@interface DayWeatherCell()
{
    UILabel* _weekName;
    UILabel* _weatherDescribe;
    UILabel* _tempScope;
    UIImageView* _weatherImg;
}

@end

@implementation DayWeatherCell

@synthesize weatid = _weatid, weather = _weather,week = _week,lowTemp = _lowTemp ,hightTemp = _hightTemp;

- (void)setWeather:(NSString *)weather
{
    if (_weather == weather) return;
    _weather = weather;
    _weatherDescribe.attributedText = [[NSAttributedString alloc]initWithString:weather];
}
- (NSString *)weather
{
    return _weather;
}

- (void)setWeek:(NSString *)week
{
    if (_week == week) return;
    _week = week;
    _weekName.attributedText = [[NSAttributedString alloc]initWithString:week];
}
- (NSString *)week
{
    return _week;
}
- (void)setWeatid:(NSString *)weatid
{
    if (_weatid == weatid) return;
    _weatid = weatid;
    _weatherImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"a_%@.png",weatid]];
}
- (NSString *)weatid
{
    return _weatid;
}
- (void)setHightTemp:(NSString *)hightTemp
{
    if (_hightTemp == hightTemp) return;
    _hightTemp = hightTemp;
    _tempScope.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",_hightTemp,_lowTemp]];
}
- (NSString *)hightTemp
{
    return _hightTemp;
}
- (void)setLowTemp:(NSString *)lowTemp
{
    if (_lowTemp == lowTemp) return;
    _lowTemp = lowTemp;
    _tempScope.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",_hightTemp,_lowTemp]];
}
- (NSString *)lowTemp
{
    return _lowTemp;
}

#pragma mark init and update

- (instancetype)init
{
    if (self = [super init]) {
        [self initAllCompoment];
    }
    return self;
}

- (void)initAllCompoment
{
    _weatherDescribe = [[UILabel alloc]init];
    _weekName = [[UILabel alloc]init];
    _tempScope = [[UILabel alloc]init];
    _weatherImg = [[UIImageView alloc]init];
    
    _weatherDescribe.numberOfLines = 2;
    _weatherDescribe.textAlignment = NSTextAlignmentCenter;
    _weekName.textAlignment = NSTextAlignmentCenter;
    

    
    _weatherDescribe.attributedText = loadingAttr;
    _weekName.attributedText = loadingAttr;
    _tempScope.attributedText = loadingAttr;
    _tempScope.numberOfLines = 2;
    _weatherImg.image = [UIImage imageNamed:@"loading.png"];
    
    
    
    NSArray* viewArray = @[_weatherDescribe,_weekName,_tempScope,_weatherImg];
    for (UIView* view in viewArray) {
        [self addSubview:view];
    }
}

- (void)layoutSubviews
{
    NSLog(@"%s",__func__);
    CGSize mySize = self.frame.size;
    CGFloat heightOfLine = mySize.height/3;
    CGFloat halfOfWitdth = mySize.width /2;
    
    _weatherDescribe.frame = CGRectMake(0, heightOfLine*2, mySize.width,heightOfLine);
    _weekName.frame = CGRectMake(0, 0, mySize.width, heightOfLine);
    _tempScope.frame = CGRectMake(halfOfWitdth, heightOfLine, halfOfWitdth, heightOfLine);
    _weatherImg.frame = CGRectMake(0, heightOfLine, halfOfWitdth, heightOfLine);
}

@end
