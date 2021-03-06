//
//  CCAlert.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CCAlert.h"
#import "GiFHUD.h"
#import "CCToast.h"

BOOL isShowProgress;
UIAlertView* alertView;
void stop()
{
    if(alertView)
    {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        alertView=nil;
    }
}

void alert_showErrMsg(NSString* msg)
{
    stop();
    alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"w_i_am_sure", nil) otherButtonTitles:nil];
    [alertView show];
}

void alert_showInfoMsg(NSString* msg)
{
    stop();
    alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"w_i_am_sure", nil) otherButtonTitles:nil];
    [alertView show];
}

void show_progress(){
    [GiFHUD setGifWithImageName:@"loading.gif"];
    [GiFHUD show];
    isShowProgress = YES;
}
BOOL isAlert_progress_show(){
    return isShowProgress;
}
void dismiss_progress(){
    isShowProgress = NO;
    [GiFHUD dismiss];
}

void toast_showInfoMsg(NSString* msg,CGFloat bottomOffset)
{
    [CCToast showWithText:msg
             bottomOffset:bottomOffset];
}




