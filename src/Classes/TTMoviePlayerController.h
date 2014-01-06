//
//  TTMoviePlayerController.h
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/26/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TTMoviePlayerConstants.h"

typedef struct {
    float position;
    float length;
} TTMoviePlayerRange;

TTMoviePlayerRange TTMoviePlayerRangeMake(float position, float length);

@class TTMoviePlayerView;
@class TTMoviePlayerLayout;

@interface TTMoviePlayerController : NSObject
{
    AVPlayer *player;
    AVPlayerItem *playerItem;
    BOOL seekToZeroBeforePlay;
    float restoreAfterScrubbingRate;
    id timeObserver;
    double scrubPosition;
    NSTimeInterval scrubPositionTimestamp;
    NSTimeInterval lastScrubTime;
    NSTimer *timer;
    BOOL interfaceVisible;
}

@property (nonatomic, copy) NSURL* URL;
@property (nonatomic, strong) TTMoviePlayerLayout *layout;
@property (nonatomic, readonly) TTMoviePlayerView *view;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL fullscreen;
@property (nonatomic, assign) TTMoviePlayerFillMode fillMode;
@property (nonatomic, assign) TTMoviePlayerScrubSpeed scrubSpeed;
@property (nonatomic, readonly) BOOL interfaceVisible;
@property (nonatomic, assign) BOOL autoplay;

- (void)beginScrubbing;
- (void)scrub:(double)time;
- (void)endScrubbing;
- (void)play;
- (void)pause;
- (void)prevTrack;
- (void)nextTrack;
- (void)showInterfaceAnimated:(BOOL)animated;
- (void)hideInterfaceAnimated:(BOOL)animated;

@end
