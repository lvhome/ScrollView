//
//  LHScrollerView.h
//  gitProject
//
//  Created by mac on 2018/10/19.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>


//点击图片的Block回调，参数当前视图的索引，也就是当前页数
typedef void(^TapScrollerViewButtonBlock)(NSInteger imageIndex);

@interface LHScrollerView : UIView
@property (nonatomic, assign) CGFloat scrollInterval;               //切换图片的时间间隔，可选，默认为3s
@property (nonatomic, assign) CGFloat animationInterVale;           //运动时间间隔,可选，默认为0.7s
@property (nonatomic, strong) NSArray * imageViewArray;              //图片数组

 /**
  创建滚动视图
  @param frame 滚动视图的Frame
  @return 返回该类对象
  */

+ (instancetype) loadScrollerViewWithFrame: (CGRect) frame;


/**
 初始化函数
 @param frame 滚动视图的Frame
 @return 该类的对象
 */
- (instancetype)initWithFrame: (CGRect)frame;


/**
 为每个视图添加点击时间
 @param block 点击按钮要执行的Block
 */
- (void) addTapEventForScrollerWithBlock: (TapScrollerViewButtonBlock) block;


@end
