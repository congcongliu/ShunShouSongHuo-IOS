//
//  CCESignatureView.m
//  AgilePOPs
//
//  Created by CongCong on 2017/7/19.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "CCESignatureView.h"
#import "Constant.h"
#import "UIColor+CustomColors.h"
@interface CCESignatureView (){
    CGFloat _lineWidth;//线宽
    UIColor * _lineColor;//线的颜色
}
/**
 *  线宽
 */
@property (nonatomic,assign) CGFloat  lineWidth;
/**
 *  线的颜色
 */
@property (nonatomic,strong) UIColor * lineColor;
/**
 *  画线路径集合
 */
@property (nonatomic, strong) NSMutableArray *pathArray;
/**
 *  路径
 */
@property (nonatomic, assign) CGMutablePathRef path;


@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, copy  ) DrawCallBack callback;
@end

@implementation CCESignatureView

- (instancetype)initWithFrame:(CGRect)frame andMapView:(MAMapView *)mapView andDrawLineCallBack:(DrawCallBack)callback
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = 3;
        self.callback = callback;
        self.mapView = mapView;
        _lineColor = [UIColor customRedColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (NSMutableArray*)locations{
    if (!_locations) {
        _locations = [NSMutableArray array];
    }
    return _locations;
}


- (NSMutableArray *)pathArray{
    if (!_pathArray) {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    //创建路径
    self.path = CGPathCreateMutable();
    [self.pathArray addObject:(__bridge id)(self.path)];//路径及属性数组
    CGPoint start = [touch locationInView:self];//起始点
    CGPathMoveToPoint(self.path, NULL, start.x, start.y);//将画笔移动到某点
    
    CLLocationCoordinate2D loaction = [self.mapView convertPoint:start toCoordinateFromView:self.mapView];
    [self.locations addObject:[NSValue valueWithMACoordinate:loaction]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint move = [touch locationInView:self];
    //将点添加到路径上
    CGPathAddLineToPoint(self.path, NULL, move.x, move.y);
    
    [self setNeedsDisplay];//自动调用drawRect:(CGRect)rect
    
    CLLocationCoordinate2D loaction = [self.mapView convertPoint:move toCoordinateFromView:self.mapView];
    [self.locations addObject:[NSValue valueWithMACoordinate:loaction]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPathRelease(self.path);//释放路径
    
    if (self.callback) {
        self.callback(self.locations);
    }
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//画图
-(void)drawRect:(CGRect)rect
{
    //获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画图
    for (int i=0; i<self.pathArray.count; i++) {
        //将路径添加到上下文
        CGPathRef pathRef = (__bridge CGPathRef)_pathArray[i];
        CGContextAddPath(context, pathRef);
        //设置上下文属性
        [_lineColor setStroke];//设置边框颜色
        CGContextSetLineWidth(context, _lineWidth);
        //绘制线条
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}

- (void)clearSignature{
    [self.pathArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)revocationDraw{
    [self.pathArray removeLastObject];
    [self setNeedsDisplay];
}

//- (UIImage *)getSignatureImage{
//    if (self.pathArray.count) {
//        UIGraphicsBeginImageContext(self.frame.size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        UIRectClip(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
//        [self.layer renderInContext:context];
//        
//        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
//        return image;
//    }
//    return nil;
//}
//



- (void)dealloc{
    NSLog(@"画圈销毁");
}




@end
