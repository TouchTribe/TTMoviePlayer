//
//  TTToggleButton.h
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/29/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerStateButton.h"

@interface TTMoviePlayerToggleButton : TTMoviePlayerStateButton

@property (nonatomic, copy) UIColor* color;
@property (nonatomic, strong) NSArray* imageNames;

@end
