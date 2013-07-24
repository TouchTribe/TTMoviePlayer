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
#import "UIView+TTAdditions.h"

@implementation TTMoviePlayerSeekBar

@synthesize controller;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        track = [self.layer addLayer];
        trackBackground = [track addShape];
        trackBackground.fillColor = [UIColor colorWithHex:0x333333FF].CGColor;
        trackDownload = [track addShape];
        trackDownload.fillColor = [UIColor colorWithHex:0x5B5B5BFF].CGColor;
        trackCurrent = [track addShape];
        trackCurrent.fillColor = [UIColor colorWithHex:0xC2C2C2FF].CGColor;
        trackMask = [self.layer addShape];
        track.mask = trackMask;
        
        knob = [[UIView alloc] init];
        knob.layer.anchorPoint = CGPointMake(0, 0);
        [knob.layer setImageNamed:@"TTMoviePlayer.bundle/knob"];
        [self addSubview:knob];

        gestureRecognizer = [[TTMoviePlayerGestureRecognizer alloc] initWithTarget:self action:@selector(doScrubbing:)];
        [knob addGestureRecognizer:gestureRecognizer];
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
        [knob.layer setImageNamed:@"TTMoviePlayer.bundle/knob-highlight"];
        isScrubbing = TRUE;
        lastTime = time;
        lastScrubPosition = point;
        scrubOffset = CGPointMake(lastScrubPosition.x - knob.layer.position.x, lastScrubPosition.y - knob.layer.position.y);
        [controller beginScrubbing];
        [controller setScrubSpeed:TTMoviePlayerScrubSpeedNormal];
    }
}

- (void)scrubbingChange:(CGPoint)point
{
    if (isScrubbing && controller) {
        double base = [self convertXToTime:(point.x - scrubOffset.x)];
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
            float timeOffset = multiplier*([self convertXToTime:lastScrubPosition.x] - [self convertXToTime:point.x]);
            time = lastTime - timeOffset;
            float prevDistance = abs(lastScrubPosition.y-knob.top);
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
    if (isScrubbing) {
        [knob.layer setImageNamed:@"TTMoviePlayer.bundle/knob"];
        isScrubbing = false;
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
    
    double y = round(0.5*(self.height-10));
    trackBackground.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, y, self.width, 10)].CGPath;
    float ratio = duration != 0 ? buffer/duration : 0;
    trackDownload.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, y, round(ratio*self.width), 10)].CGPath;
    float knobX = round([self convertTimeToX:time]);
    trackCurrent.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, y, round(knobX+0.5*knob.width), 10)].CGPath;
    trackMask.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, y, self.width, 10) cornerRadius:5].CGPath;
    knob.layer.position = CGPointMake(knobX, [knob centerY:0 :self.bottom]);
    
    [CATransaction commit];
}

- (float)convertTimeToX:(double)time_
{
    float ratio = duration != 0 ? time_/duration : 0;
    return (self.width+25-knob.width)*ratio-12;
}

- (double)convertXToTime:(float)x_
{
    return duration*(x_+12)/(self.width+25-knob.width);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
