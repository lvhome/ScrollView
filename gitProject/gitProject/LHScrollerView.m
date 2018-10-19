//
//  LHScrollerView.m
//  gitProject
//
//  Created by mac on 2018/10/19.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "LHScrollerView.h"



@interface LHScrollerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIPageControl *mainPageControl;
@property (nonatomic, assign) CGFloat widthView;
@property (nonatomic, assign) CGFloat heightView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *subLable;
@property (nonatomic, strong) UILabel *detaolLable;
@property (nonatomic, strong) UILabel *otherLable;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) UIViewContentMode imageViewcontentModel;
@property (nonatomic, assign) TapScrollerViewButtonBlock block;
@end

@implementation LHScrollerView

#pragma -- 初始化
+ (instancetype) loadScrollerViewWithFrame: (CGRect) frame {
    LHScrollerView *instance = [[LHScrollerView alloc] initWithFrame:frame];
    return instance;
}

//- (UILabel *)titleLable {
//    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
//}

#pragma -- mark 遍历初始化方法
- (instancetype)initWithFrame: (CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _widthView = frame.size.width;            //获取滚动视图的宽度
        _heightView = frame.size.height;            //获取滚动视图的高度
        _scrollInterval = 3;
        _animationInterVale = 0.7;
        _currentPage = 1;                           //当前显示页面
        _imageViewcontentModel = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)layoutSubviews {
    [self initMainScrollView]; //初始化滚动视图
    [self addDetailScrollerView];    //添加ImageView
    [self addTimerLoop];            //添加timer
    [self addPageControl];//添加PageControl
    [self initImageViewButton]; //添加点击事件
}

- (void)addTapEventForScrollerWithBlock:(TapScrollerViewButtonBlock) block{
    if (_block == nil) {
        if (block != nil) {
            _block = block;
        }
    }
}

#pragma -- mark 初始化按钮
- (void)initImageViewButton{
    for( int i = 0; i < _imageViewArray.count + 1; i ++) {
        CGRect currentFrame = CGRectMake(_widthView * i, 0, _widthView, _heightView);
        UIButton *tempButton = [[UIButton alloc] initWithFrame:currentFrame];
        [tempButton addTarget:self action:@selector(tapImageButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            tempButton.tag = _imageViewArray.count;
        } else {
            tempButton.tag = i;
        }
        [_mainScrollView addSubview:tempButton];
    }
}

- (void) tapImageButton: (UIButton *) sender{
    if (_block) {
        _block(sender.tag);
    }
}

/**
 *  初始化ScrollView
 */
- (void) initMainScrollView{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _widthView, _heightView)];
    _mainScrollView.contentSize = CGSizeMake(_widthView, _heightView);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    [self addSubview:_mainScrollView];
}

/**
 *  添加PageControl
 */
- (void) addPageControl{
    _mainPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _heightView - 20, _widthView, 20)];
    _mainPageControl.numberOfPages = _imageViewArray.count;
    _mainPageControl.currentPage = _currentPage - 1;
    _mainPageControl.tintColor = [UIColor blackColor];
    
    [self addSubview:_mainPageControl];
}


/**
 *  给ScrollView添加其它视图
 */
-(void) addDetailScrollerView{
    if (_imageViewArray != nil) {
        //设置ContentSize
        _mainScrollView.contentSize = CGSizeMake(_widthView * (_imageViewArray.count+1), _heightView);
        for ( int i = 0; i < _imageViewArray.count + 1; i ++) {
            CGRect currentFrame = CGRectMake(_widthView * i, 0, _widthView, _heightView);
            UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:currentFrame];
            tempImageView.contentMode = _imageViewcontentModel;
            tempImageView.clipsToBounds = YES;
            NSString *imageName;
            if (i == 0) {
                imageName = [_imageViewArray lastObject];
            } else {
                imageName = _imageViewArray[i - 1];
            }
            //说明是URL
            if ([imageName containsString:@"http"]) {
            } else {
                UIImage *imageTemp = [UIImage imageNamed:imageName];
                [tempImageView setImage:imageTemp];
            }
            [_mainScrollView addSubview:tempImageView];
        }
        _mainScrollView.contentOffset = CGPointMake(_widthView, 0);
    }
}

- (void) addTimerLoop{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollInterval target:self selector:@selector(changeOffset) userInfo:nil repeats:YES];
    }
}

- (void)changeOffset{
    _currentPage ++;
    
    if (_currentPage == _imageViewArray.count + 1) {
        _currentPage = 1;
    }
    
    [UIView animateWithDuration:_animationInterVale animations:^{
        _mainScrollView.contentOffset = CGPointMake(_widthView * _currentPage, 0);
    } completion:^(BOOL finished) {
        if (_currentPage == _imageViewArray.count) {
            _mainScrollView.contentOffset = CGPointMake(0, 0);
        }
    }];
    
    _mainPageControl.currentPage = _currentPage - 1;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x / _widthView;
    if(currentPage == 0){
        _mainScrollView.contentOffset = CGPointMake(_widthView * _imageViewArray.count, 0);
        _mainPageControl.currentPage = _imageViewArray.count;
        _currentPage = _imageViewArray.count;
        [self resumeTimer];
        return;
    }
    
    if (_currentPage + 1 == currentPage || currentPage == 1) {
        _currentPage = currentPage;
        
        if (_currentPage == _imageViewArray.count + 1) {
            _currentPage = 1;
        }
        if (_currentPage == _imageViewArray.count) {
            _mainScrollView.contentOffset = CGPointMake(0, 0);
        }
        _mainPageControl.currentPage = _currentPage - 1;
        [self resumeTimer];
        return;
    }
}

/**
 *  暂停定时器
 */
-(void)resumeTimer{
    
    if (![_timer isValid]) {
        return ;
    }
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollInterval-_animationInterVale]];
}


@end

