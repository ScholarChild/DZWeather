//
//  Response.h
//  DZWeather
//
//  Created by Ibokan on 15/11/18.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

@property(nonatomic,retain)NSString* request;



+ (NSDictionary*)responseWithQuestUrlString:(NSString*)urlString;


@end
