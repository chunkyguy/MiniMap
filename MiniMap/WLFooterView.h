#import <UIKit/UIKit.h>

@interface WLFooterView : UIView
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
- (void)updateMiniMapSelectionWithScrollBounds:(CGRect)scrollBounds andZoomScale:(CGFloat)zoomScale;
- (void)updateSnapshotWithScrollBounds:(CGRect)scrollBounds andZoomScale:(CGFloat)zoomScale;
@end
