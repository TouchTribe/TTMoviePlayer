//
//  ViewController.h
//  TTMoviePlayerTest
//
//  Created by Guido van Loon on 7/16/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTMoviePlayer/TTMoviePlayer.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController
{
    TTMoviePlayerController *player;
    MPMoviePlayerController *controller;
}

@end
