//
//  CustomIOSAlertView.m
//  CustomIOSAlertView
//
//  Created by Richard on 20/09/2013.
//  Copyright (c) 2013-2015 Wimagguc.
//
//  Lincesed under The MIT License (MIT)
//  http://opensource.org/licenses/MIT
//

#import "CustomIOSAlertView.h"
#import "Constant.h"
#import "NSString+Tool.h"
#import <UIView+SDAutoLayout.h>
#import "UIColor+CustomColors.h"
#import <QuartzCore/QuartzCore.h>
const static CGFloat kCustomIOSAlertViewDefaultButtonHeight       = 50;
const static CGFloat kCustomIOSAlertViewDefaultButtonSpacerHeight = 1;
const static CGFloat kCustomIOSAlertViewCornerRadius              = 25;
const static CGFloat kCustomIOS7MotionEffectExtent                = 10.0;

@interface CustomIOSAlertView (){
    UILabel *_titleLabel;
}
@property (nonatomic,assign) BOOL hasTitle;
@property (nonatomic,copy  ) NSString *titleString;
@end

@implementation CustomIOSAlertView

CGFloat buttonHeight = 0;
CGFloat buttonSpacerHeight = 0;

@synthesize parentView, containerView, dialogView, onButtonTouchUpInside;
@synthesize delegate;
@synthesize buttonTitles;
@synthesize useMotionEffects;

- (id)initWithParentView: (UIView *)_parentView
{
    self = [self init];
    if (_parentView) {
        self.frame = _parentView.frame;
        self.parentView = _parentView;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

        delegate = self;
        useMotionEffects = false;
        buttonTitles = @[@"Close"];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (id)initWithTitleString:(NSString *)titleString
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.hasTitle = YES;
        self.titleString = titleString;
        delegate = self;
        useMotionEffects = false;
        buttonTitles = @[@"Close"];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


// Create the dialog view, and animate opening the dialog
- (void)show
{
    dialogView = [self createContainerView];
  
    dialogView.layer.shouldRasterize = YES;
    dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
  
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

#if (defined(__IPHONE_7_0))
    if (useMotionEffects) {
        [self applyMotionEffects];
    }
#endif

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    [self addSubview:dialogView];

    // Can be attached to a view or to the top most window
    // Attached to a view:
    if (parentView != NULL) {
        [parentView addSubview:self];

    // Attached to the top most window
    } else {

        // On iOS7, calculate with orientation
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            
            UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            switch (interfaceOrientation) {
                case UIInterfaceOrientationLandscapeLeft:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                    break;
                    
                case UIInterfaceOrientationLandscapeRight:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                    break;
                    
                case UIInterfaceOrientationPortraitUpsideDown:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                    break;
                    
                default:
                    break;
            }
            
            [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

        // On iOS8, just place the dialog in the middle
        } else {

            CGSize screenSize = [self countScreenSize];
            CGSize dialogSize = [self countDialogSize];
            CGSize keyboardSize = CGSizeMake(0, 0);

            dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);

        }

        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }

    dialogView.layer.opacity = 0.5f;
    dialogView.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 0.5f);

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        dialogView.layer.opacity = 1.0f;
        dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    } completion:nil];

    
}

- (void)setContainerImage:(NSString *)imageString message:(NSString *)message buttons:(NSArray *)buttons{
    
    CGFloat demoViewWidth = (SYSTEM_WIDTH<SYSTEM_HEIGHT?SYSTEM_WIDTH:SYSTEM_HEIGHT)*0.80;
    
    CGFloat demoViewHight = demoViewWidth*32/59.0+40+[message sizeH:14 withLabelWidth:(demoViewWidth
                                                                                       -60)];
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, demoViewWidth, demoViewHight)];
    UIImageView *_titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageString]];
    [demoView addSubview:_titleImageView];
    _titleImageView.sd_layout
    .widthIs(demoView.width)
    .centerXEqualToView(demoView)
    .topSpaceToView(demoView,0)
    .autoHeightRatio(32/59.0);
    
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleImageView addSubview:_titleLabel];
    _titleLabel.sd_layout
    .leftEqualToView(_titleImageView)
    .rightEqualToView(_titleImageView)
    .bottomSpaceToView(_titleImageView,15)
    .autoHeightRatio(0);
    
    if ([imageString isEqualToString:@"alert_notfreshman"]) {
        _titleLabel.text = NSLocalizedString(@"id_certification", nil);
    }
    
    UILabel *_messageLabel = [[UILabel alloc]init];
    _messageLabel.font = [UIFont systemFontOfSize:14];
    _messageLabel.numberOfLines = 0;
      
//    if ([message isEqualToString:NSLocalizedString(@"only_close_you_can_answer", nil)]) {
//        
//        NSRange bottomLineRange = [message rangeOfString:NSLocalizedString(@"only_close_ondeline_text", nil)];
//        NSDictionary *testDic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:message attributes:testDic];
//        [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:bottomLineRange];
//        
//        _messageLabel.attributedText = attributedString;
//        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thirdButtonClick)];
//        [_messageLabel addGestureRecognizer:tap];
//        _messageLabel.userInteractionEnabled = YES;
//        
//    }else
        
    if(self.hasTitle){
        NSRange titleRange = [message rangeOfString:self.titleString];
        NSDictionary *testDic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:message attributes:testDic];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:titleRange];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:2];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
        _messageLabel.attributedText = attributedString;
    }
    else{
        _messageLabel.text = message;
    }
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    
    [demoView addSubview:_messageLabel];
    
    _messageLabel.sd_layout
    .rightSpaceToView(demoView,30)
    .leftSpaceToView (demoView,30)
    .bottomSpaceToView(demoView,40)
    .autoHeightRatio(0);
    
    [self setContainerView:demoView];
    [self setButtonTitles:[NSMutableArray arrayWithArray:buttons]];
    
}

- (void)thirdButtonClick{
    if (delegate != NULL) {
        [delegate customIOS7dialogButtonTouchUpInside:self clickedButtonAtIndex:2];
    }
    if (onButtonTouchUpInside != NULL) {
        onButtonTouchUpInside(self, 2);
    }
}
- (void)setContainerImage:(NSString *)imageString message:(NSString *)message{

    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH*0.8, SYSTEM_WIDTH*0.8-50)];
    UIImageView *_titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageString]];
    [demoView addSubview:_titleImageView];
    _titleImageView.sd_layout
    .widthIs(demoView.width*0.5)
    .heightIs(demoView.width*0.5)
    .centerXEqualToView(demoView)
    .topSpaceToView(demoView,25);
    

    
    
    UILabel *_messageLabel = [[UILabel alloc]init];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = [UIFont systemFontOfSize:14];
    _messageLabel.numberOfLines = 0;
    
    _messageLabel.text = message;
    
    [demoView addSubview:_messageLabel];
    _messageLabel.sd_layout
    .rightSpaceToView(demoView,35)
    .leftSpaceToView (demoView,35)
    .topSpaceToView(_titleImageView,15)
    .autoHeightRatio(0);
    
    [self setContainerView:demoView];
    [self setButtonTitles:[NSMutableArray arrayWithObjects:@"知道了", nil]];
    
}


// Button has been touched
- (IBAction)customIOS7dialogButtonTouchUpInside:(id)sender
{
    if (delegate != NULL) {
        [delegate customIOS7dialogButtonTouchUpInside:self clickedButtonAtIndex:[sender tag]];
    }

    if (onButtonTouchUpInside != NULL) {
        onButtonTouchUpInside(self, (int)[sender tag]);
    }
}

// Default button behaviour
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Clicked! %d, %d", (int)buttonIndex, (int)[alertView tag]);
    [self close];
}

// Dialog close animation then cleaning and removing the view from the parent
- (void)close
{
    CATransform3D currentTransform = dialogView.layer.transform;

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);

        dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }

    dialogView.layer.opacity = 1.0f;

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         dialogView.layer.opacity = 0.0f;
					 }
					 completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
					 }
	 ];
}

- (void)setSubView: (UIView *)subView
{
    containerView = subView;
}

// Creates the container view here: create the dialog, then add the custom content and buttons
- (UIView *)createContainerView
{
    if (containerView == NULL) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    }

    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];

    // For the black background
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];

    // This is the dialog's container; we attach the custom content and the buttons to this one
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];

    // First, we style the dialog to match the iOS7 UIAlertView >>>
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       nil];

    CGFloat cornerRadius = kCustomIOSAlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    [dialogContainer.layer insertSublayer:gradient atIndex:0];

    dialogContainer.layer.cornerRadius = cornerRadius;
    dialogContainer.layer.borderColor = [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor];
    dialogContainer.layer.borderWidth = 1;
    dialogContainer.layer.shadowRadius = cornerRadius + 5;
    dialogContainer.layer.shadowOpacity = 0.1f;
    dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;

    // There is a line above the button
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, dialogContainer.bounds.size.height - buttonHeight - buttonSpacerHeight, dialogContainer.bounds.size.width, buttonSpacerHeight)];
//    lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
//    [dialogContainer addSubview:lineView];
//    // ^^^

    // Add the custom container if there is any
    [dialogContainer addSubview:containerView];

    // Add the buttons too
    [self addButtonsToView:dialogContainer];

    return dialogContainer;
}

// Helper function: add buttons to container
- (void)addButtonsToView: (UIView *)container
{
    if (buttonTitles==NULL) { return; }

   // CGFloat buttonWidth = container.bounds.size.width / [buttonTitles count];
    if (buttonTitles.count==1) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.clipsToBounds = YES;
        closeButton.layer.cornerRadius = 20;
        closeButton.backgroundColor = [UIColor customRedColor];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"cc2f27"] forState:UIControlStateHighlighted];
        closeButton.tag = 0;
        [closeButton addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTitle:buttonTitles[0] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [container addSubview:closeButton];
        
        closeButton.sd_layout
        .bottomSpaceToView(container,30)
        .centerXEqualToView(container)
        .widthIs(120)
        .heightIs(40);
        
    }else if(buttonTitles.count==2){
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.clipsToBounds = YES;
        rightButton.layer.cornerRadius = 20;
        rightButton.backgroundColor = [UIColor whiteColor];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"dddddd"] forState:UIControlStateHighlighted];
        rightButton.tag = 0;
        rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        rightButton.layer.borderColor = [UIColor blackColor].CGColor;
        rightButton.layer.borderWidth = 2;
        [rightButton addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:buttonTitles[0] forState:UIControlStateNormal];
        [container addSubview:rightButton];
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightButton.sd_layout
        .bottomSpaceToView(container,30)
        .rightSpaceToView(container,container.width/2+10)
        .leftSpaceToView(container,30)
        .heightIs(40);
        
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.clipsToBounds = YES;
        leftButton.layer.cornerRadius = 20;
        leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        leftButton.backgroundColor = [UIColor customRedColor];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"cc2f27"] forState:UIControlStateHighlighted];
        leftButton.tag = 1;
        [leftButton addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setTitle:buttonTitles[1] forState:UIControlStateNormal];
        [container addSubview:leftButton];
        
        leftButton.sd_layout
        .bottomSpaceToView(container,30)
        .leftSpaceToView(container,container.width/2+7.5)
        .rightSpaceToView(container,30)
        .heightIs(40);
        
        
    }
    
//    for (int i=0; i<[buttonTitles count]; i++) {
//
//        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        [closeButton setFrame:CGRectMake(i * buttonWidth, container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight)];
//
//        [closeButton addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//        [closeButton setTag:i];
//
//        [closeButton setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
//        [closeButton setTitleColor:[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
//        [closeButton setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];
//        [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
//        
//        [closeButton.layer setCornerRadius:kCustomIOSAlertViewCornerRadius];
//
//        [container addSubview:closeButton];
//    }
}

// Helper function: count and return the dialog's size
- (CGSize)countDialogSize
{
    CGFloat dialogWidth = containerView.frame.size.width;
    CGFloat dialogHeight = containerView.frame.size.height + buttonHeight + buttonSpacerHeight;

    return CGSizeMake(dialogWidth, dialogHeight);
}

// Helper function: count and return the screen's size
- (CGSize)countScreenSize
{
    if (buttonTitles!=NULL && [buttonTitles count] > 0) {
        buttonHeight       = kCustomIOSAlertViewDefaultButtonHeight;
        buttonSpacerHeight = kCustomIOSAlertViewDefaultButtonSpacerHeight;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGSizeMake(screenWidth, screenHeight);
}

#if (defined(__IPHONE_7_0))
// Add motion effects
- (void)applyMotionEffects {

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }

    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);

    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);

    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];

    [dialogView addMotionEffect:motionEffectGroup];
}
#endif

- (void)dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

// Rotation changed, on iOS7
- (void)changeOrientationForIOS7 {

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;
            
        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         dialogView.transform = rotation;
                         
                     }
                     completion:nil
     ];
    
}

// Rotation changed, on iOS8
- (void)changeOrientationForIOS8: (NSNotification *)notification {

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGSize dialogSize = [self countDialogSize];
                         CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                         self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                         dialogView.frame = CGRectMake((screenWidth - dialogSize.width) / 2, (screenHeight - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
    

}

// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    // If dialog is attached to the parent view, it probably wants to handle the orientation change itself
    if (parentView != NULL) {
        return;
    }

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self changeOrientationForIOS7];
    } else {
        [self changeOrientationForIOS8:notification];
    }
}

// Handle keyboard show/hide changes
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
					 }
					 completion:nil
	 ];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
					 }
					 completion:nil
	 ];
}

@end
