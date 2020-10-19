//
// Created by Sidharth Juyal on 19/10/2020.
// Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

#import "WLMinimapView.h"

@interface WLMinimapView () {
  UIView *_borderVw;
}
@end

@implementation WLMinimapView
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
  self = [super initWithFrame:frame];
  if (self) {
    UIImageView *imageVw = [[[UIImageView alloc] initWithFrame:[self bounds]] autorelease];
    [imageVw setContentMode:UIViewContentModeScaleAspectFit];
    [imageVw setImage:image];
    [self addSubview:imageVw];

    _borderVw = [[[UIView alloc] initWithFrame:[self bounds]] autorelease];
    [[_borderVw layer] setBorderWidth:2.f];
    [[_borderVw layer] setBorderColor:[[UIColor yellowColor] CGColor]];

    [self addSubview:_borderVw];
  }
  return self;
}

- (void)setSelectionFrame:(CGRect)frame
{
  [_borderVw setFrame:frame];
}

@end
