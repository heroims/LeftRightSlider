//
//  LRNavigationController.h
//  LeftRightSlider
//
//  Created by Zhao Yiqi on 13-12-9.
//  Copyright (c) 2013年 Zhao Yiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define startX -200;

@interface LRNavigationController : UINavigationController
{
    CGFloat startBackViewX;
}

@property (nonatomic, assign) BOOL canDragBack;

@end
