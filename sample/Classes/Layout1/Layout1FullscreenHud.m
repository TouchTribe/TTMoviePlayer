//
//  Layout1FullscreenHud.m
//  TTMoviePlayerTest
//
//  Created by Guido van Loon on 8/23/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "Layout1FullscreenHud.h"

@implementation Layout1FullscreenHud

- (id)initWithInjector:(TTMoviePlayerDependencyInjector *)injector
{
    self = [super initWithInjector:injector];
    if (self) {
        self.layer.contents = nil;
        self.layer.backgroundColor = TTMoviePlayerColorWithHex(0xff000099).CGColor;
        self.playControlHeight = 20;
        self.avControlHeight = 16;
    }
    return self;
}

@end
