//
//  ViewController2.m
//  LeftRightSlider
//
//  Created by Zhao Yiqi on 13-11-29.
//  Copyright (c) 2013年 heroims. All rights reserved.
//

#import "ViewController2.h"

@interface HitView : UIScrollView

@end

@implementation HitView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (point.x<50) {
        return self.superview;
    }
    
    return [super hitTest:point withEvent:event];
}

@end

@interface ViewController2 ()

@end

@implementation ViewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor purpleColor];
    
    
    UIScrollView *bgV=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    bgV.contentSize=CGSizeMake(320*2, 300*2);
    bgV.backgroundColor=[UIColor orangeColor];
    bgV.center=self.view.center;
    [self.view addSubview:bgV];
    
    UIButton *btnPop=[UIButton buttonWithType:UIButtonTypeCustom];
    btnPop.layer.borderColor=[[UIColor whiteColor] CGColor];
    btnPop.layer.borderWidth=2;
    [btnPop setTitle:@"Pop" forState:UIControlStateNormal];
    [btnPop setFrame:CGRectMake(0, 0, 100, 50)];
    btnPop.center=self.view.center;
    [btnPop addTarget:self action:@selector(btnPopClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPop];

}

-(void)btnPopClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
