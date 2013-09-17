//
//  TTVolumeBar.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/29/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerFullscreenHud.h"
#import "TTMoviePlayerController.h"
#import "TTMoviePlayerUtil.h"

@implementation TTMoviePlayerFullscreenHud

@synthesize controller, playState, playControlHeight, avControlHeight;

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector
{
    self = [super init];
    if (self) {
        TTMoviePlayerSetImageNamedWithInsets(self.layer, @"TTMoviePlayer.bundle/fullscreen-hud", UIEdgeInsetsMake(8, 8, 8, 8));
        
        volumeControl = [injector resolveDependencyForKey:@"fullscreenVolumeControl" class:[TTMoviePlayerVolumeControl class]];
        airplayControl = [injector resolveDependencyForKey:@"fullscreenAirplayControl" class:[TTMoviePlayerAirplayControl class]];
        if (volumeControl.customizable && airplayControl.customizable) {
            [self addSubview:volumeControl];
            [self addSubview:airplayControl];
            self.frame = CGRectMake(0, 0, 380, 120);
        } else {
            volumeControl = nil;
            airplayControl = nil;
            self.frame = CGRectMake(0, 0, 380, 80);
        }

        prevButton = [injector resolveButtonForKey:@"fullscreenPrevButton"];
        [prevButton addTarget:self action:@selector(didSelectPrev) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:prevButton];
        
        playButton = [injector resolveStateButtonForKey:@"fullscreenPlayButton"];
        [playButton addTarget:self action:@selector(didSelectPlay) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playButton];

        nextButton = [injector resolveButtonForKey:@"fullscreenNextButton"];
        [nextButton addTarget:self action:@selector(didSelectNext) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];

        playState = TTMoviePlayerPlayStateStopped;
    }
    return self;
}

- (void)layoutSubviews
{
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    
    if (volumeControl != nil && airplayControl != nil) {
        float playControlHeight_ = playControlHeight > 0 ? playControlHeight : TTMoviePlayerMaxHeight(playButton, prevButton, nextButton, nil);
        float avControlHeight_ = avControlHeight > 0 ? avControlHeight : TTMoviePlayerMaxHeight(volumeControl, airplayControl, nil);
        float margin = (height-playControlHeight-avControlHeight)/3;
        float playControlCenter = margin + 0.5*playControlHeight_;
        float avControlCenter = margin + playControlHeight_ + margin + 0.5*avControlHeight_;
        
        TTMoviePlayerCenter(playButton, CGRectMake(0, playControlCenter, width, 0));
        prevButton.frame = CGRectMake(playButton.frame.origin.x-prevButton.frame.size.width-30, TTMoviePlayerCenterY(prevButton,playControlCenter,playControlCenter), prevButton.frame.size.width, prevButton.frame.size.height);
        nextButton.frame = CGRectMake(playButton.frame.origin.x+playButton.frame.size.width+30, TTMoviePlayerCenterY(nextButton,playControlCenter,playControlCenter), nextButton.frame.size.width, nextButton.frame.size.height);
        
        float boundary = width;
        if (boundary < 300) {
            boundary = 300;
        }
        float leftMargin = TTMoviePlayerInterpolateLinear(boundary, 300, 20, 748, 174);
        float rightMargin = airplayControl.frame.size.width + 40;
        if (leftMargin > rightMargin) {
            rightMargin = leftMargin;
        }
        volumeControl.frame = CGRectMake(leftMargin, TTMoviePlayerCenterY(volumeControl, avControlCenter, avControlCenter), width-leftMargin-rightMargin, volumeControl.frame.size.height);
        airplayControl.frame = CGRectMake(width-airplayControl.frame.size.height-20, TTMoviePlayerCenterY(airplayControl, avControlCenter, avControlCenter), airplayControl.frame.size.width, airplayControl.frame.size.height);
    } else {
        TTMoviePlayerCenter(playButton, CGRectMake(0, 0, width, height));
        prevButton.frame = CGRectMake(playButton.frame.origin.x-prevButton.frame.size.width-30, TTMoviePlayerCenterY(prevButton,0,height), prevButton.frame.size.width, prevButton.frame.size.height);
        nextButton.frame = CGRectMake(playButton.frame.origin.x+playButton.frame.size.width+30, TTMoviePlayerCenterY(nextButton,0,height), nextButton.frame.size.width, nextButton.frame.size.height);
    }
}

- (void)setPlayState:(TTMoviePlayerPlayState)playState_
{
    playState = playState_;
    if (playState == TTMoviePlayerPlayStatePlaying) {
        playButton.selectedIndex = 1;
    } else {
        playButton.selectedIndex = 0;
    }
}

- (void)setEnabled:(BOOL)enabled
{
    prevButton.enabled = enabled;
    playButton.enabled = enabled;
    nextButton.enabled = enabled;
}

- (void)didSelectPlay
{
    if (playState == TTMoviePlayerPlayStatePlaying) {
        [controller pause];
    } else {
        [controller play];
    }
}

- (void)didSelectPrev
{
    [controller prevTrack];
}

- (void)didSelectNext
{
    [controller nextTrack];
}


@end
