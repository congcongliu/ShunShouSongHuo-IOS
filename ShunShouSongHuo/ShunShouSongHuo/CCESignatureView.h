//
//  CCESignatureView.h
//  AgilePOPs
//
//  Created by CongCong on 2017/7/19.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
typedef void(^DrawCallBack)(NSArray *locations);

@interface CCESignatureView : UIView
- (instancetype)initWithFrame:(CGRect)frame andMapView:(MAMapView *)mapView andDrawLineCallBack:(DrawCallBack)callback;
- (void)clearSignature;
- (void)revocationDraw;


@end
