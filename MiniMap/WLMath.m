#import "WLMath.h"
#import <simd/simd.h>

CGRect wl_CGRectScale(CGRect frame, CGFloat factor)
{
  return (CGRect) {
    .origin = { .x = frame.origin.x * factor, .y = frame.origin.y * factor },
    .size = { .width = frame.size.width * factor, .height = frame.size.height * factor }
  };
}

CGRect wl_CGRectClipped(CGRect frame, CGSize targetSize)
{
  // clip origin
  if (frame.origin.x < 0) {
    frame.size.width += frame.origin.x;
    frame.origin.x = 0;
  }
  if (frame.origin.y < 0) {
    frame.size.height += frame.origin.y;
    frame.origin.y = 0;
  }

  //clip size
  if (frame.size.width > targetSize.width) {
    frame.size.width = targetSize.width;
  }
  if (CGRectGetMaxX(frame) > targetSize.width) {
    frame.size.width = targetSize.width - frame.origin.x;
  }

  if (frame.size.height > targetSize.height) {
    frame.size.height = targetSize.height;
  }
  if (CGRectGetMaxY(frame) > targetSize.height) {
    frame.size.height = targetSize.height - frame.origin.y;
  }

  return frame;
}

CGRect wl_ScrollViewSelectedFrame(CGRect scrollBounds, CGFloat zoomScale, CGSize contentSize, CGSize targetSize)
{
  CGFloat inverseZoom = 1.f / zoomScale;
  CGFloat ratio = targetSize.height / contentSize.height;
  CGRect selectionFrame = wl_CGRectScale(scrollBounds, ratio * inverseZoom);
  return wl_CGRectClipped(selectionFrame, targetSize);
}

CGRect wl_ScrollViewImageFrame(CGRect scrollBounds, CGFloat zoomScale, CGSize contentSize)
{
  CGFloat inverseZoom = 1.f / zoomScale;
  CGRect selectionFrame = wl_CGRectScale(scrollBounds, inverseZoom);
  return wl_CGRectClipped(selectionFrame, contentSize);
}
