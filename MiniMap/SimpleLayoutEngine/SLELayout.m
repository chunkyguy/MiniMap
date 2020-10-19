//
// Created by Sidharth Juyal on 15/09/2020.
// Copyright © 2020 SLE. All rights reserved.
//

#import "SLELayout.h"
#import "SLELayoutItem+Internal.h"

#define kSLEAssignIfUndefined(lhs, rhs) lhs = (lhs == kSLELayoutValueUndefined) ? rhs : lhs

@interface SLELayout () {
  CGSize _parentSize;
  NSMutableArray *_items;
  SLELayoutDirection _direction;
  SLELayoutAlignment _alignment;
}
@end

@implementation SLELayout
+ (instancetype)layoutWithParentBounds:(CGRect)bounds
                             direction:(SLELayoutDirection)direction
                             alignment:(SLELayoutAlignment)alignment;
{
  return [[[[self class] alloc] initWithParentBounds:bounds direction:direction alignment:alignment]autorelease];
}

- (instancetype)initWithParentBounds:(CGRect)bounds
                           direction:(SLELayoutDirection)direction
                           alignment:(SLELayoutAlignment)alignment
{
  self = [super init];
  if (self) {
    _parentSize = bounds.size;
    _direction = direction;
    _alignment = alignment;
    _items = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [_items release];
  [super dealloc];
}

- (void)updateSizeForItem:(SLELayoutItem *)item itemSpace:(CGFloat)itemSpace
{
  CGSize itemSize = item.originalFrame.size;
  switch (_direction) {
  case SLELayoutDirectionColumn:
    kSLEAssignIfUndefined(itemSize.width, _parentSize.width);
    kSLEAssignIfUndefined(itemSize.height, itemSpace);
    break;
  case SLELayoutDirectionRow:
    kSLEAssignIfUndefined(itemSize.width, itemSpace);
    kSLEAssignIfUndefined(itemSize.height, _parentSize.height);
    break;
  }
  [item setSize:itemSize];
}

- (CGPoint)updateOriginForItem:(SLELayoutItem *)item lastItemOrigin:(CGPoint)itemOrigin
{
  CGSize itemSize = [item frame].size;
  switch (_alignment) {
  case SLELayoutAlignmentLeading:
    break;
  case SLELayoutAlignmentCenter:
    switch (_direction) {
    case SLELayoutDirectionColumn:
      itemOrigin.x = (_parentSize.width - itemSize.width) / 2.f;
      break;
    case SLELayoutDirectionRow:
      itemOrigin.y = (_parentSize.height - itemSize.height) / 2.f;
      break;
    }
    break;
  case SLELayoutAlignmentTrailing:
    switch (_direction) {
    case SLELayoutDirectionColumn:
      itemOrigin.x = (_parentSize.width - itemSize.width);
      break;
    case SLELayoutDirectionRow:
      itemOrigin.y = (_parentSize.height - itemSize.height);
      break;
    }
    break;
  }

  [item setOrigin:itemOrigin];

  switch (_direction) {
  case SLELayoutDirectionColumn:
    itemOrigin.y += itemSize.height;
    break;
  case SLELayoutDirectionRow:
    itemOrigin.x += itemSize.width;
    break;
  }

  return itemOrigin;
}

- (void)updateFrames
{
  // calculate flex space
  CGFloat usedSpace = 0;
  NSInteger flexItems = 0;
  for (SLELayoutItem *item in _items) {
    CGRect itemFrame = item.originalFrame;
    CGFloat itemSpace = (_direction == SLELayoutDirectionColumn) ? itemFrame.size.height : itemFrame.size.width;
    if (itemSpace == kSLELayoutValueUndefined) {
      flexItems += 1;
    } else {
      usedSpace += itemSpace;
    }
  }

  // update item frame
  CGFloat maxFlexSpace = _direction == SLELayoutDirectionColumn ? _parentSize.height : _parentSize.width;
  CGFloat itemSpace = (maxFlexSpace - usedSpace) / (CGFloat)flexItems;
  CGPoint itemOrigin = CGPointZero;
  for (SLELayoutItem *item in _items) {
    [self updateSizeForItem:item itemSpace:itemSpace];
    itemOrigin = [self updateOriginForItem:item lastItemOrigin:itemOrigin];
  }
}

- (void)addItem:(SLELayoutItem *)item
{
  [_items addObject:item];
  [self updateFrames];
}

- (CGRect)frameAtIndex:(NSInteger)index;
{
  return [[_items objectAtIndex:index] frame];
}
@end
