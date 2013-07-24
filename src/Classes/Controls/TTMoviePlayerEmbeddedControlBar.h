//
//  TTMoviePlayerEmbeddedControlBar.h
//  MediaPlayerTest
//
//  Created by Guido van Loon on 7/1/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTMoviePlayerControl.h"
#import "TTMoviePlayerStateButton.h"

@interface TTMoviePlayerEmbeddedControlBar : UIView<TTMoviePlayerControl>
{
    UIView<TTMoviePlayerControl> *timeControl;
    TTMoviePlayerStateButton *playButton;
    UIButton *fullscreenButton;
}

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector;

@end
