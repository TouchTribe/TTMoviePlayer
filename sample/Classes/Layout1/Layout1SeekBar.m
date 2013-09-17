//
//  MoviePlayerSeekBar.m
//  Autoweek
//
//  Created by Guido van Loon on 8/22/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "Layout1SeekBar.h"

@implementation Layout1SeekBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        trackBackground.fillColor = TTMoviePlayerColorWithHex(0xFFFFFFFF).CGColor;
        trackBuffer.fillColor = TTMoviePlayerColorWithHex(0x98A1AAFF).CGColor;
        trackTime.fillColor = TTMoviePlayerColorWithHex(0xE00801FF).CGColor;
        track.mask = nil;
    }
    return self;
}

- (void)setScrubbing:(BOOL)scrubbing_
{
    scrubbing = scrubbing_;
    if (scrubbing) {
        TTMoviePlayerSetImageNamed(knob.layer, @"Assets/Layout1/knob-highlight");
    } else {
        TTMoviePlayerSetImageNamed(knob.layer, @"Assets/Layout1/knob-default");
    }
}

- (void)layoutSubviews
{
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    
    float x = self.frame.size.width;
    float y = round(0.5*(self.frame.size.height-4));
    trackBackground.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, y, x, 4)].CGPath;
    
    x = [self convertTime:buffer withRange:[self bufferTrackRange]];
    trackBuffer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, y, x, 4)].CGPath;
    
    x = [self convertTime:time withRange:[self timeTrackRange]];
    trackTime.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, y, x, 4)].CGPath;
    
    x = [self convertTime:time withRange:[self knobRange]];
    
    knob.layer.position = CGPointMake(x, TTMoviePlayerCenterY(knob,0,self.frame.origin.y+self.frame.size.height));
    
    [CATransaction commit];
}

- (TTMoviePlayerRange)knobRange
{
    return TTMoviePlayerRangeMake(-12, round(self.frame.size.width-knob.frame.size.width+24));
}


@end
