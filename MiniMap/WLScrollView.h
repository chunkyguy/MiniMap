#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WLScrollViewContentUpdate) {
  WLScrollViewContentUpdateBegin,
  WLScrollViewContentUpdateMoved,
  WLScrollViewContentUpdateEnd,
};

@interface WLScrollView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image
              onContentUpdate:(void (^)(WLScrollViewContentUpdate))onContentUpdate;

- (CGRect)scrollViewBounds;
- (CGFloat)zoomScale;
@end
