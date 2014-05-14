//
//  SQGameViewController.m
//  SQHealthLife
//
//  Created by ShengQiang on 5/5/14.
//  Copyright (c) 2014 SQ. All rights reserved.
//

#import "SQGameViewController.h"

@interface SQGameViewController ()
{
    float _orign;
    float _random;
}

@property (retain, nonatomic) UIImageView *wheelBkImageView;
@property (retain, nonatomic) UIImageView *wheelPointerView;

@end

@implementation SQGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.title = NSLocalizedString(@"Game", @"Game");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //添加转盘
    UIImageView *image_disk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disk.jpg"]];
    image_disk.frame = CGRectMake(0.0, 0.0, 320.0, 320.0);
    _wheelBkImageView = image_disk;
    [self.view addSubview:_wheelBkImageView];
    
    //添加转针
    UIImageView *image_start = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start.png"]];
    image_start.frame = CGRectMake(103.0, 55.0, 120.0, 210.0);
    _wheelPointerView = image_start;
    [self.view addSubview:_wheelPointerView];
    
    //添加按钮
    UIButton *btn_start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn_start.frame = CGRectMake(140.0, 350.0, 70.0, 70.0);
    [btn_start setTitle:@"抽奖" forState:UIControlStateNormal];
    [btn_start addTarget:self action:@selector(choujiang) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (void)choujiang
{
    //******************旋转动画******************
    //产生随机角度
    srand((unsigned)time(0));  //不加这句每次产生的随机数不变
    _random = (rand() % 20) / 10.0;
    //设置动画
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setFromValue:[NSNumber numberWithFloat:M_PI * (0.0+_orign)]];
    [spin setToValue:[NSNumber numberWithFloat:M_PI * (10.0+_random + _orign)]];
    [spin setDuration:2.5];
    [spin setDelegate:self];//设置代理，可以相应animationDidStop:finished:函数，用以弹出提醒框
    //速度控制器
    [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //添加动画
    [[self.wheelPointerView layer] addAnimation:spin forKey:nil];
    //锁定结束位置
    self.wheelPointerView.transform = CGAffineTransformMakeRotation(M_PI * (10.0 + _random + _orign));
    //锁定fromValue的位置
    _orign = 10.0 + _random + _orign;
    _orign = fmodf(_orign, 2.0);
}

- (void)animationDidStop:(CAAnimation *) anim finished:(BOOL) flag
{
    //判断抽奖结果
    if (_orign >= 0.0 && _orign < (0.5/3.0))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 一等奖！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
        [result show];
        [result release];
    }
    else if (_orign >= (0.5/3.0) && _orign < ((0.5/3.0) * 2))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 七等奖！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
        [result show];
        [result release];
    }
    else if (_orign >= ((0.5/3.0) * 2) && _orign < ((0.5/3.0)*3))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 六等奖！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
        [result show];
        [result release];
    }
    else if (_orign >= (0.0+0.5) && _orign < ((0.5/3.0)+0.5))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 七等奖！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
        [result show];
        [result release];
    }
    else if (_orign >= ((0.5/3.0)+0.5) && _orign < (((0.5/3.0)*2)+0.5))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 五等奖！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
        [result show];
        [result release];
    }
    else if (_orign >= (((0.5 / 3.0) * 2) + 0.5) && _orign < (((0.5 / 3.0) * 3) + 0.5))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 七等奖！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
        [result show];
        [result release];
    }
    else if (_orign >= (0.0+1.0) && _orign < ((0.5/3.0)+1.0))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 四等奖！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
        [result show];
        [result release];
    }
    else if (_orign >= ((0.5/3.0)+1.0) && _orign < (((0.5/3.0)*2)+1.0))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 七等奖！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
        [result show];
        [result release];
    }
    else if (_orign >= (((0.5/3.0) * 2) + 1.0) && _orign < (((0.5/3.0) * 3) + 1.0))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 三等奖！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
        [result show];
        [result release];
    }
    else if (_orign >= (0.0 + 1.5) && _orign < ((0.5 / 3.0) + 1.5))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 七等奖！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
        [result show];
        [result release];
    }
    else if (_orign >= ((0.5/3.0)+1.5) && _orign < (((0.5/3.0)*2)+1.5))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 二等奖！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
        [result show];
        [result release];
    }
    else if (_orign >= (((0.5/3.0)*2)+1.5) && _orign < (((0.5/3.0)*3)+1.5))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 七等奖！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
        [result show];
        [result release];
    }
}

@end
