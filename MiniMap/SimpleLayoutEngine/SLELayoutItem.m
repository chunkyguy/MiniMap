//
// Created by Sidharth Juyal on 15/09/2020.
// Copyright © 2020 SLE. All rights reserved.
//

#import "SLELayoutItem.h"
#import "SLELayoutItem+Internal.h"

const CGFloat kSLELayoutValueUndefined = -1.f;

@interface SLELayoutItem () {
  CGRect _originalFrame;
  CGRect _finalFrame;
}
@end

@implementation SLELayoutItem
+ (instancetype)flexItem
{
  return [[[[self class] alloc] initWithSize:CGSizeMake(kSLELayoutValueUndefined, kSLELayoutValueUndefined)] autorelease];
}

+ (instancetype)itemWithWidth:(CGFloat)width;
{
  return [[[[self class] alloc] initWithSize:CGSizeMake(width, kSLELayoutValueUndefined)] autorelease];
}

+ (instancetype)itemWithHeight:(CGFloat)height;
{
  return [[[[self class] alloc] initWithSize:CGSizeMake(kSLELayoutValueUndefined, height)] autorelease];
}

+ (instancetype)itemWithSize:(CGSize)size
{

  return [[[[self class] alloc] initWithSize:size] autorelease];
}

- (instancetype)initWithSize:(CGSize)size
{
  self = [super init];
  if (self) {
    _originalFrame = (CGRect) {
      .origin = { .x = kSLELayoutValueUndefined, .y = kSLELayoutValueUndefined },
      .size = { .width = size.width, size.height }
    };
    _finalFrame = CGRectZero;
  }
  return self;
}

- (void)setOrigin:(CGPoint)origin
{
  _finalFrame.origin = origin;
}

- (void)setSize:(CGSize)size
{
  _finalFrame.size = size;
}

- (CGRect)originalFrame
{
  return _originalFrame;
}

- (CGRect)frame
{
  return _finalFrame;
}

@end
