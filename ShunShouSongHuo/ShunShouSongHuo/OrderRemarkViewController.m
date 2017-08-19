//
//  OrderRemarkViewController.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/11.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "OrderRemarkViewController.h"
#import <JSONKit.h>
#import "CCDBManager.h"
#import "CCTimerServer.h"
#import "CCHTTPRequest.h"
#import "TextReamarkCell.h"
#import "RecordVoiceModel.h"
#import "ReamarkTitleView.h"
#import "VoiceReamarkCell.h"
#import "PhotoReamarkCell.h"
#import "CustomIOSAlertView.h"
#import "TakePhotosObjectModel.h"
#import "CCCameraViewController.h"
#import "PhotoDetailViewController.h"
#import "OrderRemarkViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


NSString *const TextCellIdentifier  = @"TextReamarkCell";
NSString *const VoiceCellIdentifier = @"VoiceReamarkCell";
NSString *const PhotoCellIdentifier = @"PhotoReamarkCell";
NSString *const TitleViewIdentifier = @"ReamarkTitleView";

@interface OrderRemarkViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    CCDBManager *_dbManager;
    NSString    *_textReamark;
}
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray   *photoArray;
@property(nonatomic, strong)NSMutableArray   *titles;
@property(nonatomic, strong)RecordVoiceModel *voiceModel;
@property(nonatomic, copy  )NSString         *textReamark;
@property(nonatomic, copy  )NSString         *activityId;
@end

@implementation OrderRemarkViewController

- (instancetype)initWithActiviyId:(NSString *)activityId;
{
    self = [super init];
    if (self) {
        self.activityId = activityId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加备注";
    [self.titles addObjectsFromArray:@[@"文字备注",@"语音备注",@"照片备注"]];
    _dbManager = [CCDBManager sharedManager];
    [self addNaviView];
    [self addCollectionView];
    [self addBottomButton];
}

- (NSMutableArray*)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (NSMutableArray*)titles{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

#pragma mark -----------> 添加导航条
- (void)addNaviView{
    
    CCNavigationBar *navi = [[CCNavigationBar alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_NAVI_HEIGHT) title:self.title];
    [self.view addSubview:navi];
    UIButton *left = [CCControl buttonWithFrame:CGRectMake(0, 0, 80, 20) title:@"" backGroundImage:nil target:self action:@selector(naviBackClick)];
    [navi addLeftButton:left];
}
- (void)addCollectionView{
    //此处必须要有创见一个UICollectionViewFlowLayout的对象
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 5;
    //最小两行之间的间距
    layout.minimumLineSpacing = 5;
    
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, SYSTEM_NAVI_HEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT - SYSTEM_NAVI_HEIGHT - 60) collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    //这个是横向滑动
    //layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[TextReamarkCell class] forCellWithReuseIdentifier:TextCellIdentifier];
    [_collectionView registerClass:[VoiceReamarkCell class] forCellWithReuseIdentifier:VoiceCellIdentifier];
    [_collectionView registerClass:[PhotoReamarkCell class] forCellWithReuseIdentifier:PhotoCellIdentifier];
    [_collectionView registerClass:[ReamarkTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TitleViewIdentifier];
    
}
//一共有多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger number = 1;
    switch (section) {
        case 0:
        case 1:
        {
            number = 1;
        }
            break;
        case 2:
        {
            number = self.photoArray.count+1;
        }
            break;
        default:
            break;
    }
    return number;
}

//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    switch (indexPath.section) {
        case 0:
        {
            cell=[collectionView dequeueReusableCellWithReuseIdentifier:TextCellIdentifier forIndexPath:indexPath];
            
            CCWeakSelf(self);
            [(TextReamarkCell*)cell showTextCellWithTextString:_textReamark andTextRemarkCallBack:^(NSString *textString) {
                weakself.textReamark = textString;
            }];
            
        }
            break;
        case 1:
        {
            cell=[collectionView dequeueReusableCellWithReuseIdentifier:VoiceCellIdentifier forIndexPath:indexPath];
            CCWeakSelf(self);
            [(VoiceReamarkCell*)cell showVoiceCellWithCallBack:^(NSString *voiceFile, NSInteger voiceTime) {
                if ([voiceFile isEmpty]||!voiceFile) {
                    weakself.voiceModel = nil;
                }else{
                    weakself.voiceModel = [[RecordVoiceModel alloc]init];
                    weakself.voiceModel.key = voiceFile;
                    weakself.voiceModel.file_size = [NSNumber numberWithInteger:voiceTime];
                    long long time = [[CCTimerServer defaultServer] currentTimeIntervarl]*1000;
                    weakself.voiceModel.time_stamp = [NSNumber numberWithLongLong:time];
                    [weakself.view endEditing:YES];
                }
            }];
        }
            break;
        case 2:
        {
            cell=[collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
            if (indexPath.row>0) {
                TakePhotosObjectModel *model = [self.photoArray objectAtIndex:indexPath.row-1];
                [(PhotoReamarkCell *)cell showCellWithNewModel:model];
            }else{
                [(PhotoReamarkCell*)cell showTakePhotoCellWithMinNumber:0 andMaxNumber:8];
            }
            
        }
            break;
        default:
            break;
    }
    
    return cell;
    
    
}

//头部和脚部的加载
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TitleViewIdentifier forIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSString *title = [self.titles objectAtIndex:indexPath.section];
        [(ReamarkTitleView *)view showTitleWithString:title];
        return view;
    }else{
        return nil;
    }
    return view;
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 5, 15);
}

//头部试图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SYSTEM_WIDTH, 50);
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeZero;
    
    switch (indexPath.section) {
        case 0:
        {
            cellSize = CGSizeMake(SYSTEM_WIDTH-30, 160);
        }
            break;
        case 1:
        {
            cellSize = CGSizeMake(SYSTEM_WIDTH-30, 45);
        }
            break;
        case 2:
        {
            cellSize = CGSizeMake((SYSTEM_WIDTH-75)/4, (SYSTEM_WIDTH-75)/4);
        }
            break;
        default:
            break;
    }

    return cellSize;
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //cell被点击
//    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
    
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                if (self.photoArray.count >= 3) {
                    toast_showInfoMsg(NSLocalizedString(@"q_reached_max_photos", nil), 200);
                    return;
                }
                [self newGetPhotosFromCamera];
            }
            else{
                TakePhotosObjectModel *model = [self.photoArray objectAtIndex:indexPath.row-1];
//                显示新的照片详情页面
                CCWeakSelf(self);
                PhotoDetailViewController *detailVC = [[PhotoDetailViewController alloc]initWithImageFileName:model.key andCallBack:^{
                    [weakself.photoArray removeObjectAtIndex:indexPath.row-1];
                    [weakself.collectionView reloadData];
                }];
                [self.navigationController pushViewController:detailVC animated:YES];
            }

        }
            break;
        default:
            break;
    }
    [self.view endEditing:YES];
}

- (void)newGetPhotosFromCamera{
    if ([self isAllowTakePhoto]) {
        [self isAlowGetPictuewFromPhoto];
        CCWeakSelf(self);
        CCCameraViewController *camera = [[CCCameraViewController alloc]initWithPhotoCallBack:^(NSString *photoName) {
            [weakself getPhotoNameSuccessed:photoName];
        } withCurrentPhotoCount:self.photoArray.count requiredPhotoCount:0 andMaxPhotoCount:8];
        [self presentViewController:camera animated:YES completion:nil];
    }
}

#pragma mark ---------->  拍照 回调
- (void)getPhotoNameSuccessed:(NSString *)fileName{
    NSLog(@"fileName:%@",fileName);
    TakePhotosObjectModel *model = [[TakePhotosObjectModel alloc]init];
    model.key = fileName;
    long long time = [[CCTimerServer defaultServer] currentTimeIntervarl]*1000;
    model.time_stamp = [NSNumber numberWithLongLong:time];
    [self.photoArray addObject:model];
    [self.collectionView reloadData];
}

- (BOOL)isAllowTakePhoto{
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        //无权限
        NSString *tips = NSLocalizedString(@"m_open_photo_setting", nil);
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
        [alertView setContainerImage:@"alertwrongplace" message:tips buttons:@[NSLocalizedString(@"i_got_it", nil)]];
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *currentAlertView, int buttonIndex) {
            [currentAlertView close];
            NSURL* url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
                [[UIApplication sharedApplication] openURL:url];
        }];
        [alertView show];
        return NO;
    }
    return YES;
}

- (BOOL)isAlowGetPictuewFromPhoto{
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){        //无权限
        NSString *tips = NSLocalizedString(@"m_open_picture_setting", nil);
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
        [alertView setContainerImage:@"alertwrongplace" message:tips buttons:@[NSLocalizedString(@"i_got_it", nil)]];
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *currentAlertView, int buttonIndex) {
            [currentAlertView close];
            NSURL* url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
                [[UIApplication sharedApplication] openURL:url];
        }];
        [alertView show];
        return NO;
    }
    return YES;
}


- (void)addBottomButton{
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTEM_HEIGHT-60, SYSTEM_WIDTH, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor grayTextColor];
    [bottomView addSubview:lineView];

    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.clipsToBounds = YES;
    confirmButton.layer.cornerRadius = 20;
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    confirmButton.backgroundColor = UIColorFromRGB(0xFF3B30);
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"cc2f27"] forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmButton];
    confirmButton.sd_layout
    .heightIs(40)
    .centerYEqualToView(bottomView)
    .leftSpaceToView(bottomView,15)
    .rightSpaceToView(bottomView,15);
}

- (void)confirmButtonClick{
    
    
    NSMutableArray *photos = [NSMutableArray array];
    for (TakePhotosObjectModel *photoObject in self.photoArray) {
        [photos addObject:[photoObject toDictionary]];
    }
    
    
    show_progress();
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:self.activityId key:@"activity_id"];
    [parameters put:[photos JSONString] key:@"order_deliveryman_photos"];
    
    if (self.voiceModel && self.voiceModel.key) {
        [parameters put:[self.voiceModel toDictionary] key:@"order_deliveryman_audio"];
    }
    [parameters put:_textReamark key:@"order_deliveryman_remark"];
    
    CCWeakSelf(self);
    [[CCHTTPRequest requestManager] postWithRequestBodyString:USER_UPLOAD_REMARKS parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        dismiss_progress();
        if (error) {
            CCLog(@"%@",error.domain);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", nil), 200);
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:ORDER_GOODS_DElIVERYED_NOTI object:nil];
            [weakself reportSucceed];
        }
    }];
}

- (void)reportSucceed{
    
    NSMutableArray *photos = [NSMutableArray array];
    for (TakePhotosObjectModel *photoObject in self.photoArray) {
        [photos addObject:photoObject.key];
    }
    [_dbManager insertPhotosWithfileNames:photos];
    
    if (_voiceModel&&_voiceModel.key) {
        [_dbManager insertVoiceWithFileName:_voiceModel.key];
    }
    [self naviBackClick];
}

- (void)naviBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
