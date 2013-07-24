//
//  TTMoviePlayerControl.h
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/25/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTMoviePlayerConstants.h"


@class TTMoviePlayerController;

@protocol TTMoviePlayerControl <NSObject>

@property (nonatomic, strong) TTMoviePlayerController *controller;

@optional
@property (nonatomic, assign) TTMoviePlayerPlayState playState;
- (void)updateTime:(double)time;
- (void)updateDuration:(double)duration;
- (void)updateBuffer:(double)buffer;
- (void)setFillMode:(TTMoviePlayerFillMode)fillMode;
- (void)setEnabled:(BOOL)enabled;
- (void)setScrubSpeed:(TTMoviePlayerScrubSpeed)scrubSpeed;

@end
