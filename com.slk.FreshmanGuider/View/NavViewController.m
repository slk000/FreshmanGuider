//
//  NewsViewController.m
//  NewsDemo
//
//  Created by Takanashirin on 15/11/6.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "NavViewController.h"


@interface NavViewController (){
    BMKMapManager* _mapManager;
    BMKMapView *_mapView;
    BMKLocationService* _locService;
    BMKCloudSearch* _search;

}

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
    
    
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
    BOOL ret = [_mapManager start:@"tePRFQBzEEZBQxzFgFIGK5Qv" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = _mapView;
   
    [self mapSearchBound:@"楼"];

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
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate = nil;
    self.parentViewController.navigationItem.leftBarButtonItem = nil;
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [_mapView setZoomLevel:15];
    [_locService stopUserLocationService];
}

-(void)mapSearchBound:(NSString *) keyWord
{
    BMKCloudBoundSearchInfo *cloudBoundSearch = [[BMKCloudBoundSearchInfo alloc]init];
    cloudBoundSearch.ak = @"Y3seuDuD6LVs8mEphKGA4Tdh";
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
    
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    v.backgroundColor = [UIColor redColor];
    
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
    } else {
        NSLog(@"error ==%d",error);
    }
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
