//
//  Stream.m
//  DZWeather
//
//  Created by Ibokan on 15/11/19.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "Stream.h"
@interface Stream()<NSCopying>

@property (nonatomic,retain)NSObject* beObserver;
@property (nonatomic,retain)NSMutableArray* subScriblerList;
@property (nonatomic,retain)NSMutableDictionary* flatMapStreamDic;

@end

@implementation Stream



+ (instancetype)just:(NSObject*)aValue
{
    Stream* theStream = [[[self class]alloc]init];
    theStream.beObserver = aValue;
    return theStream;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.beObserver = [[NSObject alloc]init];
        self.subScriblerList = [NSMutableArray new];
        self.flatMapStreamDic = [NSMutableDictionary new];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    typeof (self) streamCopy = [[[self class] allocWithZone:zone]init];
    [streamCopy setFlatMapStreamDic:_flatMapStreamDic];
    [streamCopy setSubScriblerList:_subScriblerList];
    return streamCopy;
}

- (void)dealloc
{
    [self releaseSubScribler];
    [self releaseFlatMapStreamDic];
    [_beObserver release];
    [super dealloc];
}

- (void)releaseFlatMapStreamDic
{
    NSArray* flatMaps = [_flatMapStreamDic allKeys];
    for (int index = 0; index < [flatMaps count]; index++) {
        Stream* aFlatMapOfIndex = [flatMaps objectAtIndex:index];
        MapWay aMapWay = [_flatMapStreamDic objectForKey:aFlatMapOfIndex];
        [_flatMapStreamDic removeObjectForKey:aFlatMapOfIndex];
        Block_release(aMapWay);
    }
    [flatMaps release];
    [_flatMapStreamDic release];
}

- (void)releaseSubScribler
{
    for (SubScribler aSubScribler in _subScriblerList) {
        [_subScriblerList removeObject:aSubScribler];
        Block_release(aSubScribler);
    }
    [_subScriblerList release];
}

#pragma mark privateMethrod

- (void)subScrible:(SubScribler)aSubScriber
{
    aSubScriber([self.beObserver copy]);
    [_subScriblerList addObject:Block_copy(aSubScriber)];
}

- (Stream *)map:(MapWay)aMapWay
{
    typeof (self) mapStream = [[[self class]alloc]init];
    mapStream.beObserver = aMapWay(self.beObserver);
    return mapStream;
}

- (Stream *)flatMap:(MapWay)aMapWay
{
    typeof (self) flatMapStream = [self map:aMapWay];
    [_flatMapStreamDic setObject:Block_copy(aMapWay) forKey:flatMapStream];
    return flatMapStream;
}

- (void)update:(NSObject *)newValue
{
    [self setBeObserver:newValue];
    [self notify];
}

- (void)notify
{
    [self notifySubScribler];
    [self notifyFlatMap];
}
- (void)notifySubScribler
{
    for (SubScribler aSubScribler in _subScriblerList) {
        aSubScribler([self.beObserver copy]);
    }
}

- (void)notifyFlatMap
{
    NSDictionary* copyFlatMapDic = [_flatMapStreamDic copy];
    NSArray* flatMaps = [copyFlatMapDic allKeys];
    
    for (int index = 0; index < [flatMaps count]; index++) {
        Stream* aflatMap = [flatMaps objectAtIndex:index];
        MapWay aFlatMapWay = [copyFlatMapDic objectForKey:aflatMap];
        aflatMap.beObserver = aFlatMapWay(self.beObserver);
    }
    [flatMaps release];
    [copyFlatMapDic release];
}


@end
