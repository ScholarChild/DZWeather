//
//  CityPageView.m
//  DZWeather
//
//  Created by Ibokan on 15/11/16.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "CityPageView.h"
#import <CoreText/CoreText.h>

@interface CityPageView()
{
    UILabel* _mainInfo;
    UIButton* _removeCity;
    UIButton* _refresh;
    WeekWeatherContext* _weekContext;
}
@end

@implementation CityPageView

@synthesize weekContext = _weekContext;

- (void)layoutSubviews
{
    NSLog(@"%s",__func__);
    CGSize mySize = self.frame.size;
    CGFloat leftInterval = mySize.width / 10;
    CGFloat btnSize = 35;
    
    _mainInfo.frame = CGRectMake(leftInterval,0,mySize.width - leftInterval, mySize.height -(mySize.width/3));
    _weekContext.frame = CGRectMake(0,mySize.height - (mySize.width /3), mySize.width, (mySize.width /3));
    _removeCity.frame = CGRectMake(leftInterval, mySize.height / 10 , btnSize, btnSize);
    _refresh.frame = CGRectMake(leftInterval, _mainInfo.frame.size.height* 5/6 , btnSize, btnSize);
}

- (void)updateMainInfo
{
    NSMutableAttributedString* mainInfoAttr = [[NSMutableAttributedString alloc]initWithString:@" "];
    NSArray* stringArr = @[[NSString stringWithFormat:@"%@\n",_areaName],
                           [NSString stringWithFormat:@"%@ \n",_tempCurrent],
                           [NSString stringWithFormat:@"%@ \n",_humi],
                           [NSString stringWithFormat:@"%@ %@\n",_wind,_winp],
                           [NSString stringWithFormat:@"%@ 发布\n",_time]];
    for (NSString* subLineStr in stringArr) {
        CTFontRef areaNameFont = CTFontCreateWithName(CFSTR("Arial"), 20, NULL);
        NSDictionary* areaNameAttr = [NSDictionary dictionaryWithObject:(__bridge id)areaNameFont forKey:NSFontAttributeName];
        NSAttributedString* subLine = [[NSAttributedString alloc]initWithString:subLineStr attributes:areaNameAttr];
        [mainInfoAttr appendAttributedString:subLine];
    }
    _mainInfo.attributedText = mainInfoAttr;
}


- (void)setWeekContext:(WeekWeatherContext *)weekContext
{
    if (_weekContext == weekContext) return;
    [_weekContext removeFromSuperview];
    _weekContext = weekContext;
    [self addSubview:_weekContext];
    [self setNeedsDisplay];
}

- (WeekWeatherContext *)weekContext
{
    return _weekContext;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initCompoment];
    }
    return self;
}

- (void)initCompoment
{
    [self initMainInfo];
    [self initWeekWeather];
    [self initRefreshBtn];
    [self initRemoveBtn];
}
- (void)initMainInfo
{
    _mainInfo = [[UILabel alloc]init];
    _mainInfo.numberOfLines = 5;
    _mainInfo.lineBreakMode = NSLineBreakByClipping;
    _mainInfo.attributedText = [[NSAttributedString alloc]initWithString:@"更新中..." attributes:[NSDictionary dictionaryWithObject:(__bridge id)CTFontCreateWithName(CFSTR("Arial"), 20, NULL) forKey:NSFontAttributeName]];
    [self addSubview:_mainInfo];
}

- (void)initWeekWeather
{
    _weekContext = [[WeekWeatherContext alloc]init];
    [_weekContext setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [self addSubview:_weekContext];
}

- (void)initRefreshBtn
{
    _refresh = [self BtnWithImg:@"refresh.png" action:@selector(refreshPage)];
    [self addSubview:_refresh];
}
- (void)refreshPage
{
    [self.delegate refreshArea:_areaName];
}

- (void)initRemoveBtn
{
    _removeCity = [self BtnWithImg:@"del.png" action:@selector(deletePage)];
    [self addSubview:_removeCity];
}
- (void)deletePage
{
    [self.delegate deleteArea:_areaName];
}

- (UIButton*)BtnWithImg:(NSString*)imgName action:(SEL)actionSelector
{
    UIImage* img = [UIImage imageNamed:imgName];
    UIButton* btn = [[UIButton alloc]init];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:actionSelector forControlEvents:UIControlEventTouchDown];
    return btn;
}

@end


















