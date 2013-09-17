//
//  UIView+TTAdditions.h
//  Base
//
//  Created by Guido van Loon on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import <QuartzCore/QuartzCore.h>

//@interface UIView(TTAdditions)
//
//@property (nonatomic,assign,readonly) float top;
//@property (nonatomic,assign,readonly) float bottom;
//@property (nonatomic,assign,readonly) float left;
//@property (nonatomic,assign,readonly) float right;
//@property (nonatomic,assign,readonly) float width;
//@property (nonatomic,assign,readonly) float height;
//@property (nonatomic,assign,readonly) UIView *rootView;
//
//- (UIView *)firstChild;
//- (UIView *)lastChild;
//- (BOOL)hasTouch:(UITouch *)touch;
//- (void)centerWithRect:(CGRect)rect;
//- (float)centerX:(float)left :(float)right;
//- (float)centerY:(float)top :(float)bottom;
//- (BOOL)pointInsideSubviews:(CGPoint)point withEvent:(UIEvent *)event;
//- (UIView *)hitTestSubviews:(CGPoint)point withEvent:(UIEvent *)event;
//- (void)enableCaching;
//- (void)disableCaching;
//- (int)getIndex;
//
//@end
//
//@interface CALayer(TTAdditions)
//
//@property (nonatomic,assign,readonly) float top;
//@property (nonatomic,assign,readonly) float bottom;
//@property (nonatomic,assign,readonly) float left;
//@property (nonatomic,assign,readonly) float right;
//@property (nonatomic,assign,readonly) float width;
//@property (nonatomic,assign,readonly) float height;
//
//+ (CALayer *)create;
//- (CALayer *)addLayer;
//- (CATextLayer *)addText;
//- (CAShapeLayer *)addShape;
//- (CAGradientLayer *)addGradient:(NSArray *)colors locations:(NSArray *)locations;
//- (void)setImageNamed:(NSString *)name;
//- (void)setImageNamed:(NSString *)name withInsets:(UIEdgeInsets)insets;
//- (CGSize)imageSize;
//- (void)moveToFront;
//- (void)centerWithRect:(CGRect)rect;
//- (float)centerX:(float)left :(float)right;
//- (float)centerY:(float)top :(float)bottom;
//- (UIImage *)snapshot;
//
//@end
//
//@interface CATextLayer(TTAdditions)
//
//+ (CATextLayer *)create;
//- (void)setFont:(NSString *)font size:(int)size color:(UIColor *)color;
//- (void)setFont:(UIFont *)font color:(UIColor *)color;
//- (void)setText:(NSString *)text;
//- (void)setMultilineText:(NSString *)text;
//- (void)setMultilineText:(NSString *)text width:(int)width;
//
//@property (nonatomic,strong,readonly) UIFont *uifont;
//@property (nonatomic,assign,readonly) CGSize textSize;
//
//@end
//
//@interface CAShapeLayer(TTAdditions)
//
//+ (CAShapeLayer *)create;
//- (void)setStrokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor;
//
//@end
//
//@interface CAGradientLayer(TTAdditions)
//
//+ (CAGradientLayer *)createWithColors:(NSArray *)colors locations:(NSArray *)locations;
//
//@end
//
//@interface UIScreen(TTAdditions)
//
//+ (CGRect)rootRectForOrientation:(UIInterfaceOrientation)orientation;
//+ (CGRect)rectForOrientation:(UIInterfaceOrientation)orientation;
//+ (CGRect)rootRect;
//+ (CGRect)rect;
//
//@end
//
//@interface UIColor(TTAdditions)
//
//+ (UIColor *)colorWithHex:(int)hex;
//
//@end
