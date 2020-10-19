#import <UIKit/UIKit.h>

@interface WLMinimapView : UIView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
- (void)setSelectionFrame:(CGRect)frame;
@end
