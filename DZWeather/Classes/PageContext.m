//
//  ContextView.m
//  DZWeather
//
//  Created by Ibokan on 15/11/17.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "PageContext.h"

@implementation PageContext

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        self.numberOfPageShowSameTime = 1;
    }
    return self;
}

- (void)addPage:(PageView *)page
{
    [self addSubview:page];
    [self setNeedsDisplay];
}
- (void)removePageWithCondition:(searchCondition)isRemovePage
{
    for (PageView* page in [self subviews]) {
        if (isRemovePage(page)) {
            [page removeFromSuperview];
            break;
        }
    }
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    NSArray* pages = [self subviews];
    NSInteger pageCount = [pages count];
    
    CGSize mySize = self.frame.size;
    CGSize pageSize = CGSizeMake(mySize.width/self.numberOfPageShowSameTime, mySize.height);
    [UIView beginAnimations:@"move" context:nil];
    for (int pageNumber = 0; pageNumber < pageCount; pageNumber++) {
        PageView* page = [pages objectAtIndex:pageNumber];
        [page setFrame:CGRectMake(pageNumber*pageSize.width, 0, pageSize.width, pageSize.height)];
    }
    self.contentSize = CGSizeMake(pageSize.width*pageCount, pageSize.height);
    [UIView commitAnimations];
}


@end
