//
//  FYTrendGraphView.m
//  图
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

#import "FYTrendGraphView.h"

@interface FYTrendGraphView()
{
    CGPoint _currentTouchPoint;
}

@property (nonatomic, assign) CGFloat yRowHeight;               // 一行的高度
@property (nonatomic, assign) BOOL isExistYvalue;
@property (nonatomic, assign) CGFloat yUnit;                    // 一个单元格对应的数值
@end

@implementation FYTrendGraphView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    [self.lineColor setStroke];
    [self setLineDash:context];
    CGContextSetLineWidth(context, self.lineWidth);
    
    for (NSInteger i = 0; i <= self.yRow; i ++) {
        
        NSInteger k = self.yRow - i;

        CGFloat currentY = self.yRowHeight * k + kVerticalMargin;
        CGFloat currentEndX = CGRectGetMaxX(rect) - kHorizontalMargin;
        
        CGFloat pixelAdjustOffset = 0;
        if (((int)(self.lineWidth * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
            pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
        }
        currentY = currentY + pixelAdjustOffset;
        currentEndX = currentEndX;
        
        CGContextMoveToPoint(context, self.startX, currentY);
        CGContextAddLineToPoint(context, currentEndX, currentY);
        CGContextStrokePath(context);
        
        if (!self.isExistYvalue) {
            
            if (k % self.yInterval == 0) {
                
                NSString* yCurrentValue = [NSString stringWithFormat:@"%.f",self.endY - (k * self.yUnit)];
                [self stringDraw:yCurrentValue AtPositionY:currentY];
            }
        }
    }
    CGContextRestoreGState(context);
    
    // 画触摸竖线
    CGContextSaveGState(context);
    [self setLineDash:context];
    [self.verticalLineColor setStroke];
    CGContextSetLineWidth(context, self.verticalLineWidth);
    if (!(_currentTouchPoint.x == 0 && _currentTouchPoint.y == 0)) {
        
        CGContextMoveToPoint(context, _currentTouchPoint.x, 0);
        CGContextAddLineToPoint(context, _currentTouchPoint.x, CGRectGetHeight(self.frame));
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
    
    if (self.isExistYvalue) {
        
        for (NSInteger i = 0; i < self.yValueArray.count; i++) {
            
            NSString* yCurrentValue = [NSString stringWithFormat:@"%@",self.yValueArray[i]];
            [self stringDraw:yCurrentValue AtPositionY:[self getPositionYWithValue:[self.yValueArray[i] floatValue]]];
        }
    }
    
    CGFloat xWidth = CGRectGetWidth(self.frame) - self.startX - kHorizontalMargin;
    CGFloat xUnit = xWidth / (self.valueArray.count - 1);
    
    CGContextSetFillColorWithColor(context, self.pointColor.CGColor);

    CGContextSaveGState(context);
    [self.pointColor setStroke];
    NSMutableArray* pointTempArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.valueArray.count; i++) {
        CGFloat xCurrentValue = xUnit * i + self.startX;
        CGFloat yCurrentValue = [self getPositionYWithValue:[self.valueArray[i] floatValue]];
        
        [pointTempArray addObject:[NSValue valueWithCGPoint:CGPointMake(xCurrentValue, yCurrentValue)]];
        
        CGContextAddArc(context, xCurrentValue, yCurrentValue, kCircleRadius, 0, 2 * M_PI, YES);
        
        if (_currentTouchPoint.x > xCurrentValue - kCircleRadius && _currentTouchPoint.x < xCurrentValue + kCircleRadius) {
            
            // 碰到处理
        }
        
        CGContextDrawPath(context, kCGPathFill);
    }
    CGContextRestoreGState(context);
    
    
    CGContextSaveGState(context);
    [self.contactLineColor setStroke];
    for (NSInteger i = 0; i < pointTempArray.count; i++) {
        
        CGPoint point = [pointTempArray[i] CGPointValue];
        if (i == 0) {
            CGContextMoveToPoint(context, point.x, point.y);
        }else {
            CGContextAddLineToPoint(context, point.x, point.y);
        }
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

#pragma mark - helper
- (void)stringDraw:(NSString*)stringValue AtPositionY:(CGFloat)positionY
{
    CGSize size = [stringValue boundingRectWithSize:CGSizeMake(self.startX, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:nil
                                              context:nil].size;
    
    [stringValue drawInRect:CGRectMake(self.startX - size.width - kYLabelRightMargin, positionY - size.height / 2, self.startX, size.height)
               withAttributes:nil];
}

- (CGPoint)changePoint:(NSSet*)touches
{
    UITouch* touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    if (point.x < self.startX || point.x > CGRectGetWidth(self.frame) - kHorizontalMargin) {
        return CGPointZero;
    }
    
    return point;
}

- (void)setLineDash:(CGContextRef)context
{
    CGFloat lengths[] = {5,2};
    CGContextSetLineDash(context, 0, lengths, 2);
}


- (CGFloat)getPositionYWithValue:(CGFloat)value
{
    CGFloat koc = value / [self.yValueArray.lastObject floatValue];
    if (!self.isExistYvalue) {
        koc = value / self.endY;
    }

    if (koc > 1) {
        return -1;
    }
    
    return (CGRectGetHeight(self.frame) - 2 * kVerticalMargin)* (1 - koc) + kVerticalMargin;
}

#pragma mark - events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _currentTouchPoint = [self changePoint:touches];
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _currentTouchPoint = [self changePoint:touches];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _currentTouchPoint = CGPointZero;
    
    [self setNeedsDisplay];
}

#pragma mark - getter and setter
- (NSInteger)yRow
{
    if (_yRow == 0) {
        
        _yRow = 10;
    }
    
    return _yRow;
}

- (CGFloat)yRowHeight
{
    if (_yRowHeight == 0) {
        
        _yRowHeight = CGRectGetHeight(({
            CGFloat startY = CGRectGetMinY(self.frame) - self.lineWidth;
            CGFloat height = CGRectGetHeight(self.frame) - 2 * kVerticalMargin - self.lineWidth;
            CGRect frame = CGRectMake(0, startY, CGRectGetWidth(self.frame), height);
            
            frame;
        })) / self.yRow;
    }
    
    return ceil(_yRowHeight);
}

- (UIColor *)lineColor
{
    if (!_lineColor) {
    
        _lineColor = [UIColor blackColor];
    }
    
    return _lineColor;
}

- (UIColor*)pointColor
{
    if (!_pointColor) {
        
        _pointColor = [UIColor blackColor];
    }
    
    return _pointColor;
}

- (UIColor *)contactLineColor
{
    if (!_contactLineColor) {
        _contactLineColor = _pointColor;
    }
    
    return _pointColor;
}

- (CGFloat)lineWidth
{
    if (_lineWidth == 0) {
        
        _lineWidth = 1.0f / [UIScreen mainScreen].scale;
    }
    
    return _lineWidth;
}

- (CGFloat)startX
{
    return 30;
}

- (NSInteger)yInterval
{
    if (_yInterval == 0) {
        _yInterval = 2;
    }
    
    return _yInterval;
}

- (void)setYValueArray:(NSArray *)yValueArray
{
    _yValueArray = yValueArray;
    
    self.endY = [yValueArray.lastObject floatValue];
}

- (BOOL)isExistYvalue
{
    if (self.yValueArray.count) {
        return YES;
    }
    
    NSAssert(self.endY, @"self.yValueArray 与 self.endY 必须有一个赋值");
    
    return NO;
}

- (CGFloat)yUnit
{
    CGFloat yHeight = self.endY - self.startY;
    return (yHeight / self.yRow);
}

- (UIColor *)verticalLineColor
{
    if (!_verticalLineColor) {
        
        _verticalLineColor = self.pointColor;
    }
    
    return _verticalLineColor;
}

- (CGFloat)verticalLineWidth
{
    if (!_verticalLineWidth) {
        
        _verticalLineWidth = 1.5;
    }
    
    return _verticalLineWidth;
}
@end
