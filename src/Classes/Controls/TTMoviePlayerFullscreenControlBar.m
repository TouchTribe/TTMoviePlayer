//
//  TTNavBar.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/27/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerFullscreenControlBar.h"
#import "TTMoviePlayerDependencyInjector.h"
#import "TTMoviePlayerController.h"
#import "TTMoviePlayerUtil.h"

@implementation TTMoviePlayerFullscreenControlBar

@synthesize controller, playState;

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 48)];
    if (self) {
        backgroundLayer = TTMoviePlayerAddLayer(self.layer);
        TTMoviePlayerSetImageNamedWithInsets(backgroundLayer, @"TTMoviePlayer.bundle/nav-background", UIEdgeInsetsMake(25, 0, 0, 0));
        
        timeControl = [injector resolveControlForKey:@"fullscreenTimeControl"];
        [self addSubview:timeControl];
        
        doneButton = [injector resolveButtonForKey:@"fullscreenDoneButton"];
        [doneButton addTarget:self action:@selector(didSelectInline) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneButton];
  
        fillModeButton = [injector resolveButtonForKey:@"fullscreenFillModeButton"];
        [fillModeButton addTarget:self action:@selector(didSelectFillMode) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fillModeButton];
        
        scrubTitle = [injector resolveLabelForKey:@"fullscreenScrubTitle"];
        [self addSubview:scrubTitle];

        scrubDescription = [injector resolveLabelForKey:@"fullscreenScrubDescription"];
        [self addSubview:scrubDescription];
    }
    return self;
}

- (void)setController:(TTMoviePlayerController *)controller_
{
    controller = controller_;
    timeControl.controller = controller_;
}

- (void)layoutSubviews
{
    doneButton.frame = CGRectMake(10, TTMoviePlayerCenterY(doneButton,0,48), doneButton.frame.size.width, doneButton.frame.size.height);
    fillModeButton.frame = CGRectMake(self.frame.size.width-fillModeButton.frame.size.width-10, TTMoviePlayerCenterY(fillModeButton, 0, 48), fillModeButton.frame.size.width, fillModeButton.frame.size.height);
    float timeControlStart = doneButton.frame.origin.x + doneButton.frame.size.width + 5;
    float timeControlEnd = fillModeButton.frame.origin.x - 5;
    timeControl.frame = CGRectMake(timeControlStart, TTMoviePlayerCenterY(doneButton,0,48), timeControlEnd-timeControlStart, 48);

    if (scrubSpeed == TTMoviePlayerScrubSpeedNone) {
        backgroundLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        scrubTitle.hidden = true;
        scrubDescription.hidden = true;
    } else {
        backgroundLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height+48);
        scrubTitle.hidden = false;
        scrubDescription.hidden = false;
        scrubTitle.frame = CGRectMake(0, self.frame.size.height-16, self.frame.size.width, 30);
        scrubDescription.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 30);
        scrubDescription.text = @"Slide your finger down to adjust the scrubbing rate.";
        switch (scrubSpeed) {
            case TTMoviePlayerScrubSpeedNone:
                scrubTitle.text = @"";
                scrubDescription.text = @"";
                break;
            case TTMoviePlayerScrubSpeedNormal:
                scrubTitle.text = @"Hi-Speed scrubbing";
                break;
            case TTMoviePlayerScrubSpeedHalf:
                scrubTitle.text = @"Half-Speed scrubbing";
                break;
            case TTMoviePlayerScrubSpeedQuart:
                scrubTitle.text = @"Quarter-Speed scrubbing";
                break;
            case TTMoviePlayerScrubSpeedFine:
                scrubTitle.text = @"Fine scrubbing";
                break;
        }
    }
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

- (void)setFillMode:(TTMoviePlayerFillMode)fillMode;
{
    fillModeButton.selectedIndex = fillMode;
}

- (void)didSelectFillMode
{
    [controller setFillMode:fillModeButton.selectedIndex];
    if (fillModeButton.selectedIndex == 0) {
        fillModeButton.selectedIndex = 1;
    } else {
        fillModeButton.selectedIndex = 0;
    }
}

- (void)didSelectInline
{
    controller.fullscreen = false;
}

- (void)setScrubSpeed:(TTMoviePlayerScrubSpeed)scrubSpeed_
{
    scrubSpeed = scrubSpeed_;
    [self setNeedsLayout];
}

@end
