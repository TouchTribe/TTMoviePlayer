//
//  TTMoviePlayerVolumeControl.m
//  TTMoviePlayer
//
//  Created by Guido van Loon on 8/24/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerVolumeControl.h"

@implementation TTMoviePlayerVolumeControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVolumeSlider = true;
        self.showsRouteButton = false;
    }
    return self;
}

- (CGRect)volumeSliderRectForBounds:(CGRect)bounds
{
    return self.bounds;
}

- (BOOL)customizable
{
    return [self respondsToSelector:@selector(setVolumeThumbImage:forState:)];
}

@end
