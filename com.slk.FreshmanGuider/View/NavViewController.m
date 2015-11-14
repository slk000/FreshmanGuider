//
//  NewsViewController.m
//  NewsDemo
//
//  Created by Takanashirin on 15/11/6.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "NavViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface NavViewController (){
    BMKMapManager* _mapManager;
    BMKMapView *mapView;
}

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"tePRFQBzEEZBQxzFgFIGK5Qv" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [mapView viewWillAppear];
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
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
