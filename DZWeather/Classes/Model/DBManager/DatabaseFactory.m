//
//  DBManagerFactory.m
//  UseDataBase
//
//  Created by Ibokan on 15/11/8.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "DatabaseFactory.h"

static DatabaseFactory* _instance = nil;

@interface DatabaseFactory()
{
    NSMutableDictionary* _managerPool;
}
@end


@implementation DatabaseFactory

+ (instancetype)shareInstance
{
    if (_instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            _instance = [[self alloc]init];
        });
    }
    return _instance;
}

+ (instancetype)alloc
{
    if (_instance == nil) {
        _instance = [super alloc];
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_instance == nil) {
        _instance = [super allocWithZone:zone];
    }
    return _instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _managerPool = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return self;
}

- (id)copy
{
    return _instance;
}

- (Database*)managerWithPath:(NSString *)filePath
{
    Database* manager;
    
    if ([self alreadyHasManagerWithPath:filePath]) {
        manager = [_managerPool objectForKey:filePath];
    }else {
        manager = [self createNewManagerWithPath:filePath];
        [_managerPool setObject:manager forKey:filePath];
    }
    return manager;
}

- (BOOL)alreadyHasManagerWithPath:(NSString*)path
{
    BOOL hasManager = NO;
    NSArray* keyList = [_managerPool allKeys];
    for (NSString* key in keyList) {
        hasManager = ([key isEqualToString:path]);
    }
    return hasManager;
}

- (Database*)createNewManagerWithPath:(NSString*)path
{
   return [[Database alloc]initWithFile:path];
}

@end
