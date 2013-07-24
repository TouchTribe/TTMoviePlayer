//
//  UIView+TTAdditions.m
//  Base
//
//  Created by Guido van Loon on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+TTAdditions.h"

@implementation UIView(TTAdditions)

- (float)left
{
    return self.frame.origin.x;
}

- (float)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (float)top
{
    return self.frame.origin.y;
}

- (float)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (float)width
{
    return self.frame.size.width;
}

- (float)height
{
    return self.frame.size.height;
}

- (UIView *)rootView
{
    UIView *rootView = self;
    while (rootView.superview) rootView = rootView.superview;
        return rootView;
}

- (void)centerWithRect:(CGRect)rect;
{
    self.frame = CGRectMake(rect.origin.x + round(0.5*(rect.size.width-self.frame.size.width)), rect.origin.y + round(0.5*(rect.size.height-self.frame.size.height)), self.frame.size.width, self.frame.size.height);
}

- (float)centerX:(float)left :(float)right
{
    return left + round(0.5*((right-left) - self.frame.size.width));
}

- (float)centerY:(float)top :(float)bottom
{
    return top + round(0.5*((bottom-top) - self.frame.size.height));
}

- (UIView *)firstChild
{
    return [self.subviews count] > 0 ? [self.subviews objectAtIndex:0] : nil;
}

- (UIView *)lastChild
{
    int count = [self.subviews count];
    return count > 0 ? [self.subviews objectAtIndex:count-1] : nil;
}

- (BOOL)hasTouch:(UITouch *)touch
{
    return [self pointInside:[touch locationInView:self] withEvent:nil];
}

- (BOOL)pointInsideSubviews:(CGPoint)point_ withEvent:(UIEvent *)event
{
    for (UIView *child in self.subviews) {
        CGPoint point = [self convertPoint:point_ toView:child];
        if (!child.hidden && [child pointInside:point withEvent:event]) {
            return TRUE;
        }
    }
    return FALSE;
}

- (UIView *)hitTestSubviews:(CGPoint)point_ withEvent:(UIEvent *)event
{
    for (UIView *child in self.subviews) {
        CGPoint point = [self convertPoint:point_ toView:child];
        if (!child.hidden && [child pointInside:point withEvent:event]) {
            return [child hitTest:point withEvent:event];
        }
    }
    return nil;
}

- (void)enableCaching
{
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    [operation addExecutionBlock:^{
        UIImage *image = [self.layer snapshot];
        self.layer.contents = (__bridge id)image.CGImage;
        for (CALayer *layer in self.layer.sublayers) {
            layer.hidden = TRUE;
        }
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

- (void)disableCaching
{
    self.layer.contents = nil;
    for (CALayer *layer in self.layer.sublayers) {
        layer.hidden = FALSE;
    }
}

- (int)getIndex
{
    if (self.superview) {
        int count = self.superview.subviews.count;
        for (int i=0; i<count; i++) {
            if (self == [self.superview.subviews objectAtIndex:i]) {
                return i;
            }
        }
    }
    return -1;
}

@end


@implementation CALayer(TTAdditions)

- (float)left
{
    return self.frame.origin.x;
}

- (float)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (float)top
{
    return self.frame.origin.y;
}

- (float)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (float)width
{
    return self.frame.size.width;
}

- (float)height
{
    return self.frame.size.height;
}

- (void)centerWithRect:(CGRect)rect;
{
    if ([self isKindOfClass:[CATextLayer class]]) {
        self.frame = CGRectMake(rect.origin.x + round(0.5*(rect.size.width-self.frame.size.width)), rect.origin.y + 3 + round(0.5*(rect.size.height-self.frame.size.height)), self.frame.size.width, self.frame.size.height);
    } else {
        self.frame = CGRectMake(rect.origin.x + round(0.5*(rect.size.width-self.frame.size.width)), rect.origin.y + round(0.5*(rect.size.height-self.frame.size.height)), self.frame.size.width, self.frame.size.height);
    }
}

- (float)centerX:(float)left :(float)right
{
    return left + round(0.5*((right-left) - self.frame.size.width));
}

- (float)centerY:(float)top :(float)bottom
{
    return top + round(0.5*((bottom-top) - self.frame.size.height));
}

+ (CALayer *)create
{
    CALayer *layer = [CALayer layer];
    layer.anchorPoint = CGPointMake(0, 0);
    layer.contentsScale = [[UIScreen mainScreen] scale];
    return layer;
}

- (CALayer *)addLayer
{
    CALayer *layer = [CALayer create];
    [self addSublayer:layer];
    return layer;
}

- (CATextLayer *)addText
{
    CATextLayer *layer = [CATextLayer create];
    [self addSublayer:layer];
    return layer;
}

- (CAShapeLayer *)addShape
{
    CAShapeLayer *layer = [CAShapeLayer create];
    [self addSublayer:layer];
    return layer;
}

- (CAGradientLayer *)addGradient:(NSArray *)colors locations:(NSArray *)locations
{
    CAGradientLayer *layer = [CAGradientLayer createWithColors:colors locations:locations];
    [self addSublayer:layer];
    return layer;
}

- (void)setImageNamed:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    self.contents = (id)image.CGImage;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, image.size.width, image.size.height);
}

- (void)setImageNamed:(NSString *)name withInsets:(UIEdgeInsets)insets
{
    UIImage *image = [UIImage imageNamed:name];
    self.contents = (id)image.CGImage;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, image.size.width, image.size.height);
    
    float width = image.size.width;
    float height = image.size.height;
    self.contentsCenter = CGRectMake(insets.left/width, insets.top/height, (width-insets.left-insets.right)/width, (height-insets.top-insets.bottom)/height);
}

- (CGSize)imageSize
{
    CGImageRef img = (__bridge CGImageRef)self.contents;
    CGSize size;
    size.width = CGImageGetWidth(img);
    size.height = CGImageGetHeight(img);
    return size;
}

- (void)moveToFront {
    CALayer *superlayer = self.superlayer;
    [self removeFromSuperlayer];
    [superlayer addSublayer:self];
}

- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    BOOL hidden = [self isHidden];
    [self setHidden:NO];
    [self renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setHidden:hidden];
    return image;
}

@end


@implementation CATextLayer(TTAdditions)

+ (CATextLayer *)create
{
    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.alignmentMode = kCAAlignmentLeft;
    layer.anchorPoint = CGPointMake(0, 0);
    return layer;
}

- (void)setFont:(NSString *)font size:(int)size color:(UIColor *)color
{
    self.font = (__bridge CFTypeRef)font;
    self.fontSize = size;
    self.foregroundColor = color.CGColor;
}

- (void)setFont:(UIFont *)font color:(UIColor *)color
{
    self.font = (__bridge CFTypeRef)font.fontName;
    self.fontSize = font.pointSize;
    self.foregroundColor = color.CGColor;
}

- (void)setText:(NSString *)text
{
    self.string = text;
    CGSize size = [text sizeWithFont:self.uifont];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width+1, size.height);    
}

- (void)setMultilineText:(NSString *)text
{
    [self setMultilineText:text width:self.width];
}

- (void)setMultilineText:(NSString *)text width:(int)width
{
    self.string = text;
    self.wrapped = TRUE;
    CGSize size = [text sizeWithFont:self.uifont constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, size.height);
}

- (UIFont *)uifont
{
    NSString* fontName = (__bridge NSString*)self.font;
    return [UIFont fontWithName:fontName size:self.fontSize];
}

- (CGSize)textSize
{
    UIFont *font = self.uifont;
    return [self.string sizeWithFont:font constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
}


@end

@implementation CAShapeLayer(TTAdditions)

+ (CAShapeLayer *)create
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.anchorPoint = CGPointMake(0,0);
    return layer;
}

- (void)setStrokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor
{
    if (strokeColor) {
        self.strokeColor = strokeColor.CGColor;
    }
    if (fillColor) {
        self.fillColor = fillColor.CGColor;
    }
}

@end

@implementation CAGradientLayer(TTAdditions)

+ (CAGradientLayer *)createWithColors:(NSArray *)colors locations:(NSArray *)locations
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.colors = colors;
    layer.locations = locations;
    return layer;
}

@end


@implementation UIScreen(TTAdditions)

+ (CGRect)rootRectForOrientation:(UIInterfaceOrientation)orientation
{
    CGRect rect = [[self mainScreen] applicationFrame];
    return CGRectMake(0, 0, rect.size.width, rect.size.height);
}

+ (CGRect)rectForOrientation:(UIInterfaceOrientation)orientation
{
    CGRect rect = [[self mainScreen] applicationFrame];
    if (orientation == UIInterfaceOrientationPortrait) {
        return rect;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGRectMake(0, 0, rect.size.height, rect.size.width);
    } else {
        return CGRectMake(0, 0, rect.size.width, rect.size.height);
    }
}

+ (CGRect)rootRect
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    return [self rootRectForOrientation:orientation];
}

+ (CGRect)rect
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    return [self rectForOrientation:orientation];
}

@end

@implementation UIColor(TTAdditions)

+ (UIColor *)colorWithHex:(int)hex
{
    float red = (hex >> 24 & 0xFF)/255.;
    float green = (hex >> 16 & 0xFF)/255.;
    float blue = (hex >> 8 & 0xFF)/255.;
    float alpha = (hex & 0xFF)/255.;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
