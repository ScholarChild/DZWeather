//
//  Response.m
//  DZWeather
//
//  Created by Ibokan on 15/11/18.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "Response.h"

@implementation Response

+ (NSDictionary*)responseWithQuestUrlString:(NSString*)urlString
{
    NSError* err;
    NSDictionary* infoDic = nil;
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* currentWeatherRequest = [NSURLRequest requestWithURL:url];

    NSData* responce = [NSURLConnection sendSynchronousRequest:currentWeatherRequest returningResponse:nil error:&err];
    
    if (responce) {
        infoDic = [NSJSONSerialization JSONObjectWithData:responce options:NSJSONReadingMutableLeaves error:&err];
    }
    return infoDic;
}


@end
