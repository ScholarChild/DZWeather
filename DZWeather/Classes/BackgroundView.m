//
//  BackgroundView.m
//  DZWeather
//
//  Created by Ibokan on 15/11/16.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "BackgroundView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface BackgroundView()
{
    MPMoviePlayerViewController* _backAnimaPlayer;
}
@end

@implementation BackgroundView

@synthesize sourceName = _sourceName;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initBackAnimaPlayer];
    }
    return self;
}

- (void)initBackAnimaPlayer
{
    _backAnimaPlayer = [[MPMoviePlayerViewController alloc]init];
    _backAnimaPlayer.moviePlayer.controlStyle = MPMovieControlStyleNone;
    _backAnimaPlayer.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    _backAnimaPlayer.moviePlayer.view.frame = self.frame;
    _backAnimaPlayer.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    [self addSubview:_backAnimaPlayer.moviePlayer.view];
}

- (void)setSourceName:(NSString *)sourceName
{
    if (_sourceName == sourceName) {
        return;
    }
    _sourceName = sourceName;
    [self updateUrl];
}

- (NSString *)sourceName
{
    return _sourceName;
}
- (void)updateUrl
{
    NSString* urlString = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:self.sourceName];
    NSURL* url = [NSURL fileURLWithPath:urlString];
    _backAnimaPlayer.moviePlayer.contentURL = url;
    [_backAnimaPlayer.moviePlayer prepareToPlay];
    [_backAnimaPlayer.moviePlayer play];
}
@end

























