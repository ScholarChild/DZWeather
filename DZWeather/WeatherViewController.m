//
//  ViewController.m
//  DZWeather
//
//  Created by Ibokan on 15/11/16.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "WeatherViewController.h"
#import "SearchTableController.h"
#import "BackgroundView.h"
#import "CityPageView.h"
#import "WeekWeatherContext.h"


#import "DayWeather.h"
#import "WeekWeather.h"

#import "AreaFatory.h"
#import "AreaNoteSaver.h"
#import "Area.h"

@interface WeatherViewController ()<PageDelegate>
{
    BackgroundView* _background;
    PageContext* _cityPageContext;
    
    NSMutableArray* _pageAreaNameList;//存储页面顺序
    NSMutableDictionary* _areaPool;//存储地区信息对象
    NSMutableDictionary* _pagePool;//存储已存在的页面对象
    NSMutableDictionary* _lastUpdateTimeOfArea;//页面最后更新时间
    CGRect _winFrame;
}

@end

@implementation WeatherViewController

#pragma mark AreaNote
- (void)saveDataToFile
{
    NSMutableArray* note = [NSMutableArray new];
    for (NSString* areaName in _pageAreaNameList) {
        [note addObject:[_areaPool objectForKey:areaName]];
    }
    [AreaNoteSaver saveNote:note];
}

- (void)prepareDataForViewInit
{
    NSMutableArray* note = [AreaNoteSaver loadNote];
    _areaPool = [NSMutableDictionary new];
    _pageAreaNameList = [NSMutableArray new];
    for (Area* area in note) {
        [_areaPool setObject:area forKey:area.district];
        [_pageAreaNameList addObject:area.district];
    }
    
    _lastUpdateTimeOfArea = [NSMutableDictionary new];
    _pagePool = [NSMutableDictionary new];
    _winFrame = self.view.frame;
}



#pragma mark ViewInit

- (void)viewDidAppear:(BOOL)animated
{
    [self updateAllPage];
}
- (void)viewDidLoad {
    NSLog(@"start %s",__func__);
    [super viewDidLoad];
    [self prepareDataForViewInit];
    [self initWeatherView];
    NSLog(@"end %s",__func__);
}

- (void)initWeatherView
{
    [self initBackground];
    [self initPageContext];
    [self addBtnToPresentSearchPage];
}

- (void)addBtnToPresentSearchPage
{
    NSString* imgName = @"add.png";
    UIImage* img = [UIImage imageNamed:imgName];
    UIButton* btn = [[UIButton alloc]init];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showSearchPage) forControlEvents:UIControlEventTouchDown];
    [btn setFrame:CGRectMake(_winFrame.size.width*5/6, _winFrame.size.height /10, 35, 35)];
    [self.view addSubview:btn];
}

- (void)showSearchPage
{
    SearchTableController* searchPage = [SearchTableController new];
    searchPage.delegate = self;
    [self presentViewController:searchPage animated:YES completion:nil];
}

- (void)initBackground
{
    _background = [[BackgroundView alloc]initWithFrame:_winFrame];
    [self.view addSubview:_background];
    [self.view sendSubviewToBack:_background];
    [_background setSourceName:@"clear.mp4"];
}

- (void)initPageContext
{
    _cityPageContext = [[PageContext alloc]initWithFrame:_winFrame];
    for (NSString* areaName in _pageAreaNameList) {
       [self addNullPageToContextWithAreaName:areaName];
    }
    [_cityPageContext setPagingEnabled:YES];
    [self.view addSubview:_cityPageContext];
}

#pragma mark pageDelegate

- (void)addArea:(NSString *)areaName
{
    if ([_pageAreaNameList containsObject:areaName]) {
        [self talkUserAlrealyHasArea:areaName];
        return;
    }
    [self addNullPageToContextWithAreaName:areaName];
    [self addAreaInfoWithAreaName:areaName];
    [self updatePageWithAreaName:areaName];
}

- (void)refreshArea:(NSString *)areaName
{
    [self updatePageWithAreaName:areaName];
}

- (void)deleteArea:(NSString *)areaName
{
    if ([[_cityPageContext subviews] count] < 2) return;
    @synchronized(self){
        [self removePageWithAreaName:areaName];
        [self removeAreaInfoWithAreaName:areaName];
        [self changeBackgroundAnimateWithSourec:@"clear.mp4"];
    }
}

#pragma mark addPage

- (void)addNullPageToContextWithAreaName:(NSString*)areaName
{
    CityPageView* page = [[CityPageView alloc]initWithFrame:_winFrame];
    [page setAreaName:areaName];
    [page setDelegate:self];
    [page setWeekContext:[[WeekWeatherContext alloc]init]];
    [_cityPageContext addPage:page];
    [_pagePool setObject:page forKey:areaName];
}

- (void)addAreaInfoWithAreaName:(NSString*)areaName
{
    [_areaPool setObject:[AreaFatory areaWithAreaName:areaName] forKey:areaName];
    [_pageAreaNameList addObject:areaName];
}

- (void)talkUserAlrealyHasArea:(NSString*)areaName
{
    NSInteger pageNumberOfArea = [_pageAreaNameList indexOfObject:areaName] + 1;
    NSString* alrealyExistMessage = [NSString stringWithFormat:@"%@ 已经添加在了 第 %lu 页中",areaName,pageNumberOfArea];
    
    UIAlertView* messgaeShower = [[UIAlertView alloc]initWithTitle:@"重复添加" message:alrealyExistMessage delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [messgaeShower show];
}

#pragma mark deletePage
- (void)removeAreaInfoWithAreaName:(NSString*)areaName
{
    [_areaPool removeObjectForKey:areaName];
    [_pageAreaNameList removeObject:areaName];
}
- (void)removePageWithAreaName:(NSString*)areaName
{
    [_cityPageContext removePageWithCondition:^(PageView* page){
        CityPageView* citypage = (CityPageView*)page;
        BOOL isRemovePage = (citypage.areaName == areaName);
        return isRemovePage;
    }];
    [_pagePool removeObjectForKey:areaName];
}

- (void)changeBackgroundAnimateWithSourec:(NSString*)sourceName
{
    [_background setSourceName:sourceName];
}

#pragma mark updatePage

- (void)updateAllPage
{
    NSLog(@"%s",__func__);
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"newThread is runing");
        for (NSString* areaName in _pageAreaNameList) {
            [self updatePageWithAreaName:areaName];
        }
    });
}

- (void)updatePageWithAreaName:(NSString*)areaName
{
    if ([self isMuchFrequentToUpdateThisArea:areaName]) {
        return;
    }
    Area* pageArea = [_areaPool objectForKey:areaName];
    DayWeather* currentWeather = [DayWeather currentWeatherWithArea:pageArea];
    
    CityPageView* page = [_pagePool objectForKey:areaName];
    page.tempCurrent = currentWeather.temp;
    page.humi = currentWeather.humi;
    page.wind = currentWeather.wind;
    page.winp = currentWeather.winp;
    page.time = currentWeather.date;
    dispatch_async(dispatch_get_main_queue(), ^{
        [page updateMainInfo];
    });
    [self updateWeekWeatherContext:page.weekContext withAreaName:areaName];
}

- (BOOL)isMuchFrequentToUpdateThisArea:(NSString*)areaName
{
    CGFloat lastUpdateTime = 0;
    NSDate* lastUpdateTimeOfThisArea = [_lastUpdateTimeOfArea objectForKey:areaName];
    if (!lastUpdateTimeOfThisArea) {
        NSDate* nowTime = [NSDate dateWithTimeIntervalSinceNow:0];
        [_lastUpdateTimeOfArea setObject:nowTime forKey:areaName];
    }else{
        lastUpdateTime = lastUpdateTimeOfThisArea.timeIntervalSinceReferenceDate;
    }
    
    
    CGFloat timeOfNow = [NSDate dateWithTimeIntervalSinceNow:0].timeIntervalSinceReferenceDate;
    CGFloat secondOfHour = 60*60;
    BOOL isMuchFrequent = YES;
    if (timeOfNow - lastUpdateTime >= secondOfHour) {
        isMuchFrequent = NO;
        lastUpdateTime = timeOfNow;
    }
    return isMuchFrequent;
}

- (void)updateWeekWeatherContext:(WeekWeatherContext*)weekContext withAreaName:(NSString*)areaName
{
    //1.update date
    Area* area = [_areaPool objectForKey:areaName];
    WeekWeather* weekWeather = [WeekWeather currentWeekWeatherOfArea:area];
    
    //2.transform date to cell
    NSArray* currentDayWeatherCells = [self dayWeatherCellsFromTransformWeekWeather:weekWeather];
    //3.update UI in main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        weekContext.dayWeatherCells = [NSArray arrayWithArray:currentDayWeatherCells];
    });
}

- (NSArray*)dayWeatherCellsFromTransformWeekWeather:(WeekWeather*)weekWeather
{
    NSMutableArray* tempDayWeatherCellArr = [NSMutableArray arrayWithCapacity:7];
    NSInteger countOfInfo = [weekWeather countOfDayWeather];
    for (int index = 0; index < countOfInfo; index++) {
        DayWeather* dayWeather = [weekWeather weatherOfIndex:index];
        DayWeatherCell* cell = [DayWeatherCell new];
        
        cell.week = dayWeather.week;
        cell.hightTemp = dayWeather.hightTemp;
        cell.lowTemp = dayWeather.lowTemp;
        cell.weather = dayWeather.weather;
        cell.weatid = dayWeather.weatid;
        [tempDayWeatherCellArr addObject:cell];
    }
    return [NSArray arrayWithArray:tempDayWeatherCellArr];
}

@end
