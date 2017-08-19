//
//  TextReamarkCell.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/11.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "TextReamarkCell.h"
#import "CCTool.h"
#import "Constant.h"
#import "NSString+Tool.h"
#import "UIColor+CustomColors.h"

@interface TextReamarkCell ()<UITextViewDelegate>
{
    UITextView *_textView;         //textView
    UILabel    *_placeHolderLabel; //placeHolder
}
@property (nonatomic, copy) TextRemarkCallBack callback;
@end

@implementation TextReamarkCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 25;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 2;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 10, self.frame.size.width-30, self.frame.size.height-20)];
    _textView.returnKeyType = UIReturnKeyDone;
    [self addSubview:_textView];
    
    _textView.font = fontBysize(16);
    _textView.delegate = self;
    _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 250, 20)];
    _placeHolderLabel.text = NSLocalizedString(@"w_please_input_text", nil);
    _placeHolderLabel.textColor = UIColorFromRGB(0xbbbbbb);
    _placeHolderLabel.font = fontBysize(16);
    [_textView addSubview:_placeHolderLabel];
}

- (void)showTextCellWithTextString:(NSString *)textString andTextRemarkCallBack:(TextRemarkCallBack)callback{
    self.callback = callback;
    if (!textString || [textString isEmpty]) {
        _placeHolderLabel.hidden = NO;
    }
    else{
        _placeHolderLabel.hidden = YES;
    }
}


#pragma mark ----------> textViewDelegat

- (void)textViewDidBeginEditing:(UITextView *)textView{
    _placeHolderLabel.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEmpty]) {
        _placeHolderLabel.hidden = NO;
    }
    else{
        _placeHolderLabel.hidden = YES;
    }
    if (self.callback) {
        self.callback(textView.text);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}


@end
