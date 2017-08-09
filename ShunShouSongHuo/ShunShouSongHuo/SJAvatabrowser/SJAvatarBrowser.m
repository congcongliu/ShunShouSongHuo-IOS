//
//  SJAvatarBrowser.m
//  zhitu
//
//  Created by 陈少杰 on 13-11-1.
//  Copyright (c) 2013年 聆创科技有限公司. All rights reserved.
//

#import "SJAvatarBrowser.h"
static CGRect oldframe;
@implementation SJAvatarBrowser
+(void)showImage:(UIImageView *)avatarImageView{
    
    
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    UIScrollView *backgroundView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    
    
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [imageView setUserInteractionEnabled:YES];
    [imageView setMultipleTouchEnabled:YES];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    
    [imageView addGestureRecognizer:pinchRecognizer];
    
    UIPanGestureRecognizer *panGR =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(objectDidDragged:)];
    //限定操作的触点数
    [panGR setMaximumNumberOfTouches:1];
    [panGR setMinimumNumberOfTouches:1];
    //将手势添加到draggableObj里
    [imageView addGestureRecognizer:panGR];
    
    
    
    [UIView animateWithDuration:0.25 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.25 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

/**
 * 处理捏合手势
 *
 * @param recognizer 捏合手势识别器对象实例
 */
+ (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    
    CGFloat scale = recognizer.scale;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    

    CGFloat absScale = recognizer.view.frame.size.width/[UIScreen mainScreen].bounds.size.width;
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"====>%f %f",absScale,scale);
        if (absScale<1) {
            recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, 1/absScale, 1/absScale);
            recognizer.view.center = window.center;
            return;
        }
        if (absScale>3) {
            recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, 3/absScale, 3/absScale);
            return;
        }
    }
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, scale, scale);
    //在已缩放大小基础下进行累加变化；区别于：使用 CGAffineTransformMakeScale 方法就是在原大小基础下进行变化
    recognizer.scale = 1.0;
}
//拖动手势
+ (void)objectDidDragged:(UIPanGestureRecognizer *)sender {
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    if (sender.state == UIGestureRecognizerStateChanged ||
        sender.state == UIGestureRecognizerStateEnded) {
        //注意，这里取得的参照坐标系是该对象的上层View的坐标。
        CGPoint offset = [sender translationInView:window];
        UIView *draggableObj = sender.view;
        //通过计算偏移量来设定draggableObj的新坐标
        [draggableObj setCenter:CGPointMake(draggableObj.center.x + offset.x, draggableObj.center.y + offset.y)];
        //初始化sender中的坐标位置。如果不初始化，移动坐标会一直积累起来。
        [sender setTranslation:CGPointMake(0, 0) inView:window];
    }
    
    CGFloat absScale = sender.view.frame.size.width/[UIScreen mainScreen].bounds.size.width;
    if (absScale<=1) {
        sender.view.center = window.center;
    }
}


@end
