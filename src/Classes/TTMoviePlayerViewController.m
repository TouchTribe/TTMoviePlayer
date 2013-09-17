//
//  TTMoviePlayerViewController.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 7/2/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerViewController.h"

@interface TTMoviePlayerViewController ()

@end

@implementation TTMoviePlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.wantsFullScreenLayout = TRUE;
    }
    return self;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration
{
//    CGRect rect;
//    if (UIInterfaceOrientationIsLandscape(orientation)) {
//        rect = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
//    } else {
//        rect = self.view.frame;
//    }
//    for (UIView *view in self.view.subviews) {
//        view.frame = rect;
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
