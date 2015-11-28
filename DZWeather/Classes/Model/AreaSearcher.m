//
//  AreaSearcher.m
//  DZWeather
//
//  Created by Ibokan on 15/11/19.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "AreaSearcher.h"
#import "Database.h"

@implementation AreaSearcher

- (instancetype)init
{
    if (self = [super init]) {
        _onlySearchMainArea = NO;
        _openFuzzySearch = YES;
    }
    return self;
}

- (void)switchOnlySearchMainArea
{
    _onlySearchMainArea = !_onlySearchMainArea;
}
- (void)switchOpenFuzzySearch
{
    _openFuzzySearch = !_openFuzzySearch;
}

- (NSArray *)allArea
{
    return [self areaWithSql:@"select * from areaid_v"];
}

- (NSArray*)areaWithSearchKey:(NSString*)keyWord
{
    NSMutableSet* temp = [NSMutableSet new];
    [temp addObjectsFromArray:[self areaForMatchSearchWithSearchKey:keyWord]];
    if ([self isOpenFuzzySearch]) {
        [temp addObjectsFromArray:[self areaForFuzzySearchWithSearchKey:keyWord]];
    }
    return [NSArray arrayWithArray:[temp allObjects]];
}


- (NSArray*)areaForMatchSearchWithSearchKey:(NSString*)keyWord
{
    NSString* tableName = [self isOnlySearchMainArea] ? @"areaid_f":@"areaid_v";
    NSString* selectCondition = [NSString stringWithFormat:@"select * from %@ where NAMECN Like '%%%@%%' ",tableName,keyWord];
    return [[self class] areaWithSql:selectCondition];
}

- (NSArray*)areaForFuzzySearchWithSearchKey:(NSString*)keyWord
{
    NSMutableSet* tempSet = [NSMutableSet new];
    NSString* tableName = [self isOnlySearchMainArea] ? @"areaid_f":@"areaid_v";
    
    
    NSString* selectCondition =
      [NSString stringWithFormat:@"select * from %@ where NAMECN Like '%%%@%%' ",tableName,keyWord];
    [tempSet addObjectsFromArray:[[self class] areaWithSql:selectCondition]];
    
    
    return [tempSet allObjects];
}


- (NSArray*)areaWithSql:(NSString*)sql
{
    NSString* path = [[NSBundle mainBundle]pathForResource:@"weatherChina" ofType:@"sqlite"];
    Database* database = [[Database alloc]initWithFile:path];
    NSMutableArray* tempArr = [NSMutableArray arrayWithCapacity:1];
    
    database.callback = ^(NSDictionary* keyValues) {
        Area* area = [Area new];
        area.ID = [keyValues objectForKey:@"AREAID"];
        area.province = [keyValues objectForKey:@"PROVCN"];
        area.city = [keyValues objectForKey:@"DISTRICTCN"];
        area.district = [keyValues objectForKey:@"NAMECN"];
        [tempArr addObject:area];
        return 0;
    };
    [database execSql:sql];
    return [NSArray arrayWithArray:tempArr];
}

@end
