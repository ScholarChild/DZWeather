//
//  ContextView.h
//  DZWeather
//
//  Created by Ibokan on 15/11/17.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageView.h"

typedef BOOL (^searchCondition)(PageView*);

@interface PageContext : UIScrollView

@property(nonatomic,assign)NSInteger numberOfPageShowSameTime;

- (void)addPage:(PageView*)page;
- (void)removePageWithCondition:(searchCondition) isRemovePage;

@end
