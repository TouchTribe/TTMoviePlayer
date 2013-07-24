//
//  TTLabel.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/29/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerLabel.h"

@implementation TTMoviePlayerLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont boldSystemFontOfSize:12];
        self.shadowColor = [UIColor blackColor];
        self.shadowOffset = CGSizeMake(0, -1);
        self.numberOfLines = 1;
    }
    return self;
}

@end
