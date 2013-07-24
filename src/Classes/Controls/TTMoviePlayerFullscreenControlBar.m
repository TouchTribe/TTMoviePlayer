//
//  TTNavBar.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/27/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerDependencyInjector.h"
#import "TTMoviePlayerFullscreenControlBar.h"
#import "TTMoviePlayerController.h"
#import "UIView+TTAdditions.h"

@implementation TTMoviePlayerFullscreenControlBar

@synthesize controller, playState;

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 48)];
    if (self) {
        backgroundLayer = [self.layer addLayer];
        [backgroundLayer setImageNamed:@"TTMoviePlayer.bundle/nav-background" withInsets:UIEdgeInsetsMake(25, 0, 0, 0)];
        
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
    timeControl.frame = CGRectMake(0, 0, self.width-doneButton.width-fillModeButton.width-40, 48);
    [timeControl centerWithRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, 48)];
    doneButton.frame = CGRectMake(10, [doneButton centerY:0 :48], doneButton.width, doneButton.height);
    fillModeButton.frame = CGRectMake(self.width-fillModeButton.width-10, [fillModeButton centerY:0 :48], fillModeButton.width, fillModeButton.height);
    if (scrubSpeed == TTMoviePlayerScrubSpeedNone) {
        backgroundLayer.frame = CGRectMake(0, 0, self.width, self.height);
        scrubTitle.hidden = true;
        scrubDescription.hidden = true;
    } else {
        backgroundLayer.frame = CGRectMake(0, 0, self.width, self.height+48);
        scrubTitle.hidden = false;
        scrubDescription.hidden = false;
        scrubTitle.frame = CGRectMake(0, self.height-16, self.width, 30);
        scrubDescription.frame = CGRectMake(0, self.height, self.width, 30);
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
