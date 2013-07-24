//
//  TTMoviePlayerGestureRecognizer.m
//  TTMoviePlayer
//
//  Created by Guido van Loon on 7/19/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation TTMoviePlayerGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
}

- (void)reset
{
    [super reset];
}

@end
