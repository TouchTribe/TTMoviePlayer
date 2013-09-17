//
//  MoviePlayerLayout.m
//  Autoweek
//
//  Created by Guido van Loon on 7/22/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "Layout1.h"
#import "Layout1SeekBar.h"
#import "Layout1FullscreenControlBar.h"
#import "Layout1FullscreenHud.h"
#import "StyleConstants.h"

@implementation Layout1

- (void)registerDependencies:(TTMoviePlayerDependencyInjector *)injector
{
    [super registerDependencies:injector];
    
    [injector registerDependencyForKey:@"fullscreenControlBar" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        return [[Layout1FullscreenControlBar alloc] initWithInjector:injector];
    }];
    [injector registerDependencyForKey:@"fullscreenHud" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        return [[Layout1FullscreenHud alloc] initWithInjector:injector];
    }];
    
    [injector registerDependencyForKey:@"inlinePlayButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerStateButton *button = [[TTMoviePlayerStateButton alloc] initWithFrame:CGRectMake(0,0,45,41)];
        [button addState:^(TTMoviePlayerStateButton *button) {
            [button setImage:[UIImage imageNamed:@"Assets/Layout1/play-default"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"Assets/Layout1/play-highlight"] forState:UIControlStateHighlighted];
        }];
        [button addState:^(TTMoviePlayerStateButton *button) {
            [button setImage:[UIImage imageNamed:@"Assets/Layout1/pause-default"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"Assets/Layout1/pause-highlight"] forState:UIControlStateHighlighted];
        }];
        return button;
    }];
    
    [injector registerDependencyForKey:@"seekBar" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        return [[Layout1SeekBar alloc] init];
    }];
    [injector registerDependencyForKey:@"timeLabel" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerLabel *label = [[TTMoviePlayerLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        label.textColor = TTMoviePlayerColorWithHex(0x98A0AAFF);
        label.font = [UIFont fontWithName:kFontNameMyriad size:14];
        label.textAlignment = NSTextAlignmentRight;
        return label;
    }];
    [injector registerDependencyForKey:@"durationLabel" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerLabel *label = [[TTMoviePlayerLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        label.textColor = TTMoviePlayerColorWithHex(0x98A0AAFF);
        label.font = [UIFont fontWithName:kFontNameMyriad size:14];
        return label;
    }];
    
    [injector registerDependencyForKey:@"inlineFullscreenButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [button setImage:[UIImage imageNamed:@"Assets/Layout1/fullscreen-default"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"Assets/Layout1/fullscreen-highlight"] forState:UIControlStateHighlighted];
        return button;
    }];
    
    [injector registerDependencyForKey:@"fullscreenDoneButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 88, 50)];
        [button setBackgroundImage:TTMoviePlayerImageWithColor(CGSizeMake(88, 50), 0x98A1ADFF, UIEdgeInsetsMake(10, 10, 10, 10)) forState:UIControlStateNormal];
        [button setBackgroundImage:TTMoviePlayerImageWithColor(CGSizeMake(88, 50), 0xE00801FF, UIEdgeInsetsMake(10, 10, 10, 10)) forState:UIControlStateHighlighted];
        [button setTitle:@"gereed" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:kFontNameAmplitudeCondMedium size:15];
        return button;
    }];
    
    [injector registerDependencyForKey:@"fullscreenFillModeButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerStateButton *button = [[TTMoviePlayerStateButton alloc] initWithFrame:CGRectMake(0,0,50,50)];
        [button addState:^(TTMoviePlayerStateButton *button) {
            [button setImage:[UIImage imageNamed:@"Assets/Layout1/fit-default"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"Assets/Layout1/fit-highlight"] forState:UIControlStateHighlighted];
        }];
        [button addState:^(TTMoviePlayerStateButton *button) {
            [button setImage:[UIImage imageNamed:@"Assets/Layout1/fill-default"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"Assets/Layout1/fill-highlight"] forState:UIControlStateHighlighted];
        }];
        return button;
    }];
    [injector registerDependencyForKey:@"fullscreenScrubTitle" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerLabel *label = [[TTMoviePlayerLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        label.textColor = TTMoviePlayerColorWithHex(0xFFFFFFFF);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:kFontNameAmplitudeBold size:13];
        return label;
    }];
    [injector registerDependencyForKey:@"fullscreenScrubDescription" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerLabel *label = [[TTMoviePlayerLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        label.textColor = TTMoviePlayerColorWithHex(0x98A0AAFF);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:kFontNameAmplitudeBold size:13];
        return label;
    }];
    
    [injector registerDependencyForKey:@"fullscreenPrevButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 50)];
        [button setImage:[UIImage imageNamed:@"Assets/Layout1/prev-default"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"Assets/Layout1/prev-highlight"] forState:UIControlStateHighlighted];
        return button;
    }];
    [injector registerDependencyForKey:@"fullscreenPlayButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerStateButton *button = [[TTMoviePlayerStateButton alloc] initWithFrame:CGRectMake(0,0,50,50)];
        [button addState:^(TTMoviePlayerStateButton *button) {
            [button setImage:[UIImage imageNamed:@"Assets/Layout1/play-default"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"Assets/Layout1/play-highlight"] forState:UIControlStateHighlighted];
        }];
        [button addState:^(TTMoviePlayerStateButton *button) {
            [button setImage:[UIImage imageNamed:@"Assets/Layout1/pause-default"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"Assets/Layout1/pause-highlight"] forState:UIControlStateHighlighted];
        }];
        return button;
    }];
    [injector registerDependencyForKey:@"fullscreenNextButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 50)];
        [button setImage:[UIImage imageNamed:@"Assets/Layout1/next-default"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"Assets/Layout1/next-highlight"] forState:UIControlStateHighlighted];
        return button;
    }];
    [injector registerDependencyForKey:@"fullscreenVolumeControl" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerVolumeControl *control = [[TTMoviePlayerVolumeControl alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
        UIImage *minimumTrack = [UIImage imageNamed:@"Assets/Layout1/volumeMinimumTrack"];
        UIImage *maximumTrack = [UIImage imageNamed:@"Assets/Layout1/volumeMaximumTrack"];
        [control setMinimumVolumeSliderImage:[minimumTrack resizableImageWithCapInsets:UIEdgeInsetsMake(6, 0, 6, 0)] forState:UIControlStateNormal];
        [control setMaximumVolumeSliderImage:[maximumTrack resizableImageWithCapInsets:UIEdgeInsetsMake(6, 0, 6, 0)] forState:UIControlStateNormal];
        [control setVolumeThumbImage:[UIImage imageNamed:@"Assets/Layout1/volume-knob-default"] forState:UIControlStateNormal];
        [control setVolumeThumbImage:[UIImage imageNamed:@"Assets/Layout1/volume-knob-highlight"] forState:UIControlStateHighlighted];
        return control;
    }];
    [injector registerDependencyForKey:@"fullscreenAirplayControl" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerAirplayControl *control = [[TTMoviePlayerAirplayControl alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [control setRouteButtonImage:[UIImage imageNamed:@"Assets/Layout1/airplay-default"] forState:UIControlStateNormal];
        [control setRouteButtonImage:[UIImage imageNamed:@"Assets/Layout1/airplay-highlight"] forState:UIControlStateHighlighted];
        [control setRouteButtonImage:[UIImage imageNamed:@"Assets/Layout1/airplay-highlight"] forState:UIControlStateSelected];
        return control;
    }];
}

- (void)layout:(CGRect)rect
{
    if (self.fullscreen) {
        embeddedControlBar.hidden = TRUE;
        fullscreenControlBar.hidden = FALSE;
        fullscreenControlBar.frame = CGRectMake(0, statusBarWasHiddenInline ? 0 : 20, rect.size.width, fullscreenControlBar.frame.size.height);
        fullscreenHud.hidden = FALSE;
        fullscreenHud.frame = CGRectMake(0, rect.size.height-100, rect.size.width, 100);
    } else {
        embeddedControlBar.hidden = FALSE;
        embeddedControlBar.frame = CGRectMake(0, rect.size.height-embeddedControlBar.frame.size.height, rect.size.width, embeddedControlBar.frame.size.height);
        fullscreenControlBar.hidden = TRUE;
        fullscreenHud.hidden = TRUE;
    }
}


@end
