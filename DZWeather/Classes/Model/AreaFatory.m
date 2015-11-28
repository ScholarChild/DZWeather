//
//  AreaFatory.m
//  DZWeather
//
//  Created by Ibokan on 15/11/19.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "AreaFatory.h"
#import "Database.h"
#import "Response.h"

@implementation AreaFatory


+ (Area*)currentArea;
{
    NSDictionary* currAreaInfo = [Response responseWithQuestUrlString:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json"];
    NSString* district = [currAreaInfo objectForKey:@"district"];
    NSString* city = [currAreaInfo objectForKey:@"city"];
    NSString* areaName = ([district isEqualToString:@""]) ? city : district;
    return [[self class] areaWithAreaName:areaName];
}

+ (Area*)areaWithAreaName:(NSString *)areaName
{
    NSString* selectAreaF = [NSString stringWithFormat:@"select * from areaid_f where NAMECN = '%@' ",areaName];
    NSString* selectAreaV = [NSString stringWithFormat:@"select * from areaid_v where NAMECN = '%@' ",areaName];
    Area* area = [[self class] areaWithSql:selectAreaF];
    if (area.ID == nil) {
        area = [[self class] areaWithSql:selectAreaV];
    }
    return area;
}

+ (Area*)areaWithSql:(NSString*)sql
{
    NSString* path = [[NSBundle mainBundle]pathForResource:@"weatherChina" ofType:@"sqlite"];
    Database* database = [[Database alloc]initWithFile:path];
    Area* area = [Area new];
    
    database.callback = ^(NSDictionary* keyValues) {
        area.ID = [keyValues objectForKey:@"AREAID"];
        area.province = [keyValues objectForKey:@"PROVCN"];
        area.city = [keyValues objectForKey:@"DISTRICTCN"];
        area.district = [keyValues objectForKey:@"NAMECN"];
        return 0;
    };
    [database execSql:sql];    
    return area;
}



@end
