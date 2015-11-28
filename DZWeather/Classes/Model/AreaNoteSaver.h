//
//  AreaNoter.h
//  DZWeather
//
//  Created by Ibokan on 15/11/19.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaNoteSaver : NSObject

+ (NSMutableArray *)loadNote;
+ (void)saveNote:(NSArray*)note;

@end
