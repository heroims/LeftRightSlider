//
//  LRNavigationController.h
//  LeftRightSlider
//
//  Created by Zhao Yiqi on 13-12-9.
//  Copyright (c) 2013年 Zhao Yiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRNavigationController : UINavigationController

@property (nonatomic, assign) BOOL canDragBack;

@property (nonatomic, assign) float startX;

@property (nonatomic, assign) float judgeOffset;

@property (nonatomic, assign) float contentScale;

@property (nonatomic, retain) NSDictionary *unGestureDic;

- (void)popViewControllerWithLRAnimated;

- (void)popToRootViewControllerWithLRAnimated;

- (void)pushViewControllerWithLRAnimated:(UIViewController *)viewController;

@end
