//
//  OrderStoreMapView.m
//  AgilePOPs
//
//  Created by CongCong on 2017/7/21.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "OrderStoreMapView.h"
#import "CCAlert.h"
#import "CCControl.h"
#import "CCUserData.h"
#import "LinkFailed.h"
#import "MANaviRoute.h"
#import "UserLocation.h"
#import "CCHTTPRequest.h"
#import "NSString+Tool.h"
#import "CCESignatureView.h"
#import <MAMapKit/MAMapKit.h>
#import "NSDictionary+Tool.h"
#import "CustomIOSAlertView.h"
#import <UIView+SDAutoLayout.h>
#import "UIColor+CustomColors.h"
#import "StorePointAnnotation.h"
#import "StorePointAnnotationView.h"
#import "NSMutableDictionary+Tool.h"
#import <AMapLocationKit/AMapLocationKit.h>

static const NSInteger RoutePlanningPaddingEdge = 20;

@interface OrderStoreMapView ()<AMapLocationManagerDelegate,MAMapViewDelegate,AMapSearchDelegate>{
    CGFloat _screenDiagonal;
    id <MAAnnotation> _selectedAnnotation;;
    UIButton *_drawLineButton;
    CCESignatureView *_drawLineView;
}
@property (nonatomic, strong) UIButton               *myLocationButton;//回到我的位置按钮
@property (nonatomic, strong) UIImageView            *locationImage;//定位按钮图片
@property (nonatomic, strong) AMapLocationManager    *locationManager;
@property (nonatomic, strong) MAMapView              *mapView;//地图
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;//用户的坐标
@property (nonatomic, assign) CLLocationCoordinate2D mapCenterLocation;
@property (nonatomic, assign) BOOL                   isUserSpanMapView;//是否是用户滑动
@property (nonatomic, assign) BOOL                   isLoading;//是否加载中
@property (nonatomic, strong) LinkFailed             *defaultView;
@property (nonatomic, strong) NSMutableArray         *annotations;
@property (nonatomic, strong) NSMutableArray         *storePoints;
@property (nonatomic, strong) MAAnnotationView       *userLocationAnnotationView;

//路线规划
@property (nonatomic, strong) NSMutableArray         *myRouteStores; //我门店
@property (nonatomic, strong) AMapSearchAPI          *search;
@property (nonatomic, strong) NSMutableArray         *routes;
@property (nonatomic, strong) NSMutableArray         *naviRoutes;
@property (nonatomic, strong) NSMutableArray         *naviRouteLines;
//选择门店
@property (nonatomic, assign) BOOL                   isSelectStoreMode;//是选择门店

//仓库
@property (nonatomic, strong) MAPointAnnotation      *storageAnnotation;
@end

@implementation OrderStoreMapView
- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id<OrderStoreDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self initLocation];
        [self initSearch];
        [self initMapView];
        [self addDrawLineButton];
        [self initMyLocationButton];
        [self addStorageAnnotationView];
    }
    return self;
}

#pragma mark  ---------> 懒加载
- (NSMutableArray*)annotations{
    
    if (!_annotations) {
        _annotations = [NSMutableArray array];
    }
    return _annotations;
}

- (NSMutableArray*)storePoints{
    
    if (!_storePoints) {
        _storePoints = [NSMutableArray array];
    }
    return _storePoints;
}

- (NSMutableArray *)naviRoutes{
    if (!_naviRoutes) {
        _naviRoutes = [NSMutableArray array];
    }
    return _naviRoutes;
}

- (NSMutableArray *)naviRouteLines{
    if (!_naviRouteLines) {
        _naviRouteLines = [NSMutableArray array];
    }
    return _naviRouteLines;
}

- (NSMutableArray *)selectedStores{
    if (!_selectedStores) {
        _selectedStores = [NSMutableArray array];
    }
    return _selectedStores;
}

- (NSMutableArray *)myRouteStores{
    if (!_myRouteStores) {
        _myRouteStores = [NSMutableArray array];
    }
    return _myRouteStores;
}

#pragma mark  ---------> 无网络
- (void)initLinkFailedView{
    CCWeakSelf(self);
    _defaultView = [[LinkFailed alloc]initWithFrame:self.bounds callBack:^{
        [weakself getStoreListWithLocation:_userLocation];
    }];
    [_mapView addSubview:_defaultView];
    _defaultView.hidden = YES;
}

- (void)initMapView{
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, self.bounds.size.height)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.rotateEnabled = NO;
    _mapView.rotateCameraEnabled = NO;
    _mapView.backgroundColor = [UIColor whiteColor];
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [_mapView setZoomLevel:11 animated:YES];
    [self addSubview:_mapView];
    _screenDiagonal = sqrt(pow(SYSTEM_WIDTH,2)+pow(SYSTEM_HEIGHT, 2))/2.00;
}

#pragma mark ------------> 画图
- (void)addDrawLineButton{
    _drawLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _drawLineButton.frame = CGRectMake(20, self.mapView.frame.size.height-65, 45, 45);
    [_drawLineButton setImage:[UIImage imageNamed:@"cirle_unstart"] forState:UIControlStateNormal];
    [_drawLineButton setImage:[UIImage imageNamed:@"cirle_selected"] forState:UIControlStateSelected];
    _drawLineButton.backgroundColor = [UIColor whiteColor];
    [_drawLineButton setBackgroundImage:[UIImage imageNamed:@"custom_red"] forState:UIControlStateSelected];
    _drawLineButton.clipsToBounds = YES;
    _drawLineButton.layer.cornerRadius = 22.5;
    _drawLineButton.layer.borderColor = [UIColor blackColor].CGColor;
    _drawLineButton.layer.borderWidth = 2;
    [_drawLineButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_drawLineButton addTarget:self action:@selector(startDrawLine) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_drawLineButton];
    
    _drawLineButton.hidden = YES;
}

- (void)startDrawLine{
    _drawLineButton.selected = !_drawLineButton.selected;
    [_drawLineView removeFromSuperview];
    if (_drawLineButton.selected) {
        CCWeakSelf(self);
        _drawLineView = [[CCESignatureView alloc]initWithFrame:self.mapView.bounds andMapView:self.mapView andDrawLineCallBack:^(NSArray *locations) {
            [weakself seleteStoresByLineLocations:locations];
        }];
        [self.mapView addSubview:_drawLineView];
    }
}

- (void)seleteStoresByLineLocations:(NSArray *)locations{
    
    _drawLineButton.selected = NO;
    
    if (locations.count<1) {
        return;
    }
    
    CLLocationCoordinate2D coordinates[locations.count];
    for (int i=0; i<locations.count; i++) {
        NSValue *value = locations[i];
        CLLocationCoordinate2D coordinate = value.MACoordinateValue;
        coordinates[i] = coordinate;
    }
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:locations.count];
    
    for (StorePointAnnotation *annotation in self.annotations) {
        MAMapPoint point = MAMapPointForCoordinate(annotation.coordinate);
        if (MAPolygonContainsPoint(point, polygon.points, locations.count) && ![self.selectedStores containsObject:annotation.subtitle]) {
            [self.selectedStores addObject:annotation.subtitle];
        }
    }
    [self.mapView removeAnnotations:self.annotations];
    [self.mapView addAnnotations:self.annotations];
}


- (void)addStorageAnnotationView{
    [self.mapView removeAnnotation:self.storageAnnotation];
    if (!storageAddress()||[storageAddress() isEmpty]||!storageLocation()||storageLocation().count<1) {
        return;
    }
    MAPointAnnotation *poi = [[MAPointAnnotation alloc] init];
    poi.title = @"仓库";
    poi.subtitle = storageAddress();
    NSNumber *lat = storageLocation()[1];
    NSNumber *lon = storageLocation()[0];
    poi.coordinate = CLLocationCoordinate2DMake(lat.floatValue, lon.floatValue);
    [self.mapView addAnnotation:poi];
    self.storageAnnotation = poi;
}

#pragma mark  --------->  获取当前地理位置
- (void)initLocation{
    //初始化检索对象
    _mapCenterLocation = [[UserLocation defaultUserLoaction] userLoaction];
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
    _isUserSpanMapView = YES;
}

- (void)initSearch{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{

    [_locationManager stopUpdatingLocation];
    _userLocation = location.coordinate;
    //调整地图缩放范围
    if (_mapView.zoomLevel>15||_mapView.zoomLevel<9) {
        [_mapView setZoomLevel:11 animated:YES];
    }
    [_mapView setCenterCoordinate:location.coordinate animated:YES];
    [self showMyLocationWhenAtCenter:YES];
    _mapCenterLocation = _userLocation;
    [self getStoreListWithLocation:location.coordinate];
}

#pragma mark  ---------> 获取门店
- (void)getStoreListWithLocation:(CLLocationCoordinate2D)location{
    
    if (self.isLoading||location.latitude==0||location.longitude==0||self.isSelectStoreMode) {
        return;
    }
    self.isLoading = YES;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    
    double lat = location.latitude;
    double lon = location.longitude;
    [parameters put:@[[NSNumber numberWithDouble:lon],[NSNumber numberWithDouble:lat]] key:@"center_location"];
    
    [parameters put:@"distance" key:@"sort_key"];
    CGFloat screenDistance = _screenDiagonal*[self.mapView metersPerPointForZoomLevel:self.mapView.zoomLevel]/1000.00;
    [parameters put:[NSNumber numberWithFloat:screenDistance] key:@"radius"];
    
    CCWeakSelf(self);
    [[CCHTTPRequest requestManager] getWithRequestBodyString:USER_GET_STORE_MAP parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            if (error.code == -404) {
                weakself.defaultView.hidden = NO;
            }
        }else{
            weakself.defaultView.hidden = YES;
            [weakself.storePoints removeAllObjects];
            [weakself.myRouteStores removeAllObjects];
            NSArray *pois = [result objectForKey:@"pois"];
            NSLog(@"门店个数 --------->  %ld",pois.count);
            for (NSDictionary *poiDict in pois) {
                OrderStoreModel *model = [[OrderStoreModel alloc]initWithDictionary:poiDict error:nil];
                [weakself.storePoints addObject:model];
                if (model.self_order_count.integerValue>0) {
                    [weakself.myRouteStores addObject:model];
                }
            }
            [weakself showAnnmontions];
//            if (!weakself.isSelectStoreMode&&!weakself.isRouted) {
//                [weakself showDriveRoute];
//            }
        }
        weakself.isLoading = NO;
    }];
}

- (void)showAnnmontions{
    [_mapView removeAnnotations:self.annotations];
    [self.annotations removeAllObjects];
    for (OrderStoreModel *model in self.storePoints) {
        StorePointAnnotation *annotation = [[StorePointAnnotation alloc] init];
        NSNumber *lonNumber = model.location[0];
        NSNumber *latNumber = model.location[1];
        annotation.coordinate = CLLocationCoordinate2DMake(latNumber.doubleValue,lonNumber.doubleValue);
        annotation.subtitle = model._id;
        annotation.storeModel = model;
        [self.annotations addObject:annotation];
    }
    [_mapView addAnnotations:self.annotations];
    
    
    
}

#pragma mark  ---------> 回到我的位置
- (void)initMyLocationButton{
    _myLocationButton = [CCControl buttonWithFrame:CGRectMake(SYSTEM_WIDTH-65, _mapView.frame.size.height-65, 45, 45) title:@"" backGroundColor:[UIColor whiteColor] cornerRadius:45/2.0 target:self action:@selector(goToMyLocation)];
    [_myLocationButton setBackgroundImage:[UIImage imageNamed:@"location_2"] forState:UIControlStateSelected];
    _myLocationButton.layer.borderColor = [UIColor blackColor].CGColor;
    _myLocationButton.layer.borderWidth = 2;
    _locationImage = [[UIImageView alloc]initWithFrame:CGRectMake(11.5, 11.5, 22, 22)];
    _locationImage.image = [UIImage imageNamed:@"location_2"];
    [_myLocationButton addSubview:_locationImage];
    [_mapView addSubview:_myLocationButton];
}
- (void)goToMyLocation{
    [self.locationManager startUpdatingLocation];
}
- (void)showMyLocationWhenAtCenter:(BOOL)isAtCenter{
    if (isAtCenter) {
        _locationImage.image = [UIImage imageNamed:@"location_2"];
    }
    else{
        _locationImage.image = [UIImage imageNamed:@"location_1"];
    }
}

#pragma mark  ---------> MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]]) {
            static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
            
            MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
            if (poiAnnotationView == nil){
                poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                                 reuseIdentifier:routePlanningCellIdentifier];
            }
            poiAnnotationView.canShowCallout = YES;
            poiAnnotationView.image = nil;
            poiAnnotationView.image = [UIImage imageNamed:@"car"];
            return poiAnnotationView;
        }else if ([annotation isKindOfClass:[StorePointAnnotation class]]){
            static NSString *customReuseIndetifier = @"customReuseIndetifier";
            StorePointAnnotationView *annotationView = (StorePointAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
            if (annotationView == nil){
                annotationView = [[StorePointAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
                annotationView.canShowCallout = NO;
            }
            StorePointAnnotation *storeAnnotation = (StorePointAnnotation *)annotation;
            if (storeAnnotation.storeModel.self_order_count.integerValue>0) {
                annotationView.portrait = [UIImage imageNamed:@"select_store"];
            }else if (storeAnnotation.storeModel.urgent_order_count.integerValue>0){
                annotationView.portrait = [UIImage imageNamed:@"urgent_store"];
            }else if (storeAnnotation.storeModel.order_count.integerValue>0){
                annotationView.portrait = [UIImage imageNamed:@"valid_store"];
            }
            annotationView._id = annotation.subtitle;
            
            if (self.isSelectStoreMode&&[self.selectedStores containsObject:annotationView._id]) {
                annotationView.portrait = [UIImage imageNamed:@"select_store"];
            }
            annotationView.centerOffset = CGPointMake(0, 0);
            return annotationView;
        }else{
            static NSString *reuseIndetifier = @"annotationReuseIndetifier";
            MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:reuseIndetifier];
            }
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"storage"];
            annotationView.centerOffset = CGPointMake(0, -5);
            return annotationView;
        }
    }
    return nil;
}

#pragma mark  --------->  选中一个地图上的任务
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    
    if (![view isKindOfClass:[StorePointAnnotationView class]]) {
        return;
    }
    StorePointAnnotationView *customView = (StorePointAnnotationView*)view;
    NSLog(@"customViewID:%@",customView._id);
    
    if (self.isSelectStoreMode) {
        if ([self.selectedStores containsObject:customView._id]) {
            customView.portrait = [UIImage imageNamed:@"valid_store"];
            [self.selectedStores removeObject:customView._id];
        }else{
            customView.portrait = [UIImage imageNamed:@"select_store"];
            [self.selectedStores addObject:customView._id];
        }
        [self performSelector:@selector(deseletedStore:) withObject:customView.annotation afterDelay:0.1];
    }else{
        StorePointAnnotation *storeAnnotation = (StorePointAnnotation *)view.annotation;
        OrderStoreModel *model = storeAnnotation.storeModel;
        if (model) {
            [self showPopViewWithModel:model];
        }
        NSNumber *latitude = model.location.lastObject;
        NSNumber *longitude = model.location.firstObject;
        [mapView setCenterCoordinate:CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue) animated:YES];
        [self showMyLocationWhenAtCenter:NO];
        _selectedAnnotation = customView.annotation;
    }
}

- (void)deseletedStore:(id <MAAnnotation>)annmation{
    [_mapView deselectAnnotation:annmation animated:NO];
}

- (OrderStoreModel *)getModelByID:(NSString *)_id{
    for (OrderStoreModel *model  in self.storePoints) {
        if ([model._id isEqualToString:_id]) {
            return model;
        }
    }
    return nil;
}

#pragma mark ---------------> MAMapViewDelegate 划线
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.strokeColor = [UIColor customRedColor];
        return polylineRenderer;
    }
    
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        polylineRenderer.lineWidth = 4;
        polylineRenderer.strokeColor = [UIColor customBlueColor];
        return polylineRenderer;
    }
    
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:(MAMultiPolyline*)overlay];
        polylineRenderer.lineWidth = 4;
        polylineRenderer.strokeColors = @[[UIColor customBlueColor]];
        polylineRenderer.gradient = YES;
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark  --------->  地图 滑动结束后 回调
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    _mapCenterLocation = [_mapView convertPoint:_mapView.center toCoordinateFromView:_mapView];
    if (wasUserAction) {
        [self reloadData];
        [self showMyLocationWhenAtCenter:NO];
        [self hiddenPopList];
        _selectedAnnotation  = nil;
    }
}


- (void)reloadData{
    [self getStoreListWithLocation:_mapCenterLocation];
}

#pragma mark  --------->  mapView 地图 点击事件回调
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self hiddenPopList];
    _selectedAnnotation  = nil;
}

#pragma mark --------->地图 中心点 设置
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if (self.userLocationAnnotationView) {
        return;
    }
    for (MAAnnotationView *view in views) {
        if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
            MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
            pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.1];
            pre.image = [UIImage imageNamed:@"loaction_arrow"];
            [_mapView updateUserLocationRepresentation:pre];
            view.calloutOffset = CGPointMake(0, 0);
            view.canShowCallout = NO;
            self.userLocationAnnotationView = view;
            return;
        }
    }
}

#pragma  mark --------> 箭头方向
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil){
        [UIView animateWithDuration:0.1 animations:^{
            double degree = userLocation.heading.trueHeading;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
        }];
    }
}

- (void)showPopViewWithModel:(OrderStoreModel *)model{
    if ([self.delegate respondsToSelector:@selector(didSeletedStore:)]) {
        [self.delegate didSeletedStore:model];
    }
}

- (void)hiddenPopList{
    if ([self.delegate respondsToSelector:@selector(didDeseletedStore)]) {
        [self.delegate didDeseletedStore];
    }
    if (_selectedAnnotation) {
        [_mapView deselectAnnotation:_selectedAnnotation animated:NO];
    }
    _selectedAnnotation  = nil;
}


- (void)showDriveRoute{
    [self clear];
    [self addDriveRouteLine];
}

- (void)addDriveRouteLine{
    
    CLLocationCoordinate2D startLoaction = [[UserLocation defaultUserLoaction] userLoaction];
    MAMapPoint userPoint = MAMapPointForCoordinate(startLoaction);
    
    NSArray *newStorePoints = [self.myRouteStores sortedArrayUsingComparator:^NSComparisonResult(OrderStoreModel *firstModel, OrderStoreModel *secondModel) {
        NSNumber *firstLat = firstModel.location[1];
        NSNumber *firstLon = firstModel.location[0];
        MAMapPoint firstPoi = MAMapPointForCoordinate(CLLocationCoordinate2DMake(firstLat.floatValue,firstLon.floatValue));
        NSNumber *secondLat = secondModel.location[1];
        NSNumber *secondLon = secondModel.location[0];
        MAMapPoint secondPoi = MAMapPointForCoordinate(CLLocationCoordinate2DMake(secondLat.floatValue,secondLon.floatValue));
        return MAMetersBetweenMapPoints(userPoint,firstPoi) > MAMetersBetweenMapPoints(userPoint,secondPoi);
    }];
    
    NSMutableArray *wayPassLocations = [NSMutableArray array];
    for (int i=0; i<newStorePoints.count; i++) {
        OrderStoreModel *model = [newStorePoints objectAtIndex:i];
        NSNumber *Lat = model.location[1];
        NSNumber *Lon = model.location[0];
        CLLocationCoordinate2D destLocation = CLLocationCoordinate2DMake(Lat.floatValue,Lon.floatValue);
//        [wayPassLocations addObject:[AMapGeoPoint locationWithLatitude:destLocation.latitude longitude:destLocation.longitude]];
        //小于500 不导航
        if (MAMetersBetweenMapPoints(userPoint,MAMapPointForCoordinate(destLocation))>500) {
            [wayPassLocations addObject:[AMapGeoPoint locationWithLatitude:destLocation.latitude longitude:destLocation.longitude]];
        }
    }
    
    if (wayPassLocations.count<1||wayPassLocations.count>16) {
        return;
    }
    
    AMapGeoPoint *destPoi = [wayPassLocations lastObject];
    [wayPassLocations removeLastObject];
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.waypoints = wayPassLocations;
    navi.requireExtension = YES;
    //    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:startLoaction.latitude
                                           longitude:startLoaction.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:destPoi.latitude
                                                longitude:destPoi.longitude];
    
    [self.search AMapDrivingRouteSearch:navi];
}

#pragma mark ---------> 路径规划搜索回调.
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil){
        return;
    }
    self.isRouted = YES;
    [self.naviRoutes removeAllObjects];
    [self.naviRouteLines removeAllObjects];
    
    [self.routes addObject:response.route];
    if (response.count > 0){
        [self presentDriveLineWithRoute:response.route];
    }else{
        [self setErrorLineForRequest:request];
    }
}
/* 展示当前路线方案. 驾车🚗*/
- (void)presentDriveLineWithRoute:(AMapRoute*)route
{
    MANaviRoute *naviRoute = [MANaviRoute naviRouteForPath:route.paths[0] withNaviType:MANaviAnnotationTypeDrive showTraffic:YES startPoint:route.origin endPoint:route.destination];
    [naviRoute addToMapView:self.mapView];
    [self.naviRoutes addObject:naviRoute];
    [self.naviRouteLines addObjectsFromArray:naviRoute.routePolylines];
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView showOverlays:self.naviRouteLines edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge) animated:YES];

}

- (void)setErrorLineForRequest:(AMapRouteSearchBaseRequest*)request{
    MANaviRoute *naviRoute = [MANaviRoute naviRouteForFailedLinWitheStartPoint:request.origin endPoint:request.destination];
    [naviRoute addToMapView:self.mapView];
    [self.naviRoutes addObject:naviRoute];
    [self.naviRouteLines addObjectsFromArray:naviRoute.routePolylines];
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView showOverlays:self.naviRouteLines edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge) animated:YES];
}

/* 清空地图上已有的路线. */
- (void)clear{
    for (MANaviRoute *route in self.naviRoutes) {
        [route removeFromMapView];
    }
//    [self.naviRoutes removeAllObjects];
//    [self.naviRouteLines removeAllObjects];
}

#pragma mark ------------> 门店选择模块

- (void)startSelectStore{
    
//    [self clear];
    [self.selectedStores removeAllObjects];
    for (OrderStoreModel *model in self.myRouteStores) {
        [self.selectedStores addObject:model._id];
    }
    self.isSelectStoreMode = YES;
    [self.mapView removeAnnotations:self.annotations];
    [self.mapView addAnnotations:self.annotations];
    _drawLineButton.hidden = NO;
}

- (NSInteger)getSeletedCount{
    return self.myRouteStores.count;
}

- (void)stopSelectStore{
    self.isSelectStoreMode = NO;
    [self.selectedStores removeAllObjects];
    
//    for (MANaviRoute *naviRoute in self.naviRoutes) {
//        [naviRoute addToMapView:self.mapView];
//    }
    
    [self.mapView removeAnnotations:self.annotations];
    [self.mapView addAnnotations:self.annotations];
    
    
    _drawLineButton.hidden = YES;
    _drawLineButton.selected = NO;
    [_drawLineView removeFromSuperview];
    _drawLineView = nil;
    [self reloadData];
}

- (void)dealloc{
    NSLog(@"storeMap delloc");
}


@end
