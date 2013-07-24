//
//  TTMoviePlayerDependencyInjector.m
//  TTMoviePlayer
//
//  Created by Guido van Loon on 7/21/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMoviePlayerDependencyInjector.h"
#import "TTMoviePlayerControl.h"
#import "TTMoviePlayerToggleButton.h"

@implementation TTMoviePlayerDependencyInjector

- (id)init
{
    self = [super init];
    if (self) {
        dependencies = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)registerDependencyForKey:(NSString *)key creator:(id(^)(TTMoviePlayerDependencyInjector *))creator
{
    [dependencies setObject:creator forKey:key];
}

- (id)resolveDependencyForKey:(NSString *)key class:(Class)class
{
    id(^creator)(TTMoviePlayerDependencyInjector *) = [dependencies objectForKey:key];
    if (creator == nil) {
        [NSException raise:@"Dependency not found" format:@"dependency for %@ not found", key];
    }
    id value = creator(self);
    if (![value isKindOfClass:class]) {
        [NSException raise:@"Unexpected class for dependency" format:@"dependency for %@ is not a %@", key, class];
    }
    return value;
}

- (id)resolveDependencyForKey:(NSString *)key class:(Class)class protocol:(Protocol *)protocol
{
    id value = [self resolveDependencyForKey:key class:class];
    if (![value conformsToProtocol:protocol]) {
        [NSException raise:@"Unexpected protocol for dependency" format:@"dependency for %@ is not a %@", key, protocol];
    }
    return value;
}

- (id)resolveControlForKey:(NSString *)key
{
    return [self resolveDependencyForKey:key class:[UIView class] protocol:@protocol(TTMoviePlayerControl)];
}

- (id)resolveButtonForKey:(NSString *)key
{
    return [self resolveDependencyForKey:key class:[UIButton class]];
}

- (id)resolveStateButtonForKey:(NSString *)key
{
    return [self resolveDependencyForKey:key class:[TTMoviePlayerStateButton class]];
}

- (id)resolveLabelForKey:(NSString *)key
{
    return [self resolveDependencyForKey:key class:[UILabel class]];
}


@end
