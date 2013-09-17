#import "TTMoviePlayerUtil.h"

float TTMoviePlayerCenterY(UIView *view, float top, float bottom) {
    return round(top + 0.5*((bottom-top) - view.frame.size.height));
}

float TTMoviePlayerCenterX(UIView *view, float left, float right) {
    return round(left + 0.5*((right-left) - view.frame.size.width));
}

void TTMoviePlayerCenter(UIView *view, CGRect rect) {
    view.frame = CGRectMake(round(rect.origin.x + 0.5*(rect.size.width-view.frame.size.width)), round(rect.origin.y + 0.5*(rect.size.height-view.frame.size.height)), view.frame.size.width, view.frame.size.height);
}

int TTMoviePlayerGetIndex(UIView *view)
{
    if (view.superview) {
        int count = view.superview.subviews.count;
        for (int i=0; i<count; i++) {
            if (view == [view.superview.subviews objectAtIndex:i]) {
                return i;
            }
        }
    }
    return -1;
}

CALayer * TTMoviePlayerAddLayer(CALayer *parent)
{
    CALayer *layer = [CALayer layer];
    layer.anchorPoint = CGPointMake(0, 0);
    layer.contentsScale = [[UIScreen mainScreen] scale];
    [parent addSublayer:layer];
    return layer;
}

CATextLayer * TTMoviePlayerAddText(CALayer *parent)
{
    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.alignmentMode = kCAAlignmentLeft;
    layer.anchorPoint = CGPointMake(0, 0);
    [parent addSublayer:layer];
    return layer;
}

CAShapeLayer * TTMoviePlayerAddShape(CALayer *parent)
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.anchorPoint = CGPointMake(0,0);
    [parent addSublayer:layer];
    return layer;
}

void TTMoviePlayerSetImageNamed(CALayer *layer, NSString *name)
{
    UIImage *image = [UIImage imageNamed:name];
    layer.contents = (id)image.CGImage;
    layer.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y, image.size.width, image.size.height);
}

void TTMoviePlayerSetImageNamedWithInsets(CALayer *layer, NSString *name, UIEdgeInsets insets)
{
    UIImage *image = [UIImage imageNamed:name];
    layer.contents = (id)image.CGImage;
    layer.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y, image.size.width, image.size.height);
    
    float width = image.size.width;
    float height = image.size.height;
    layer.contentsCenter = CGRectMake(insets.left/width, insets.top/height, (width-insets.left-insets.right)/width, (height-insets.top-insets.bottom)/height);
}


UIColor * TTMoviePlayerColorWithHex(int hex)
{
    float red = (hex >> 24 & 0xFF)/255.;
    float green = (hex >> 16 & 0xFF)/255.;
    float blue = (hex >> 8 & 0xFF)/255.;
    float alpha = (hex & 0xFF)/255.;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

UIImage * TTMoviePlayerImageWithColor(CGSize size, int hex, UIEdgeInsets insets)
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, TTMoviePlayerColorWithHex(hex).CGColor);
    CGContextFillRect(context, CGRectMake(insets.left, insets.top, size.width-insets.left-insets.right, size.height-insets.top-insets.bottom));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

float TTMoviePlayerInterpolateLinear(float targetX, float x1, float y1, float x2, float y2)
{
    /// a*x + b = y
    float a = (y2-y1)/(x2-x1);
    float b = y1 - a*x1;
    return a*targetX + b;
}

float TTMoviePlayerMaxHeight(UIView *firstView, ...)
{
    float height = 0;
    va_list args;
    va_start(args, firstView);
    for (UIView *view = firstView; view != nil; view = va_arg(args, UIView*)) {
        if (view.frame.size.height > height) {
            height = view.frame.size.height;
        }
    }
    va_end(args);
    return height;
}

float TTMoviePlayerMaxWidth(UIView *firstView, ...)
{
    float width = 0;
    va_list args;
    va_start(args, firstView);
    for (UIView *view = firstView; view != nil; view = va_arg(args, UIView*)) {
        if (view.frame.size.width > width) {
            width = view.frame.size.width;
        }
    }
    va_end(args);
    return width;
}


