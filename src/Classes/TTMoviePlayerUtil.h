#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


float TTMoviePlayerCenterY(UIView *view, float top, float bottom);
float TTMoviePlayerCenterX(UIView *view, float left, float right);
void TTMoviePlayerCenter(UIView *view, CGRect rect);
int TTMoviePlayerGetIndex(UIView *view);
CALayer * TTMoviePlayerAddLayer(CALayer *parent);
CATextLayer * TTMoviePlayerAddText(CALayer *parent);
CAShapeLayer * TTMoviePlayerAddShape(CALayer *parent);
void TTMoviePlayerSetImageNamed(CALayer *layer, NSString *name);
void TTMoviePlayerSetImageNamedWithInsets(CALayer *layer, NSString *name, UIEdgeInsets insets);
UIColor * TTMoviePlayerColorWithHex(int hex);
UIImage * TTMoviePlayerImageWithColor(CGSize size, int hex, UIEdgeInsets insets);
float TTMoviePlayerInterpolateLinear(float targetX, float x1, float y1, float x2, float y2);
float TTMoviePlayerMaxWidth(UIView *firstView, ...);
float TTMoviePlayerMaxHeight(UIView *firstView, ...);