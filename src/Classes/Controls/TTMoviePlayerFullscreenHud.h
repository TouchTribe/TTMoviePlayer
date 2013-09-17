//
//  TTVolumeBar.h
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/29/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMoviePlayerControl.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TTMoviePlayerStateButton.h"
#import "TTMoviePlayerDependencyInjector.h"
#import "TTMoviePlayerVolumeControl.h"
#import "TTMoviePlayerAirplayControl.h"

@interface TTMoviePlayerFullscreenHud : UIView<TTMoviePlayerControl>
{
    UIButton *prevButton;
    TTMoviePlayerStateButton *playButton;
    UIButton *nextButton;
    TTMoviePlayerVolumeControl *volumeControl;
    TTMoviePlayerAirplayControl *airplayControl;
}

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector;

@property (nonatomic,assign) float playControlHeight;
@property (nonatomic,assign) float avControlHeight;

@end
