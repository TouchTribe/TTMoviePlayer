//
//  TTMoviePlayerEmbeddedControlBar.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 7/1/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerDependencyInjector.h"
#import "TTMoviePlayerEmbeddedControlBar.h"
#import "TTMoviePlayerController.h"
#import "UIView+TTAdditions.h"

@implementation TTMoviePlayerEmbeddedControlBar

@synthesize controller, playState;

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 44)];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x00000099];

        timeControl = [injector resolveControlForKey:@"inlineTimeControl"];
        [self addSubview:timeControl];
        
        playButton = [injector resolveStateButtonForKey:@"inlinePlayButton"];
        [playButton addTarget:self action:@selector(didSelectPlay) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playButton];
        
        fullscreenButton = [injector resolveButtonForKey:@"inlineFullscreenButton"];
        [fullscreenButton addTarget:self action:@selector(didSelectFullscreen) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fullscreenButton];
    }
    return self;
}

- (void)setController:(TTMoviePlayerController *)controller_
{
    controller = controller_;
    timeControl.controller = controller_;
}

- (void)updateTime:(double)time_
{
    [timeControl updateTime:time_];
}

- (void)updateDuration:(double)duration_
{
    [timeControl updateDuration:duration_];
}

- (void)updateBuffer:(double)buffer_
{
    [timeControl updateBuffer:buffer_];
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

- (void)layoutSubviews
{
    timeControl.frame = CGRectMake(0, 0, self.width-playButton.width-fullscreenButton.width-20, self.height);
    [timeControl centerWithRect:self.bounds];
    
    playButton.frame = CGRectMake(12, [playButton centerY:0 :self.height], playButton.width, playButton.height);
    fullscreenButton.frame = CGRectMake(self.width-fullscreenButton.width-12, [fullscreenButton centerY:0 :self.height], fullscreenButton.width, fullscreenButton.height);
}

- (void)didSelectPlay
{
    if (controller) {
        if (playState == TTMoviePlayerPlayStatePlaying) {
            [controller pause];
        } else {
            [controller play];
        }
    }
}

- (void)didSelectFullscreen
{
    if (controller) {
        controller.fullscreen = true;
    }
}


@end
