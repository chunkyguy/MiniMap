#import "WLMath.h"

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

  // calc focus frame
  if (selectedFrame.origin.x < 0) {
    selectedFrame.size.width += selectedFrame.origin.x;
    selectedFrame.origin.x = 0;
  }
  if (selectedFrame.origin.y < 0) {
    selectedFrame.size.height += selectedFrame.origin.y;
    selectedFrame.origin.y = 0;
  }

  if (minimapSize.height < selectedFrame.size.height) {
    selectedFrame.size.height = minimapSize.height;
  }
  if ((selectedFrame.origin.y + selectedFrame.size.height) > minimapSize.height) {
    selectedFrame.size.height = minimapSize.height - selectedFrame.origin.y;
  }

  if (minimapSize.width < selectedFrame.size.width) {
    selectedFrame.size.width = minimapSize.width;
  }
  if ((selectedFrame.origin.x + selectedFrame.size.width) > minimapSize.width) {
    selectedFrame.size.width = minimapSize.width - selectedFrame.origin.x;
  }

  return selectedFrame;
}
