//
//  TTMoviePlayerBaseLayout.m
//  TTMoviePlayer
//
//  Created by Guido van Loon on 7/20/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMoviePlayerLayout.h"
#import "TTMoviePlayerControl.h"
#import "TTMoviePlayerController.h"
#import "TTMoviePlayerDependencyInjector.h"

@implementation TTMoviePlayerLayout

@synthesize fullscreen, controller;

- (id)init
{
    self = [super init];
    if (self) {
        TTMoviePlayerDependencyInjector *injector = [[TTMoviePlayerDependencyInjector alloc] init];
        [self registerDependencies:injector];
        [self resolveDependencies:injector];
    }
    return self;
}

- (void)registerDependencies:(TTMoviePlayerDependencyInjector *)injector
{
    
}

- (void)resolveDependencies:(TTMoviePlayerDependencyInjector *)injector
{
    
}

- (void)setController:(TTMoviePlayerController *)controller_
{
    controller = controller_;
    for (id<TTMoviePlayerControl> control in self.controls) {
        control.controller = controller;
    }
}

- (NSArray *)controls
{
    return [NSArray arrayWithObjects: nil];
}

- (void)layout:(CGRect)rect
{
}

- (void)showInterfaceAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             for (UIView *control in self.controls) {
                                 control.alpha = 1;
                             }
                         }
                         completion:nil];
        if (fullscreen && !statusBarWasHiddenInline) {
            [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
        }
    } else {
        for (UIView *control in self.controls) {
            control.alpha = 1;
        }
        if (fullscreen && !statusBarWasHiddenInline) {
            [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
        }
    }
}

- (void)hideInterfaceAnimated:(BOOL)animated
{
    UIApplication *application = [UIApplication sharedApplication];
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             for (UIView *control in self.controls) {
                                 control.alpha = 0;
                             }
                         }
                         completion:nil];
        if (fullscreen && !application.isStatusBarHidden) {
            [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
        }
    } else {
        for (UIView *control in self.controls) {
            control.alpha = 0;
        }
        if (fullscreen && !application.isStatusBarHidden) {
            [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationNone];
        }
    }
}


- (void)setFullscreen:(BOOL)fullscreen_
{
    if (fullscreen_ != fullscreen) {
        fullscreen = fullscreen_;
        UIApplication *application = [UIApplication sharedApplication];
        statusBarWasHiddenInline = application.statusBarHidden;
        [controller hideInterfaceAnimated:false];
        if (fullscreen) {
            [application setStatusBarHidden:true withAnimation:UIStatusBarAnimationNone];
        } else {
            [application setStatusBarHidden:statusBarWasHiddenInline withAnimation:UIStatusBarAnimationNone];
            [controller pause];
        }
    }
}


@end
