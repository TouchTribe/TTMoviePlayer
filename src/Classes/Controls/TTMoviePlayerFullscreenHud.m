//
//  TTVolumeBar.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/29/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerFullscreenHud.h"
#import "TTMoviePlayerController.h"
#import "UIView+TTAdditions.h"

@implementation TTMoviePlayerFullscreenHud

@synthesize controller, playState;

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector
{
    self = [super init];
    if (self) {
        [self.layer setImageNamed:@"TTMoviePlayer.bundle/fullscreen-hud" withInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        [self setFrame:CGRectMake(0, 0, 380, 120)];
        
        volumeView = [injector resolveDependencyForKey:@"fullscreenVolumeView" class:[MPVolumeView class]];
        [self addSubview:volumeView];

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
    int buttonHeight = prevButton.height;
    if (playButton.height > buttonHeight) {
        buttonHeight = playButton.height;
    }
    if (nextButton.height > buttonHeight) {
        buttonHeight = nextButton.height;
    }
    
    int height = volumeView.height + 10 + buttonHeight;
    int buttonTop = round(0.5*(self.height-height));
    int buttonBottom = buttonTop + buttonHeight;
    
    prevButton.frame = CGRectMake(30, [prevButton centerY:buttonTop :buttonBottom], prevButton.width, prevButton.height);
    playButton.frame = CGRectMake([playButton centerX:0 :self.width], [playButton centerY:buttonTop :buttonBottom], playButton.width, playButton.height);
    nextButton.frame = CGRectMake(self.width-nextButton.width-30, [nextButton centerY:buttonTop :buttonBottom], nextButton.width, nextButton.height);

    volumeView.frame = CGRectMake(30, buttonBottom+10, self.width-60, volumeView.height);
}

- (void)setPlayState:(TTMoviePlayerPlayState)playState_
{
    playState = playState_;
    if (playState == TTMoviePlayerPlayStatePlaying) {
        playButton.selectedIndex = 0;
    } else {
        playButton.selectedIndex = 1;
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
