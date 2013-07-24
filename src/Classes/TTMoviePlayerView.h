//
//  TTMoviePlayer.h
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/25/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class TTMoviePlayerLayout;
@class TTMoviePlayerController;

@interface TTMoviePlayerView : UIView
{
    UIView *container;
    UIViewController *placeHolderController;
    UIView *placeHolderView;
}

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) TTMoviePlayerLayout *layout;
@property (nonatomic, strong) TTMoviePlayerController *controller;
@property (nonatomic, readonly) AVPlayerLayer *display;
@property (nonatomic, assign) BOOL animationEnabled;
@property (nonatomic, assign) BOOL fullscreen;

- (void)setVideoFillMode:(NSString *)fillMode;


@end
