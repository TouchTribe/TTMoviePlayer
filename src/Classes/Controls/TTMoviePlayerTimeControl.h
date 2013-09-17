//
//  TTTimeControl.h
//  MediaPlayerTest
//
//  Created by Guido van Loon on 7/1/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMoviePlayerLabel.h"
#import "TTMoviePlayerSeekBar.h"

@interface TTMoviePlayerTimeControl : UIView<TTMoviePlayerControl>
{
    TTMoviePlayerSeekBar *seekBar;
    UILabel *timeLabel;
    UILabel *durationLabel;
 
    double duration;
    double time;
}

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector;

@end
