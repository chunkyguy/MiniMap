#import "ViewController.h"
#import "SLELayout.h"
#import "WLFooterView.h"
#import "WLMath.h"
#import "WLScrollView.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <UIScrollViewDelegate> {
  BOOL _isSetUp;
  WLScrollView *_scrollView;
  WLFooterView *_footerView;
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
  UIImage *image = [UIImage imageNamed:@"bench.jpg"];
  UIEdgeInsets insets = UIEdgeInsetsZero;
  if (@available(iOS 11.0, *)) {
    insets = self.view.safeAreaInsets;
  }
  SLELayout *layout = [SLELayout layoutWithParentBounds:self.view.bounds
                                              direction:SLELayoutDirectionColumn
                                              alignment:SLELayoutAlignmentCenter];
  CGFloat viewWidth = self.view.bounds.size.width;
  CGSize frameSize = CGSizeMake(viewWidth, viewWidth);
  SLELayoutItem *scrollLayoutItem = [SLELayoutItem itemWithSize:frameSize];
  SLELayoutItem *footerLayoutItem = [SLELayoutItem flexItem];
  [layout addItem:[SLELayoutItem itemWithHeight:insets.top]];
  [layout addItem:scrollLayoutItem];
  [layout addItem:footerLayoutItem];
  [layout addItem:[SLELayoutItem itemWithHeight:insets.bottom]];

  _scrollView = [[[WLScrollView alloc] initWithFrame:[scrollLayoutItem frame]
                                               image:image
                                     onContentUpdate:^(WLScrollViewContentUpdate update) {
                                       [self updateFooterWithUpdate:update];
                                     }] autorelease];
  _footerView = [[[WLFooterView alloc] initWithFrame:[footerLayoutItem frame] image:image] autorelease];

  [self.view addSubview:_scrollView];
  [self.view addSubview:_footerView];

  [self updateFooterWithUpdate:WLScrollViewContentUpdateEnd];
}

- (void)updateFooterWithUpdate:(WLScrollViewContentUpdate)update
{
  switch (update) {
  case WLScrollViewContentUpdateBegin:
    [_footerView updateMiniMapSelectionWithScrollBounds:[_scrollView scrollViewBounds] andZoomScale:[_scrollView zoomScale]];
    break;

  case WLScrollViewContentUpdateMoved:
    [_footerView updateMiniMapSelectionWithScrollBounds:[_scrollView scrollViewBounds] andZoomScale:[_scrollView zoomScale]];
    break;

  case WLScrollViewContentUpdateEnd:
    [_footerView updateMiniMapSelectionWithScrollBounds:[_scrollView scrollViewBounds] andZoomScale:[_scrollView zoomScale]];
    [_footerView updateSnapshotWithScrollBounds:[_scrollView scrollViewBounds] andZoomScale:[_scrollView zoomScale]];
    break;
  }
}

@end
