//
//  FileManager.h
//  UseFileOperation
//
//  Created by Ibokan on 15/10/26.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectArchiver : NSObject

@property(readonly) NSString* docPath;
@property(readonly) NSString* libPath;
@property(readonly) NSString* tmpPath;

+ (void)codingObject:(id<NSCoding>)object ForKey:(NSString*)key AtFile:(NSString*)fileName;
+ (id)UncodingObjectForKey:(NSString*)key AtFile:(NSString*)fileName;
@end




