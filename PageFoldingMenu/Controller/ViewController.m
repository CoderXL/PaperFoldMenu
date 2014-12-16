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
    
    CGPoint originalPoint;
    
    CGFloat delta;
    
    CGPoint velocity;
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
    
    [view1.layer addAnimation:[self rotationAnimation] forKey:@"showAnimation"];
    view1.layer.speed = 0;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [containerView addGestureRecognizer:panGesture];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"pan");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        originalPoint = [gesture locationInView:self.view];
        delta = 3./80;
        velocity = [gesture velocityInView:self.view];
        
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translatePoint = [gesture translationInView:gesture.view];
        if (gesture.view.frame.origin.x<-80||gesture.view.frame.origin.x>0) {
            
        }else
        {
            if (gesture.view.frame.origin.x>=0&&velocity.x>0) {
                return;
            }
            gesture.view.center = CGPointMake(gesture.view.center.x+translatePoint.x, gesture.view.center.y);
            CGPoint currentPoint = [gesture locationInView:self.view];
            NSLog(@"currentpoint is %@",NSStringFromCGPoint(currentPoint));
            CGFloat currentDelta = (currentPoint.x - originalPoint.x)*delta;
            NSLog(@"current delta is %f",currentDelta);
            if (currentDelta>0) {
                view1.layer.timeOffset = currentDelta;
            }else
            {
                view1.layer.timeOffset = (3+currentDelta);
            }
            
        }
        [gesture setTranslation:CGPointZero inView:gesture.view];
    }
    if (gesture.state == UIGestureRecognizerStateEnded||gesture.state == UIGestureRecognizerStateCancelled) {
        if (CGRectGetMinX(gesture.view.frame)<-40) {
            [UIView animateWithDuration:0.1 animations:^{
                gesture.view.frame = CGRectMake(-80, 0, CGRectGetWidth(gesture.view.frame), CGRectGetHeight(gesture.view.frame));
                view1.layer.timeOffset = 0;
            }];
        }else
        {
            [UIView animateWithDuration:0.1 animations:^{
                gesture.view.frame = CGRectMake(0, 0, CGRectGetWidth(gesture.view.frame), CGRectGetHeight(gesture.view.frame));
            }];
            view1.layer.timeOffset = 3;
        }
    }
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
    rotation.removedOnCompletion = YES;
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
