//
//  FYTrendGraphView.h
//  图
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kVerticalMargin 10                      // 虚线框距离上下的边距，防止最上方和最下方的y轴数值显示不下
#define kHorizontalMargin   5                   // 虚线框距离左右的边距，防止最右边的点显示不下
#define kYLabelRightMargin 8                    // lable 右侧距离虚线框的距离
#define kCircleRadius   4                       // 值点圆的半径

@interface FYTrendGraphView : UIView

/**
 *  X轴值数组
 */
@property (nonatomic, strong) NSArray* valueArray;

/**
 *  Y轴值数组
 */
@property (nonatomic, strong) NSArray* yValueArray;

/**
 *  Y轴行数，默认是10
 */
@property (nonatomic, assign) NSInteger yRow;

/**
 *  Y轴间隔几个显示，默认为2
 */
@property (nonatomic, assign) NSInteger yInterval;

/**
 *  左侧label的宽度（并减去 kYLabelRightMargin 数值）
 */
@property (nonatomic, assign) CGFloat startX;

/**
 *  Y轴开始数值
 */
@property (nonatomic, assign) CGFloat startY;

/**
 *  Y轴结束数值
 */
@property (nonatomic, assign) CGFloat endY;

/**
 *  线的颜色,默认是黑色
 */
@property (nonatomic, strong) UIColor* lineColor;

/**
 *  圆点颜色
 */
@property (nonatomic, strong) UIColor* pointColor;

/**
 *  连接线颜色
 */
@property (nonatomic, strong) UIColor* contactLineColor;
/**
 *  线的宽度，默认是1
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 *  触摸竖线颜色,默认跟点的颜色相同
 */
@property (nonatomic, strong) UIColor* verticalLineColor;
/**
 *  触摸线的宽度,默认是1.5
 */
@property (nonatomic, assign) CGFloat verticalLineWidth;

@end
