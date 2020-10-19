#import "WLFooterView.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>

#import "SLELayout.h"
#import "WLMath.h"
#import "WLMinimapView.h"

@interface WLFooterView () {
  UIImageView *_snapshotVw;
  WLMinimapView *_miniMapVw;
  UIImage *_image;

  CGSize _contentSize;
  CGSize _minimapSize;

  dispatch_queue_t _imageQueue;
  BOOL _isCreatingSnapshot;
}
@end

@implementation WLFooterView
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
  self = [super initWithFrame:frame];
  if (self) {
    _image = [image retain];
    _imageQueue = dispatch_queue_create("com.wl.minimap.queue.imagesWrite", DISPATCH_QUEUE_SERIAL);
    _isCreatingSnapshot = NO;

    SLELayout *layout = [SLELayout layoutWithParentBounds:[self bounds] direction:SLELayoutDirectionRow alignment:SLELayoutAlignmentCenter];

    CGRect halfFrame = [self bounds];
    halfFrame.size.width /= 2.f;
    halfFrame.size.width -= 4.f;
    CGSize contentSize = [image size];
    CGSize subviewSize = AVMakeRectWithAspectRatioInsideRect(contentSize, halfFrame).size;

    SLELayoutItem *snapshotItem = [SLELayoutItem itemWithSize:subviewSize];
    SLELayoutItem *minimapItem = [SLELayoutItem itemWithSize:subviewSize];
    [layout addItem:snapshotItem];
    [layout addItem:[SLELayoutItem flexItem]];
    [layout addItem:minimapItem];

    _snapshotVw = [[[UIImageView alloc] initWithFrame:[snapshotItem frame]] autorelease];
    _miniMapVw = [[[WLMinimapView alloc] initWithFrame:[minimapItem frame] image:image] autorelease];
    [self addSubview:_snapshotVw];
    [self addSubview:_miniMapVw];

    _minimapSize = _miniMapVw.bounds.size;
    _contentSize = [image size];

    [_snapshotVw setContentMode:UIViewContentModeScaleAspectFit];
    [_snapshotVw setImage:image];
  }
  return self;
}

- (void)dealloc
{
  dispatch_release(_imageQueue);
  [_image release];
  [super dealloc];
}

- (void)updateMiniMapSelectionWithScrollBounds:(CGRect)scrollBounds andZoomScale:(CGFloat)zoomScale;
{
  CGRect selectionFrame = wl_ScrollViewSelectedFrame(scrollBounds, zoomScale, _contentSize, _minimapSize);
  [_miniMapVw setSelectionFrame:selectionFrame];
}
- (void)updateSnapshotWithScrollBounds:(CGRect)scrollBounds andZoomScale:(CGFloat)zoomScale;
{
  if (_isCreatingSnapshot) {
    return;
  }

  _isCreatingSnapshot = YES;
  CGRect sampleFrame = wl_ScrollViewImageFrame(scrollBounds, zoomScale, _contentSize);
  dispatch_async(_imageQueue, ^{
    CGImageRef sampleImage = CGImageCreateWithImageInRect([_image CGImage], sampleFrame);
    dispatch_async(dispatch_get_main_queue(), ^{
      [_snapshotVw setImage:[UIImage imageWithCGImage:sampleImage]];
      CGImageRelease(sampleImage);
      _isCreatingSnapshot = NO;
    });
  });
}

@end
