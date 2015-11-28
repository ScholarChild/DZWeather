//
//  PageDelegate.h
//  DZWeather
//
//  Created by Ibokan on 15/11/22.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PageDelegate <NSObject>

- (void)addArea:(NSString*)areaName;
- (void)deleteArea:(NSString*)areaName;
- (void)refreshArea:(NSString*)areaName;

@end
