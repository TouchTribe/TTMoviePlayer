//
//  TTDefaultLayout.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/27/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerDefaultLayout.h"
#import "TTMoviePlayerDependencyInjector.h"
#import "TTMoviePlayerView.h"
#import "UIView+TTAdditions.h"
#import "TTMoviePlayerEmbeddedControlBar.h"
#import "TTMoviePlayerFullscreenControlBar.h"
#import "TTMoviePlayerFullscreenHud.h"

@implementation TTMoviePlayerDefaultLayout

- (void)registerDependencies:(TTMoviePlayerDependencyInjector *)injector
{
    // inline control bar
    
    [injector registerDependencyForKey:@"inlineControlBar" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        return [[TTMoviePlayerEmbeddedControlBar alloc] initWithInjector:injector];
    }];
    [injector registerDependencyForKey:@"inlineTimeControl" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        return [[TTMoviePlayerTimeControl alloc] initWithInjector:injector];
    }];
    [injector registerDependencyForKey:@"inlineSeekBar" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        return [[TTMoviePlayerSeekBar alloc] init];
    }];
    [injector registerDependencyForKey:@"inlinePlayButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerToggleButton *button = [[TTMoviePlayerToggleButton alloc] init];
        button.imageNames = [NSArray arrayWithObjects:@"TTMoviePlayer.bundle/bar-pause", @"TTMoviePlayer.bundle/bar-play", nil];
        return button;
    }];
    [injector registerDependencyForKey:@"inlineFullscreenButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerButton *button = [[TTMoviePlayerButton alloc] init];
        button.imageName = @"TTMoviePlayer.bundle/zoomout_icon";
        return button;
    }];
    
    // fullscreen control bar

    [injector registerDependencyForKey:@"fullscreenControlBar" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        return [[TTMoviePlayerFullscreenControlBar alloc] initWithInjector:injector];
    }];
    [injector registerDependencyForKey:@"fullscreenDoneButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerButton *button = [[TTMoviePlayerButton alloc] init];
        button.color = UIColor.blueColor;
        button.title = @"Done";
        return button;
    }];
    [injector registerDependencyForKey:@"fullscreenTimeControl" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        return [[TTMoviePlayerTimeControl alloc] initWithInjector:injector];
    }];
    [injector registerDependencyForKey:@"fullscreenFillModeButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerToggleButton *button = [[TTMoviePlayerToggleButton alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
        button.color = UIColor.blackColor;
        button.imageNames = [NSArray arrayWithObjects:@"TTMoviePlayer.bundle/fullscreen-mode", @"TTMoviePlayer.bundle/widescreen-mode", nil];
        return button;
    }];
    [injector registerDependencyForKey:@"fullscreenScrubTitle" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerLabel *label = [[TTMoviePlayerLabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:11];
        return label;
    }];
    [injector registerDependencyForKey:@"fullscreenScrubDescription" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerLabel *label = [[TTMoviePlayerLabel alloc] init];
        label = [[TTMoviePlayerLabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:11];
        label.textColor = [UIColor colorWithHex:0x999999FF];
        return label;
    }];

    // fullscreen hud

    [injector registerDependencyForKey:@"fullscreenHud" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        return [[TTMoviePlayerFullscreenHud alloc] initWithInjector:injector];
    }];
    [injector registerDependencyForKey:@"fullscreenVolumeView" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        MPVolumeView *view = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [view sizeToFit];
        return view;
    }];
    [injector registerDependencyForKey:@"fullscreenPrevButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerButton *button = [[TTMoviePlayerButton alloc] initWithFrame:CGRectMake(0,0,51,35)];
        button.imageName = @"TTMoviePlayer.bundle/prevtrack";
        button.backgroundColor = UIColor.redColor;
        return button;
    }];
    [injector registerDependencyForKey:@"fullscreenPlayButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerToggleButton *button = [[TTMoviePlayerToggleButton alloc] initWithFrame:CGRectMake(0,0,51,35)];
        button.imageNames = [NSArray arrayWithObjects:@"TTMoviePlayer.bundle/hud-pause", @"TTMoviePlayer.bundle/hud-play", nil];
        return button;
    }];
    [injector registerDependencyForKey:@"fullscreenNextButton" creator:^id(TTMoviePlayerDependencyInjector *injector) {
        TTMoviePlayerButton *button = [[TTMoviePlayerButton alloc] initWithFrame:CGRectMake(0,0,51,35)];
        button.imageName = @"TTMoviePlayer.bundle/nexttrack";
        return button;
    }];
}

- (void)resolveDependencies:(TTMoviePlayerDependencyInjector *)injector
{
    embeddedControlBar = [injector resolveControlForKey:@"inlineControlBar"];
    fullscreenControlBar = [injector resolveControlForKey:@"fullscreenControlBar"];
    fullscreenHud = [injector resolveControlForKey:@"fullscreenHud"];
}

- (NSArray *)controls
{
    return [NSArray arrayWithObjects:embeddedControlBar,fullscreenControlBar, fullscreenHud, nil];
}

- (void)layout:(CGRect)rect
{
    if (self.fullscreen) {
        embeddedControlBar.hidden = TRUE;
        fullscreenControlBar.hidden = FALSE;
        fullscreenControlBar.frame = CGRectMake(0, statusBarWasHiddenInline ? 0 : 20, rect.size.width, fullscreenControlBar.height);
        fullscreenHud.hidden = FALSE;
        
        int width = fmin(fullscreenHud.width, rect.size.width-40);
        fullscreenHud.frame = CGRectMake(round(0.5*(rect.size.width-width)), rect.size.height-fullscreenHud.height-20, width, fullscreenHud.height);
    } else {
        embeddedControlBar.hidden = FALSE;
        embeddedControlBar.frame = CGRectMake(0, rect.size.height-embeddedControlBar.height, rect.size.width, embeddedControlBar.height);
        fullscreenControlBar.hidden = TRUE;
        fullscreenHud.hidden = TRUE;
    }
}

@end
