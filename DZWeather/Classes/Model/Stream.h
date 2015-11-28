//
//  Stream.h
//  DZWeather
//
//  Created by Ibokan on 15/11/19.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Stream;

typedef void (^SubScribler)(NSObject* Observale);
typedef void (^EmitWay)(Stream* observer);
typedef id(^MapWay)(id);

@interface Stream : NSObject


+ (instancetype)just:(NSObject*)aValue;
//+ (instancetype)create:(EmitWay)theEmitWay;
- (void)update:(NSObject*)newValue;


- (void)subScrible:(SubScribler)aSubScriber;
- (Stream *)map:(MapWay)aMapWay;
- (Stream *)flatMap:(MapWay)aMapWay;

/*
 - (void)onNext:(NSObject*)nextValue;
 
 */


@end
