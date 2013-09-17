//
//  TTMoviePlayer.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/25/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerLayout.h"
#import "TTMoviePlayerView.h"
#import "TTMoviePlayerController.h"
#import "TTMoviePlayerViewController.h"
#import "TTMoviePlayerUtil.h"

@implementation TTMoviePlayerView

@synthesize player, layout, fullscreen, controller;

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.blackColor;
        self.display.videoGravity = AVLayerVideoGravityResize;
        self.clipsToBounds = TRUE;
        
        container = [[UIView alloc] init];
        [self addSubview:container];
    }
    return self;
}

- (void)setPlayer:(AVPlayer *)player_
{
    player = player_;
    self.display.player = player;
}

- (void)setLayout:(TTMoviePlayerLayout *)layout_
{
    for (UIView *control in container.subviews) {
        [control removeFromSuperview];
    }
    layout = layout_;
    if (layout != nil && layout.controls != nil) {
        for (UIView *control in layout.controls) {
            [container addSubview:control];
        }
    }
    [self setNeedsLayout];
}

- (void)setVideoFillMode:(NSString *)fillMode
{
	self.display.videoGravity = fillMode;
}

- (void)setFullscreen:(BOOL)fullscreen_
{
    if (fullscreen_ != fullscreen) {
        fullscreen = fullscreen_;
        if (fullscreen) {
            // create placeholder
            placeHolderController = self.window.rootViewController;
            placeHolderView = [[UIView alloc] initWithFrame:self.frame];
            [self.superview insertSubview:placeHolderView atIndex:TTMoviePlayerGetIndex(self)];
            
            // move display in view hierarchy
            [self.window addSubview:self];
            self.transform = placeHolderController.view.transform;
            self.frame = [placeHolderView.window convertRect:placeHolderView.frame fromView:placeHolderView.superview];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = self.window.bounds;
            } completion:^(BOOL finished) {
                TTMoviePlayerViewController *controller_ = [[TTMoviePlayerViewController alloc] init];
                controller_.view = self;
                self.window.rootViewController = controller_;
            }];
        } else {
            CGRect frame = self.frame;
            self.window.rootViewController = placeHolderController;
            self.frame = frame;
            [placeHolderView.window addSubview:self];
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = [placeHolderView.window convertRect:placeHolderView.frame fromView:placeHolderView.superview];
            } completion:^(BOOL finished) {
                self.transform = placeHolderView.transform;
                self.frame = placeHolderView.frame;
                [placeHolderView.superview insertSubview:self atIndex:TTMoviePlayerGetIndex(placeHolderView)];
                [placeHolderView removeFromSuperview];
            }];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (controller.interfaceVisible) {
        [controller hideInterfaceAnimated:true];
    } else {
        [controller showInterfaceAnimated:true];
    }
}

- (void)layoutSubviews
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    container.frame = self.bounds; 
    [CATransaction commit];
    if (layout) {
        CGRect rect = CGRectApplyAffineTransform(self.frame, self.transform);
        [layout layout:rect];
    }
}

- (AVPlayerLayer *)display
{
    return (AVPlayerLayer *)self.layer;
}


@end
