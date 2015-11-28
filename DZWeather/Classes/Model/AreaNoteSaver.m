//
//  AreaNoter.m
//  DZWeather
//
//  Created by Ibokan on 15/11/19.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "AreaNoteSaver.h"
#import "ObjectArchiver.h"
#import "AreaFatory.h"
#define AreaNote @"AreaNote"
#define encodePath [[[ObjectArchiver new] docPath]stringByAppendingPathComponent:@"AreaNote.encode"]

@interface AreaNoteSaver()

@end


@implementation AreaNoteSaver


+ (void)saveNote:(NSArray *)note
{
    NSLog(@"%s",__func__);
    [ObjectArchiver codingObject:note ForKey:AreaNote AtFile:encodePath];
}

+ (NSMutableArray *)loadNote
{
    NSMutableArray*   encodingArray = [NSMutableArray new];
    if ([[NSFileManager defaultManager] fileExistsAtPath:encodePath]) {
        encodingArray = [ObjectArchiver UncodingObjectForKey:AreaNote AtFile:encodePath];
    }else{
        [self initNote:encodingArray];
    }
    return encodingArray;
}

+ (void)initNote:(NSMutableArray*)encodingArray
{
    [encodingArray addObject:[AreaFatory currentArea]];
    [ObjectArchiver codingObject:encodingArray ForKey:AreaNote AtFile:encodePath];
}

@end
