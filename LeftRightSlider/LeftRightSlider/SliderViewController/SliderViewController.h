//
//  SliderViewController.h
//  LeftRightSlider
//
//  Created by Zhao Yiqi on 13-11-27.
//  Copyright (c) 2013年 Zhao Yiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderViewControllerLeftDelegate <NSObject>

-(void)sliderViewLeftFinish;
-(void)sliderViewLeftCancel;
-(void)sliderViewLeftWithPer:(float)per;

@end

@protocol SliderViewControllerRightDelegate <NSObject>

-(void)sliderViewRightFinish;
-(void)sliderViewRightCancel;
-(void)sliderViewRightWithPer:(float)per;

@end

@protocol SliderViewControllerMainDelegate <NSObject>

-(void)sliderViewWillDisappear;
-(void)sliderViewWillAppear;

@end

@interface SliderViewController : UIViewController

@property(nonatomic,strong)id<SliderViewControllerLeftDelegate> ldelegate;
@property(nonatomic,strong)id<SliderViewControllerRightDelegate> rdelegate;
@property(nonatomic,strong)id<SliderViewControllerMainDelegate> mdelegate;

@property(nonatomic,strong)UIViewController *LeftVC;
@property(nonatomic,strong)UIViewController *RightVC;
@property(nonatomic,strong)UIViewController *MainVC;

@property(nonatomic,strong)NSMutableDictionary *controllersDict;

@property(nonatomic,assign)float LeftSContentOffset;
@property(nonatomic,assign)float RightSContentOffset;

@property(nonatomic,assign)float LeftSContentScale;
@property(nonatomic,assign)float RightSContentScale;

@property(nonatomic,assign)float LeftSJudgeOffset;
@property(nonatomic,assign)float RightSJudgeOffset;

@property(nonatomic,assign)float LeftSOpenDuration;
@property(nonatomic,assign)float RightSOpenDuration;

@property(nonatomic,assign)float LeftSCloseDuration;
@property(nonatomic,assign)float RightSCloseDuration;

@property(nonatomic,assign)float LeftStartX;
@property(nonatomic,assign)float RightStartX;

@property(nonatomic,assign)BOOL canShowLeft;
@property(nonatomic,assign)BOOL canShowRight;

+ (SliderViewController*)sharedSliderController;

- (void)showContentControllerWithModel:(NSString *)className animated:(BOOL)animated;
- (void)showContentControllerWithModel:(NSString*)className;
- (void)showLeftViewController;
- (void)showRightViewController;

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes;

@end
