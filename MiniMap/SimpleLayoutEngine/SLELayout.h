//
// Created by Sidharth Juyal on 15/09/2020.
// Copyright © 2020 SLE. All rights reserved.
//

#import "SLELayoutItem.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SLELayoutDirection) {
  SLELayoutDirectionRow,
  SLELayoutDirectionColumn
};

typedef NS_ENUM(NSUInteger, SLELayoutAlignment) {
  SLELayoutAlignmentLeading,
  SLELayoutAlignmentCenter,
  SLELayoutAlignmentTrailing
};

@interface SLELayout : NSObject
+ (instancetype)layoutWithParentBounds:(CGRect)bounds
                             direction:(SLELayoutDirection)direction
                             alignment:(SLELayoutAlignment)alignment;

- (void)addItem:(SLELayoutItem *)item;
- (CGRect)frameAtIndex:(NSInteger)index;
@end


