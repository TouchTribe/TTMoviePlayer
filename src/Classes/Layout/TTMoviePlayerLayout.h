//
//  TTMoviePlayerBaseLayout.h
//  TTMoviePlayer
//
//  Created by Guido van Loon on 7/20/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TTMoviePlayerController;
@class TTMoviePlayerDependencyInjector;

@interface TTMoviePlayerLayout : NSObject
{
    BOOL statusBarWasHiddenInline;
}

@property (nonatomic, readonly) NSArray *controls;
@property (nonatomic, assign) BOOL fullscreen;
@property (nonatomic, assign) TTMoviePlayerController *controller;

- (void)layout:(CGRect)rect;
- (void)showInterfaceAnimated:(BOOL)animated;
- (void)hideInterfaceAnimated:(BOOL)animated;
- (void)registerDependencies:(TTMoviePlayerDependencyInjector *)injector;
- (void)resolveDependencies:(TTMoviePlayerDependencyInjector *)injector;

@end
