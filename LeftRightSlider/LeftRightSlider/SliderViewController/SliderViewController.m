//
//  SliderViewController.m
//  LeftRightSlider
//
//  Created by heroims on 13-11-27.
//  Copyright (c) 2013年 heroims. All rights reserved.
//

#import "SliderViewController.h"
#import <sys/utsname.h>

typedef NS_ENUM(NSInteger, RMoveDirection) {
    RMoveDirectionLeft = 0,
    RMoveDirectionRight
};

@interface SliderViewController ()<UIGestureRecognizerDelegate>{
    UIView *_mainContentView;
    UIView *_leftSideView;
    UIView *_rightSideView;
    
    NSMutableDictionary *_controllersDict;
    
    UITapGestureRecognizer *_tapGestureRec;
    UIPanGestureRecognizer *_panGestureRec;
    
}

@end

@implementation SliderViewController

-(void)dealloc{
#if __has_feature(objc_arc)
    _mainContentView = nil;
    _leftSideView = nil;
    _rightSideView = nil;
    
    _controllersDict = nil;
    
    _tapGestureRec = nil;
    _panGestureRec = nil;
    
    _LeftVC = nil;
    _RightVC = nil;
    _MainVC = nil;
#else
    [_mainContentView release];
    [_leftSideView release];
    [_rightSideView release];
    
    [_controllersDict release];
    
    [_tapGestureRec release];
    [_panGestureRec release];
    
    [_LeftVC release];
    [_RightVC release];
    [_MainVC release];
    [super dealloc];
#endif

}

+ (SliderViewController*)sharedSliderController
{
    static SliderViewController *sharedSVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSVC = [[self alloc] init];
    });
    
    return sharedSVC;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super initWithCoder:decoder])) {
        _LeftSContentOffset=160;
        _RightSContentOffset=160;
        _LeftSContentScale=0.85;
        _RightSContentScale=0.85;
        _LeftSJudgeOffset=100;
        _RightSJudgeOffset=100;
        _LeftSOpenDuration=0.4;
        _RightSOpenDuration=0.4;
        _LeftSCloseDuration=0.3;
        _RightSCloseDuration=0.3;
        _LeftStartX=0;
        _RightStartX=0;
        _canShowLeft=YES;
        _canShowRight=YES;
        _shadowOffsetWidth=2.0;
        _shadowOffsetHeight=1.0;
        _shadowOpacity=0.8;
        _shadowColor=[UIColor blackColor];
	}
	return self;
}

- (id)init{
    if (self = [super init]){
        _LeftSContentOffset=160;
        _RightSContentOffset=160;
        _LeftSContentScale=0.85;
        _RightSContentScale=0.85;
        _LeftSJudgeOffset=100;
        _RightSJudgeOffset=100;
        _LeftSOpenDuration=0.4;
        _RightSOpenDuration=0.4;
        _LeftSCloseDuration=0.3;
        _RightSCloseDuration=0.3;
        _LeftStartX=0;
        _RightStartX=0;
        _canShowLeft=YES;
        _canShowRight=YES;
        _shadowOffsetWidth=2.0;
        _shadowOffsetHeight=1.0;
        _shadowOpacity=0.8;
        _shadowColor=[UIColor blackColor];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;

    _controllersDict = [[NSMutableDictionary alloc] init];
    
    [self initSubviews];

    [self initChildControllers:_LeftVC rightVC:_RightVC];
    
    [self showContentControllerWithModel:_MainVC!=nil?NSStringFromClass([_MainVC class]):@"MainViewController"];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED<=__IPHONE_7
    if((self.wantsFullScreenLayout=_MainVC.wantsFullScreenLayout)){
        _rightSideView.frame=[UIScreen mainScreen].bounds;
        _leftSideView.frame=[UIScreen mainScreen].bounds;
        _mainContentView.frame=[UIScreen mainScreen].bounds;
    }
#else
#endif

    _tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToClose)];
    _tapGestureRec.delegate=self;
    [self.view addGestureRecognizer:_tapGestureRec];
    _tapGestureRec.enabled = NO;
    
    _panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [self.view addGestureRecognizer:_panGestureRec];
    
}

#pragma mark - Init

- (void)initSubviews
{
    _mainContentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mainContentView];

    _rightSideView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:_rightSideView];
    
    _leftSideView = [[UIView alloc] initWithFrame:CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:_leftSideView];
}

- (void)initChildControllers:(UIViewController*)leftVC rightVC:(UIViewController*)rightVC
{
    if (_canShowRight&&rightVC!=nil) {
        [self addChildViewController:rightVC];
        rightVC.view.frame=CGRectMake(0, 0, rightVC.view.frame.size.width, rightVC.view.frame.size.height);
        [_rightSideView addSubview:rightVC.view];
    }
    if (_canShowLeft&&leftVC!=nil) {
        [self addChildViewController:leftVC];
        leftVC.view.frame=CGRectMake(0, 0, leftVC.view.frame.size.width, leftVC.view.frame.size.height);
        [_leftSideView addSubview:leftVC.view];
    }
}

#pragma mark - Actions

- (void)showContentControllerWithModel:(NSString *)className animated:(BOOL)animated
{
    [self closeSideBar:animated];
    
    UIViewController *controller = _controllersDict[className];
    if (!controller)
    {
        Class c = NSClassFromString(className);
        
#if __has_feature(objc_arc)
        controller = [[c alloc] init];
#else
        controller = [[[c alloc] init] autorelease];
#endif
        [_controllersDict setObject:controller forKey:className];
    }
    
    if (_mainContentView.subviews.count > 0)
    {
        UIView *view = [_mainContentView.subviews firstObject];
        [view removeFromSuperview];
    }
    
    controller.view.frame = _mainContentView.frame;
    [_mainContentView addSubview:controller.view];
    if (_showingLeft) {
        [_LeftVC viewDidDisappear:YES];
    }
    if (_showingRight) {
        [_RightVC viewDidDisappear:YES];
    }
    self.MainVC=controller;
    if (![_MainVC isKindOfClass:[controller class]]) {
        [_MainVC viewDidAppear:YES];
    }
}

- (void)showContentControllerWithModel:(NSString *)className
{
    [self closeSideBar:YES];
    
    UIViewController *controller = _controllersDict[className];
    if (!controller)
    {
        Class c = NSClassFromString(className);
        
#if __has_feature(objc_arc)
        controller = [[c alloc] init];
#else
        controller = [[[c alloc] init] autorelease];
#endif
        [_controllersDict setObject:controller forKey:className];
    }
    
    if (_mainContentView.subviews.count > 0)
    {
        UIView *view = [_mainContentView.subviews firstObject];
        [view removeFromSuperview];
    }
    
    controller.view.frame = _mainContentView.frame;
    [_mainContentView addSubview:controller.view];
    if (_showingLeft) {
        [_LeftVC viewDidDisappear:YES];
    }
    if (_showingRight) {
        [_RightVC viewDidDisappear:YES];
    }
    self.MainVC=controller;
    if (![_MainVC isKindOfClass:[controller class]]) {
        [_MainVC viewDidAppear:YES];
    }
}

- (void)showLeftViewController
{
    _mainContentView.userInteractionEnabled=NO;

    if (_showingLeft) {
        [self closeSideBar:YES];
        _mainContentView.userInteractionEnabled=YES;

        return;
    }
    if (!_canShowLeft||_LeftVC==nil) {
        _mainContentView.userInteractionEnabled=YES;

        return;
    }
    
    [self.view bringSubviewToFront:_leftSideView];
    [_LeftVC viewWillAppear:YES];
    [_MainVC viewWillDisappear:YES];
    
    [UIView animateWithDuration:_LeftSOpenDuration
                     animations:^{
                         _leftSideView.frame=CGRectMake(0, 0, _leftSideView.frame.size.width, _leftSideView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         _tapGestureRec.enabled = YES;
                         _showingLeft=YES;
                         _mainContentView.userInteractionEnabled=YES;
                         [_LeftVC viewDidAppear:YES];
                         [_MainVC viewDidDisappear:YES];
                     }];
    if (_ldelegate!=nil&&[_ldelegate respondsToSelector:@selector(sliderViewLeftFinish)]) {
        [_ldelegate sliderViewLeftFinish];
    }
}

- (void)showRightViewController
{
    _mainContentView.userInteractionEnabled=NO;

    if (_showingRight) {
        [self closeSideBar:YES];
        _mainContentView.userInteractionEnabled=YES;

        return;
    }
    if (!_canShowRight||_RightVC==nil) {
        _mainContentView.userInteractionEnabled=YES;
        return;
    }
    
    [self.view bringSubviewToFront:_rightSideView];
    [_RightVC viewWillAppear:YES];
    [_MainVC viewWillDisappear:YES];

    [UIView animateWithDuration:_RightSOpenDuration
                     animations:^{
                         _rightSideView.frame=CGRectMake(0, 0, _rightSideView.frame.size.width, _rightSideView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         _tapGestureRec.enabled = YES;
                         _showingRight=YES;
                         _mainContentView.userInteractionEnabled=YES;
                         [_RightVC viewDidAppear:YES];
                         [_MainVC viewDidDisappear:YES];
                     }];
    
    if (_rdelegate!=nil&&[_rdelegate respondsToSelector:@selector(sliderViewRightFinish)]) {
        [_rdelegate sliderViewRightFinish];
    }
}

- (void)closeSideBar:(BOOL)animated
{
    if (_showingLeft) {
        [_LeftVC viewWillDisappear:YES];
    }
    if (_showingRight) {
        [_RightVC viewWillDisappear:YES];
    }
    [_MainVC viewWillAppear:YES];

    if (animated) {
        [UIView animateWithDuration:_mainContentView.transform.tx==_LeftSContentOffset?_LeftSCloseDuration:_RightSCloseDuration
                         animations:^{
                             _leftSideView.frame=CGRectMake(-_leftSideView.frame.size.width, 0, _leftSideView.frame.size.width, _leftSideView.frame.size.height);
                             _rightSideView.frame=CGRectMake(_rightSideView.frame.size.width, 0, _leftSideView.frame.size.width, _leftSideView.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (_showingLeft) {
                                 [_LeftVC viewDidDisappear:YES];
                             }
                             if (_showingRight) {
                                 [_RightVC viewDidDisappear:YES];
                             }
                             [_MainVC viewDidAppear:YES];

                             _tapGestureRec.enabled = NO;
                             _showingRight=NO;
                             _showingLeft=NO;

                         }];
    }
    else{
        if (_showingLeft) {
            [_LeftVC viewDidDisappear:YES];
        }
        if (_showingRight) {
            [_RightVC viewDidDisappear:YES];
        }
        [_MainVC viewDidAppear:YES];

        _leftSideView.frame=CGRectMake(-_leftSideView.frame.size.width, 0, _leftSideView.frame.size.width, _leftSideView.frame.size.height);
        _rightSideView.frame=CGRectMake(_rightSideView.frame.size.width, 0, _leftSideView.frame.size.width, _leftSideView.frame.size.height);
        _tapGestureRec.enabled = NO;
        _showingRight=NO;
        _showingLeft=NO;
    }
    if (_ldelegate!=nil&&[_ldelegate respondsToSelector:@selector(sliderViewLeftCancel)]) {
        [_ldelegate sliderViewLeftCancel];
    }
    if (_rdelegate!=nil&&[_rdelegate respondsToSelector:@selector(sliderViewRightCancel)]) {
        [_rdelegate sliderViewRightCancel];
    }

}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes
{
    static CGFloat currentTranslateX;

    static CGFloat currentOriginLX;
    static CGFloat currentOriginRX;

    if (panGes.state == UIGestureRecognizerStateBegan)
    {
        currentOriginLX=_leftSideView.frame.origin.x;
        currentOriginRX=_rightSideView.frame.origin.x;
        
        currentTranslateX = self.view.transform.tx;
    }
    if (panGes.state == UIGestureRecognizerStateChanged)
    {
        CGFloat transX = [panGes translationInView:self.view].x;
        transX = transX + currentTranslateX;
        
        if (transX > 0)
        {
            [self.view bringSubviewToFront:_leftSideView];
            if (_rightSideView.frame.origin.x>=_rightSideView.frame.size.width) {
                if (!_canShowLeft||_LeftVC==nil||_leftSideView.frame.origin.x>=0||_showingLeft) {
                    return;
                }

                _leftSideView.frame=CGRectMake(-_leftSideView.frame.size.width+transX, 0, _leftSideView.frame.size.width, _leftSideView.frame.size.height);
                if (_ldelegate!=nil&&[_ldelegate respondsToSelector:@selector(sliderViewLeftWithPer:)]) {
                    [_ldelegate sliderViewLeftWithPer:transX/_leftSideView.frame.size.width];
                }
            }
            else{
                if (currentOriginRX>=0) {
                    return;
                }
                _rightSideView.frame=CGRectMake(transX, 0, _rightSideView.frame.size.width, _rightSideView.frame.size.height);
            }

        }
        else    //transX < 0
        {

            [self.view bringSubviewToFront:_rightSideView];
            if (_leftSideView.frame.origin.x<=-_leftSideView.frame.size.width) {
                if (!_canShowRight||_RightVC==nil||_rightSideView.frame.origin.x<=0||_showingRight) {
                    return;
                }

                _rightSideView.frame=CGRectMake(_rightSideView.frame.size.width+transX, 0, _rightSideView.frame.size.width, _rightSideView.frame.size.height);
                if (_rdelegate!=nil&&[_rdelegate respondsToSelector:@selector(sliderViewRightWithPer:)]) {
                    [_rdelegate sliderViewRightWithPer:-transX/_rightSideView.frame.size.width];
                }
            }
            else{
                if (currentOriginLX<=-[UIScreen mainScreen].bounds.size.width) {
                    return;
                }
                _leftSideView.frame=CGRectMake(transX, 0, _leftSideView.frame.size.width, _leftSideView.frame.size.height);
            }
        }
    }
    else if (panGes.state == UIGestureRecognizerStateEnded)
    {
        currentOriginLX=0;
        currentOriginRX=0;

        if (_leftSideView.frame.origin.x >(-_leftSideView.frame.size.width+_LeftSJudgeOffset)&&_rightSideView.frame.origin.x>=_rightSideView.frame.size.width)
        {
            if (!_canShowLeft||_LeftVC==nil) {
                return;
            }

            [_MainVC viewDidDisappear:YES];
            [_LeftVC viewWillAppear:YES];
            
            [UIView beginAnimations:nil context:nil];
            _leftSideView.frame=CGRectMake(0, 0, _leftSideView.frame.size.width, _leftSideView.frame.size.height);
            [UIView commitAnimations];
            
            [_LeftVC viewDidAppear:YES];

            if (_ldelegate!=nil&&[_ldelegate respondsToSelector:@selector(sliderViewLeftFinish)]) {
                [_ldelegate sliderViewLeftFinish];
            }

            _showingLeft=YES;
            _tapGestureRec.enabled = YES;
            return;
        }
        if (_rightSideView.frame.origin.y < (_rightSideView.frame.size.width-_RightSJudgeOffset)&&_leftSideView.frame.origin.x<=-_leftSideView.frame.size.width)
        {
            if (!_canShowRight||_RightVC==nil) {
                return;
            }
            [_MainVC viewDidDisappear:YES];
            [_RightVC viewWillAppear:YES];
            
            [UIView beginAnimations:nil context:nil];
            _rightSideView.frame=CGRectMake(0, 0, _rightSideView.frame.size.width, _rightSideView.frame.size.height);
            [UIView commitAnimations];

            [_RightVC viewDidAppear:YES];

            if (_rdelegate!=nil&&[_rdelegate respondsToSelector:@selector(sliderViewRightFinish)]) {
                [_rdelegate sliderViewRightFinish];
            }

            _showingRight=YES;
            _tapGestureRec.enabled = YES;
            return;
        }
        else
        {
            if (_showingLeft) {
                [_LeftVC viewDidDisappear:YES];
            }
            if (_showingRight) {
                [_RightVC viewDidDisappear:YES];
            }
            [_MainVC viewWillAppear:YES];

            [UIView beginAnimations:nil context:nil];
            _leftSideView.frame=CGRectMake(-_leftSideView.frame.size.width, 0, _leftSideView.frame.size.width, _leftSideView.frame.size.height);
            _rightSideView.frame=CGRectMake(_rightSideView.frame.size.width, 0, _rightSideView.frame.size.width, _rightSideView.frame.size.height);
            [UIView commitAnimations];
            
            [_MainVC viewDidAppear:YES];

            if (_ldelegate!=nil&&[_ldelegate respondsToSelector:@selector(sliderViewLeftCancel)]) {
                [_ldelegate sliderViewLeftCancel];
            }
            if (_rdelegate!=nil&&[_rdelegate respondsToSelector:@selector(sliderViewRightCancel)]) {
                [_rdelegate sliderViewRightCancel];
            }

            _showingRight=NO;
            _showingLeft=NO;
            _tapGestureRec.enabled = NO;
        }
    }
}

-(void)tapToClose{
    [self closeSideBar:YES];
}

#pragma mark -

- (CGAffineTransform)transformWithDirection:(RMoveDirection)direction
{
    CGFloat translateX = 0;
    CGFloat transcale = 0;
    switch (direction) {
        case RMoveDirectionLeft:
            translateX = -_RightSContentOffset;
            transcale = _RightSContentScale;
            break;
        case RMoveDirectionRight:
            translateX = _LeftSContentOffset;
            transcale = _LeftSContentScale;
            break;
        default:
            break;
    }
    
    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, 0);
    CGAffineTransform scaleT = CGAffineTransformMakeScale(transcale, transcale);
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    
    return conT;
}

- (NSString*)deviceWithNumString{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    @try {
        return [deviceString stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    @catch (NSException *exception) {
        return deviceString;
    }
    @finally {
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_showingLeft) {
        [_LeftVC viewWillAppear:animated];
    }
    if (_showingRight) {
        [_RightVC viewWillAppear:animated];
    }
    if (!_showingLeft&&!_showingRight) {
        [_MainVC viewWillAppear:animated];
    }
    
    if (_mdelegate!=nil&&[_mdelegate respondsToSelector:@selector(sliderViewWillAppear)]) {
        [_mdelegate sliderViewWillAppear];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if (_showingLeft) {
        [_LeftVC viewDidAppear:animated];
    }
    if (_showingRight) {
        [_RightVC viewDidAppear:animated];
    }
    if (!_showingLeft&&!_showingRight) {
        [_MainVC viewDidAppear:animated];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (_showingLeft) {
        [_LeftVC viewWillDisappear:animated];
    }
    if (_showingRight) {
        [_RightVC viewWillDisappear:animated];
    }
    if (!_showingLeft&&!_showingRight) {
        [_MainVC viewWillDisappear:animated];
    }
    
    if (_mdelegate!=nil&&[_mdelegate respondsToSelector:@selector(sliderViewWillDisappear)]) {
        [_mdelegate sliderViewWillDisappear];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (_showingLeft) {
        [_LeftVC viewDidDisappear:animated];
    }
    if (_showingRight) {
        [_RightVC viewDidDisappear:animated];
    }
    if (!_showingLeft&&!_showingRight) {
        [_MainVC viewDidDisappear:animated];
    }
}

@end
