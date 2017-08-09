//
//  UIControl+ButtonClick.m
// cmfieldwork

//  Created by chance on 15/11/25.
//  Copyright (c) 2015年 Shanghai Zhongyi Communication Technology Engieering Co., Ltd. All rights reserved.
//



#import "UIControl+ButtonClick.h"
#import <objc/runtime.h>

static const char *UIControl_ignoreEvent = "UIControl_ignoreEvent";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

@implementation UIControl (ButtonClick)


- (NSTimeInterval)acceptEventTime{
    return [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}
-(BOOL)ignoreEvent{
    return [objc_getAssociatedObject(self, UIControl_ignoreEvent) boolValue];
}

-(void)setIgnoreEvent:(BOOL)ignoreEvent{
    objc_setAssociatedObject(self, UIControl_ignoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setAcceptEventTime:(NSTimeInterval)acceptEventTime{
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(otherSendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
    
}

- (void)otherSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    if (self.ignoreEvent) {
        return;
    }
    if (self.acceptEventTime > 0) {
        self.ignoreEvent = YES;
        [self performSelector:@selector(reAccepEvent) withObject:nil afterDelay:self.acceptEventTime];
    }
    [self otherSendAction:action to:target forEvent:event];
}

-(void)reAccepEvent {
    self.ignoreEvent=NO;
}
@end
