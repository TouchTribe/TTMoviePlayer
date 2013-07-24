//
//  TTMoviePlayerStateButton.m
//  TTMoviePlayer
//
//  Created by Guido van Loon on 7/22/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerStateButton.h"

@implementation TTMoviePlayerStateButton

@synthesize selectedIndex, states;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        states = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setStates:(NSArray *)states_
{
    states = [[NSMutableArray alloc] initWithArray:states_];
    void(^state)(TTMoviePlayerStateButton *) = [states objectAtIndex:selectedIndex];
    state(self);
}

- (void)setSelectedIndex:(int)selectedIndex_
{
    if (selectedIndex < 0 || selectedIndex >= states.count) {
        selectedIndex = 0;
    }
    if (selectedIndex_ != selectedIndex) {
        selectedIndex = selectedIndex_;
        void(^state)(TTMoviePlayerStateButton *) = [states objectAtIndex:selectedIndex];
        state(self);
    }
}

- (void)addState:(void(^)(TTMoviePlayerStateButton *))state
{
    [states addObject:state];
    if (states.count == 1) {
        void(^state)(TTMoviePlayerStateButton *) = [states objectAtIndex:0];
        state(self);
    }
}

@end
