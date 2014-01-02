//
//  LRNavigationController.m
//  LeftRightSlider
//
//  Created by Zhao Yiqi on 13-12-9.
//  Copyright (c) 2013年 Zhao Yiqi. All rights reserved.
//


#import "LRNavigationController.h"

@interface LRNavigationController ()
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;

}

@property (nonatomic,retain) UIView *backgroundView;

@property (nonatomic,assign) BOOL isMoving;

@end

@implementation LRNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _canDragBack = YES;
        
        _startX=-200;
        _judgeOffset=50;
        _contentScale=1;
    }
    return self;
}

- (void)dealloc
{
#if __has_feature(objc_arc)
    lastScreenShotView=nil;
    blackMask=nil;
    [_backgroundView removeFromSuperview];
    _backgroundView=nil;
#else
    [lastScreenShotView release];
    [blackMask release];
    [_backgroundView release];
    [super dealloc];
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(paningGestureReceive:)];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
#if __has_feature(objc_arc)
#else
    [recognizer release];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}

-(void)pushViewControllerWithLRAnimated:(UIViewController *)viewController{
    [self pushViewController:viewController animated:NO];

    _isMoving = YES;
    
    if (!_backgroundView)
    {
        CGRect frame = self.view.frame;
        
        if (self.navigationBar.translucent) {
            _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:_backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        }
        else{
            _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, frame.size.width , frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)];
            [self.view.superview insertSubview:_backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)];
            
        }
        blackMask.backgroundColor = [UIColor blackColor];
        [_backgroundView addSubview:blackMask];
    }
    
    _backgroundView.hidden = NO;
    
    if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
    
    UIGraphicsBeginImageContextWithOptions(((UIViewController*)self.viewControllers[[self.viewControllers indexOfObject:self.visibleViewController]-1]).view.bounds.size, ((UIViewController*)self.viewControllers[[self.viewControllers indexOfObject:self.visibleViewController]-1]).view.opaque, 0.0);
    [((UIViewController*)self.viewControllers[[self.viewControllers indexOfObject:self.visibleViewController]-1]).view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImage *lastScreenShot = img;
    
    
#if __has_feature(objc_arc)
    lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
#else
    if (lastScreenShotView!=nil) {
        [lastScreenShotView release];
        lastScreenShotView=nil;
    }
    lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
#endif
    
    [lastScreenShotView setFrame:CGRectMake(0,
                                            0,
                                            _backgroundView.frame.size.width,
                                            _backgroundView.frame.size.height)];

    CGRect frame = self.view.frame;
    frame.origin.x = self.view.frame.size.width;
    self.view.frame = frame;

    [_backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];

    
    [UIView animateWithDuration:0.3 animations:^{
        [self moveViewWithX:0];
    } completion:^(BOOL finished) {
        _isMoving = NO;
        _backgroundView.hidden = YES;
    }];

}

-(void)popViewControllerWithLRAnimated{
    _isMoving = YES;
    
    if (!_backgroundView)
    {
        CGRect frame = self.view.frame;
        
        if (self.navigationBar.translucent) {
            _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:_backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        }
        else{
            _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, frame.size.width , frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)];
            [self.view.superview insertSubview:_backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)];
            
        }
        blackMask.backgroundColor = [UIColor blackColor];
        [_backgroundView addSubview:blackMask];
    }
    
    _backgroundView.hidden = NO;
    
    if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
    
    UIGraphicsBeginImageContextWithOptions(((UIViewController*)self.viewControllers[[self.viewControllers indexOfObject:self.visibleViewController]-1]).view.bounds.size, ((UIViewController*)self.viewControllers[[self.viewControllers indexOfObject:self.visibleViewController]-1]).view.opaque, 0.0);
    [((UIViewController*)self.viewControllers[[self.viewControllers indexOfObject:self.visibleViewController]-1]).view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImage *lastScreenShot = img;
    
    
#if __has_feature(objc_arc)
    lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
#else
    if (lastScreenShotView!=nil) {
        [lastScreenShotView release];
        lastScreenShotView=nil;
    }
    lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
#endif
    
    [lastScreenShotView setFrame:CGRectMake(_startX,
                                            lastScreenShotView.frame.origin.y,
                                            lastScreenShotView.frame.size.width,
                                            lastScreenShotView.frame.size.height)];
    
    [_backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];

    [UIView animateWithDuration:0.3 animations:^{
        [self moveViewWithX:self.view.frame.size.width];
        
    } completion:^(BOOL finished) {
        
        [self popViewControllerAnimated:NO];
        CGRect frame = self.view.frame;
        frame.origin.x = 0;
        self.view.frame = frame;
        
        _isMoving = NO;
    }];
}

#pragma mark - Utility Methods

- (void)moveViewWithX:(float)x
{
    x = x>self.view.frame.size.width?self.view.frame.size.width:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float alpha = 0.4 - (x/1000);

    blackMask.alpha = alpha;

    CGFloat aa = abs(_startX)/[UIScreen mainScreen].bounds.size.width;
    CGFloat y = x*aa;

    
    CGFloat lastScreenScale=_contentScale+x/self.view.frame.size.width*(1-_contentScale);
    
    [lastScreenShotView setFrame:CGRectMake(_startX+y+lastScreenShotView.superview.frame.size.width*(1-lastScreenScale)/2,
                                            lastScreenShotView.superview.frame.size.height*(1-lastScreenScale)/2,
                                            lastScreenShotView.superview.frame.size.width*lastScreenScale,
                                            lastScreenShotView.superview.frame.size.height*lastScreenScale)];
}


#pragma mark - Gesture Recognizer

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    CGPoint touchPoint = [recoginzer locationInView:[UIApplication sharedApplication].keyWindow];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!_backgroundView)
        {
            CGRect frame = self.view.frame;

            if (self.navigationBar.translucent) {
                _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
                [self.view.superview insertSubview:_backgroundView belowSubview:self.view];
                
                blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            }
            else{
                _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, frame.size.width , frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)];
                [self.view.superview insertSubview:_backgroundView belowSubview:self.view];
                
                blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)];
                
            }
            blackMask.backgroundColor = [UIColor blackColor];
            [_backgroundView addSubview:blackMask];
        }
        
        _backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        UIGraphicsBeginImageContextWithOptions(((UIViewController*)self.viewControllers[[self.viewControllers indexOfObject:self.visibleViewController]-1]).view.bounds.size, ((UIViewController*)self.viewControllers[[self.viewControllers indexOfObject:self.visibleViewController]-1]).view.opaque, 0.0);
        [((UIViewController*)self.viewControllers[[self.viewControllers indexOfObject:self.visibleViewController]-1]).view.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();

        UIImage *lastScreenShot = img;
        

#if __has_feature(objc_arc)
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
#else
        if (lastScreenShotView!=nil) {
            [lastScreenShotView release];
            lastScreenShotView=nil;
        }
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
#endif
        
        [lastScreenShotView setFrame:CGRectMake(_startX,
                                                lastScreenShotView.frame.origin.y,
                                                lastScreenShotView.frame.size.width,
                                                lastScreenShotView.frame.size.height)];

        [_backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];

        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > _judgeOffset)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:self.view.frame.size.width];

            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                _backgroundView.hidden = YES;
            }];

        }
        return;
        
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            _backgroundView.hidden = YES;
        }];
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}



@end



