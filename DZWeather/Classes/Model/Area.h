//
//  CityInfo.h
//  DZWeatherDataModel
//
//  Created by Ibokan on 15/11/16.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Area : NSObject<NSCoding>

@property(nonatomic,retain)NSString* ID;
@property(nonatomic,retain)NSString* province;//省
@property(nonatomic,retain)NSString* city;//市
@property(nonatomic,retain)NSString* district;//区


@end
