//
//  Layout1FullscreenControlBar.m
//  TTMoviePlayerTest
//
//  Created by Guido van Loon on 8/23/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "Layout1FullscreenControlBar.h"

@implementation Layout1FullscreenControlBar

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector
{
    self = [super initWithInjector:injector];
    if (self) {
        self.frame = CGRectMake(0, 0, 0, 50);
        backgroundLayer.contents = nil;
        backgroundLayer.backgroundColor = TTMoviePlayerColorWithHex(0x00000099).CGColor;
    }
    return self;
}

@end
