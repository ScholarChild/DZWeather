//
//  AreaFatory.h
//  DZWeather
//
//  Created by Ibokan on 15/11/19.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Area.h"
@interface AreaFatory : NSObject

+ (Area*)currentArea;
+ (Area*)areaWithAreaName:(NSString *)areaName;

@end
