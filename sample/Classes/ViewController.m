//
//  ViewController.m
//  TTMoviePlayerTest
//
//  Created by Guido van Loon on 7/16/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
    
    player = [[TTMoviePlayerController alloc] init];
    player.URL = [NSURL URLWithString:@"http://pdl.warnerbros.com/wbmovies/manofsteel/trailer4/MAN%20OF%20STEEL%20-%20TRAILER%205%202D-480.mov"];
    player.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    [self.view addSubview:player.view];
    
    NSURL *movieURL = [NSURL URLWithString:@"http://pdl.warnerbros.com/wbmovies/manofsteel/trailer4/MAN%20OF%20STEEL%20-%20TRAILER%205%202D-480.mov"];
    controller = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    controller.view.frame = CGRectMake(0, 300, self.view.frame.size.width, 300);
    [self.view addSubview:controller.view];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 600, self.view.frame.size.width, self.view.frame.size.height-600)];
    view.backgroundColor = UIColor.blueColor;
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
