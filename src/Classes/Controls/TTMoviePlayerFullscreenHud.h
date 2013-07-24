//
//  TTVolumeBar.h
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/29/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+TTAdditions.h"
#import "TTMoviePlayerControl.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TTMoviePlayerStateButton.h"
#import "TTMoviePlayerDependencyInjector.h"

@interface TTMoviePlayerFullscreenHud : UIView<TTMoviePlayerControl>
{
    MPVolumeView *volumeView;
    UIButton *prevButton;
    TTMoviePlayerStateButton *playButton;
    UIButton *nextButton;
}

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector;

@end
