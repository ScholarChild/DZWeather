//
//  CityInfo.m
//  DZWeatherDataModel
//
//  Created by Ibokan on 15/11/16.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "Area.h"
#import "Database.h"
#import "Response.h"

@implementation Area

- (NSString *)description
{
    return [NSString stringWithFormat:@"{\n\t%@\n\t%@\n\t%@\n\t%@\n\t%@\n}",
            [super description],
            [self ID],
            [self province],
            [self city],
            [self district]];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.district = [aDecoder decodeObjectForKey:@"district"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.district forKey:@"district"];
}



@end
