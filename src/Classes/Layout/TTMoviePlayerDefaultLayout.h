//
//  TTDefaultLayout.h
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/27/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTMoviePlayerLayout.h"

@protocol TTMoviePlayerControl;
@class TTMoviePlayerEmbeddedControlBar;
@class TTMoviePlayerFullscreenControlBar;
@class TTMoviePlayerFullscreenHud;
@class TTMoviePlayerLayout;

@interface TTMoviePlayerDefaultLayout : TTMoviePlayerLayout
{
    UIView<TTMoviePlayerControl> *embeddedControlBar;
    UIView<TTMoviePlayerControl> *fullscreenControlBar;
    UIView<TTMoviePlayerControl> *fullscreenHud;
}

@end
