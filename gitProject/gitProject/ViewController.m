//
//  ViewController.m
//  gitProject
//
//  Created by mac on 2018/10/17.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "ViewController.h"
#import "LHScrollerView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addScrollerView];
}

-(void) addScrollerView{
    //获取要显示的位置
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0, 200, screenFrame.size.width, 200);
    NSArray *imageArray = @[@"1.jpeg", @"2.jpeg", @"3.jpeg", @"4.jpeg", @"5.jpeg"];
    //初始化控件
    LHScrollerView *detailScrollerView = [LHScrollerView loadScrollerViewWithFrame:frame];
    detailScrollerView.imageViewArray = imageArray;
    detailScrollerView.scrollInterval = 3;
    detailScrollerView.animationInterVale = 0.6;
    [self.view addSubview:detailScrollerView];
    [detailScrollerView addTapEventForScrollerWithBlock:^(NSInteger imageIndex) {
        NSString *str = [NSString stringWithFormat:@"我是第%ld张图片", imageIndex];
        NSLog(@"%@",str);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
