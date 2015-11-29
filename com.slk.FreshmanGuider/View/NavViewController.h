//
//  NewsViewController.h
//  NewsDemo
//
//  Created by Takanashirin on 15/11/6.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import "BNCoreServices.h"

@interface NavViewController : UIViewController <BMKGeneralDelegate,BMKMapViewDelegate ,BMKLocationServiceDelegate, BMKCloudSearchDelegate, BMKRouteSearchDelegate>
- (void)showalert;
@property (retain, nonatomic) UIBarButtonItem *poiSearchBtn;
@property (retain, nonatomic) UIBarButtonItem *poiListBtn;
-(void)mapSearchBound:(NSString *) keyWord;
-(void)onClickWalkSearch:(NSString *)des;
-(void)onClickBusSearch;
@end
