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

@class TTMoviePlayerDependencyInjector;

@interface TTMoviePlayerSeekBar : UIView<TTMoviePlayerControl>
{
    CALayer *track;
    CAShapeLayer *trackBackground;
    CAShapeLayer *trackDownload;
    CAShapeLayer *trackCurrent;
    CAShapeLayer *trackMask;
    
    UIView *knob;
    
    double time;
    double buffer;
    double duration;
    
    CGPoint scrubOffset;
    double lastTime;
    CGPoint lastScrubPosition;
    
    BOOL isScrubbing;
    TTMoviePlayerGestureRecognizer *gestureRecognizer;
}

@end
