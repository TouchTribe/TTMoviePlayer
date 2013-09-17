//
//  TTMoviePlayerAirplayControl.m
//  TTMoviePlayer
//
//  Created by Guido van Loon on 8/24/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerAirplayControl.h"

@implementation TTMoviePlayerAirplayControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVolumeSlider = false;
        self.showsRouteButton = true;
    }
    return self;
}

- (CGRect)routeButtonRectForBounds:(CGRect)bounds
{
    return self.bounds;
}

- (BOOL)customizable
{
    return [self respondsToSelector:@selector(setRouteButtonImage:forState:)];
}

@end
