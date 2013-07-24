//
//  TTMoviePlayerStateButton.h
//  TTMoviePlayer
//
//  Created by Guido van Loon on 7/22/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTMoviePlayerStateButton : UIButton
{
    NSMutableArray *states;
}

@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) NSArray *states;

- (void)addState:(void(^)(TTMoviePlayerStateButton *))state;

@end
