//
//  TTButton.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/29/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerButton.h"

@implementation TTMoviePlayerButton

@synthesize color, title, imageName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectIsEmpty(frame) ? CGRectMake(0, 0, 50, 30) : frame];
    if (self) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.titleLabel.shadowColor = [UIColor blackColor];
        self.titleLabel.shadowOffset = CGSizeMake(0, -1);
        self.color = nil;
    }
    return self;
}

- (void)setColor:(UIColor *)color_
{
    color = color_;
    if ([UIColor.blueColor isEqual:color]) {
        [self setBackgroundImage:[UIImage imageNamed:@"TTMoviePlayer.bundle/blue-button-gloss"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"TTMoviePlayer.bundle/blue-button-matte"] forState:UIControlStateHighlighted];
    } else if ([UIColor.blackColor isEqual:color]) {
        [self setBackgroundImage:[UIImage imageNamed:@"TTMoviePlayer.bundle/black-button"] forState:UIControlStateNormal];
    } else {
        self.adjustsImageWhenHighlighted = false;
        [self setBackgroundImage:[UIImage imageNamed:@"TTMoviePlayer.bundle/glow"] forState:UIControlStateHighlighted];
    }
}

- (void)setImageName:(NSString *)imageName_
{
    imageName = imageName_;
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title_
{
    title = title_;
    [self setTitle:title forState:UIControlStateNormal];
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds
{
    if (!color) {
        return CGRectInset(bounds, round(0.5*(bounds.size.width-70)), round(0.5*(bounds.size.height-70)));
    } else {
        return [super backgroundRectForBounds:bounds];
    }
}

@end
