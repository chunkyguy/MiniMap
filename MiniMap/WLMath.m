#import "WLMath.h"

const CGFloat kDownsizeRatio = 1.0f;

CGRect wl_ScrollViewSelectedFrame(CGRect scrollBounds, CGFloat zoomScale, CGSize contentSize, CGSize minimapSize)
{
  CGRect selectedFrame = scrollBounds;

  CGFloat ratio = contentSize.height / minimapSize.height;
  selectedFrame.origin.x /= ratio;
  selectedFrame.origin.y /= ratio;
  selectedFrame.size.width /= ratio;
  selectedFrame.size.height /= ratio;

  selectedFrame.origin.x /= zoomScale;
  selectedFrame.origin.y /= zoomScale;
  selectedFrame.size.width /= zoomScale;
  selectedFrame.size.height /= zoomScale;

  // downsize
  selectedFrame.origin.x /= kDownsizeRatio;
  selectedFrame.origin.y /= kDownsizeRatio;
  selectedFrame.size.width /= kDownsizeRatio;
  selectedFrame.size.height /= kDownsizeRatio;

  // calc focus frame
  if (selectedFrame.origin.x < 0) {
    selectedFrame.size.width += selectedFrame.origin.x;
    selectedFrame.origin.x = 0;
  }
  if (selectedFrame.origin.y < 0) {
    selectedFrame.size.height += selectedFrame.origin.y;
    selectedFrame.origin.y = 0;
  }

  CGSize thumbDownsizeSize = CGSizeMake(minimapSize.width / kDownsizeRatio, minimapSize.height / kDownsizeRatio);

  if (thumbDownsizeSize.height < selectedFrame.size.height) {
    selectedFrame.size.height = thumbDownsizeSize.height;
  }
  if ((selectedFrame.origin.y + selectedFrame.size.height) > thumbDownsizeSize.height) {
    selectedFrame.size.height = thumbDownsizeSize.height - selectedFrame.origin.y;
  }

  if (thumbDownsizeSize.width < selectedFrame.size.width) {
    selectedFrame.size.width = thumbDownsizeSize.width;
  }
  if ((selectedFrame.origin.x + selectedFrame.size.width) > thumbDownsizeSize.width) {
    selectedFrame.size.width = thumbDownsizeSize.width - selectedFrame.origin.x;
  }

  return selectedFrame;
}
