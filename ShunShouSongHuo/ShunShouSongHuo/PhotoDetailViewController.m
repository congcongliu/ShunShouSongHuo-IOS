//
//  PhotoDetailViewController.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/11.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "CCFile.h"
#import "Constant.h"
#import <UIView+SDAutoLayout.h>
#import "UIColor+CustomColors.h"
#import <UIImageView+WebCache.h>

typedef void(^PhotoDetailsCallBackBlock)();

@interface PhotoDetailViewController ()<UIScrollViewDelegate>{
    UIImageView  *_imageView;
    NSString     *_fileName;
    UIScrollView *_scrollView;
    UIButton     *_deletedButton;
}
@property (nonnull, copy) PhotoDetailsCallBackBlock callback;

@end

@implementation PhotoDetailViewController

- (instancetype)initWithImageFileName:(NSString *)fileName andCallBack:(void(^)())callBackHandler
{
    self = [super init];
    if (self) {
        _fileName     = fileName;
        self.callback = callBackHandler;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览图片";
    [self addNaviView];
    [self addDetailImage];
    // Do any additional setup after loading the view.
}
#pragma mark -----------> 添加导航条
- (void)addNaviView{
    
    CCNavigationBar *navi = [[CCNavigationBar alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_NAVI_HEIGHT) title:self.title];
    [self.view addSubview:navi];
    UIButton *left = [CCControl buttonWithFrame:CGRectMake(0, 0, 80, 20) title:@"" backGroundImage:nil target:self action:@selector(naviBackClick)];
    [navi addLeftButton:left];
    
    UIButton * deletedButton = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH-60, 20, 60, 44)];
    [deletedButton setTitle:@"删除" forState:UIControlStateNormal];
    deletedButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [deletedButton setTitleColor:[UIColor customRedColor] forState:UIControlStateNormal];
    [deletedButton addTarget:self action:@selector(deletedPhoto) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:deletedButton];
}

- (void)deletedPhoto{
    if (self.callback) {
        self.callback();
    }
    [self naviBackClick];
}

- (void)addDetailImage{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SYSTEM_NAVI_HEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTEM_NAVI_HEIGHT)];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.contentSize = CGSizeMake(SYSTEM_WIDTH, SYSTEM_HEIGHT+1);
    _scrollView.delegate = self;
    //设置最大伸缩比例
    _scrollView.maximumZoomScale=3.0;
    //设置最小伸缩比例
    _scrollView.minimumZoomScale=1;
    [self.view addSubview:_scrollView];
    _scrollView.bounces = YES;
    _imageView  = [[UIImageView alloc]initWithFrame:_scrollView.bounds];
    [_scrollView addSubview:_imageView];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    UIImage *photoImage = [self addLocalPhotoWith:_fileName];
    if (!photoImage) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_HEARDER_URL,_fileName]]];
        return;
    }
    _imageView.image = photoImage;
}

//告诉_scrollView要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (UIImage*)addLocalPhotoWith:(NSString *)name;
{
    NSString* filePath=filePathByName([NSString stringWithFormat:@"%@.jpg", name]);
    //NSLog(@"filepath: %@",filePath);
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}


- (void)naviBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
