//
//  FileManager.m
//  UseFileOperation
//
//  Created by Ibokan on 15/10/26.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "ObjectArchiver.h"
#import <objc/runtime.h>

@implementation ObjectArchiver

//@synthesize docPath = _docPath;

- (instancetype)init
{
    if (self = [super init]) {
        [self initPath];
    }
    return self;
}

-(void)initPath
{
    NSArray* docSearchArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray* libSearchArr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    _docPath = [docSearchArr objectAtIndex:0];
    _libPath = [libSearchArr objectAtIndex:0];
    _tmpPath = NSTemporaryDirectory();
}

+ (void)codingObject:(id<NSCoding>)object ForKey:(NSString *)key AtFile:(NSString *)fileName
{
    
    NSMutableData* data = [[NSMutableData alloc]init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];

    [archiver encodeObject:object forKey:key];
    //必须要有,且在归档完成后马上调用
    [archiver finishEncoding];
    [data writeToFile:fileName atomically:YES];
}

+ (id)UncodingObjectForKey:(NSString *)key AtFile:(NSString *)fileName
{
    //解码
    NSData* data = [[NSData alloc]initWithContentsOfFile:fileName];
    NSKeyedUnarchiver * UnArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    id object  = [UnArchiver decodeObjectForKey:key];
    [UnArchiver finishDecoding];
    return object;
}

@end
