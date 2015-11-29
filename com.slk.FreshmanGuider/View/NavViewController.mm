//
//  NewsViewController.m
//  NewsDemo
//
//  Created by Takanashirin on 15/11/6.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "NavViewController.h"
#import "POITableViewController.h"
#import "MainViewController.h"
#import "MapPopViewController.h"
#import "UIImage+Rotate.h"
#import <BaiduMapAPI_Utils/BMKGeometry.h>
@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@interface NavViewController (){
    BMKMapManager* _mapManager;
    BMKMapView *_mapView;
    BMKLocationService* _locService;
    BMKCloudSearch* _search;
    BMKRouteSearch *_routeSearch;
    BMKUserLocation *_userLocation;
    NSMutableDictionary *_pois;
    
}

@end
@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end


@interface NavViewController(){
    UIStoryboard *sb;
    POITableViewController *poiVC;
    MapPopViewController *popVC;
}
@end
@implementation NavViewController
@synthesize poiListBtn;
@synthesize poiSearchBtn;
- (void)initPOIdata{
    [self mapGetPOIs:@""];
    //[self mapGetPOIs:@"后勤"];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    poiListBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showalert)];
    poiSearchBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onClickBusSearch)];
    poiSearchBtn.tintColor = poiListBtn.tintColor = [UIColor whiteColor];
    
    
    sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    poiVC = [sb instantiateViewControllerWithIdentifier:@"poitable"];
    poiVC.pois = [[NSMutableDictionary alloc]init];
 
    popVC = [sb instantiateViewControllerWithIdentifier:@"mappopview"];
    popVC.view.height = 150;
    popVC.view.width = 250;
    [self addChildViewController:popVC];
    
    //初始化BMKLocationService
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.showsUserLocation= YES;
    
    //初始化云检索服务
    _search = [[BMKCloudSearch alloc]init];
    
    
    // Do any additional setup after loading the view.
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BAIDU_MAP_KEY generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = _mapView;
    
    ///初始化百度导航
    [BNCoreServices_Instance initServices:BAIDU_MAP_KEY];
    [BNCoreServices_Instance startServicesAsyn:nil fail:nil];
    _routeSearch = [[BMKRouteSearch alloc]init];
    _routeSearch.delegate = self;

    [self initPOIdata];
    _pois = [[NSMutableDictionary alloc]init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _search.delegate = self;
        
    if (self.parentViewController.navigationItem.leftBarButtonItem == nil) {
        self.parentViewController.navigationItem.leftBarButtonItem = poiSearchBtn;
    }
    if (self.parentViewController.navigationItem.rightBarButtonItem == nil) {
        self.parentViewController.navigationItem.rightBarButtonItem = poiListBtn;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate = nil;
    //_routeSearch = nil;
    self.parentViewController.navigationItem.leftBarButtonItem = nil;
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _userLocation = userLocation;
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    _mapView.showMapScaleBar = YES;
    _mapView.showsUserLocation = YES;

    [_mapView setZoomLevel:16];
    [_locService stopUserLocationService];
}

-(void)mapSearchBound:(NSString *) keyWord
{
    BMKCloudBoundSearchInfo *cloudBoundSearch = [[BMKCloudBoundSearchInfo alloc]init];
    cloudBoundSearch.ak = BAIDU_MAP_POI_KEY;
    cloudBoundSearch.geoTableId = 126048;
    cloudBoundSearch.pageIndex = 0;
    cloudBoundSearch.pageSize = 10;
    cloudBoundSearch.bounds = @"116.30,36.20;118.30,40.20";
    cloudBoundSearch.keyword = keyWord;
    BOOL flag = [_search boundSearchWithSearchInfo:cloudBoundSearch];
    if(flag)
    {
        NSLog(@"矩形云检索发送成功");
    }
    else
    {
        NSLog(@"矩形云检索发送失败");
    }
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    

    //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    popVC.poiTitleLabel.text = annotationView.annotation.title;
    UIView *v = popVC.view;
    BMKActionPaopaoView *p = [[BMKActionPaopaoView alloc]initWithCustomView:v];
    [annotationView setPaopaoView:p];
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark -
#pragma mark implement BMKSearchDelegate

- (void)onGetCloudPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    
    NSLog(@"searchType:%d", type);
    if (type == BMK_CLOUD_BOUND_SEARCH) {
        // 清楚屏幕中所有的annotation
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        
        if (error == BMKErrorOk) {
            BMKCloudPOIList* result = [poiResultList objectAtIndex:0];
            for (int i = 0; i < result.POIs.count; i++) {
                BMKCloudPOIInfo* poi = [result.POIs objectAtIndex:i];
                //自定义字段
                if(poi.customDict!=nil&&poi.customDict.count>1)
                {
                    NSString* customStringField = [poi.customDict objectForKey:@"custom"];
                    NSLog(@"customFieldOutput=%@",customStringField);
                    NSNumber* customDoubleField = [poi.customDict objectForKey:@"double"];
                    NSLog(@"customDoubleFieldOutput=%f",customDoubleField.doubleValue);
                    
                }
                
                BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
                CLLocationCoordinate2D pt = (CLLocationCoordinate2D){ poi.longitude,poi.latitude};
                item.coordinate = pt;
                item.title = poi.title;
                item.subtitle=[NSString stringWithFormat:@"%f",poi.longitude];
                
                [_mapView addAnnotation:item];
                if(i == 0)
                {
                    //将第一个点的坐标移到屏幕中央
                    _mapView.centerCoordinate = pt;
                }
            }
        }
        else {
            NSLog(@"error ==%d",error);
        }
    }
    else if (type == BMK_CLOUD_LOCAL_SEARCH){
        if (error == BMKErrorOk) {
            [_pois removeAllObjects];
            for (BMKCloudPOIList *list in poiResultList) {
              
                for (BMKCloudPOIInfo *ele in list.POIs) {
                    CLLocation *poiLoc = [[CLLocation alloc]initWithLatitude:ele.latitude longitude:ele.longitude];
                    [_pois setObject:poiLoc forKey:ele.title];
                    NSLog(@"%@", ele.title);
                    if (![[poiVC.pois allKeys]containsObject:ele.tags]){
                        [poiVC.pois setValue:[[NSMutableArray alloc]init] forKey:ele.tags];
                        NSLog(@"add key %@", ele.tags);
                    }
                    [[poiVC.pois objectForKey:ele.tags]addObject:ele.title];
                    NSLog(@"add title %@ into key %@", ele.title, ele.tags);
                }
            }

            
        }
        else{
            NSLog(@"error:%d", error);
        }
    }
}

- (void)showalert
{
//    UIAlertView *a = [[UIAlertView alloc]initWithTitle:@"title" message:@"nav clss" delegate:nil cancelButtonTitle:@"cc" otherButtonTitles:@"ccc", nil];
//    [a show];
    
    
//    UITableView *poiView = poiVC.tableView;
//    MainViewController *mainVC = [[MainViewController alloc]init];
//    NSLog(@"%@", NSStringFromClass([mainVC class]));
    NSLog(@"self.parentVC:%@", [self.parentViewController class]);
//        [mainVC.navigationController addChildViewController:poiVC];
//    [mainVC addChildViewController:poiVC];

//    [self.view addSubview:poiVC.view];
//    [self addChildViewController:poiVC];
    
//    [self.parentViewController.navigationController pushViewController:poiVC animated:YES];
    [self presentViewController:poiVC animated:YES completion:^{
        poiVC.parentVC = self;
    }];

}


#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}



- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"bus error:%@", error);
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

-(void)onClickBusSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name = @"百度大厦";
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = @"天安门";
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= @"北京市";
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    
    BOOL flag = [_routeSearch transitSearch:transitRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"bus检索发送成功");
    }
    else
    {
        NSLog(@"bus检索发送失败");
    }
}





-(void)onClickWalkSearch:(NSString *)des
{
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    if (_userLocation.location) {
        start.pt = _userLocation.location.coordinate;
    }
    else{
        start.name=@"天安门";
    }
    
    start.cityName = @"北京市";
    BMKPlanNode* end = [[BMKPlanNode alloc]init];

    

//    end.pt = CLLocationCoordinate2DMake(+40.09926224,+116.31545258);
    double lon = ((CLLocation *)[_pois objectForKey:des]).coordinate.longitude;
    double lat = ((CLLocation *)[_pois objectForKey:des]).coordinate.latitude;
    NSLog(@"long:%lf", lon);
    NSLog(@"lat:%lf", lat);
    
    end.pt = CLLocationCoordinate2DMake(lon, lat);
    
    NSLog(@"end:%@", ((CLLocation *)[_pois objectForKey:des]));
    end.cityName = @"北京市";
    
//    end.name=@"北京农学院行政楼";
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routeSearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }
    
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}


//发起导航
//- (void)startNavi
//{
//    //节点数组
//    NSMutableArray *nodesArray = [[NSMutableArray alloc]    initWithCapacity:2];
//    
//    //起点
//    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
//    startNode.pos = [[BNPosition alloc] init];
//    startNode.pos.x = 113.936392;
//    startNode.pos.y = 22.547058;
//    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
//    [nodesArray addObject:startNode];
//    
//    //终点
//    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
//    endNode.pos = [[BNPosition alloc] init];
//    endNode.pos.x = 114.077075;
//    endNode.pos.y = 22.543634;
//    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
//    [nodesArray addObject:endNode];
//    //发起路径规划
//    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
//    NSLog(@"start navi");
//}
////算路成功后，在回调函数中发起导航，如下：
////算路成功回调
//-(void)routePlanDidFinished:(NSDictionary *)userInfo
//{
//    NSLog(@"算路成功");
//    
//    //路径规划成功，开始导航
//    [BNCoreServices_UI showNaviUI: BN_NaviTypeSimulator delegete:self isNeedLandscape:YES];
//	
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) mapGetPOIs:(NSString *)tagName {
    BMKCloudLocalSearchInfo *localSearchInfo = [[BMKCloudLocalSearchInfo alloc]init];
    localSearchInfo.ak = BAIDU_MAP_POI_KEY;
    localSearchInfo.geoTableId = 126048;
    localSearchInfo.pageIndex = 0;
    localSearchInfo.pageSize = 10;
    localSearchInfo.keyword = @" ";
    localSearchInfo.pageSize = 50;
    localSearchInfo.tags = tagName;
    
    localSearchInfo.region = @"北京市";
    
    BOOL flag = [_search localSearchWithSearchInfo:localSearchInfo];
    if(flag)
    {
        NSLog(@"矩形云检索发送成功");
    }
    else
    {
        NSLog(@"矩形云检索发送失败");
    }
}

@end
