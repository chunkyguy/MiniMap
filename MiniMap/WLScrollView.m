#import "WLScrollView.h"

@interface WLScrollView () <UIScrollViewDelegate> {
  UIScrollView *_scrollVw;
  UIImageView *_contentVw;
  void (^_onContentUpdate)(WLScrollViewContentUpdate);
}
@end

@implementation WLScrollView
- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image
              onContentUpdate:(void (^)(WLScrollViewContentUpdate))onContentUpdate;
{
  self = [super initWithFrame:frame];
  if (self) {
    _onContentUpdate = Block_copy(onContentUpdate);

    _scrollVw = [[[UIScrollView alloc] initWithFrame:[self bounds]] autorelease];
    [self addSubview:_scrollVw];

    _contentVw = [[[UIImageView alloc] initWithImage:image] autorelease];
    [_scrollVw addSubview:_contentVw];

    [_scrollVw setDelegate:self];

    CGSize contentSize = [image size];
    CGSize frameSize = [self bounds].size;
    [_scrollVw setContentSize:contentSize];
    [_scrollVw setMaximumZoomScale:5.f];
    [_scrollVw setMinimumZoomScale:MIN(frameSize.width / contentSize.width, frameSize.height / contentSize.height)];
    [_scrollVw setZoomScale:MAX(frameSize.width / contentSize.width, frameSize.height / contentSize.height)];
  }
  return self;
}

- (void)dealloc
{
  Block_release(_onContentUpdate);
  [super dealloc];
}

- (CGRect)scrollViewBounds
{
  return _scrollVw.bounds;
}

- (CGFloat)zoomScale
{
  return _scrollVw.zoomScale;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return _contentVw;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  _onContentUpdate(WLScrollViewContentUpdateMoved);
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
  _onContentUpdate(WLScrollViewContentUpdateBegin);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
  _onContentUpdate(WLScrollViewContentUpdateEnd);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  _onContentUpdate(WLScrollViewContentUpdateBegin);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  if (!decelerate) {
    _onContentUpdate(WLScrollViewContentUpdateEnd);
  }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
  _onContentUpdate(WLScrollViewContentUpdateBegin);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  _onContentUpdate(WLScrollViewContentUpdateEnd);
}

@end
