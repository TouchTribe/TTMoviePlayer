//
//  TTMoviePlayerDependencyInjector.h
//  TTMoviePlayer
//
//  Created by Guido van Loon on 7/21/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMoviePlayerDependencyInjector : NSObject
{
    NSMutableDictionary *dependencies;

}

- (void)registerDependencyForKey:(NSString *)key creator:(id(^)(TTMoviePlayerDependencyInjector *))creator;
- (id)resolveDependencyForKey:(NSString *)key class:(Class)class;
- (id)resolveDependencyForKey:(NSString *)key class:(Class)class protocol:(Protocol *)protocol;
- (id)resolveControlForKey:(NSString *)key;
- (id)resolveButtonForKey:(NSString *)key;
- (id)resolveStateButtonForKey:(NSString *)key;
- (id)resolveLabelForKey:(NSString *)key;

@end
