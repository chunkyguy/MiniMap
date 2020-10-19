//
// Created by Sidharth Juyal on 15/09/2020.
// Copyright © 2020 SLE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface SLELayoutItem : NSObject

+ (instancetype)flexItem;
+ (instancetype)itemWithSize:(CGSize)size;
+ (instancetype)itemWithWidth:(CGFloat)width;
+ (instancetype)itemWithHeight:(CGFloat)height;

@property (nonatomic, readonly) CGRect frame;

@end


