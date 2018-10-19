# ScrollView  
使用简单
引入  #import "LHScrollerView.h"

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
