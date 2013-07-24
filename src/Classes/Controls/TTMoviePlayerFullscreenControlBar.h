//
//  TTNavBar.h
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/27/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTMoviePlayerControl.h"
#import "TTMoviePlayerTimeControl.h"
#import "TTMoviePlayerButton.h"
#import "TTMoviePlayerToggleButton.h"

@interface TTMoviePlayerFullscreenControlBar : UIView<TTMoviePlayerControl>
{
    CALayer *backgroundLayer;
    UIView<TTMoviePlayerControl> *timeControl;
    UIButton *doneButton;
    TTMoviePlayerToggleButton *fillModeButton;
    TTMoviePlayerLabel *scrubTitle;
    TTMoviePlayerLabel *scrubDescription;
    TTMoviePlayerScrubSpeed scrubSpeed;
}

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector;

@end
