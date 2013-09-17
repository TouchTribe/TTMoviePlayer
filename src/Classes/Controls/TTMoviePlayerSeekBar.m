//
//  TTBaseSeekBar.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/25/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMoviePlayerSeekBar.h"
#import "TTMoviePlayerController.h"
#import "TTMoviePlayerUtil.h"

@implementation TTMoviePlayerSeekBar

@synthesize controller;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        track = TTMoviePlayerAddLayer(self.layer);
        trackBackground = TTMoviePlayerAddShape(track);
        trackBackground.fillColor = TTMoviePlayerColorWithHex(0x333333FF).CGColor;
        trackBuffer = TTMoviePlayerAddShape(track);
        trackBuffer.fillColor = TTMoviePlayerColorWithHex(0x5B5B5BFF).CGColor;
        trackTime = TTMoviePlayerAddShape(track);
        trackTime.fillColor = TTMoviePlayerColorWithHex(0xC2C2C2FF).CGColor;
        trackMask = TTMoviePlayerAddShape(self.layer);
        track.mask = trackMask;
        
        knob = [[UIView alloc] init];
        knob.layer.anchorPoint = CGPointMake(0, 0);
        [self addSubview:knob];

        gestureRecognizer = [[TTMoviePlayerGestureRecognizer alloc] initWithTarget:self action:@selector(doScrubbing:)];
        [knob addGestureRecognizer:gestureRecognizer];

        self.scrubbing = FALSE;
    }
    return self;
}

- (void)updateTime:(double)time_
{
    time = time_;
    [self setNeedsLayout];
}

- (void)updateDuration:(double)duration_
{
    duration = duration_;
    [self setNeedsLayout];
}

- (void)updateBuffer:(double)buffer_
{
    buffer = buffer_;
    [self setNeedsLayout];
}

- (void)setScrubbing:(BOOL)scrubbing_
{
    scrubbing = scrubbing_;
    if (scrubbing) {
        TTMoviePlayerSetImageNamed(knob.layer, @"TTMoviePlayer.bundle/knob-highlight");
    } else {
        TTMoviePlayerSetImageNamed(knob.layer, @"TTMoviePlayer.bundle/knob");
    }
}

- (BOOL)scrubbing
{
    return scrubbing;
}

- (void)doScrubbing:(UIGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self scrubbingBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStatePossible:
            [self scrubbingChange:point];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self scrubbingEnd:point];
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
}

- (void)scrubbingBegin:(CGPoint)point
{
    if (controller) {
        lastTime = time;
        lastScrubPosition = point;
        scrubOffset = CGPointMake(point.x - knob.frame.origin.x, point.y - knob.frame.origin.y);
        [controller beginScrubbing];
        [controller setScrubSpeed:TTMoviePlayerScrubSpeedNormal];
        self.scrubbing = TRUE;
    }
}

- (void)scrubbingChange:(CGPoint)point
{
    if (scrubbing && controller) {
        TTMoviePlayerRange knobRange = [self knobRange];
        float base = [self convertPosition:(point.x - scrubOffset.x) withRange:knobRange];
        float distance = abs(point.y-knob.layer.position.y);

        if (distance < 75) {
            time = base;
            controller.scrubSpeed = TTMoviePlayerScrubSpeedNormal;
        } else {
            float multiplier = 0;
            if (distance < 150) {
                multiplier = 0.5;
                controller.scrubSpeed = TTMoviePlayerScrubSpeedHalf;
            } else if (distance < 225) {
                multiplier = 0.25;
                controller.scrubSpeed = TTMoviePlayerScrubSpeedQuart;
            } else {
                multiplier = 0.125;
                controller.scrubSpeed = TTMoviePlayerScrubSpeedFine;
            }
            float timeOffset = multiplier*([self convertPosition:lastScrubPosition.x withRange:knobRange] - [self convertPosition:point.x withRange:knobRange]);
            time = lastTime - timeOffset;
            float prevDistance = abs(lastScrubPosition.y-knob.frame.origin.y);
            if (distance < prevDistance) {
                float ratio = (prevDistance-distance)/(prevDistance-75);
                time = ratio*(base-time) + time;
            }
        }
        if (time < 0) {
            time = 0;
        } else if (time > duration) {
            time = duration;
        }
        
        [controller scrub:time];
        [self setNeedsLayout];
        lastTime = time;
        lastScrubPosition = point;
    }
}

- (void)scrubbingEnd:(CGPoint)point
{
    if (scrubbing) {
        self.scrubbing = FALSE;
        if (controller) {
            [controller endScrubbing];
            [controller setScrubSpeed:TTMoviePlayerScrubSpeedNone];
        }
    }
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
- (void)layoutSubviews
{
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
 
    float x = self.frame.size.width;
    float y = round(0.5*(self.frame.size.height-10));
    trackBackground.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, y, x, 10)].CGPath;
    
    x = [self convertTime:buffer withRange:[self bufferTrackRange]];
    trackBuffer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, y, x, 10)].CGPath;
    
    x = [self convertTime:time withRange:[self timeTrackRange]];
    trackTime.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, y, x, 10)].CGPath;
    
    x = [self convertTime:time withRange:[self knobRange]];
    knob.layer.position = CGPointMake(x, TTMoviePlayerCenterY(knob,0,self.frame.origin.y+self.frame.size.height));
    
    trackMask.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, y, self.frame.size.width, 10) cornerRadius:5].CGPath;
    
    [CATransaction commit];
}

- (float)convertTime:(float)time_ withRange:(TTMoviePlayerRange)range
{
    float ratio = duration != 0 ? time_/duration : 0;
    return ratio*range.length+range.position;
}

- (float)convertPosition:(float)position withRange:(TTMoviePlayerRange)range
{
    float ratio = (position-range.position)/range.length;
    return duration*ratio;
}

- (TTMoviePlayerRange)bufferTrackRange
{
    return TTMoviePlayerRangeMake(0, round(self.frame.size.width));
}

- (TTMoviePlayerRange)timeTrackRange
{
    return TTMoviePlayerRangeMake(0, round(self.frame.size.width));
}

- (TTMoviePlayerRange)knobRange
{
    return TTMoviePlayerRangeMake(-12, round(self.frame.size.width-knob.frame.size.width+23));
}

@end
