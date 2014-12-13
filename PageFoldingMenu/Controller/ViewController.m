//
//  ViewController.m
//  PageFoldingMenu
//
//  Created by zangqilong on 14/12/2.
//  Copyright (c) 2014年 zangqilong. All rights reserved.
//

#import "ViewController.h"
#import "LeftViewController.h"
#import "CenterViewController.h"
#import "MacroDefinition.h"

@interface ViewController ()
{
    UIView *view1;
    UIView *containerView;
    
    CGFloat startCenterX;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(-80, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view insertSubview:containerView atIndex:0];
    containerView.backgroundColor = [UIColor blackColor];
    
    startCenterX = containerView.center.x;
    
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0,0 , 80, 320)];
    view1.backgroundColor = [UIColor redColor];
    view1.center = self.view.center;
    view1.layer.anchorPoint = CGPointMake(1., 0.5);
    view1.layer.position = CGPointMake(80, SCREEN_HEIGHT/2);
    view1.layer.transform = [self p_transform3D];
    [containerView addSubview:view1];
    
    NSArray *iconArray = @[@"home",@"shopping_list",@"friends",@"work"];
    for (int i =0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0,80*i , 80, 80);
        [button setImage:[UIImage imageNamed:iconArray[i]] forState:UIControlStateNormal];
        [view1 addSubview:button];
    }
    
    [view1.layer addAnimation:[self rotationAnimation] forKey:@"haha"];
    view1.layer.speed = 0;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)changeValue:(UISlider *)sender
{
    view1.layer.timeOffset = sender.value;
    containerView.center = CGPointMake(startCenterX+80.*sender.value/3., containerView.center.y);
}

- (CABasicAnimation *)rotationAnimation
{
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotation.duration = 3;
    rotation.fromValue = @(-M_PI_2);
    rotation.toValue = @(0);
    return rotation;
}

- (CATransform3D)p_transform3D
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 2.5 / -2000;
    return transform;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
