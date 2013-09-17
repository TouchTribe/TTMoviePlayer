//
//  TTTimeControl.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 7/1/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerLayout.h"
#import "TTMoviePlayerDependencyInjector.h"
#import "TTMoviePlayerTimeControl.h"
#import "TTMoviePlayerUtil.h"

@implementation TTMoviePlayerTimeControl

@synthesize controller;

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector
{
    self = [super init];
    if (self) {
        seekBar = [injector resolveDependencyForKey:@"seekBar" class:[TTMoviePlayerSeekBar class]];
        [self addSubview:seekBar];
        
        timeLabel = [injector resolveDependencyForKey:@"timeLabel" class:[UILabel class]];
        [self addSubview:timeLabel];
        
        durationLabel = [injector resolveDependencyForKey:@"durationLabel" class:[UILabel class]];
        [self addSubview:durationLabel];
        
        [self updateTimeLabels];
    }
    return self;
}

- (void)setController:(TTMoviePlayerController *)controller_
{
    controller = controller_;
    seekBar.controller = controller_;
}

- (void)layoutSubviews
{
    CGSize size = [@"-0:00:00" sizeWithFont:timeLabel.font];
    
    seekBar.frame = CGRectMake(0, 0, self.frame.size.width-2*(size.width+8), self.frame.size.height);
    TTMoviePlayerCenter(seekBar, self.bounds);
    timeLabel.frame = CGRectMake(size.width-timeLabel.frame.size.width, TTMoviePlayerCenterY(timeLabel,0,self.frame.size.height+timeLabel.font.lineHeight - timeLabel.font.pointSize), timeLabel.frame.size.width, timeLabel.frame.size.height);
    durationLabel.frame = CGRectMake(self.frame.size.width-size.width, TTMoviePlayerCenterY(durationLabel,0,self.frame.size.height+timeLabel.font.lineHeight - timeLabel.font.pointSize), durationLabel.frame.size.width, durationLabel.frame.size.height);
}

- (void)updateTime:(double)time_
{
    time = time_;
    [self updateTimeLabels];
    [seekBar updateTime:time_];
}

- (void)updateDuration:(double)duration_
{
    duration = duration_;
    [self updateTimeLabels];
    [seekBar updateDuration:duration_];
}

- (void)updateBuffer:(double)buffer_
{
    [seekBar updateBuffer:buffer_];
}

- (void)updateTimeLabels
{
    if (duration > 0) {
        timeLabel.text = [self formatTime:(time)];
        durationLabel.text = [NSString stringWithFormat:@"-%@", [self formatTime:(duration-time)]];
    } else {
        timeLabel.text = @"-:--";
        durationLabel.text = @"-:--";
    }
}

- (NSString *)formatTime:(double)time_
{
    unsigned long h, m, s;
    h = (time_ / 3600);
    m = ((unsigned long)(time_ / 60)) % 60;
    s = ((unsigned long) time_) % 60;
    if (h > 0) {
        return [NSString stringWithFormat:@"%lu:%02lu:%02lu", h, m, s];
    } else {
        return [NSString stringWithFormat:@"%lu:%02lu", m, s];
    }
}

@end
