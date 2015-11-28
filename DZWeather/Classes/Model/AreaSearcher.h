//
//  AreaSearcher.h
//  DZWeather
//
//  Created by Ibokan on 15/11/19.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Area.h"

@interface AreaSearcher : NSObject

@property (nonatomic,assign,getter=isOnlySearchMainArea)BOOL onlySearchMainArea;
@property (nonatomic,assign,getter=isOpenFuzzySearch)BOOL openFuzzySearch;


- (NSArray*)allArea;
- (NSArray*)areaWithSearchKey:(NSString*)keyWord;

- (void)switchOnlySearchMainArea;
- (void)switchOpenFuzzySearch;

@end
