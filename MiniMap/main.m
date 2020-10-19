#import "AppDelegate.h"
#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
  int retVal = 0;
#if __has_feature(objc_arc)
  NSString *appDelegateClassName;
  @autoreleasepool {
    appDelegateClassName = NSStringFromClass([AppDelegate class]);
  }
  retVal = UIApplicationMain(argc, argv, nil, appDelegateClassName);
#else
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  [pool release];
#endif
  return retVal;
}
