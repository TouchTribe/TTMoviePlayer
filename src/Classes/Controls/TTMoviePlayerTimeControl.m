//
//  TTTimeControl.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 7/1/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerLayout.h"
#import "TTMoviePlayerTimeControl.h"
#import "UIView+TTAdditions.h"

@implementation TTMoviePlayerTimeControl

@synthesize controller;

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector
{
    self = [super init];
    if (self) {
        seekBar = [[TTMoviePlayerSeekBar alloc] init];
        [self addSubview:seekBar];
        
        timeLabel = [[TTMoviePlayerLabel alloc] initWithFrame:CGRectMake(100, 0, 100, 30)];
        [self addSubview:timeLabel];
        
        timeLeftLabel = [[TTMoviePlayerLabel alloc] initWithFrame:CGRectMake(500, 0, 100, 30)];
        [self addSubview:timeLeftLabel];
        
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
    
    seekBar.frame = CGRectMake(0, 0, self.width-2*(size.width+8), self.height);
    [seekBar centerWithRect:self.bounds];
    timeLabel.frame = CGRectMake(size.width-timeLabel.width, [timeLabel centerY:0 :self.height-2], timeLabel.width, timeLabel.height);
    timeLeftLabel.frame = CGRectMake(self.width-size.width, [timeLeftLabel centerY:0 :self.height-2], timeLeftLabel.width, timeLeftLabel.height);
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
        timeLeftLabel.text = [NSString stringWithFormat:@"-%@", [self formatTime:(duration-time)]];
    } else {
        timeLabel.text = @"-:--";
        timeLeftLabel.text = @"-:--";
    }
    [timeLabel sizeToFit];
    [timeLeftLabel sizeToFit];
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
