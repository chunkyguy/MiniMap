#import "ViewController.h"
#import "SLELayout.h"
#import "WLMath.h"
#import "WLMinimapView.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <UIScrollViewDelegate> {
  BOOL _isSetUp;
  UIScrollView *_scrollVw;
  UIImageView *_contentVw;
  WLMinimapView *_miniMapVw;
  CGSize _contentSize;
  CGSize _frameSize;
  CGSize _minimapSize;
}
@end

@implementation ViewController

- (void)awakeFromNib
{
  [super awakeFromNib];
  _isSetUp = NO;
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  if (!_isSetUp) {
    [self setUp];
    _isSetUp = YES;
  }
}

- (void)setUp
{
  UIImage *fullImage = [UIImage imageNamed:@"bench.jpg"];
  //  UIImage *thumbImage = [UIImage imageNamed:@"smallBench.jpg"];

  _contentSize = [fullImage size];

  UIEdgeInsets insets = UIEdgeInsetsZero;
  if (@available(iOS 11.0, *)) {
    insets = self.view.safeAreaInsets;
  }
  SLELayout *layout = [SLELayout layoutWithParentBounds:self.view.bounds
                                              direction:SLELayoutDirectionColumn
                                              alignment:SLELayoutAlignmentCenter];
  CGFloat viewWidth = self.view.bounds.size.width;
  _frameSize = CGSizeMake(viewWidth, viewWidth);
  SLELayoutItem *scrollVwLayoutItem = [SLELayoutItem itemWithSize:_frameSize];
  SLELayoutItem *fillerLayoutItem = [SLELayoutItem flexItem];
  [layout addItem:[SLELayoutItem itemWithHeight:insets.top]];
  [layout addItem:scrollVwLayoutItem];
  [layout addItem:fillerLayoutItem];
  [layout addItem:[SLELayoutItem itemWithHeight:insets.bottom]];

  SLELayout *fillerLayout = [SLELayout layoutWithParentBounds:[fillerLayoutItem frame]
                                                    direction:SLELayoutDirectionRow
                                                    alignment:SLELayoutAlignmentLeading];
  CGRect minimapBound = AVMakeRectWithAspectRatioInsideRect(_contentSize, [fillerLayoutItem frame]);
  SLELayoutItem *minimapLayoutItem = [SLELayoutItem itemWithSize:minimapBound.size];
  [fillerLayout addItem:[SLELayoutItem flexItem]];
  [fillerLayout addItem:minimapLayoutItem];
  [fillerLayout addItem:[SLELayoutItem flexItem]];

  _scrollVw = [[[UIScrollView alloc] initWithFrame:[scrollVwLayoutItem frame]] autorelease];
  _contentVw = [[[UIImageView alloc] initWithImage:fullImage] autorelease];
  [_scrollVw addSubview:_contentVw];
  [self.view addSubview:_scrollVw];

  CGRect minimapFrame = [minimapLayoutItem frame];
  minimapFrame.origin.y = [fillerLayoutItem frame].origin.y;
  _minimapSize = minimapFrame.size;
  _miniMapVw = [[[WLMinimapView alloc] initWithFrame:minimapFrame image:fullImage] autorelease];
  [self.view addSubview:_miniMapVw];

  [_scrollVw setDelegate:self];

  // set zooming
  [_scrollVw setContentSize:_contentSize];
  [_scrollVw setMaximumZoomScale:5.f];
  [_scrollVw setMinimumZoomScale:MIN(_frameSize.width / _contentSize.width, _frameSize.height / _contentSize.height)];
  [_scrollVw setZoomScale:MAX(_frameSize.width / _contentSize.width, _frameSize.height / _contentSize.height)];

  [self addjustMiniMapSelection];
}

- (void)addjustMiniMapSelection
{
  [_miniMapVw setSelectionFrame:wl_ScrollViewSelectedFrame(_scrollVw.bounds, _scrollVw.zoomScale, _contentSize, _minimapSize)];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return _contentVw;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self addjustMiniMapSelection];
}

@end
