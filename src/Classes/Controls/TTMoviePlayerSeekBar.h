//
//  TTBaseSeekBar.h
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/25/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "TTMoviePlayerControl.h"
#import "TTMoviePlayerButton.h"
#import "TTMoviePlayerGestureRecognizer.h"
#import "TTMoviePlayerController.h"

@class TTMoviePlayerDependencyInjector;

@interface TTMoviePlayerSeekBar : UIView<TTMoviePlayerControl>
{
    CALayer *track;
    CAShapeLayer *trackBackground;
    CAShapeLayer *trackBuffer;
    CAShapeLayer *trackTime;
    CAShapeLayer *trackMask;
    
    UIView *knob;
    
    double time;
    double buffer;
    double duration;
    
    CGPoint scrubOffset;
    double lastTime;
    CGPoint lastScrubPosition;
    
    TTMoviePlayerGestureRecognizer *gestureRecognizer;
    
    BOOL scrubbing;
}

@property (nonatomic, assign) BOOL scrubbing;

- (float)convertTime:(float)time_ withRange:(TTMoviePlayerRange)range;
- (float)convertPosition:(float)position withRange:(TTMoviePlayerRange)range;
- (TTMoviePlayerRange)bufferTrackRange;
- (TTMoviePlayerRange)timeTrackRange;
- (TTMoviePlayerRange)knobRange;

@end
